//
//  SCPushTransition.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/7/21.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCPushTransition.h"
#import "SCTransitionDelegateManager.h"
#import <objc/runtime.h>
#import "UIView+Capture.h"

@implementation SCPushTransition

#pragma mark - Push

+ (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
                completion:(void (^)())completion {
    [self pushViewController:viewController fromNavigationController:nil animated:animated completion:completion];
}

+ (void)pushViewController:(UIViewController *)viewController
  fromNavigationController:(UINavigationController *)navigationController
                  animated:(BOOL)animated
                completion:(void (^)())completion {
    if (viewController == nil) {
        return;
    }
    UIView *rootView = [self rootView:viewController];
    
    if (!navigationController) {
        navigationController = (UINavigationController *)self.topViewController;
    }
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        SCTransitionDelegateManager *transMgr = [[SCTransitionDelegateManager alloc] initWithView:rootView isPush:YES];
        transMgr.didPush = completion;
        navigationController.delegate = transMgr;
        objc_setAssociatedObject(viewController, TransitionKey, transMgr, OBJC_ASSOCIATION_RETAIN);
        [navigationController pushViewController:viewController animated:animated];
    }
}

+ (void)pushViewController:(UIViewController *)viewController
                sourceView:(UIView *)sourceView
                targetView:(UIView *)targetView
                  animated:(BOOL)animated
                completion:(void (^)())completion {
    if (viewController == nil) {
        return;
    }
    UIView *rootView = [self rootView:viewController];
    
    UINavigationController *topViewController = (UINavigationController *)self.topViewController;
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        SCTransitionDelegateManager *transMgr = [[SCTransitionDelegateManager alloc] initWithView:rootView sourceView:sourceView targetView:targetView isPush:YES];
        transMgr.didPush = completion;
        topViewController.delegate = transMgr;
        objc_setAssociatedObject(viewController, TransitionKey, transMgr, OBJC_ASSOCIATION_RETAIN);
        [topViewController pushViewController:viewController animated:animated];
    }
}

+ (void)pushViewControllers:(NSArray<UIViewController *> *)viewControllers
                   animated:(BOOL)animated
                 completion:(void (^)())completion {
    if (!viewControllers.count) {
        return;
    }
    
    UINavigationController *topViewController = (UINavigationController *)self.topViewController;
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
        NSMutableArray *arrM = [NSMutableArray arrayWithArray:topViewController.viewControllers];
        for (UIViewController *viewController in viewControllers) {
            NSInteger index = [viewControllers indexOfObject:viewController];
            UIView *rootView = [self rootView:viewController];
            SCTransitionDelegateManager *transMgr = [[SCTransitionDelegateManager alloc] initWithView:rootView isPush:YES];
            if (index == viewControllers.count - 1) {
                transMgr.didPush = completion;
                topViewController.delegate = transMgr;
            } else {
                NSLog(@"当前set了多个controller，可对非最后一个controller进行额外的操作");
            }
            objc_setAssociatedObject(viewController, TransitionKey, transMgr, OBJC_ASSOCIATION_RETAIN);
        }
        [arrM addObjectsFromArray:viewControllers];
        [topViewController setViewControllers:[arrM copy] animated:animated];
    }
}

+ (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
                  animated:(BOOL)animated
                completion:(void (^)())completion {
    [self setViewControllers:viewControllers fromNavigationController:nil animated:animated completion:completion];
}

+ (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
  fromNavigationController:(UINavigationController *)navigationController
                  animated:(BOOL)animated
                completion:(void (^)())completion {
    if (!viewControllers.count) {
        return;
    }
    
    if (!navigationController) {
        navigationController = (UINavigationController *)self.topViewController;
    }
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *viewController in viewControllers) {
            NSInteger index = [viewControllers indexOfObject:viewController];
            if (index == 0) {
                continue;
            }
            UIView *rootView = [self rootView:viewController];
            SCTransitionDelegateManager *transMgr = [[SCTransitionDelegateManager alloc] initWithView:rootView isPush:YES];
            if (index == viewControllers.count - 1) {
                transMgr.didPush = completion;
                navigationController.delegate = transMgr;
            } else {
                NSLog(@"set了多个controller时，对每个controller可能进行的操作");
            }
            objc_setAssociatedObject(viewController, TransitionKey, transMgr, OBJC_ASSOCIATION_RETAIN);
        }
        [navigationController setViewControllers:viewControllers animated:animated];
    }
}

#pragma mark - Pop

+ (UIViewController *)popViewControllerAnimated:(BOOL)animated
                                     completion:(void (^)())completion {
    UINavigationController *topViewController = (UINavigationController *)self.topViewController;
    if ([topViewController isKindOfClass:[UINavigationController class]] &&
        topViewController.viewControllers.count > 1) {
        SCTransitionDelegateManager *transMgr = (SCTransitionDelegateManager *)topViewController.delegate;
        transMgr.didPop = completion;
        return [topViewController popViewControllerAnimated:animated];
    }
    return nil;
}

+ (NSArray *)popToViewController:(UIViewController *)viewController
                        animated:(BOOL)animated
                      completion:(void (^)())completion {
    UINavigationController *topViewController = (UINavigationController *)self.topViewController;
    if ([topViewController isKindOfClass:[UINavigationController class]] &&
        topViewController.viewControllers.count > 1) {
        SCTransitionDelegateManager *transMgr = (SCTransitionDelegateManager *)topViewController.delegate;
        transMgr.didPop = completion;
        return [topViewController popToViewController:viewController animated:animated];
    }
    return nil;
}

+ (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
                                  completion:(void (^)())completion {
    UINavigationController *topViewController = (UINavigationController *)self.topViewController;
    if ([topViewController isKindOfClass:[UINavigationController class]] &&
        topViewController.viewControllers.count > 1) {
        SCTransitionDelegateManager *transMgr = (SCTransitionDelegateManager *)topViewController.delegate;
        transMgr.didPop = completion;
        return [topViewController popToRootViewControllerAnimated:animated];
    }
    return nil;
}

#pragma mark - Private Method

+ (UIView *)rootView:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]] &&
        ((UINavigationController *)viewController).viewControllers.count) {
        UIViewController *rootVC = ((UINavigationController *)viewController).viewControllers.firstObject;
        return rootVC.view;
    } else {
        return viewController.view;
    }
}

+ (UIViewController *)topViewController {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (YES) {
        if ([topViewController presentedViewController] == nil) {
            break;
        }
        topViewController = [topViewController presentedViewController];
    }
    return topViewController;
}

@end
