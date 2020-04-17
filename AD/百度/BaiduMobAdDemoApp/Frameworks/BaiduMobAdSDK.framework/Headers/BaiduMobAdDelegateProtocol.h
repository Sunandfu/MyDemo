//
//  BaiduMobAdDelegateProtocol.h
//  BaiduMobAdSdk
//
//  Created by jaygao on 11-9-8.
//  Copyright 2011年 Baidu. All rights reserved.
//
//

#import "BaiduMobAdCommonConfig.h"

@class BaiduMobAdView;
/**
 *  广告sdk委托协议
 */
@protocol BaiduMobAdViewDelegate <NSObject>

@required
/**
 *  应用的APPID
 */
- (NSString *)publisherId;

@optional
/**
 *  渠道ID
 */
- (NSString *)channelId;
/**
 *  启动位置信息
 */
- (BOOL)enableLocation;

/**
 *  广告将要被载入
 */
- (void)willDisplayAd:(BaiduMobAdView *)adview;

/**
 *  广告载入失败
 */
- (void)failedDisplayAd:(BaiduMobFailReason)reason;

/**
 *  本次广告展示成功时的回调
 */
- (void)didAdImpressed;

/**
 *  本次广告展示被用户点击时的回调
 */
- (void)didAdClicked;

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)didDismissLandingPage;

/**
 *  用户点击关闭按钮关闭广告后的回调
 */
- (void)didAdClose;

@end
