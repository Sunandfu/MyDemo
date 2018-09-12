//
//  YQDataBase.m
//  YQDataBaseDevelop
//
//  Created by FreakyYang on 2017/11/14.
//  Copyright © 2017年 FreakyYang. All rights reserved.
//

#import "YQLocalStorage.h"

#import <sqlite3.h>

#define strAdd(x,y) x = [x stringByAppendingString:y]
#define strAddFormat(x,y,z) x = [x stringByAppendingString:[NSString stringWithFormat:y,z]]
#define charToNSString(x) [NSString stringWithUTF8String:(const char *)x]

@interface YQLocalStorage ()
{
    sqlite3 *database;
}

@property (nonatomic , strong) NSString *databasePath;
@property (nonatomic , strong) NSMutableDictionary *keysDic;

//for sql queue manager
@property (nonatomic , strong) dispatch_group_t     YQLSActionGroup;
@property (nonatomic , strong) dispatch_semaphore_t YQLSActionSemaphore;
@property (nonatomic , strong) dispatch_queue_t     YQLSActionQueue;

//for api queue manager
@property (nonatomic , strong) dispatch_group_t     YQLSApiActionGroup;
@property (nonatomic , strong) dispatch_semaphore_t YQLSApiActionSemaphore;
@property (nonatomic , strong) dispatch_queue_t     YQLSApiActionQueue;

@end

@implementation YQLocalStorage

+ (YQLocalStorage *)storageWithPath:(NSString *)path {
    YQLocalStorage *database = [[YQLocalStorage alloc] initWithPath:path];
    return database;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    self.databasePath = path;
    
    if ([self openOrCreatDataAtDataBasePath]) {
        [self setupGCD];
        return self;
    } else {
        //open database Fail
        return nil;
    }
}

- (NSMutableDictionary *)keysDic {
    if (!_keysDic) {
        _keysDic = [NSMutableDictionary dictionary];
    }
    return _keysDic;
}

- (BOOL)openOrCreatDataAtDataBasePath {
    
    if (self.databasePath.length <= 0) {
        NSAssert(NO,@"YQLocalStorage : invailed database Path");
        [NSException raise:@"invailed database Path" format:@"YQLocalStorage : invailed database Path"];
    }
    if (database != nil) {
        //already opened
        return YES;
    }
    
    //get full file path
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *strPath = [str stringByAppendingPathComponent:self.databasePath];
    
    //open database
    //if do not exist ,it will automatic creat one
    int result = sqlite3_open([strPath UTF8String], &database);
    //check Result
    if (result == SQLITE_OK) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setupGCD {
    NSString *queueName = [NSString stringWithFormat:@"YQLSAction_%@",self.databasePath];
    self.YQLSActionGroup     = dispatch_group_create();
    self.YQLSActionSemaphore = dispatch_semaphore_create(1);
    self.YQLSActionQueue     = dispatch_queue_create([queueName UTF8String], NULL);
    
    NSString *queueNameApi = [NSString stringWithFormat:@"YQLSApiAction_%@",self.databasePath];
    self.YQLSApiActionGroup     = dispatch_group_create();
    self.YQLSApiActionSemaphore = dispatch_semaphore_create(1);
    self.YQLSApiActionQueue     = dispatch_queue_create([queueNameApi UTF8String], NULL);
}

- (void)runOnGCDQueue:(void(^)(void))block {
    dispatch_group_async(self.YQLSActionGroup, self.YQLSActionQueue, ^{
        dispatch_semaphore_wait(self.YQLSActionSemaphore, DISPATCH_TIME_FOREVER);
        block();
        dispatch_semaphore_signal(self.YQLSActionSemaphore);
    });
}

//!! ApiQueue need manual release semaphore !!
//**** If you're going to use this, you need to be very very careful ****
- (void)runOnApiQueue:(void(^)(void))block {
    dispatch_group_async(self.YQLSApiActionGroup, self.YQLSApiActionQueue, ^{
        dispatch_semaphore_wait(self.YQLSApiActionSemaphore, DISPATCH_TIME_FOREVER);
        block();
    });
}

- (void)checkOrCreatTableWithName:(NSString *)tableName
                             keys:(NSArray<NSString *>*)keys
                            block:(nullable YQLSBoolBlock)block {
    __weak typeof (self) weakSelf = self;
    [self runOnApiQueue:^{
        NSString *tableString = [NSString stringWithFormat:@" '%@' ( 'id' integer primary key autoincrement , 'creattime' double , 'updatetime' double ",tableName];
        for (NSString *key in keys) {
            strAddFormat(tableString, @", '%@' text ", key);
        }
        strAdd(tableString, @" )");
        
        NSString *creatString = @"create table if not exists";
        strAdd(creatString, tableString);
        
        NSString *checkString = @"CREATE TABLE";
        strAdd(checkString, tableString);
        
        //check the table if is exactly as our wanted
        [weakSelf checkTableWithTableName:tableName
                              completeSql:checkString
                                    block:^(BOOL succeed, NSString * _Nullable reason)
         {
             if (succeed) {
                 [self.keysDic setObject:keys forKey:tableName];
                 [self doStorageAction:creatString
                                 block:^(BOOL succeed,NSString * _Nullable reason)
                  {
                      dispatch_semaphore_signal(self.YQLSApiActionSemaphore);
                      block ? block(succeed,reason) : nil;
                  }];
             } else {
                 // need to delete table first
                 NSString *deleteString = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
                 [weakSelf doStorageAction:deleteString
                                     block:^(BOOL succeed, NSString * _Nullable reason)
                  {
                      //delete finished
                      [weakSelf.keysDic setObject:keys forKey:tableName];
                      [weakSelf doStorageAction:creatString
                                          block:^(BOOL succeed,NSString * _Nullable reason)
                       {
                           dispatch_semaphore_signal(self.YQLSApiActionSemaphore);
                           block ? block(succeed,reason) : nil;
                       }];
                  }];
             }
         }];
    }];
}

//return NO means need to delete table
//return YES means can creat table or exist same table
- (void)checkTableWithTableName:(NSString *)tableName
                    completeSql:(NSString *)completeSql
                          block:(nullable YQLSBoolBlock)block {
    NSString *searchString = [NSString stringWithFormat:@"select * from 'sqlite_master' where type = 'table' and name = '%@'",tableName];
    [self runOnGCDQueue:^{
        sqlite3_stmt *stmt = NULL;
        int result = sqlite3_prepare_v2(database, [searchString UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            BOOL tableNotExist = YES;
            NSString *outStr = @"";
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                tableNotExist = NO;
                //'sqlite_master' structur is type,name,tbl_name,rootpage,sql.
                //here we check the 'sql',like 'CREATE TABLE 'person'('id' ...'
                const unsigned char *strValue = sqlite3_column_text(stmt, 4);
                outStr = charToNSString(strValue);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (tableNotExist) {
                    block(YES,@"not exist");
                }else if ([outStr isEqualToString:completeSql]) {
                    block(YES,@"same table");
                } else {
                    block(NO,@"exist but not same");
                }
            });
        } else {
            //search illegal
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO,@"check wrong");
            });
        }
    }];
}

- (void)deleteObjectWithTableName:(NSString *)tableName
                               ID:(long)ID
                            block:(nullable YQLSBoolBlock)block {
    [self deleteObjectWithTableName:tableName
                          condition:[NSString stringWithFormat:@" id=%ld",ID]
                              block:block];
}

- (void)deleteObjectWithTableName:(NSString *)tableName
                        condition:(nullable NSString *)condition
                            block:(nullable YQLSBoolBlock)block {
    [self runOnApiQueue:^{
        NSString *sqlstring = [NSString stringWithFormat:@"delete from '%@'",tableName];
        if (condition.length > 0) {
            sqlstring = [NSString stringWithFormat:@"delete from '%@' where %@",tableName,condition];
        }
        
        [self doStorageAction:sqlstring block:^(BOOL succeed, NSString * _Nullable reason) {
            dispatch_semaphore_signal(self.YQLSApiActionSemaphore);
            block ? block(succeed,reason) : nil;
        }];
    }];
}

- (void)insertObjectWithTableName:(NSString *)tableName
                             data:(NSDictionary<NSString *,NSString *> *)data
                            block:(nullable YQLSBoolBlock)block {
    __weak typeof (self) weakSelf = self;
    [self runOnApiQueue:^{
        NSString *sqlString = [NSString stringWithFormat:@"insert into %@(creattime, updatetime",tableName];
        
        for (NSString *key in data.allKeys) {
            strAddFormat(sqlString, @", %@", key);
        }
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        
        NSString *valusStr = [NSString stringWithFormat:@") values(%f, %f",interval,interval];
        strAdd(sqlString, valusStr);
        
        for (NSString *value in data.allValues) {
            strAdd(sqlString, @", '");
            if ([value isKindOfClass:[NSString class]]) {
                strAdd(sqlString, value);
            } else {
                NSString *newstr = [NSString stringWithFormat:@"%@",value];
                strAdd(sqlString, newstr);
            }
            strAdd(sqlString, @"'");
        }
        strAdd(sqlString, @")");
        [weakSelf doStorageAction:sqlString block:^(BOOL succeed,
                                                    NSString * _Nullable reason)
         {
             dispatch_semaphore_signal(self.YQLSApiActionSemaphore);
             block ? block(succeed,reason) : nil;
         }];
    }];
}


- (void)updateObjectWithTableName:(NSString *)tableName
                         objectID:(long)ID
                             data:(nullable NSDictionary<NSString *,NSString *> *)data
                            block:(nullable YQLSBoolBlock)block {
    [self updateObjectWithTableName:tableName
                          condition:[NSString stringWithFormat:@" id=%ld ",ID]
                               data:data
                              block:block];
}

- (void)updateObjectWithTableName:(NSString *)tableName
                        condition:(nullable NSString *)conditon
                             data:(nullable NSDictionary<NSString *,NSString *> *)data
                            block:(nullable YQLSBoolBlock)block {
    __weak typeof (self) weakSelf = self;
    [self runOnApiQueue:^{
        NSString *sqlString = [NSString stringWithFormat:@"update '%@' set updatetime=%f, ",tableName,[[NSDate date]timeIntervalSince1970]];
        
        NSArray *localAllKey = [weakSelf.keysDic valueForKey:tableName];
        if (localAllKey) {
            for (NSString *key in localAllKey) {
                if (![data.allKeys containsObject:key]) {
                    strAddFormat(sqlString, @"%@='', ", key);
                } else {
                    NSString *pair = [NSString stringWithFormat:@"%@='%@', ",key,[data valueForKey:key]];
                    strAdd(sqlString, pair);
                }
            }
        } else {
            for (NSString *key in data.allKeys) {
                NSString *pair = [NSString stringWithFormat:@"%@='%@', ",key,[data valueForKey:key]];
                strAdd(sqlString, pair);
            }
        }
        sqlString = [sqlString substringWithRange:NSMakeRange(0, sqlString.length-2)];
        
        if (conditon) {
            strAddFormat(sqlString, @" where %@", conditon);
        }
        [weakSelf doStorageAction:sqlString block:^(BOOL succeed,
                                                    NSString * _Nullable reason)
         {
             dispatch_semaphore_signal(self.YQLSApiActionSemaphore);
             block ? block(succeed,reason) : nil;
         }];
    }];
}

- (void)doStorageAction:(NSString *)actionString
                  block:(nullable YQLSBoolBlock)block {
    [self runOnGCDQueue:^{
        char *error = NULL;
        int result = sqlite3_exec(database, [actionString UTF8String], nil, nil, &error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result == SQLITE_OK) {
                if (block)block(YES,nil);
            } else {
                if (block)block(NO,[NSString stringWithUTF8String:error]);
            }
        });
    }];
}

- (void)searchStorageWithTableName:(NSString *)tableName
                         condition:(nullable NSString *)condition
                              Keys:(nullable NSArray<NSString *>*)keysArr
                             block:(nullable void(^)(BOOL succeed,NSArray<YQLSSearchResultItem *> *_Nullable result))block {
    __weak typeof (self) weakSelf = self;
    [self runOnApiQueue:^{
        [weakSelf runOnGCDQueue:^{
            NSString *serchString = @"select ";
            if (keysArr) {
                strAdd(serchString, @"id, creattime, updatetime");
                if (keysArr.count>0) {
                    for (NSString *searchKey in keysArr) {
                        strAddFormat(serchString, @", %@", searchKey);
                    }
                }
            } else {
                strAdd(serchString, @" * ");
            }
            strAddFormat(serchString, @" from '%@'", tableName);
            if (condition.length > 0) {
                strAddFormat(serchString, @" where %@", condition);
            }
            sqlite3_stmt *stmt = NULL;
            int result = sqlite3_prepare_v2(database, [serchString UTF8String], -1, &stmt, NULL);
            if (result != SQLITE_OK) {
                //search illegal
                dispatch_async(dispatch_get_main_queue(), ^{
                    block ? block(NO,nil) : nil;
                });
            } else {
                //search leagal
                NSMutableArray *resultArr = [NSMutableArray array];
                //do SQL
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    NSMutableDictionary *itemDataDic = [NSMutableDictionary dictionary];
                    if (keysArr) {
                        if (keysArr.count>0) {
                            //keys: @[a,b,c] return id,created,updated and each user wanted
                            for (int i=0; i<keysArr.count; i++) {
                                const unsigned char *strValue = sqlite3_column_text(stmt, 3+i);
                                [itemDataDic setObject:charToNSString(strValue)
                                                forKey:keysArr[i]];
                            }
                        } else {
                            //keys: @[] return just id,created,updated
                        }
                    } else {
                        //keys: nil。return allkeys
                        if (weakSelf.keysDic && [weakSelf.keysDic.allKeys containsObject:tableName]) {
                            NSArray *localAllKeys = [self.keysDic valueForKey:tableName];
                            for (int i=0; i<localAllKeys.count; i++) {
                                const unsigned char *strValue = sqlite3_column_text(stmt, 3+i);
                                if (strValue && localAllKeys[i]) {
                                    [itemDataDic setObject:charToNSString(strValue)
                                                    forKey:localAllKeys[i]];
                                }
                            }
                        }
                    }
                    YQLSSearchResultItem *item = [[YQLSSearchResultItem alloc]
                                                   initWithLocalStorage:weakSelf
                                                   table:tableName
                                                   ID:(int)sqlite3_column_int64(stmt, 0)
                                                   creatTime:sqlite3_column_double(stmt, 1)
                                                   updateTime:sqlite3_column_double(stmt, 2)
                                                   data:[NSDictionary dictionaryWithDictionary:itemDataDic]];
                    [resultArr addObject:item];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block ? block(YES,resultArr) : nil;
                });
            }
            dispatch_semaphore_signal(self.YQLSApiActionSemaphore);
        }];
    }];
}

- (void)countStorageWithTableName:(NSString *)tableName
                        condition:(nullable NSString *)condition
                            block:(nullable void(^)(BOOL succeed,NSUInteger count))block {
    [self searchStorageWithTableName:tableName
                           condition:condition
                                Keys:@[]
                               block:^(BOOL succeed,
                                       NSArray<YQLSSearchResultItem *> * _Nullable result)
     {
         succeed ? block(succeed,result.count) : block(succeed,0);
     }];
}

@end




