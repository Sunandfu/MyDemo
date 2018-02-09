//
//  SFTool.h
//  45678
//
//  Created by 小富 on 16/3/31.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFTool : NSObject
//是否在iOSnumber以上
+ (BOOL)DeviceorLaterIsSystemVersion:(double)number;
+ (BOOL)DeviceIsIpone6orLater;
#pragma mark alert弹框提示
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message button:(NSUInteger)buttons done:(void(^)())act;

+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSArray<NSString *>*)buttons done:(void (^)())agree cancel:(void (^)())disagree;
//跳转动画
+ (CATransition *)transitWithProperties:(NSDictionary *)propertites;

+ (CGFloat)dynamicHeightWithString:(NSString *)string width:(CGFloat)width attribute:(NSDictionary *)attrs;

+ (void)layerCornerRadius:(CALayer *)dest radius:(float)radius width:(float)width color:(UIColor *)color;

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
//设置多于的分割线  该方法在创建完tableView完之后再调用
+(void)setExtraCellLineHidden: (UITableView *)tableView;

//获取当前的设备
+ (NSString *)getCurrentDeviceModel;

//通过字符串的长度来设置label的高度
+(CGFloat)setLabelHeightWithString:(NSString *)str label:(UILabel *)label;

#pragma mark 获取当前的北京时间
+(NSString *)getBeijingNowTime;


#pragma mark 正则匹配手机号
+ (BOOL)validateMobileNumber:(NSString *)string;
/*手机号码验证 MODIFIED BY HELENSONG(正则表达式)*/
+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL) validateMobile:(NSString *)mobile;

#pragma mark 判断用户名与密码
//用户名
+ (BOOL) validateUserName:(NSString *)name rule:(NSString*)rule;
//密码
+ (BOOL) validatePassword:(NSString *)passWord  rule:(NSString*)rule;
//判断密码6-16位
+(BOOL)validatePassword:(NSString *)password;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;


#pragma mark 正则匹配邮政编码
+ (BOOL)validatePostCodeNumber:(NSString *)string;
#pragma mark 邮箱
+ (BOOL) validateEmail:(NSString *)email;

//判断字符串是否为[NSNULL Class]
+ (BOOL)isEmpty:(NSString*)str;

#pragma mark 拨打电话
+ (void)callAndBack:(NSString *)phoneNum;

//#pragma mark 判断耳机是否插入
//+ (BOOL)isHeadphone;

#pragma mark 是否是纯数字
+ (BOOL)isNumText:(NSString *)str;


//姓名校验
+(BOOL)checkUserName:(NSString *)userName;
#pragma mark 二维码制作
/*
 @abstract：根据传入的字符串生成二维码
 @para:  text 要生成二维码的文字；
 size 指定分辨率
 @return: 返回二维码的图片
 */
+(UIImage*) generateQRCode:(NSString*)text size:(CGFloat)size;

//给二维码染色，背景透明
+(UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

#pragma mark Factory
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
