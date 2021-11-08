//
//  SFTimerModel.m
//  deomo
//
//  Created by 张冬 on 2018/1/2.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import "SFTimerModel.h"

@interface SFTimerModel()
@property(nonatomic , strong)dispatch_source_t timer;
/// 记录timer是否暂停状态，暂停状态不能被销毁
@property(nonatomic , assign)BOOL isPause;
@end

@implementation SFTimerModel

-(instancetype)init {
    if (self = [super init]) {
        self.isPause = true;
        if (!_timer) {
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        }
    }
    return self;
}

-(void)dealloc {
    if (_timer) {
        // ** 被挂起的定时器，是不能被销毁的
        if (self.isPause == true) {
            [self resumeGCDTimer];
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
//    NSLog(@"dealloc SFTimerModel");
}
/// creat GCD  Timer
-(void)startTimerDelayTime:(NSTimeInterval)delayTime RepeatTime:(NSTimeInterval)repeatTime HandleBlock:(void (^)(void))eventBlock {
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0) , repeatTime * NSEC_PER_SEC, repeatTime * NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        /// 获取主线程再block
        dispatch_async(dispatch_get_main_queue(), ^{
            eventBlock();
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (self.isPause == YES) {
            [self resumeGCDTimer];
        }
    });
    
}
/// resume GCD Timer
-(void)resumeGCDTimer {
    if (_timer) {
        self.isPause = false;
        dispatch_resume(_timer);
    }
    
}
/// resume GCD Timer
-(void)cancelGCDTimer {
    if (_timer) {
        // ** 被挂起的定时器，是不能被销毁的
        if (self.isPause == true) {
            [self resumeGCDTimer];
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
/// pause GCD Timer
-(void)pauseGCDTimer {
    if(_timer){
        self.isPause = true;
        dispatch_suspend(_timer);
    }
}

#pragma mark -- set and get

@end
