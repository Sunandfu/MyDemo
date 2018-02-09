//
//  CYNavigationTransitionAnimation.m
//  JKSPatients
//
//  Created by 张 春雨 on 2017/3/2.
//  Copyright © 2017年 张 春雨. All rights reserved.
//

#import "CustomTransitionAnimation.h"

@implementation HighlightTransitionAnimation

/**
 *  Animate time Interval
 */
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

/**
 *  Do animate
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    UIView *mask = [[UIView alloc]initWithFrame:toViewController.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3;
    toViewController.view.maskView = mask;
    
    toViewController.view.transform = CGAffineTransformMakeScale(0.94, 0.95);
    [UIView animateWithDuration:duration animations:^{
        mask.alpha = 1.0;
        toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        toViewController.view.maskView = nil;
        toViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end



@implementation NormalTransitionAnimation

/**
 *  Animate time Interval
 */
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

/**
 *  Do animate
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    UIView *mask = [[UIView alloc]initWithFrame:toViewController.view.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.5;
    toViewController.view.maskView = mask;
    
    [UIView animateWithDuration:duration animations:^{
        mask.alpha = 1.0;
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        toViewController.view.maskView = nil;
        toViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
