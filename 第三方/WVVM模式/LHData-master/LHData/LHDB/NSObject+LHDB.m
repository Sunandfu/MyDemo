//
//  NSObject+LHModelExecute.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/2/15.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NSObject+LHDB.h"
#import "LHPredicate.h"
#import <objc/runtime.h>
#import "LHDBPath.h"
#import "LHSqlite.h"
#import "NSObject+LHModel.h"
#import "LHModelStateMent.h"


#define run_in_queue(...) dispatch_async([self executeQueue], ^{\
__VA_ARGS__; \
})

#define DatabasePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"data.sqlite"]

static NSString* const DatabaseFilePath = @"DatabaseFilePath";
static NSString* const DataBaseExecute = @"DataBaseExecute";
static NSString* const DataBaseQueue = @"DataBaseQueue";

static LHSqlite* sqlite;

@implementation NSObject (LHDB)

- (dispatch_queue_t)executeQueue
{
    static dispatch_queue_t executeQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        executeQueue = dispatch_queue_create("com.sancai.lhdb", DISPATCH_QUEUE_SERIAL);
    });
    return executeQueue;
}

+ (dispatch_queue_t)executeQueue
{
    return [[self new] executeQueue];
}

- (NSString*)dbPath
{
    if ([LHDBPath instanceManagerWith:nil].dbPath.length == 0) {
        return DatabasePath;
    }else
        return [LHDBPath instanceManagerWith:nil].dbPath;
}

+ (NSString*)dbPath
{
    if ([LHDBPath instanceManagerWith:nil].dbPath.length == 0) {
        return DatabasePath;
    }else
        return [LHDBPath instanceManagerWith:nil].dbPath;
}

- (void)setFilePath:(NSString *)filePath
{
    objc_setAssociatedObject(self, &DatabaseFilePath, filePath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)filePath
{
    return objc_getAssociatedObject(self, &DatabaseFilePath);
}

+ (void)createTable
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:createTableString(self) object:nil executeType:LHSqliteTypeWrite success:nil fail:nil];
}

+ (void)addColum:(NSString*)name
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:addColum(self, name) object:nil executeType:LHSqliteTypeWrite success:nil fail:nil];
}

- (void)save
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:insertString(self) object:self executeType:LHSqliteTypeWrite success:nil fail:nil];
}

+ (void)saveWithDic:(NSDictionary*)dic
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:insertStringWithDic(self, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:nil];
}

- (void)saveWithIfError:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:insertString(self) object:self executeType:LHSqliteTypeWrite success:nil fail:error];
}

+ (void)saveWithDic:(NSDictionary*)dic error:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:insertStringWithDic(self, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:error];
}

- (void)updateWithPredicate:(LHPredicate*)predicate
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:updateString(self, predicate) object:self executeType:LHSqliteTypeWrite success:nil fail:nil];
}

+ (void)updateWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:updateStringWithDic(self, predicate, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:nil];
}

- (void)updateWithPredicate:(LHPredicate*)predicate error:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:updateString(self, predicate) object:self executeType:LHSqliteTypeWrite success:nil fail:error];
}

+ (void)updateWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate error:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:updateStringWithDic(self, predicate, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:error];
}

+ (void)deleteWithPredicate:(LHPredicate*)predicate
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:deleteString(self, predicate) object:nil executeType:LHSqliteTypeWrite success:nil fail:nil];
}

+ (void)deleteWithPredicate:(LHPredicate*)predicate error:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    [sqlite executeSQLWithSqlstring:deleteString(self, predicate) object:nil executeType:LHSqliteTypeWrite success:nil fail:error];
}

+ (NSArray*)selectWithPredicate:(LHPredicate*)predicate
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    __block NSMutableArray* array = [NSMutableArray array];
    [sqlite executeSQLWithSqlstring:selectString(self, predicate) object:nil executeType:LHSqliteTypeRead success:^(NSArray *result) {
        for (NSDictionary* dic in result) {
            [array addObject:[self lh_ModelWithDictionary:dic]];
        }
    } fail:nil];
    return array;
}

+ (NSArray*)selectWithPredicate:(LHPredicate*)predicate error:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    __block NSMutableArray* array = [NSMutableArray array];
    [sqlite executeSQLWithSqlstring:selectString(self, predicate) object:nil executeType:LHSqliteTypeRead success:^(NSArray *result) {
        for (NSDictionary* dic in result) {
            [array addObject:[self lh_ModelWithDictionary:dic]];
        }
    } fail:error];
    return array;
}

+ (void)inQueueCreateTable
{
    run_in_queue([self createTable]);
}

+ (void)inQueueAddColum:(NSString*)name
{
    run_in_queue([self addColum:name]);
}

- (void)inQueueSave
{
    run_in_queue([self save]);
}

+ (void)inQueueSaveWithDic:(NSDictionary*)dic
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    run_in_queue([sqlite executeSQLWithSqlstring:insertStringWithDic(self, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:nil]);
}

- (void)inQueueSaveWithIfError:(executeError)fail
{
    run_in_queue([self saveWithIfError:fail]);
}

+ (void)inQueueSaveWithDic:(NSDictionary*)dic error:(executeError)fail
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    run_in_queue([sqlite executeSQLWithSqlstring:insertStringWithDic(self, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:fail]);
}

- (void)inQueueUpdateWithPredicate:(LHPredicate*)predicate
{
    run_in_queue([self updateWithPredicate:predicate]);
}

+ (void)inQueueUpdateWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    run_in_queue([sqlite executeSQLWithSqlstring:updateStringWithDic(self, predicate, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:nil]);
}

- (void)inQueueUpdateWithPredicate:(LHPredicate*)predicate error:(executeError)fail
{
    run_in_queue([self updateWithPredicate:predicate error:fail]);
}

+ (void)inQueueUpdateWithDic:(NSDictionary*)dic predicate:(LHPredicate *)predicate error:(executeError)error
{
    LHSqlite* sqlite = [LHSqlite shareInstance];
    sqlite.sqlPath = [self dbPath];
    run_in_queue([sqlite executeSQLWithSqlstring:updateStringWithDic(self, predicate, dic) object:dic executeType:LHSqliteTypeWrite success:nil fail:error]);
}

+ (void)inQueueDeleteWithPredicate:(LHPredicate*)predicate
{
    run_in_queue([self deleteWithPredicate:predicate]);
}

+ (void)inQueueDeleteWithPredicate:(LHPredicate*)predicate error:(executeError)fail
{
    run_in_queue([self deleteWithPredicate:predicate error:fail]);
}

+ (void)inQueueSelectWithPredicate:(LHPredicate*)predicate result:(void(^)(NSArray* resultArray))result
{
    run_in_queue(result([self selectWithPredicate:predicate]));
}

+ (void)inQueueSelectWithPredicate:(LHPredicate*)predicate result:(void(^)(NSArray* resultArray))result error:(executeError)fail
{
    
    run_in_queue(result([self selectWithPredicate:predicate error:fail]));
}

@end
