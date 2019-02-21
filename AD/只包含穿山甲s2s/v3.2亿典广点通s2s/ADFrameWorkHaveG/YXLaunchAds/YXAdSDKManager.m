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
#import "YXLaunchAdConst.h"

#import "NetTool.h"


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
    
    
    
    
}  
- (void)hmtSDK
{
    
    NSString * HMTAPPID = @"hmt_6UTLPWFO";
    
    NSString * bundle = [NetTool getPackageName];
    if ([bundle isEqualToString:@"com.xcloudtech.iot"]) {
        HMTAPPID = @"hmt_5K7KPQ80";
    }else if ([bundle isEqualToString:@"com.xcloudtech.locate"]){
        HMTAPPID = @"hmt_59MH8XGK";
    }else if ([bundle isEqualToString:@"net.goome.EBus"]){
        HMTAPPID = @"hmt_44G2I8U6";
    }else if ([bundle isEqualToString:@"com.chipsea.btWeigh"]){
        HMTAPPID = @"hmt_4BU3MB4O";
    }else if ([bundle isEqualToString:@"com.cloudsee.CloudViews"]){
        HMTAPPID = @"hmt_2OJ9A6KR";
    }else if ([bundle isEqualToString:@"com.zhongwei.aiweibaby"]){
        HMTAPPID = @"hmt_6GQ1C5N6";
    }else if ([bundle isEqualToString:@"com.futurefleet.PandaBus"]){
        HMTAPPID = @"hmt_6BGIE62E";
    }else if ([bundle isEqualToString:@"com.12sporting.duolaisport"]){
        HMTAPPID = @"hmt_16M8RLV6";
    }else if ([bundle isEqualToString:@"com.com.yunx.fitness"]){
        HMTAPPID = @"hmt_2QGMB9WP";
    }else if ([bundle isEqualToString:@"com.jianyou.swatch"]){
        HMTAPPID = @"hmt_6PTL6FL1";
    }else if ([bundle isEqualToString:@"com.wxbus.app"]){
        HMTAPPID = @"hmt_7YHNNNDN";
    }else if ([bundle isEqualToString:@"com.ixiaoma.chinabusride"]){
        HMTAPPID = @"hmt_7YL77M8F";
    }else{
        HMTAPPID = @"hmt_6UTLPWFO";
    }
    
    [HMTAgentSDK setServerHost:@"https://t.hypers.com.cn"];
    [HMTAgentSDK setOnLineConfigUrl:@"https://t.hypers.com.cn"];
    
    [HMTAgentSDK initWithAppKey:HMTAPPID channel:@"V3.2" reportPolicy:HMT_REALTIME];
    //    [HMTAgentSDK setLocation:YES];
    [HMTAgentSDK setCrashReportEnabled:YX_DEBUG_MODE];
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
