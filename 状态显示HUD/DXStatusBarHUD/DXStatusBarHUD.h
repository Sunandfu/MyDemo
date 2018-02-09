//
//  DXStatusBarHUD.h
//  JS-网易新闻案例
//
//  Created by xiongdexi on 16/3/5.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXStatusBarHUD : NSObject

/**
 *  显示加载
 *
 *  @param msg 文字信息
 */
+ (void)showLoading:(NSString *)msg;
/**
 *  隐藏加载窗口
 */
+ (void)hideLoading;

/**
 *  显示信息
 *
 *  @param msg   文字内容
 *  @param image 图片对象
 */
+ (void)showMessage:(NSString *)msg image:(UIImage *)image;

/**
 *  显示信息
 *
 *  @param msg     文字内容
 *  @param imgName 图片名称 (图片高度最好在 20 以内, 仅限于本地图片)
 */
+ (void)showMessage:(NSString *)msg imgName:(NSString *)imgName;

/**
 *  显示成功信息: 传入需要展示信息的文字字符串
 */
+ (void)showSuccess:(NSString *)msg;

/**
 *  显示失败的信息: 传入需要展示信息的文字字符串
 */
+ (void)showError:(NSString *)msg;

@end
