//
//  YXAdSDKManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/28.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXAdSDKManager.h"
#import "Network.h"

@implementation YXAdSDKManager

+ (void)addBlackList:(NSString*)media andTime:(NSInteger)day
{
    
    [Network blackListUrl:USERBLACK andMedia:media andTime:day isAdd:YES];
}

+ (void)removeBlackList:(NSString *)media
{
    [Network blackListUrl:USERBLACKREMOVE andMedia:media andTime:0 isAdd:NO];
}


@end
