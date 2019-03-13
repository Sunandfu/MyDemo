//
//  GDTUnifiedNativeAd.h
//  GDTMobSDK
//
//  Created by nimomeng on 2018/10/10.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdDataObject.h"
#import "GDTUnifiedNativeAdView.h"

@protocol GDTUnifiedNativeAdDelegate <NSObject>

/**
 广告数据回调

 @param unifiedNativeAdDataObjects 广告数据数组
 @param error 错误信息
 */
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error;
@end

@interface GDTUnifiedNativeAd : NSObject
@property (nonatomic, weak) id<GDTUnifiedNativeAdDelegate> delegate;

/**
 构造方法

 @param appId 媒体ID
 @param placementId 广告位ID
 @return GDTUnifiedNativeAd 实例
 */
- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId;

/**
 加载广告
 */
- (void)loadAd;

/**
 加载广告

 @param adCount 加载条数
 */
- (void)loadAdWithAdCount:(int)adCount;
@end
