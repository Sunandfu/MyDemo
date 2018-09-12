//
//  YQDataBase.h
//  YQDataBaseDevelop
//
//  Created by FreakyYang on 2017/11/14.
//  Copyright © 2017年 FreakyYang. All rights reserved.
//

//已经做好了串行线程管理

#import <Foundation/Foundation.h>

#import "YQLSSearchResultItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface YQLocalStorage : NSObject

typedef void(^YQLSBoolBlock)(BOOL succeed,NSString *_Nullable reason);

/*
     path do not need docment path at front,
     like "***.sqlite"
 */
+ (YQLocalStorage *)storageWithPath:(NSString *)path;

/*
     check before use (seggust)
 
     parameters cannot contain id & creattime & updatetime,they will automatic be created
     if creat fail,result will return by block
 */
- (void)checkOrCreatTableWithName:(NSString *)tableName
                             keys:(NSArray<NSString *>*)keys
                            block:(nullable YQLSBoolBlock)block;
/*
     delete object by ID and tableName
 */
- (void)deleteObjectWithTableName:(NSString *)tableName
                               ID:(long)ID
                            block:(nullable YQLSBoolBlock)block;

/*
 condition like " age < 60 and name = 'Wilddog' "
 */
- (void)deleteObjectWithTableName:(NSString *)tableName
                        condition:(nullable NSString *)condition
                            block:(nullable YQLSBoolBlock)block;

/*
     insert object
 */
- (void)insertObjectWithTableName:(NSString *)tableName
                             data:(NSDictionary<NSString *,NSString *> *)data
                            block:(nullable YQLSBoolBlock)block;

/*
     update object by ID
 */
- (void)updateObjectWithTableName:(NSString *)tableName
                         objectID:(long)ID
                             data:(nullable NSDictionary<NSString *,NSString *> *)data
                            block:(nullable YQLSBoolBlock)block;
/*
     update object by condition
 */
- (void)updateObjectWithTableName:(NSString *)tableName
                        condition:(nullable NSString *)conditon
                             data:(nullable NSDictionary<NSString *,NSString *> *)data
                            block:(nullable YQLSBoolBlock)block;

/*
     if pass keysArr with nil,it will return all keys when checked table
     if pass keysArr with @[] (empty Array),it will return items with empty data,but has ID,creattime,updatetime
 
     condition can be nil, like " age < 60 and name = 'Wilddog' "
     search result will return by block
 */
- (void)searchStorageWithTableName:(NSString *)tableName
                         condition:(nullable NSString *)condition
                              Keys:(nullable NSArray<NSString *>*)keysArr
                             block:(nullable void(^)(BOOL succeed,NSArray<YQLSSearchResultItem *> *_Nullable result))block;

/*
     condition can be nil, like " age < 60 and name = 'Wilddog' "
     count result will return by block
 */
- (void)countStorageWithTableName:(NSString *)tableName
                         condition:(nullable NSString *)condition
                             block:(nullable void(^)(BOOL succeed,NSUInteger count))block;

/*
     actionString just like sql string
 */
- (void)doStorageAction:(NSString *)actionString
                   block:(nullable YQLSBoolBlock)block;
@end

NS_ASSUME_NONNULL_END




