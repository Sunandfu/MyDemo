//
//  NSString+PinYin.h
//  ZMPinYinDemo
//
//  Created by ZengZhiming on 2017/3/31.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYin)


/**
 将中文字符串转换为拼音格式（带声调）
 
 @return 返回带声调拼音字符串
 */
- (NSString *)transformToPinyinTone;


/**
 将中文字符串转换为拼音格式（不带声调）
 
 @return 返回不带声调拼音字符串
 */
- (NSString *)transformToPinyin;


/**
 将中字符串转换为拼音首字母
 
 @return 拼音首字母字符串
 */
- (NSString *)transformToFirstLetter;


@end
