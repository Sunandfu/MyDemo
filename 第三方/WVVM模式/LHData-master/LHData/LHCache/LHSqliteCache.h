//
//  LHSqliteCache.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/25.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSqliteCache : NSObject
/*
 *数据库路径  无法修改
 */
@property (nonatomic,strong,readonly) NSString* dbPath;
/*
 *过期时间,最后一次更新时间到当前使用时间,当超过这个时间，数据就会清除 default = -1 永久保存
 */
@property (nonatomic,assign) NSTimeInterval overtime;
/*
 *存储data   如果数据存在则更新  不存在插入
 */
- (void)setData:(NSData*)data forKey:(NSString*)key;

- (NSData*)dataForKey:(NSString*)key;
/*
 *清除所有不常用的数据
 */
- (void)removeInactiveData;
/*
 清除所有数据
 */
- (void)removeAllData;
/*
 *删除数据库文件
 */
- (void)deleteDB;

@end
