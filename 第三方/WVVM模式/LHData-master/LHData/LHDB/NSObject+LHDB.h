//
//  NSObject+LHModelExecute.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/2/15.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^executeError)(NSError* error);

@class LHSqlite,LHPredicate;
@interface NSObject (LHDB)

/*
    不在队列中执行，无法保证线程安全
*/
/*
 类方法直接建表
 */
+ (void)createTable;

/*
 传人属性名,对一个已经存在的表增加字段
 */
+ (void)addColum:(NSString*)name;

/*
 插入操作
 */
- (void)save;

+ (void)saveWithDic:(NSDictionary*)dic;

/*
 插入操作,如果失败,返回错误信息
 */
- (void)saveWithIfError:(executeError)error;

+ (void)saveWithDic:(NSDictionary*)dic error:(executeError)error;

/*
 更新操作,predicate 更新的范围  类似NSPredicate
 */
- (void)updateWithPredicate:(LHPredicate*)predicate;

+ (void)updateWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate;

- (void)updateWithPredicate:(LHPredicate*)predicate error:(executeError)error;

+ (void)updateWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate error:(executeError)error;

+ (void)deleteWithPredicate:(LHPredicate*)predicate;

+ (void)deleteWithPredicate:(LHPredicate*)predicate error:(executeError)error;

+ (NSArray*)selectWithPredicate:(LHPredicate*)predicate;

+ (NSArray*)selectWithPredicate:(LHPredicate*)predicate error:(executeError)error;

/*
    所有数据库操作全部是线程安全，不需要担心数据库锁住
    所有操作都是异步执行,回调的block也是在子线程中
 */

+ (void)inQueueCreateTable;

+ (void)inQueueAddColum:(NSString*)name;

- (void)inQueueSave;

+ (void)inQueueSaveWithDic:(NSDictionary*)dic;

- (void)inQueueSaveWithIfError:(executeError)fail;

+ (void)inQueueSaveWithDic:(NSDictionary*)dic error:(executeError)fail;

- (void)inQueueUpdateWithPredicate:(LHPredicate*)predicate;

+ (void)inQueueUpdateWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate;

- (void)inQueueUpdateWithPredicate:(LHPredicate*)predicate error:(executeError)fail;

+ (void)inQueueUpdateWithDic:(NSDictionary*)dic predicate:(LHPredicate *)predicate error:(executeError)error;

+ (void)inQueueDeleteWithPredicate:(LHPredicate*)predicate;

+ (void)inQueueDeleteWithPredicate:(LHPredicate*)predicate error:(executeError)fail;

+ (void)inQueueSelectWithPredicate:(LHPredicate*)predicate result:(void(^)(NSArray* resultArray))result;

+ (void)inQueueSelectWithPredicate:(LHPredicate*)predicate result:(void(^)(NSArray* resultArray))result error:(executeError)fail;

@end
