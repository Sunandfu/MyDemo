//
//  SCTransitionDelegateManager.m
//  SCTransitionDelegateManager
//
//  Created by sichenwang on 16/2/5.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCTransitionDelegateManager.h"
#import "SCNormalPresentTransition.h"
#import "SCNormalDismissTransition.h"
#import "SCZoomPresentTransition.h"
#import "SCZoomDismissTransition.h"
#import "SCGestureTransitionBackContext.h"
#import "SCSwipeBackInteractionController.h"
#import <objc/runtime.h>

@interface SCTransitionDelegateManager()<SCGestureBackInteractionDelegate>

@property (nonatomic, strong) SCNormalPresentTransition *normalPresentTrans;
@property (nonatomic, strong) SCNormalDismissTransition *normalDismissTrans;
@property (nonatomic, strong) SCZoomPresentTransition *zoomPresentTrans;
@property (nonatomic, strong) SCZoomDismissTransition *zoomDismissTrans;
@property (nonatomic, strong) SCSwipeBackInteractionController *interactionController;

@end

@implementation SCTransitionDelegateManager

- (instancetype)initWithView:(UIView *)view
                      isPush:(BOOL)isPush {
    if (self = [super init]) {
        _type = SCTransitionTypeNormal;
        _normalPresentTrans = [[SCNormalPresentTransition alloc] init];
        _normalDismissTrans = [[SCNormalDismissTransition alloc] init];
        
        _interactionController = [[SCSwipeBackInteractionController alloc] initWithView:view isPush:isPush];
        SCGestureTransitionBackContext *context = [[SCGestureTransitionBackContext alloc] init];
        _interactionController.context = context;
        _normalDismissTrans.context = context;
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
                  sourceView:(UIView *)sourceView
                  targetView:(UIView *)targetView
                      isPush:(BOOL)isPush {
    if (self = [super init]) {
        _type = SCTransitionTypeZoom;
        UIView *visibleView = self.visibleView;
        _zoomPresentTrans = [[SCZoomPresentTransition alloc] init];
        _zoomDismissTrans = [[SCZoomDismissTransition alloc] init];
        _zoomPresentTrans.sourceView = sourceView;
        _zoomDismissTrans.sourceView = sourceView;
        _zoomPresentTrans.targetView = targetView;
        _zoomDismissTrans.targetView = targetView;
        _zoomPresentTrans.view = visibleView;
        _zoomDismissTrans.view = visibleView;
        
        _interactionController = [[SCSwipeBackInteractionController alloc] initWithView:view isPush:isPush];
        SCGestureTransitionBackContext *context = [[SCGestureTransitionBackContext alloc] init];
        _interactionController.context = context;
        _zoomDismissTrans.context = context;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (self.type == SCTransitionTypeZoom) {
        return self.zoomPresentTrans;
    } else {
        return self.normalPresentTrans;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.type == SCTransitionTypeZoom) {
        return self.zoomDismissTrans;
    } else {
        return self.normalDismissTrans;
    }
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactionController.interactionInProgress ? self.interactionController : nil;
}

#pragma mark - UINavigationControllerDelegate

- (nullable id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                           animationControllerForOperation:(UINavigationControllerOperation)operation
                                                        fromViewController:(UIViewController *)fromVC
                                                          toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        if (self.type == SCTransitionTypeZoom) {
            return self.zoomPresentTrans;
        } else {
            return self.normalPresentTrans;
        }
    } else if (operation == UINavigationControllerOperationPop) {
        if (self.type == SCTransitionTypeZoom) {
            return self.zoomDismissTrans;
        } else {
            return self.normalDismissTrans;
        }
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.interactionController.interactionInProgress ? self.interactionController : nil;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    SCTransitionDelegateManager *transMgr = objc_getAssociatedObject(viewController, TransitionKey);
    if (![transMgr isEqual:navigationController.delegate]) {
        SCTransitionDelegateManager *currentTransMgr = (SCTransitionDelegateManager *)navigationController.delegate;
        if ([currentTransMgr isKindOfClass:[SCTransitionDelegateManager class]]) {
            if (currentTransMgr.didPop) {
                currentTransMgr.didPop();
                currentTransMgr.didPop = nil;
            }
        }
        navigationController.delegate = transMgr;
    } else {
        if (transMgr.didPush) {
            transMgr.didPush();
            transMgr.didPush = nil;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    SCTransitionDelegateManager *transMgr = objc_getAssociatedObject(viewController, TransitionKey);
    if ([transMgr isEqual:navigationController.delegate]) {
        NSLog(@"viewController即将显示，可能添加的额外操作");
    }
}

#pragma mark - Private Method

- (UIView *)visibleView {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (YES) {
        if ([topViewController presentedViewController] == nil) {
            break;
        }
        topViewController = [topViewController presentedViewController];
    }
    if ([topViewController isKindOfClass:[UINavigationController class]] &&
        ((UINavigationController *)topViewController).viewControllers.count) {
        return ((UINavigationController *)topViewController).topViewController.view;
    } else {
        return topViewController.view;
    }
}
@end
