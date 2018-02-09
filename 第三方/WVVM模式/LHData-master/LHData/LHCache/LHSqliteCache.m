//
//  LHSqliteCache.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/25.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHSqliteCache.h"
#import "LHDB.h"
#define CachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"com.sancai.lhsqlitecache"]

#define DataBasePath [CachePath stringByAppendingPathComponent:@"data.sqlite"]

@interface LHSqliteCacheModel : NSObject

@property (nonatomic,strong) NSData* value;

@property (nonatomic,copy) NSString* key;

@property (nonatomic,strong) NSDate* updateDate;

@property (nonatomic,assign) NSUInteger useCount;

@end

@implementation LHSqliteCacheModel



@end

static void createCachePath()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:CachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:CachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
}

@implementation LHSqliteCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        [LHDBPath instanceManagerWith:DataBasePath];
        createCachePath();
        [LHSqliteCacheModel createTable];
        _overtime = -1;
        _dbPath = DataBasePath;
    }
    return self;
}

- (void)setData:(NSData *)data forKey:(NSString *)key
{
    if (![key isKindOfClass:[NSString class]]||key.length== 0) return;
    LHPredicate* predicate = [LHPredicate predicateWithFormat:@"key = '%@'",key];
    NSArray* result = [LHSqliteCacheModel selectWithPredicate:predicate];
    if (result.count>0) {
        NSDictionary* dic = @{@"value":data,@"updateDate":[NSDate date]};
        [LHSqliteCacheModel updateWithDic:dic predicate:predicate];
    }else {
        NSDictionary* dic = @{@"value":data,@"updateDate":[NSDate date],@"key":key};
        [LHSqliteCacheModel saveWithDic:dic];
    }
}

- (NSData*)dataForKey:(NSString*)key
{
    [LHDBPath instanceManagerWith:DataBasePath];
    if (![key isKindOfClass:[NSString class]]||key.length== 0) return nil;
    LHPredicate* predicate = [LHPredicate predicateWithFormat:@"key = '%@'",key];
    NSArray* result = [LHSqliteCacheModel selectWithPredicate:predicate];
    if (result.count>0) {
        LHSqliteCacheModel* model = [result firstObject];
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:model.updateDate];
        if (time>_overtime&&_overtime>0) {
            [LHSqliteCacheModel deleteWithPredicate:predicate];
            return nil;
        }else {
            model.useCount += 1;
            [model updateWithPredicate:predicate];
        }
        return model.value;
    }
    return nil;
}

- (void)removeAllData
{
    [LHSqliteCacheModel deleteWithPredicate:nil];
}

- (void)removeInactiveData
{
    NSArray* result = [LHSqliteCacheModel selectWithPredicate:[LHPredicate predicateWithString:nil OrderBy:@"useCount asc"]];
    for (LHSqliteCacheModel* model in result) {
        if (model.useCount <= 2) {
            [LHSqliteCacheModel deleteWithPredicate:[LHPredicate predicateWithFormat:@"key = '%@'",model.key]];
        }
    }
}

- (void)deleteDB
{
    [[NSFileManager defaultManager] removeItemAtPath:DataBasePath error:nil];
}

@end
