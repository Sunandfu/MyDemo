//
//  LHImageDownloadManager.h
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/4/5.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHHTTPRequest.h"

@interface LHImageDownloadManager : NSObject

@property (nonatomic,strong) NSOperationQueue* downloadQueue;

@property (nonatomic,readonly,strong) NSMutableDictionary* operationDic;

+ (instancetype)shareInstance;

- (void)addOperationWithUrlString:(NSString*)urlString progress:(LHHTTPDownloadProgress)progress receiveData:(LHHTTPReceiveData)receiveData complete:(LHHTTPFinishRequest)complete;

- (void)cancelAll;

@end
