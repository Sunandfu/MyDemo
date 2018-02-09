//
//  LHFileCache.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/25.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHFileCache : NSObject
/*
 *当key存在,是否希望追加写入data
 *默认为no key存在时会替换原有的数据 if yes  则会在存在的data之后拼接数据
 */
@property BOOL cacheShouldAppend;
/*
 *读取大文件时 一次读取的数据量  default is 1024
 */
@property NSUInteger bufferSize;
/*
 *filecache所有文件的大小
 */
@property (readonly) NSUInteger  length;

/*
 *存储data
 *@param data :要存储的数据
 *@param key :data对应的标志   不是路径
 */
- (BOOL)setData:(NSData*)data forKey:(NSString*)key;

- (NSData*)dataForKey:(NSString*)key;
/*
 *大文件的读取
 *此方法是异步
 *回调每次读取的数据量
 */
- (void)readLargerDataForKey:(NSString*)key readCallback:(void(^)(NSData* data))callback;

/*
 *根据标志删除文件
 */
- (void)removeDataForKey:(NSString*)key;
/*
 *删除所有文件
 */
- (void)removeAllData;

@end
