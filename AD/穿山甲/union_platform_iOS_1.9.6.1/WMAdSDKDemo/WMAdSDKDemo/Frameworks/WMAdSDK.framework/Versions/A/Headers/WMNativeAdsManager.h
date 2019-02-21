//
//  WMNativeAdsManager.h
//  WMAdSDK
//
//  Created by chenren on 24/05/2017.
//  Copyright © 2017 bytedance. All rights reserved.
//

/**
 WMNativeAdsManager适用于同时请求多条广告，
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WMAdSlot.h"
#import "WMMaterialMeta.h"
#import "WMNativeAd.h"

@protocol WMNativeAdsManagerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WMNativeAdsManager : NSObject

@property (nonatomic, strong, nullable) WMAdSlot *adslot;
@property (nonatomic, strong, nullable) NSArray<WMNativeAd *> *data;
/// 广告位加载展示响应的代理回调，可以设置为遵循<WMNativeAdDelegate>的任何类型，不限于Viewcontroller
@property (nonatomic, weak, nullable) id<WMNativeAdsManagerDelegate> delegate;

- (instancetype)initWithSlot:(WMAdSlot * _Nullable) slot;

/**
 请求广告素材数量，建议不超过3个，
 一次最多不超过10个
 @param count 最多广告返回的广告素材的数量
 */
- (void)loadAdDataWithCount:(NSInteger)count;

@end

@protocol WMNativeAdsManagerDelegate <NSObject>

@optional

- (void)nativeAdsManagerSuccessToLoad:(WMNativeAdsManager *)adsManager nativeAds:(NSArray<WMNativeAd *> *_Nullable)nativeAdDataArray;

- (void)nativeAdsManager:(WMNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
