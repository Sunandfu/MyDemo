//
//  WMFullscreenVideoAd.h
//  WMAdSDK
//
//  Created by 李盛 on 2018/8/3.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WMFullscreenVideoAd;

@protocol WMFullscreenVideoAdDelegate <NSObject>

@optional

/**
 视频广告物料加载成功
 */
- (void)fullscreenVideoMaterialMetaAdDidLoad:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告视频素材缓存成功
 */
- (void)fullscreenVideoAdVideoDataDidLoad:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 广告位即将展示
 */
- (void)fullscreenVideoAdWillVisible:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告关闭
 */
- (void)fullscreenVideoAdDidClose:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告点击下载
 */
- (void)fullscreenVideoAdDidClickDownload:(WMFullscreenVideoAd *)fullscreenVideoAd;

/**
 视频广告素材加载失败
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAd:(WMFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放完成或发生错误
 
 @param fullscreenVideoAd 当前视频对象
 @param error 错误对象
 */
- (void)fullscreenVideoAdDidPlayFinish:(WMFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error;

/**
 视频广告播放点击跳过

 @param fullscreenVideoAd 当前视频对象
 */
- (void)fullscreenVideoAdDidClickSkip:(WMFullscreenVideoAd *)fullscreenVideoAd;

@end

@interface WMFullscreenVideoAd : NSObject

@property (nonatomic, weak, nullable) id<WMFullscreenVideoAdDelegate> delegate;
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

/**
 初始化 WMFullscreenVideoAd
 
 @param slotID 代码位ID
 @return WMFullscreenVideoAd
 */
- (instancetype)initWithSlotID:(NSString *)slotID;

/**
 加载数据
 */
- (void)loadAdData;

/**
 展示视频广告

 @param rootViewController 展示视频的根视图
 @return 是否成功展示
 */
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

@end
