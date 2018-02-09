//
//  XHQAuxiliary.h
//  AutoHome
//
//  Created by qianfeng on 16/3/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XHQAuxiliary : NSObject

+ (BOOL)DeviceIsIOS8orLater;
+ (BOOL)DeviceIsIpone6orLater;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSUInteger)buttons done:(void(^)())act;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSArray *)buttons done:(void (^)())agree cancel:(void(^)())disagree;

+ (CATransition *)transitWithProperties:(NSDictionary *)propertites;

+ (CGFloat)dynamicHeightWithString:(NSString *)string width:(CGFloat)width attribute:(NSDictionary *)attrs;

+ (void)layerCornerRadius:(CALayer *)dest radius:(float)radius width:(float)width color:(UIColor *)color;



+ (BOOL)validateUserName:(NSString *)name rule:(NSString *)rule;

+ (BOOL)validateMobile:(NSString *)mobile;

+ (BOOL)validateIdentityCard:(NSString *)identityCard;
+ (BOOL) validatePassword:(NSString *)passWord  rule:(NSString*)rule;


+ (BOOL)validateEmail:(NSString *)email;

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com