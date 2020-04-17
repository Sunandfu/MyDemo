//
//  UIViewController+UIViewController_SFScrollPageController.h
//  SFScrollPageView
//
//  Created by jasnig on 16/6/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface UIViewController (SFScrollPageController)
/**
 *  所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak, readonly) UIViewController *sf_scrollViewController;

@property (nonatomic, assign) NSInteger sf_currentIndex;




@end
