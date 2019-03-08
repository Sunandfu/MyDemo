//
//  AppDelegate.h
//  TestAdA
//
//  Created by shuai on 2018/3/24.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YX_IPHONEX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
static  NSString * splashMediaID = @"wxbus_ios_splash";
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

