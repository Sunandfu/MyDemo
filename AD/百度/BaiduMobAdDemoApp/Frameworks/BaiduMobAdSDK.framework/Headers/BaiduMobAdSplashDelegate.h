//
//  BaiduMobAdSplashDelegate.h
//  BaiduMobAdSDK
//
//  Created by LiYan on 16/5/25.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import "BaiduMobAdCommonConfig.h"
#import <Foundation/Foundation.h>

@class BaiduMobAdSplash;

@protocol BaiduMobAdSplashDelegate <NSObject>

@required
/**
 *  应用的APPID
 */
- (NSString *)publisherId;

@optional

/**
 *  渠道id
 */
- (NSString*) channelId;

/**
 *  启动位置信息
 */
-(BOOL) enableLocation;


/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash;

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason;

/**
 *  广告被点击
 */
- (void)splashDidClicked:(BaiduMobAdSplash *)splash;

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash;

/**
 *  广告详情页消失
 */
- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash;


@end
