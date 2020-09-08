//
//  SCPresentTransition.h
//  SCTransitionManager
//
//  Created by sichenwang on 16/7/21.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPresentTransition : NSObject

// present
+ (void)presentViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^)())completion;
+ (void)presentViewController:(UIViewController *)viewController
                   sourceView:(UIView *)sourceView
                   targetView:(UIView *)targetView
                     animated:(BOOL)animated
                   completion:(void (^)())completion;

// dismiss
+ (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)())completion;
+ (void)dismissToViewController:(UIViewController *)viewController
                       animated:(BOOL)animated
                     completion:(void (^)())completion;
+ (void)dismissToRootViewControllerAnimated:(BOOL)animated
                                 completion:(void (^)())completion;

@end
