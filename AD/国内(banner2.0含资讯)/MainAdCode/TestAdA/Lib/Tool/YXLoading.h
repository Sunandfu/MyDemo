//
//  YXLoading.h
//  fitness
//
//  Created by 帅 on 2017/1/4.
//  Copyright © 2017年 YunXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLoading : UIView

/**
  无加载框 底部自动消失
 */
+ (void)showStatus:(NSString *)str;

+ (void)showStatus:(NSString *)str delay:(CGFloat)delay;

/**
 无加载框 中间处 自动消失
 */
+ (void)showMiddleStatus:(NSString *)str;

/**
 有加载框
 */
+ (void)showWithStatus:(NSString *)str;

+ (void)showProgress;

+ (void)dissmissProgress;

@end
