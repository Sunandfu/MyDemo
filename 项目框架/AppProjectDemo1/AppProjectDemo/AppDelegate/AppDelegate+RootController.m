//
//  AppDelegate+RootController.m
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "AppDelegate+RootController.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"

@implementation AppDelegate (RootController)

/**
 *  首次启动轮播图
 */
- (void)createLoadingScrollView{
    
}

/**
 *  window实例
 */
- (void)setAppWindows{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

/**
 *  设置根视图
 */
- (void)setRootViewController{
    self.window.rootViewController = [BaseTabBarController new];
}

/**
 *  首次启动登陆页
 */
- (void)createLoadingLoginVC{
    
}

@end
