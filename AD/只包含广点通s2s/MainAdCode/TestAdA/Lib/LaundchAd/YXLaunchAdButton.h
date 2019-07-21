//
//  YXLaunchAdSkipButton.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import <UIKit/UIKit.h>
#import "YXLaunchConfiguration.h"


@interface YXLaunchAdButton : UIButton
- (instancetype)init;
- (instancetype)initWithSkipType:(SkipType)skipType;
- (void)startRoundDispathTimerWithDuration:(CGFloat )duration;
- (void)setTitleWithSkipType:(SkipType)skipType duration:(NSInteger)duration;
- (void)setTitleduration:(NSInteger)duration;
@end
