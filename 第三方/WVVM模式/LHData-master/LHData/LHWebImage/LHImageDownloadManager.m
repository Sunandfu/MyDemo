//
//  LHImageDownloadManager.m
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/4/5.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHImageDownloadManager.h"

@implementation LHImageDownloadManager

+ (instancetype)shareInstance
{
    static LHImageDownloadManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LHImageDownloadManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    _operationDic = [NSMutableDictionary dictionary];
    self.downloadQueue = [[NSOperationQueue alloc] init];
    self.downloadQueue.maxConcurrentOperationCount = 5;
    return self;
}

- (void)addOperationWithUrlString:(NSString*)urlString progress:(LHHTTPDownloadProgress)progress receiveData:(LHHTTPReceiveData)receiveData complete:(LHHTTPFinishRequest)complete
{
    void (^requestBlock)() = ^(){
        LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:urlString];
        if (!request) return;
        if (progress) request.downloadProgress = [progress copy];
        if (complete) request.requestFinish = [complete copy];
        if (receiveData) request.receiveData = [receiveData copy];
        [request startSynchronous];
    };
    [self.downloadQueue addOperationWithBlock:requestBlock];
}

- (void)cancelAll
{
    [self.downloadQueue cancelAllOperations];
}

@end
