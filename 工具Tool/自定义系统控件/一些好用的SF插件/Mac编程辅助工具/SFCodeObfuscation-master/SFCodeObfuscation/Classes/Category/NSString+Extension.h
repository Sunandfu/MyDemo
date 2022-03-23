//
//  NSString+Extension.h
//  CodeObfuscation
//
//  Created by SF on 2018/8/16.
//  Copyright © 2018年 Lurich All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 生成length长度的随机字符串（不包含数字） */
+ (instancetype)sf_randomStringWithoutDigitalWithLength:(int)length;

/** 去除空格 */
- (instancetype)sf_stringByRemovingSpace;

/** 将字符串用空格分割成数组 */
- (NSArray *)sf_componentsSeparatedBySpace;

/** 从mainBundle中加载文件数据 */
+ (instancetype)sf_stringWithFilename:(NSString *)filename
                            extension:(NSString *)extension;

/** 生成MD5 */
- (NSString *)sf_MD5;

/** 生成crc32 */
- (NSString *)sf_crc32;

@end
