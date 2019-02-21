//
//  YXAdSDKManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/28.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXAdSDKManager.h"
#import "Network.h"

#import "HMTAgentSDK.h"

#import <Tapjoy/Tapjoy.h>



@interface YXAdSDKManager()

@property (nonatomic,assign) BOOL openLog;

@end

@implementation YXAdSDKManager

static YXAdSDKManager * manager = nil;

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXAdSDKManager alloc]init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpConfig];
    }
    return self;
}
 

- (void)setUpConfig
{
    _openLog = NO;
    
    [self hmtSDK];
    
//    [self videoSDK];
    
    
    
}
static NSString * HMTAPPID = @"hmt_2QGMB9WP";

- (void)hmtSDK
{
    [HMTAgentSDK setServerHost:@"https://t.hypers.com.cn"];
    [HMTAgentSDK setOnLineConfigUrl:@"https://t.hypers.com.cn"];
    
    [HMTAgentSDK initWithAppKey:HMTAPPID channel:@"APP Store" reportPolicy:HMT_REALTIME];
//    [HMTAgentSDK setLocation:YES];
    [HMTAgentSDK setCrashReportEnabled:YES];
}
- (void)videoSDK
{
    //      设置成功和失败提醒
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectSuccess)
                                                 name:TJC_CONNECT_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tjcConnectFail)
                                                 name:TJC_CONNECT_FAILED
                                               object:nil];
    
    //打开 Tapjoy 调节模式
    [Tapjoy setDebugEnabled:YES]; //Do not set this for any version of the app released to an app store
    
    
    //当tapjoy连接时调用
    [Tapjoy connect:@"ZTCXfY7SR1qCzfsHVzRfUAEBgbJqtKbbPhLQqUM1Bo42eWUzp61fGMi7iDzW"];
}

- (void)tjcConnectSuccess
{
    
}
- (void)tjcConnectFail
{
    
}

- (void)addBlackList:(NSString*)media andTime:(NSInteger)day
{
    
    [Network blackListUrl:USERBLACK andMedia:media andTime:day isAdd:YES];
}

- (void)removeBlackList:(NSString *)media
{
    [Network blackListUrl:USERBLACKREMOVE andMedia:media andTime:0 isAdd:NO];
}

- (void)setOpenLog:(BOOL)openLog
{
    _openLog = openLog;
}


@end
