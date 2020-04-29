//
//  NSTimer+KNTimer.h
//  KNBillboardScrollView
//
//  Created by 刘凡 on 2017/11/14.
//  Copyright © 2017年 KrystalName. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (KNTimer)

+ (NSTimer *)kn_TimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *))block;


@end
