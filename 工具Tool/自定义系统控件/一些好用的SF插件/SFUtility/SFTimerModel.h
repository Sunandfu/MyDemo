//
//  SFTimerModel.h
//  deomo
//
//  Created by 张冬 on 2018/1/2.
//  Copyright © 2018年 张冬. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 封装一个定时器模型
 */
@interface SFTimerModel : NSObject
@property(nonatomic , copy)void(^block)(void);

/**
 * 创建一个GCD定时器，并启动开始执行
 *
 * @parma delayTime 多少秒后执行
 * @param repeatTime 重复执行的时间
 * @param eventBlock 事件回调
 *
 */
-(void)startTimerDelayTime: (NSTimeInterval)delayTime RepeatTime: (NSTimeInterval)repeatTime HandleBlock: (void(^)(void)) eventBlock;

/**
 * 暂停定时器
 */
-(void)pauseGCDTimer;

/**
 * 重新启动定时器
 */
-(void)resumeGCDTimer;

/**
 取消定时器
*/
-(void)cancelGCDTimer;

@end
