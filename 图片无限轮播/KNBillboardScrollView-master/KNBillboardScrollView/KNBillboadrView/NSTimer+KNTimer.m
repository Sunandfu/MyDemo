//
//  NSTimer+KNTimer.m
//  KNBillboardScrollView
//
//  Created by 刘凡 on 2017/11/14.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import "NSTimer+KNTimer.h"

@implementation NSTimer (KNTimer)

+ (NSTimer *)kn_TimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block {
    if ([self respondsToSelector:@selector(timerWithTimeInterval:repeats:block:)]) {
        return [self timerWithTimeInterval:interval repeats:repeats block:block];
    }
    return [self timerWithTimeInterval:interval target:self selector:@selector(timerAction:) userInfo:block repeats:repeats];
}


+ (void)timerAction:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) block(timer);
}

@end
