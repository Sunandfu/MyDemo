//
//  SCNormalDismissTransition.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/7.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCNormalDismissTransition.h"

@implementation SCNormalDismissTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // toView
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView sendSubviewToBack:toView];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toInitFrame = CGRectOffset(toFinalFrame, -toFinalFrame.size.width / 3, 0);
    toView.frame = toInitFrame;

    // fromView
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    CGRect fromInitFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromFinalFrame = CGRectOffset(fromInitFrame, [[UIScreen mainScreen] bounds].size.width, 0);
    
    // animate
    void (^animationBlock)() = ^(){
        fromView.frame = fromFinalFrame;
        toView.frame = toFinalFrame;
    };
    void (^animationCompleteBlock)(BOOL finished) = ^(BOOL finished){
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };

    // 1.右划返回手势，加入速度判断，如果速度大于阀值，则无论滑动过程是否超过50%，都认为手势成功
    // 2.右划手势返回和点返回按钮的动画时间函数不同
    UIViewAnimationOptions opts = transitionContext.isInteractive ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseOut;

    if (self.context.gestureFinished && transitionContext.isInteractive) {
        animationBlock();
        animationCompleteBlock(YES);
    } else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionOverrideInheritedOptions | opts |UIViewAnimationOptionTransitionNone
                         animations:animationBlock completion:animationCompleteBlock];
    }
}

@end
