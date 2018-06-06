//
//  BaseViewController.h
//  museum
//
//  Created by 小富 on 2017/11/8.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Cloudox.h"

typedef enum : NSUInteger {
    NavigationTypeBlack          = 0,
    NavigationTypeWhite          = 1,
    NavigationTypeClean          = 2,
    NavigationTypeVariableWhite  = 3,//只改变状态栏与title的字体颜色
    NavigationTypeVariableBlack  = 4,
} NavigationType;

@interface BaseViewController : UIViewController

@property (nonatomic,assign) CGFloat navigationAndStatuHeight;

@property (nonatomic,assign) CGFloat navigationBarHeight;

@property (nonatomic,assign) CGFloat statusBarHeight;

@property (nonatomic, assign) CGFloat tabBarHeight;

@property (nonatomic,assign) NavigationType type;

@property (nonatomic, strong) UIView *navigationView;

- (void)backAction;

- (UIWindow *)window;

- (void)addLeftBackButton;

@end
