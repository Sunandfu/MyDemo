//
//  SFSqliteTool.m
//  ReadBook
//
//  Created by lurich on 2020/5/20.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFSqliteTool.h"
#import "FMDB.h"

#define DataBasePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Downloads.db"]

@implementation SFSqliteTool

+ (FMDatabaseQueue *)defaultDatabaseQueue
{
    static FMDatabaseQueue * databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
        NSLog(@"数据库路径:%@",DataBasePath);
    });
    return databaseQueue;
}

#pragma mark - 数据

NSString * createDB = @"create table if not exists Datas(ID integer primary key autoincrement,scriptId text,scriptImage text,scriptName text,startNumberMin integer,startNumberMax integer,scriptLevel text,scriptType text,duration text,scriptClass text,scriptScore text,author text,scriptIntro text,scriptFlake text,isDownload integer,isOnline integer);";

+ (BOOL)insertData:(SFSqliteModel *)data
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createDB;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * insert = [NSString stringWithFormat:@"insert into Datas(ID,scriptId,scriptImage,scriptName,startNumberMin,startNumberMax,scriptLevel,scriptType,duration,scriptClass,scriptScore,author,scriptIntro,scriptFlake,isDownload,isOnline)values('%ld','%@','%@','%@','%ld','%ld','%@','%@','%@','%@',%@,'%@','%@','%@','%ld','%ld');",data.ID,data.scriptId,data.scriptImage,data.scriptName,(long)data.startNumberMin,(long)data.startNumberMax,data.scriptLevel,data.scriptType,data.duration,data.scriptClass,data.scriptScore,data.author,data.scriptIntro,data.scriptFlake,(long)data.isDownload,(long)data.isOnline];
            work = [db executeUpdate:insert];
        }
    }];
    return work;
}

+ (BOOL)deleteData:(SFSqliteModel *)data
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createDB;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString *delete = [NSString stringWithFormat:@"delete from Datas where ID = %zd",data.ID];
            work = [db executeUpdate:delete];
        }
    }];
    return work;
}

+ (BOOL)updateData:(SFSqliteModel *)data
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createDB;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * update = [NSString stringWithFormat:@"update Datas set scriptId = '%@',scriptImage = '%@',scriptName = '%@',startNumberMin = '%ld',startNumberMax = '%ld',scriptLevel = '%@',scriptType = '%@',duration = '%@',scriptClass = '%@',scriptScore = '%@',author = '%@',scriptIntro = '%@',scriptFlake = '%@',isDownload = '%ld',isOnline = '%ld' where ID = %ld ;",data.scriptId,data.scriptImage,data.scriptName,(long)data.startNumberMin,(long)data.startNumberMax,data.scriptLevel,data.scriptType,data.duration,data.scriptClass,data.scriptScore,data.author,data.scriptIntro,data.scriptFlake,(long)data.isDownload,(long)data.isOnline,data.ID];
            work = [db executeUpdate:update];
        }
    }];
    return work;
}

+ (SFSqliteModel *)selectedDataID:(NSString *)scriptId
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block SFSqliteModel *data = nil;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createDB;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from Datas";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                NSString *dataID = [set stringForColumn:@"scriptId"];
                if ([dataID isEqualToString:scriptId]) {
                    data = [SFSqliteModel new];
                    data.scriptId = [set stringForColumn:@"scriptId"];
                    data.scriptImage = [set stringForColumn:@"scriptImage"];
                    data.scriptName = [set stringForColumn:@"scriptName"];
                    data.startNumberMin = [set longForColumn:@"startNumberMin"];
                    data.startNumberMax = [set longForColumn:@"startNumberMax"];
                    data.scriptLevel = [set stringForColumn:@"scriptLevel"];
                    data.scriptType = [set stringForColumn:@"scriptType"];
                    data.duration = [set stringForColumn:@"duration"];
                    data.scriptClass = [set stringForColumn:@"scriptClass"];
                    data.scriptScore = [set stringForColumn:@"scriptScore"];
                    data.author = [set stringForColumn:@"author"];
                    data.scriptIntro = [set stringForColumn:@"scriptIntro"];
                    data.scriptFlake = [set stringForColumn:@"scriptFlake"];
                    data.isDownload = [set longForColumn:@"isDownload"];
                    data.isOnline = [set longForColumn:@"isOnline"];
                    break;
                }
            }
            [set close];
        }
    }];
    return data;
}

+ (BOOL)deleteDataTable
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createDB;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * delete = [NSString stringWithFormat:@"drop table if exists Datas"];
            work = [db executeUpdate:delete];
        }
    }];
    return work;
}

+ (NSArray<SFSqliteModel *> *)selectData
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block NSMutableArray *datas = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createDB;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from Datas";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                SFSqliteModel *data = [SFSqliteModel new];
                data.scriptId = [set stringForColumn:@"scriptId"];
                data.scriptImage = [set stringForColumn:@"scriptImage"];
                data.scriptName = [set stringForColumn:@"scriptName"];
                data.startNumberMin = [set longForColumn:@"startNumberMin"];
                data.startNumberMax = [set longForColumn:@"startNumberMax"];
                data.scriptLevel = [set stringForColumn:@"scriptLevel"];
                data.scriptType = [set stringForColumn:@"scriptType"];
                data.duration = [set stringForColumn:@"duration"];
                data.scriptClass = [set stringForColumn:@"scriptClass"];
                data.scriptScore = [set stringForColumn:@"scriptScore"];
                data.author = [set stringForColumn:@"author"];
                data.scriptIntro = [set stringForColumn:@"scriptIntro"];
                data.scriptFlake = [set stringForColumn:@"scriptFlake"];
                data.isDownload = [set longForColumn:@"isDownload"];
                data.isOnline = [set longForColumn:@"isOnline"];
                [datas addObject:data];
            }
            [set close];
        }
    }];
    return [NSArray arrayWithArray:datas];
}

+ (BOOL)isHaveData:(SFSqliteModel *)data{
    NSArray *dataArray = [SFSqliteTool selectData];
    for (SFSqliteModel *model in dataArray) {
        if ([model.scriptId isEqualToString:data.scriptId] ) {
            return YES;
        }
    }
    return NO;
}

@end
