//
//  SCSwipeBackInteractionController.h
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/7.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNormalDismissTransition.h"

@interface UIView (FindUIViewController)

- (UIViewController *)firstAvailableUIViewController;
- (id)traverseResponderChainForUIViewController;

@end

/**
 *  手势delegate，用户手势划回过程的回调通知delegate
 */
@protocol SCGestureBackInteractionDelegate<NSObject>

@optional

/**
 *  手势划回完成，当前页面即将关闭，要在此方法中执行页面退出前的清理代码。
 */
- (void)gestureBackFinish;
/**
 *  手势划回开始
 */
- (void)gestureBackBegin;
/**
 *  手势划回取消
 */
- (void)gestureBackCancel;
/**
 *  禁止手势返回，默认为NO
 *
 *  @return YES 禁止； NO 开启；
 */
- (BOOL)disableGuesture;

/**
 *  自定义启动手势返回后的逻辑，实现后将不执行dismiss的方法
 */
- (void)fireGuestureBack;

@end

@interface SCSwipeBackInteractionController : UIPercentDrivenInteractiveTransition

/**
 *  手势进行中：YES，正在进行手势交互；NO，未进行手势交互
 */
@property (nonatomic, assign) BOOL interactionInProgress;

@property (nonatomic, strong) SCGestureTransitionBackContext *context;

/**
 *  @param 要支持手势划回的view
 */
- (instancetype)initWithView:(UIView *)view isPush:(BOOL)isPush;

@end
