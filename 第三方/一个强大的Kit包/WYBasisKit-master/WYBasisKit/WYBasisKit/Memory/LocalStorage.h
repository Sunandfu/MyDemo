//
//  LocalStorage.h
//  WYBasisKit
//
//  Created by  jacke-xu on 2018/6/14.
//  Copyright © 2018年 jacke-xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject

/** 获取缓存数据单例 */
+ (LocalStorage *)shared;

/**
 * 向本地存储一个数组
 * @param  array     要存储的数组
 * @param  arrayKey  要存储的数组的键值
 */
- (void)storageArray:(NSArray *)array forKey:(NSString *)arrayKey;

/**
 * 返回一个数组
 * @param  arrayKey  要获取的数组的键值
 */
- (NSArray *)fetchStorageArrayForKey:(NSString *)arrayKey;

/**
 * 向本地存储一个字典
 * @param  dictionary     要存储的字典
 * @param  dictionaryKey  要存储的字典的键值
 */
- (void)storageDictionary:(NSDictionary *)dictionary forKey:(NSString *)dictionaryKey;

/**
 * 返回一个字典
 * @param  dictionaryKey  要获取的字典的键值
 */
- (NSDictionary *)fetchStorageDictionaryForKey:(NSString *)dictionaryKey;

@end
