//
//  NSString+additional.h
//
//  Created by 史岁富 on 15/11/18.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (additional)

+ (BOOL)isMeetStandard:(NSString *)passwordString;

- (NSString *)md5;
- (BOOL)isPureInt;//是否是int
-(NSAttributedString *)selfFont:(int)sfont
                      selfColor:(UIColor *)selfColor
                      LightText:(NSString *)text
                      LightFont:(int)lfont
                     LightColor:(UIColor *)lightColor;
//去除字符串中的－
- (NSString*)trim1;
//去除字符串中的空格
- (NSString*)trim2;
//去除字符串中的@"\"
- (NSString*)trim3;
//去除字符串中的charStr
- (NSString*)trim:(NSString *)charStr;
//年月日
+ (NSString *)getDate:(NSString *)TimeInterval;
//年月日 时分秒
+ (NSString *)getDate1:(NSString *)TimeInterval;
// 得到当前时间
+ (NSString *)stringWithGetCurrentTime;
//将jsonStr 转化为 NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//将字典转化为 jsonStr
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic;
//判断是否包含某个子串
- (BOOL)isContainsSubStr:(NSString *)subStr;
//根据文字判断高度与宽度
+ (CGFloat)heightForText:(NSString *)text withWidth:(CGFloat)width WithFont:(CGFloat)font;
+ (CGFloat)widthForText:(NSString *)text withWheight:(CGFloat)height WithFont:(CGFloat)font;

@end
