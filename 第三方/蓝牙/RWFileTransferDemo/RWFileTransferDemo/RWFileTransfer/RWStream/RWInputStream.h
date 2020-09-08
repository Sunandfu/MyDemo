//
//  RWInputStream.h
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWInputStream;
@protocol RWInputStreamDelegate <NSObject>

- (void)inputStream:(RWInputStream *)inputStream streamName:(NSString *)streamName progress:(long long)progress;

- (void)inputStream:(RWInputStream *)inputStream transferEndWithStreamName:(NSString *)streamName filePath:(NSString *)filePath;

- (void)inputStream:(RWInputStream *)inputStream transferErrorWithStreamName:(NSString *)streamName;

@end

@interface RWInputStream : NSObject

@property (copy, nonatomic)NSString *streamName;

@property (assign, nonatomic)id <RWInputStreamDelegate> delegate;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream;

- (void)start;

- (void)stop;

@end
