//
//  SFPermenantThread.h
//  AdDemo
//
//  Created by lurich on 2021/6/16.
//

#import <Foundation/Foundation.h>

typedef void (^SFPermenantThreadTask)(void);

@interface SFPermenantThread : NSObject

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(SFPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end
