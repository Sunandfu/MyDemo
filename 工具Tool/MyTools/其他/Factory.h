//
//  Factory.h
//  StopWatchDemo
//
//  Created by Hailong.wang on 15/7/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Addition.h"
@interface Factory : NSObject

//设置多于的分割线  该方法在创建完tableView完之后再调用
+(void)setExtraCellLineHidden: (UITableView *)tableView;

//获取当前的设备
+ (NSString *)getCurrentDeviceModel;

//通过字符串的长度来设置label的高度
+(CGFloat)setLabelHeightWithString:(NSString *)str label:(UILabel *)label;

/*手机号码验证 MODIFIED BY HELENSONG(正则表达式)*/
+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL)isMobileNumber:(NSString *)mobileNum;

//判断密码6-16位
+(BOOL)validatePassword:(NSString *)password;

//获取当前的北京时间
+(NSString *)getBeijingNowTime;

//创建Button的工厂，将特殊的元素传入，生产相对应的Button
+ (UIButton *)createButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)target selector:(SEL)selector color:(UIColor *)color;

//创建普通的button
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target Selector:(SEL)selector;

//创建Label的工厂，将特殊的元素传入，生产相对应的Label
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame;
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color;
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)size;
+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size;

//创建View的工厂，将特殊的元素传入，生产相应的View
+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame;

//创建textField的工厂，将特殊的元素传入，生产响应的textField
+ (UITextField *)createViewWithText:(NSString *)text frame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle;
//根据控件的大小切割图片
+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *) sourceImage;

//把图片做等比缩放，生成一个新图片
+ (UIImage *) imageByScalingProportionallyToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage;

@end
