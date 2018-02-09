//
//  CustomPercentDriver.h
//  JKSPatients
//
//  Created by 张春雨 on 2017/3/4.
//  Copyright © 2017年 张 春雨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPercentDriver : UIPercentDrivenInteractiveTransition<UIGestureRecognizerDelegate>
/** 驱动是否执行中 */
@property (nonatomic,assign,readonly) BOOL driveWasExecuteing;
/** 控制器 */
@property (nonatomic,weak) UINavigationController *navController;

/**
 * 初始化
 * @param  navController  导航控制器
 * @return                交互动画驱动者的实例
 */
+ (instancetype)standardDriverWithNavController:(UINavigationController *)navController;

/**
 * 初始化
 * @param  navController  导航控制器
 * @return                交互动画驱动者的实例
 */
- (instancetype)initWithNavController:(UINavigationController *)navController;

/**
 * 添加驱动手势
 */
- (void)addGesture:(UIPanGestureRecognizer *)gesture;
@end
