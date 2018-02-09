//
//  HomeViewController.m
//  自定义tabbar
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 SSF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSFTabBar;

@interface SSFTabBarViewController : UITabBarController

+ (instancetype)shareTabBarVC;

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedimageName:(NSString *)selectedImageName;

@property (nonatomic, strong) SSFTabBar *tabbar;

@end
