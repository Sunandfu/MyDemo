//
//  SCZoomPresentTransition.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/9.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCZoomPresentTransition.h"
#import "UIView+Capture.h"

@implementation SCZoomPresentTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.alpha = 0;
    [transitionContext.containerView addSubview:toViewController.view];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    CGRect originFrame = self.view.frame;
    UIView *sourceVCSnapshotView = self.view.captureView;
    UIView *backgroundView = [[UIView alloc] initWithFrame:originFrame];
    backgroundView.backgroundColor = [UIColor colorWithRed:238.0/255.0
                                                     green:238.0/255.0
                                                      blue:238.0/255.0
                                                     alpha:1.0];
    [self.view.superview insertSubview:backgroundView aboveSubview:self.view];
    sourceVCSnapshotView.frame = backgroundView.bounds;
    [backgroundView addSubview:sourceVCSnapshotView];
    
    UIView *animationView = [[UIView alloc] initWithFrame:self.view.frame];
    animationView.backgroundColor = [UIColor clearColor];
    [self.view.superview insertSubview:animationView aboveSubview:backgroundView];
    
    UIView *imageViewSourceVC = self.sourceView.captureView;
    CGRect frameInVCView = [self.sourceView convertRect:self.sourceView.bounds toView:animationView];
    imageViewSourceVC.frame = frameInVCView;
    imageViewSourceVC.contentMode = self.sourceView.contentMode;
    [animationView addSubview:imageViewSourceVC];
    
    CGPoint centerobj = [self.sourceView convertPoint:CGPointMake(self.sourceView.bounds.size.width / 2, self.sourceView.bounds.size.height / 2) toView:self.view];
    
    CGRect targetFrame = self.targetView.frame;
    CGPoint centerOfTargetFrame = CGPointMake(targetFrame.origin.x + targetFrame.size.width / 2, targetFrame.origin.y + targetFrame.size.height / 2);
    
    CGFloat deltaXToTargetFrameCenter = centerOfTargetFrame.x - centerobj.x;
    CGFloat deltaYToTargetFrameCenter = centerOfTargetFrame.y - centerobj.y;
    CGRect frame = sourceVCSnapshotView.layer.frame;
    sourceVCSnapshotView.layer.anchorPoint = CGPointMake(centerOfTargetFrame.x / sourceVCSnapshotView.bounds.size.width, centerOfTargetFrame.y / sourceVCSnapshotView.bounds.size.height);
    sourceVCSnapshotView.layer.frame = frame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        sourceVCSnapshotView.alpha = 0.0;
        
        CGFloat xScale = targetFrame.size.width / self.sourceView.bounds.size.width;
        CGFloat yScale = xScale;
        sourceVCSnapshotView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(deltaXToTargetFrameCenter, deltaYToTargetFrameCenter), CGAffineTransformMakeScale(xScale,yScale)) ;
        
        imageViewSourceVC.frame = CGRectMake(targetFrame.origin.x, targetFrame.origin.y, imageViewSourceVC.frame.size.width * xScale, imageViewSourceVC.frame.size.height * yScale);
        
    } completion:^(BOOL finished) {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [UIView animateWithDuration:0.2 animations:^{
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            [animationView removeFromSuperview];
            [imageViewSourceVC removeFromSuperview];
            [backgroundView removeFromSuperview];
            [transitionContext completeTransition:YES];
            [[UIApplication sharedApplication ] endIgnoringInteractionEvents];
        }];
    }];
}

@end
