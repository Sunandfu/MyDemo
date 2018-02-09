//
//  BaseViewController.m
//  智能大棚
//
//  Created by 张春雨 on 16/8/15.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYNavigationController.h"
#import "CustomPercentDriver.h"

@interface CYNavigationController ()<UINavigationControllerDelegate>
/** 驱动动画交互 */
@property (nonatomic,strong) CustomPercentDriver *transitionAnimationDriver;
@end

@implementation CYNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        //abandon system navigationbar
        for (UIView *loop in self.navigationBar.subviews) {
            loop.hidden = YES;
        }
        self.navigationBar.hidden = YES;
        self.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
        self.interactivePopGestureRecognizer.delegate = nil;
        self.transitionAnimationDriver = [CustomPercentDriver standardDriverWithNavController:self];
    }
    return self;
}

/**
 *  Realization of the push and pop
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        [self.transitionAnimationDriver addGesture:viewController.backGesture];
    }
    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}

/**
 *  ViewController did appear
 */
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}


/**
 *  Transition animation
 */
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop && self.transitionAnimationDriver.driveWasExecuteing) {
        return [[[CYNavigationConfig shared].transitionAnimationClass alloc]init];
    }
    return nil;
}

/**
 *  Transition animation of interactive
 */
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if([animationController isKindOfClass:[CYNavigationConfig shared].transitionAnimationClass]
       && self.transitionAnimationDriver.driveWasExecuteing){
        return self.transitionAnimationDriver;
    }
    return nil;
}

@end
