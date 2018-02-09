//
//  LHHTTPRequestManager.h
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/3/31.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHHTTPRequest.h"

@interface LHHTTPRequestManager : NSObject

@property (nonatomic,assign) BOOL shouldAllowJSONParse;

@property (nonatomic) dispatch_queue_t completeQueue;

+ (instancetype)shareInstance;

- (void)GET:(NSString*)url
                  success:(void(^)(id response))success
                     fail:(void(^)(NSError* error))fail;

- (void)GET:(NSString*)url progress:(LHHTTPProgressRequest)progerss
                                            receiveData:(LHHTTPReceiveData)receiveData  complete:(LHHTTPFinishRequest)complete;

- (void)POST:(NSString*)url parameters:(id)parameters
                                    success:(void(^)(id response))success
                                        fail:(void(^)(NSError* error))fail;
/*
 阻塞下载
 */
- (void)downloadToFilePathWithURL:(NSString*)urlString
                                        filePath:(NSString*)filePath;
/*
 非阻塞下载
 */
- (void)downloadToFilePathWithURL:(NSString *)urlString
                                    filePath:(NSString *)filePath progress:
                                            (LHHTTPProgressRequest)progress;


@end
