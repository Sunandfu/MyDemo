//
//  BaseViewController.h
//  museum
//
//  Created by 小富 on 2017/11/8.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NavigationTypeBlack = 0,
    NavigationTypeWhite = 1,
    NavigationTypeClean = 2,
} NavigationType;

@interface BaseViewController : UIViewController

@property (nonatomic,assign) CGFloat navigationAndStatuHeight;

@property (nonatomic,assign) CGFloat navigationBarHeight;

@property (nonatomic,assign) CGFloat statusBarHeight;

@property (nonatomic, assign) CGFloat tabBarHeight;

@property (nonatomic,assign) NavigationType type;

- (void)backAction;

- (UIWindow *)window;

- (void)addLeftBackButton;

@end
