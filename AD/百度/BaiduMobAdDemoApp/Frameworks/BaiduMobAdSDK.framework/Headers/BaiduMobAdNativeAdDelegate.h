//
//  BaiduMobAdInterstitialDelegate.h
//  BaiduMobAdWebSDK
//
//  Created by deng jinxiang on 13-8-1.
//
//
#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"
@class BaiduMobAdNative;
@class BaiduMobAdNativeAdView;

@protocol BaiduMobAdNativeAdDelegate <NSObject>

@optional
/**
 *  应用在mssp.baidu.com上的APPID
 */
- (NSString *)publisherId;

/**
 * 广告位id
 */
-(NSString*)apId;

/**
 * 模版高度，仅用于信息流模版广告
 */
-(NSNumber*)baiduMobAdsHeight;

/**
 * 模版宽度，仅用于信息流模版广告
 */
-(NSNumber*)baiduMobAdsWidth;

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
 * @param 请求成功的BaiduMobAdNativeAdObject数组，如果只成功返回一条原生广告，数组大小为1
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds;
/**
 *  广告请求失败
 * @param 失败的BaiduMobAdNative
 * @param 失败的类型 BaiduMobFailReason
 */
- (void)nativeAdsFailLoad:(BaiduMobFailReason) reason;

/**
 *  广告点击
 */
- (void)nativeAdClicked:(UIView*)nativeAdView;

/**
 *  广告详情页关闭
 */
-(void)didDismissLandingPage:(UIView *)nativeAdView;



@end
