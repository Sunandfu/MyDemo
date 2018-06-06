//
//  AppDelegate+RootController.h
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (RootController)

/**
 *  首次启动轮播图
 */
- (void)createLoadingScrollView;

/**
 *  window实例
 */
- (void)setAppWindows;

/**
 *  设置根视图
 */
- (void)setRootViewController;

/**
 *  首次启动登陆页
 */
- (void)createLoadingLoginVC;

@end
