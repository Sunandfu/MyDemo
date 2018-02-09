//
//  HomeViewController.m
//  自定义tabbar
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 SSF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSFTabBar;

@protocol SSFTabBarDelegate <NSObject>

@optional
- (void)tabBar:(SSFTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

@end

@interface SSFTabBar : UIView

- (void)addTabBarItem:(UITabBarItem *)item;

@property (weak,nonatomic) id <SSFTabBarDelegate> delegate;

@end
