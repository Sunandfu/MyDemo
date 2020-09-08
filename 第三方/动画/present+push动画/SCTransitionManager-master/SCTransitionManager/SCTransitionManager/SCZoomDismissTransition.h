//
//  SCZoomDismissTransition.h
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/9.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGestureTransitionBackContext.h"

@interface SCZoomDismissTransition : NSObject<UIViewControllerAnimatedTransitioning>

/**
 *  动画结束时，缩放动画完成的UIView对象
 */
@property (nonatomic,weak) UIView *sourceView;

/**
 *  动画开始时，进行缩放动画的UIView对象
 */
@property (nonatomic, weak) UIView *targetView;

/**
 *  目标view，即ViewController.view
 */
@property (nonatomic, weak) UIView *view;

@property (nonatomic,strong) SCGestureTransitionBackContext *context;

@end
