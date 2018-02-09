//
//  LHHTTPRequestManager.m
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/3/31.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHHTTPRequestManager.h"
#import "LHHTTPRequest.h"

@implementation LHHTTPRequestManager

- (instancetype)init
{
    self = [super init];
    self.shouldAllowJSONParse = YES;
    return self;
}

+ (instancetype)shareInstance
{
    static LHHTTPRequestManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LHHTTPRequestManager alloc] init];
    });
    return manager;
}

- (void)GET:(NSString*)url
            success:(void(^)(id response))success
                fail:(void(^)(NSError* error))fail;
{
    LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:url];
    request.requestFinish = [success copy];
    request.requestError = [fail copy];
    [request startAsynchronous];
}

- (void)GET:(NSString*)url progress:(LHHTTPProgressRequest)progerss
                                                receiveData:(LHHTTPReceiveData)receiveData  complete:(LHHTTPFinishRequest)complete
{
    LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:url];
    request.requestProgress = [progerss copy];
    request.receiveData = [receiveData copy];
    request.requestFinish = [complete copy];
    [request startAsynchronous];
}

- (void)POST:(NSString*)url parameters:(id)parameters
                                    success:(void(^)(id response))success
                                        fail:(void(^)(NSError* error))fail
{
    LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:url];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        request.requestBody = [parameters mutableCopy];
    }else if ([parameters isKindOfClass:[NSData class]]) {
        request.requestDataBody = [parameters mutableCopy];
    }
    request.requestFinish = [success copy];
    request.requestError = [fail copy];
    [request startAsynchronous];
}

- (void)downloadToFilePathWithURL:(NSString*)urlString
                                        filePath:(NSString*)filePath
{
    if (filePath.length == 0) return;
    LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:urlString];
    request.downloadPath = filePath;
    [request startSynchronous];
}

- (void)downloadToFilePathWithURL:(NSString *)urlString
                                    filePath:(NSString *)filePath progress:
                                                (LHHTTPProgressRequest)progress
{
    if (filePath.length == 0) return;
    LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:urlString];
    request.requestProgress = [progress copy];
    request.downloadPath = filePath;
    [request startAsynchronous];
}

@end
