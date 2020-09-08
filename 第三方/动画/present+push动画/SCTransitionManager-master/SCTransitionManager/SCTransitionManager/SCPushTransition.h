//
//  SCPushTransition.h
//  SCTransitionManager
//
//  Created by sichenwang on 16/7/21.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPushTransition : NSObject

// push
+ (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(void (^)())completion;
+ (void)pushViewController:(UIViewController *)viewController
  fromNavigationController:(UINavigationController *)navigationController
                  animated:(BOOL)animated
                completion:(void (^)())completion;
+ (void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers
                   animated:(BOOL)animated
                 completion:(void (^)())completion;
+ (void)pushViewController:(UIViewController *)viewController
                sourceView:(UIView *)sourceView
                targetView:(UIView *)targetView
                  animated:(BOOL)animated
                completion:(void (^)())completion;

// set
+ (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated
                completion:(void (^)())completion;
+ (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
  fromNavigationController:(UINavigationController *)navigationController
                  animated:(BOOL)animated
                completion:(void (^)())completion;

// pop
+ (UIViewController *)popViewControllerAnimated:(BOOL)animated
                                     completion:(void (^)())completion;
+ (NSArray *)popToViewController:(UIViewController *)viewController
                        animated:(BOOL)animated
                      completion:(void (^)())completion;
+ (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
                                  completion:(void (^)())completion;

@end
