//
//  AppDelegate.h
//  mySelfProject
//
//  Created by 小富 on 16/3/14.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabbarController;
@property (strong, nonatomic) UINavigationController *navController;

@end

