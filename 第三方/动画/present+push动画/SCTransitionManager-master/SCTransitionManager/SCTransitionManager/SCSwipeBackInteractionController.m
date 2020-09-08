//
//  SCSwipeBackInteractionController.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/7.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "SCSwipeBackInteractionController.h"

@implementation UIView(FindUIViewController)

- (UIViewController *)firstAvailableUIViewController {
    return (UIViewController *)self.traverseResponderChainForUIViewController;
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = self.nextResponder;
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end

@interface SCSwipeBackInteractionController()<UIGestureRecognizerDelegate>

@end

@implementation SCSwipeBackInteractionController
{
    BOOL _shouldCompleteTransition;
    BOOL _gestureChanged;
    BOOL _isPush;
    __weak id<SCGestureBackInteractionDelegate> _gestureBackInteractionDelegate;
}

- (instancetype)initWithView:(UIView *)view isPush:(BOOL)isPush {
    if (self = [super init]) {
        _gestureChanged = NO;
        _isPush = isPush;
        [self addSwipeBackToView:view];
    }
    return self;
}

- (void)addSwipeBackToView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:gesture];
    gesture.delegate = self;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.context.gestureFinished = NO;
            UIViewController *parentViewController = [gestureRecognizer.view firstAvailableUIViewController];
            if (parentViewController.isBeingPresented ||
                parentViewController.isBeingDismissed) {
                self.interactionInProgress = NO;
                return;
            }
            self.interactionInProgress = YES;
            
            [self getProperDelegate:gestureRecognizer];
            if ([_gestureBackInteractionDelegate respondsToSelector:@selector(fireGuestureBack)]) {
                [_gestureBackInteractionDelegate fireGuestureBack];
            } else {
                if (_isPush) {
                    if (parentViewController.navigationController) {
                        [parentViewController.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    [parentViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            if ([_gestureBackInteractionDelegate respondsToSelector:@selector(gestureBackBegin)]) {
                [_gestureBackInteractionDelegate gestureBackBegin];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            _gestureChanged = YES;
            CGFloat fraction = (translation.x / [UIScreen mainScreen].bounds.size.width);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            _shouldCompleteTransition = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.context.gestureFinished = YES;
            self.interactionInProgress = NO;
            
            if ([gestureRecognizer velocityInView:gestureRecognizer.view].x > 100) {//手势速度大于阀值则判断为手势成功，目前阀值设置为100
                _shouldCompleteTransition = YES;
            }
            if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
                if ([_gestureBackInteractionDelegate respondsToSelector:@selector(gestureBackCancel)]) {
                    [_gestureBackInteractionDelegate gestureBackCancel];
                }
                _gestureChanged = NO;
            } else {
                if (_gestureBackInteractionDelegate && [_gestureBackInteractionDelegate respondsToSelector:@selector(gestureBackFinish)]) {
                    [_gestureBackInteractionDelegate gestureBackFinish];
                }
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (id <SCGestureBackInteractionDelegate>)getProperDelegate:(UIGestureRecognizer *)gestureRecognizer {
    id target;
    if (_gestureBackInteractionDelegate) {
        target = _gestureBackInteractionDelegate;
    } else {
        UIViewController *parentVC = gestureRecognizer.view.firstAvailableUIViewController;
        target = parentVC;
        _gestureBackInteractionDelegate = target;
    }
    
    if ([target conformsToProtocol:@protocol(SCGestureBackInteractionDelegate)]) {
        return target;
    }
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIViewController *controller = gestureRecognizer.view.firstAvailableUIViewController;
    
    if (controller.isBeingDismissed || controller.isBeingPresented || controller.view.window == nil) {
        self.interactionInProgress = NO;
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    id<SCGestureBackInteractionDelegate> target = [self getProperDelegate:gestureRecognizer];
    
    if ([target respondsToSelector:@selector(disableGuesture)]) {
        if ([(id<SCGestureBackInteractionDelegate>)target disableGuesture]) {
            return NO;
        };
    }
    return YES;
}

@end
