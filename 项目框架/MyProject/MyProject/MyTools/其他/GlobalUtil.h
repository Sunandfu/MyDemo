//
//  GlobalUtil.h
//  TvBuy
//
//  Created by qianhe on 14/6/25.
//  Copyright (c) 2014年 Beijing CHSY E-Business Co., Ltd. All rights reserved.
//
#import "MBProgressHUD.h"

@interface GlobalUtil : NSObject

#pragma mark 判断是否有网络
+ (BOOL)networkIsPing;

+ (BOOL)networkIsWIFI;

#pragma mark 正则匹配手机号
+ (BOOL)validateMobileNumber:(NSString *)string;

#pragma mark 正则匹配邮政编码
+ (BOOL)validatePostCodeNumber:(NSString *)string;

#pragma mark 正则匹配——禁止输入中文且是6-16位之间非空格的任意字符
+ (BOOL)validatePassword:(NSString *)string;

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg;

+ (BOOL)isEmpty:(NSString*)str;

/**
 *  延迟显示MBProgressHud
 *
 *  @param mainViewController 显示的ViewController
 *  @param hudType            显示原生的样式或者自定义的样式
 */

+ (void)showLoadingOnController:(UIViewController *)viewController andTitle:(NSString *)title;
/**
 *  隐藏MBProgressHudinterface error
 *
 *  @param mainViewController
 */
+ (void)hideProgressHud:(UIViewController *)mainViewController;

/**
 *  MBProgressHud样式的提示文字(此方法只能在导航控制器中使用)
 *
 *  @param viewController
 *  @param title
 */
+ ( MBProgressHUD *)showMBProgressHudOnController:(UIViewController *)viewController withTitle:(NSString *)title;

+( MBProgressHUD *)showMBProgressHudOnView:(UIView *)view withTitle:(NSString *)title;
+ (void)hideProgressHudOfView:(UIView *)view;
/**
 *  操作完成提示
 *
 *  @param viewController
 *  @param title          完成提示(例如: 收藏成功, 删除成功)
 */
+ (void)showCompleteOnController:(UIViewController *)viewController andTitle:(NSString *)title;


//#pragma mark 代码创建纯色背景的按钮
//+ (ColorButton*)buttonWithTarget:(id)target action:(SEL)action title:(NSString*)title titleColor:(UIColor*)color frame:(CGRect)frame isWeiZone:(BOOL)isWeiZone;

//#pragma mark 微公社导航条
//+ (void)WeiZoneNavBarConfig:(CustomNavBar_iPhone*)navBar;


#pragma mark 拨打电话
+ (void)callAndBack:(NSString *)phoneNum;

//#pragma mark 判断耳机是否插入
//+ (BOOL)isHeadphone;

#pragma mark 是否是纯数字
+ (BOOL)isNumText:(NSString *)str;

//定制app的皮肤
//+ (void)customizeAppearance;

#pragma mark - 身份证识别
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

//姓名校验
+(BOOL)checkUserName:(NSString *)userName;

//解析网络数据json
+(NSDictionary *)analyzeRequestDataOfJSON:(id)responseObject;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
@end
