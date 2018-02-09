//
//  CustomPercentDriver.m
//  JKSPatients
//
//  Created by 张春雨 on 2017/3/4.
//  Copyright © 2017年 张 春雨. All rights reserved.
//

#import "CustomPercentDriver.h"

@implementation CustomPercentDriver

+ (instancetype)standardDriverWithNavController:(UINavigationController *)navController{
    return [[CustomPercentDriver alloc]initWithNavController:navController];
}

- (instancetype)initWithNavController:(UINavigationController *)navController{
    self = [super init];
    if (self) {
        _navController = navController;
    }
    return self;
}

/**
 *  Add drive gesture for viewController
 */
- (void)addGesture:(UIPanGestureRecognizer *)gesture{
    gesture.delegate = self;
    [gesture addTarget:self action:@selector(viewControllerPop:)];
}


/**
 *  Observe gesture sliding
 */
- (void)viewControllerPop:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat progress = [gestureRecognizer translationInView:gestureRecognizer.view].x / gestureRecognizer.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:{
            _driveWasExecuteing = YES;
            [self.navController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            if (progress >= 0.4) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            _driveWasExecuteing = NO;
            break;
        }
        default:
            break;
    }
}

/**
 *  Gesture limit or allow
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navController.viewControllers.count > 1 && !self.driveWasExecuteing;
}


@end
