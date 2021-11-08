//
//  SFQueue.h
//  ApiTestDemo
//
//  Created by lurich on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFQueue : NSObject

//队列里的元素个数
- (NSInteger)size;
//入队
- (void)enQueueObject:(id)anObject;
//出队
- (id)deQueue;
//清空队列里的元素
- (void)clear;
//判断队列是否为空
- (BOOL)isEmpty;
//获取队列的第一个元素
- (id)first;

@end

NS_ASSUME_NONNULL_END
