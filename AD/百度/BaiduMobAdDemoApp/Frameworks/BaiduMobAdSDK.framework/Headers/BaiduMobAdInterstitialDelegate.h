//
//  BaiduMobAdInterstitialDelegate.h
//  XAdSDKDevSample
//
//  Created by LiYan on 16/4/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaiduMobAdCommonConfig.h"
#import <Foundation/Foundation.h>

@class BaiduMobAdInterstitial;

@protocol BaiduMobAdInterstitialDelegate <NSObject>

@required
/**
 *  appid
 */
- (NSString *)publisherId;

@optional

/**
 *  channel id
 */
- (NSString *)channelId;

/**
 *  location
 */
- (BOOL) enableLocation;

/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial;

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial;

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)interstitial;

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial;

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason;

/**
 *  广告展示被用户点击时的回调
 */
- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial;

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)interstitial;

/**
 *  广告详情页被关闭
 */
- (void)interstitialDidDismissLandingPage:(BaiduMobAdInterstitial *)interstitial;

@end
