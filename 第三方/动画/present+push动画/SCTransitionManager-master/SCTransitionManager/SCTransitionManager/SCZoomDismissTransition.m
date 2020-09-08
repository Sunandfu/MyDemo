//
//  SCZoomDismissTransition.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/9.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCZoomDismissTransition.h"
#import "UIView+Capture.h"

@implementation SCZoomDismissTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:toViewController.view];
    [transitionContext.containerView sendSubviewToBack:toViewController.view];
    UIView *sourceView = self.targetView.captureView;
    UIView *animationView = [[UIView alloc] initWithFrame:self.view.frame];
    animationView.backgroundColor = [UIColor clearColor];
    [self.view.superview insertSubview:animationView aboveSubview:self.view];
    [animationView addSubview:sourceView];
    UIImage *layerImage = self.view.captureLayer;
    UIView *destinationImageView = [[UIImageView alloc] initWithImage:layerImage];
    UIView *whiteBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBgView];
    destinationImageView.frame = whiteBgView.bounds;
    [whiteBgView addSubview:destinationImageView];
    sourceView.frame = self.targetView.frame;

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *sourceVC = nil;
    if ([fromViewController isKindOfClass:[UINavigationController class]] && ((UINavigationController *)fromViewController).viewControllers.count) {
        sourceVC = ((UINavigationController *)fromViewController).viewControllers.firstObject;
    } else {
        sourceVC = fromViewController;
    }
    
    CGPoint centerOfDestinationView =  [self.sourceView convertPoint:CGPointMake(self.sourceView.frame.size.width/2, self.sourceView.frame.size.height/2) toView:self.view];
    
    CGPoint centerOfSourceFrame = CGPointMake(self.targetView.frame.origin.x + self.targetView.frame.size.width/2, self.targetView.frame.origin.y + self.targetView.frame.size.height / 2);
    
    CGFloat deltaXToSourceFrameCenter = centerOfSourceFrame.x - centerOfDestinationView.x;
    CGFloat deltaYToSourceFrameCenter = centerOfSourceFrame.y - centerOfDestinationView.y;
    
    
    CGFloat xScale = self.targetView.frame.size.width / self.sourceView.frame.size.width;
    CGFloat yScale = xScale;
    CGAffineTransform trans = CGAffineTransformConcat(CGAffineTransformMakeTranslation(deltaXToSourceFrameCenter, deltaYToSourceFrameCenter), CGAffineTransformMakeScale(xScale,yScale)) ;
    
    CGRect frame = destinationImageView.layer.frame;
    destinationImageView.layer.anchorPoint = CGPointMake(centerOfSourceFrame.x/destinationImageView.frame.size.width, centerOfSourceFrame.y/destinationImageView.frame.size.height);
    destinationImageView.layer.frame = frame;
    destinationImageView.transform = trans;
    
    
    void (^animationBlock)() = ^(){
        destinationImageView.transform = CGAffineTransformIdentity;
        destinationImageView.alpha = 1.0;
        sourceView.frame = [self.sourceView convertRect:self.sourceView.bounds toView:animationView];
    };
    
    void (^animationCompleteBlock)(BOOL finished) = ^(BOOL finished){
        [whiteBgView removeFromSuperview];
        [sourceView removeFromSuperview];
        [animationView removeFromSuperview];
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];        
    };
    
    if ([transitionContext isInteractive] && self.context.gestureFinished) {
        //这是苹果的bug，有时候手势都介绍了才触发动画返回（正常情况是手势开始就应调用这个方法），此时animation的completion不会被调用，会导致冻屏，因此出此下策
        animationBlock();
        animationCompleteBlock(YES);
    } else {
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionLayoutSubviews|UIViewAnimationOptionOverrideInheritedOptions
                                  animations:^{
                                      
                                      
                                      [UIView addKeyframeWithRelativeStartTime:0
                                                              relativeDuration:0.5
                                                                    animations:^{
                                                                        sourceVC.view.alpha = 0;
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.5
                                                              relativeDuration:0.5
                                                                    animations:animationBlock
                                       ];
                                      
                                  } completion:animationCompleteBlock];
    }
    return;
}
@end
