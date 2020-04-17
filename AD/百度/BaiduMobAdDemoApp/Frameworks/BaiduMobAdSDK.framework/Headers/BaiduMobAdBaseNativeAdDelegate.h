//
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/7/11.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"

@class BaiduMobAdBaseNativeAdView;

@protocol BaiduMobAdBaseNativeAdDelegate <NSObject>
@required
/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString *)publisherId;

/**
 * 广告位id
 */
-(NSString*)apId;

@optional

/**
 *  渠道ID
 */
- (NSString *)channelId;

/**
 *  启动位置信息
 */
-(BOOL) enableLocation;//如果enable，plist 需要增加NSLocationWhenInUseUsageDescription

/**
 * 广告请求成功
 * @param 请求成功的AdObject数组，如果只成功返回一条广告，数组大小为1
 */
- (void)onAdObjectsSuccessLoad:(NSArray*)adsArray;
/**
 *  广告请求失败
 * @param 失败的类型 BaiduMobFailReason
 */
- (void)onAdsFailLoad:(BaiduMobFailReason) reason;

/**
 *  广告点击
 */
- (void)onAdClicked:(BaiduMobAdBaseNativeAdView*)adView;

/**
 *  广告详情页关闭
 */
-(void)didDismissLandingPage:(BaiduMobAdBaseNativeAdView *)adView;
@end
