//
//  NSString+additional.h
//  daShu
//
//  Created by 史岁富 on 15/11/3.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (additional)
- (NSString *)md5;
- (BOOL)isPureInt;//是否是int
-(NSAttributedString *)selfFont:(int)sfont
                      selfColor:(UIColor *)selfColor
                      LightText:(NSString *)text
                      LightFont:(int)lfont
                     LightColor:(UIColor *)lightColor;
//去掉字符串中的“－”
- (NSString*)trim1;
//传入1970到现在的总秒数   返回所得到的时间 YYYY-MM-dd HH:mm:ss
+ (NSString *)getDateTime:(NSString *)TimeInterval;
//获得当前时间
+ (NSString *)stringWithGetCurrentTime;
//传入1970到现在的总秒数   返回所得到的时间  YYYY-MM-dd
+ (NSString *)getDate1:(NSString *)TimeInterval;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//判断是否包含某个字串
- (BOOL)isContainsSubStr:(NSString *)subStr;
//给出text width font 返回高度
+ (CGFloat)heightForText:(NSString *)text withWidth:(CGFloat)width WithFont:(CGFloat)font;
//给出text height font 返回宽度
+ (CGFloat)widthForText:(NSString *)text withWheight:(CGFloat)height WithFont:(CGFloat)font;
//判断密码 是否是6-20位的 只包含字母数字
+ (BOOL)isMeetStandard:(NSString *)passwordString;
@end
