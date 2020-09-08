//
//  SCPresentTransition.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/7/21.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCPresentTransition.h"
#import "SCTransitionDelegateManager.h"
#import <objc/runtime.h>
#import "UIView+Capture.h"

@implementation SCPresentTransition

#pragma mark - Present

+ (void)presentViewController:(UIViewController *)viewController
                     animated:(BOOL)animated
                   completion:(void (^)())completion {
    if (viewController == nil) {
        return;
    }
    UIView *rootView = [self rootView:viewController];
    SCTransitionDelegateManager *transMgr = [[SCTransitionDelegateManager alloc] initWithView:rootView isPush:NO];
    viewController.transitioningDelegate = transMgr;
    objc_setAssociatedObject(viewController, TransitionKey, transMgr, OBJC_ASSOCIATION_RETAIN);
    
    UIViewController *topViewController = self.topViewController;
    if (!topViewController.isBeingDismissed &&
        !topViewController.isBeingPresented) {
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [topViewController presentViewController:viewController animated:animated completion:completion];
    }
}

+ (void)presentViewController:(UIViewController *)viewController
                   sourceView:(UIView *)sourceView
                   targetView:(UIView *)targetView
                     animated:(BOOL)animated
                   completion:(void (^)())completion {
    if (viewController == nil) {
        return;
    }
    UIView *rootView = [self rootView:viewController];
    
    SCTransitionDelegateManager *transMgr = [[SCTransitionDelegateManager alloc] initWithView:rootView sourceView:sourceView targetView:targetView isPush:NO];
    
    viewController.transitioningDelegate = transMgr;
    objc_setAssociatedObject(viewController, TransitionKey, transMgr, OBJC_ASSOCIATION_RETAIN);
    
    UIViewController *topViewController = self.topViewController;
    if (!topViewController.isBeingDismissed &&
        !topViewController.isBeingPresented) {
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [topViewController presentViewController:viewController animated:animated completion:completion];
    }
}

#pragma mark - Dismiss

+ (void)dismissViewControllerAnimated:(BOOL)animated
                           completion:(void (^)())completion {
    UIViewController *vcToDismiss = self.topViewController;
    if (!vcToDismiss.isBeingDismissed &&
        !vcToDismiss.isBeingPresented) {
        [vcToDismiss dismissViewControllerAnimated:animated completion:completion];
    }
}

+ (void)dismissToViewController:(UIViewController *)viewController
                       animated:(BOOL)animated
                     completion:(void (^)())completion {
    UIViewController *topViewController = self.topViewController;
    UIViewController *vcToDismiss = viewController.presentedViewController;
    
    if (vcToDismiss != nil &&
        !vcToDismiss.isBeingDismissed &&
        !vcToDismiss.isBeingPresented) {
        vcToDismiss.view = topViewController.view.captureView;
        [viewController dismissViewControllerAnimated:animated completion:completion];
    }
}

+ (void)dismissToRootViewControllerAnimated:(BOOL)animated
                                 completion:(void (^)())completion {
    UIViewController *topViewController = self.topViewController;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *vcToDismiss = rootVC.presentedViewController;
    
    if (vcToDismiss != nil &&
        !vcToDismiss.isBeingDismissed &&
        !vcToDismiss.isBeingPresented) {
        if (![vcToDismiss isEqual:topViewController]) {
            vcToDismiss.view = topViewController.view.captureView;
        }
        [rootVC dismissViewControllerAnimated:animated completion:completion];
    }
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
