//
//  SCTransitionDelegateManager.h
//  SCTransitionDelegateManager
//
//  Created by sichenwang on 16/2/5.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

typedef enum {
    SCTransitionTypeNormal,
    SCTransitionTypeZoom
} SCTransitionType;

#import <UIKit/UIKit.h>

static const void *TransitionKey = @"TransitionKey";

@interface SCTransitionDelegateManager : NSObject<UIViewControllerTransitioningDelegate,
UINavigationControllerDelegate>

@property (nonatomic, assign, readonly) SCTransitionType type;

- (instancetype)initWithView:(UIView *)view
                      isPush:(BOOL)isPush;

- (instancetype)initWithView:(UIView *)view
                  sourceView:(UIView *)sourceView
                  targetView:(UIView *)targetView
                      isPush:(BOOL)isPush;

@property (nonatomic, copy) void (^didPop)();
@property (nonatomic, copy) void (^didPush)();

@end
