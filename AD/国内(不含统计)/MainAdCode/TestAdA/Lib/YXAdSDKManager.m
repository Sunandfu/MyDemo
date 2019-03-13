//
//  YXAdSDKManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/28.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXAdSDKManager.h"
#import "Network.h"

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
