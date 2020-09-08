//
//  SCZoomPresentTransition.h
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/9.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCZoomPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

/**
 *  动画开始时，进行缩放动画的UIView对象
 */
@property (nonatomic, weak) UIView *sourceView;

/**
 *  动画结束时，缩放动画完成的UIView对象
 */
@property (nonatomic, weak) UIView *targetView;

/**
 *  起始view，即ViewController.view
 */
@property (nonatomic, weak) UIView *view;

@end
