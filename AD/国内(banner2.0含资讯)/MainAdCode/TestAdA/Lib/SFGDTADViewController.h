//
//  SFADViewController.h
//  TestAdA
//
//  Created by lurich on 2019/8/27.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "GDTUnifiedBannerView.h"
#import "YXFeedAdData.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SFADViewDelegate <NSObject>

/**
 加载成功的回调
 
 @param data  回调的广告素材
 */
- (void)didLoadFeedAd:(NSArray<YXFeedAdData *> *)data Type:(NSInteger)adType;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadFeedAd:(NSError *)error Type:(NSInteger)adType;
/**
 广告点击后回调
 */
- (void)didClickedFeedAdType:(NSInteger)adType;
/**
 广告被关闭
 */
- (void)nativeExpressAdClose;
/**
 广告渲染成功
 */
- (void)didFeedAdRenderSuccessFeedAd:(NSArray<YXFeedAdData *> *)data Type:(NSInteger)adType;
/**
 广告渲染失败
 */
- (void)didFeedAdRenderFail;
/**
 原生广告曝光回调
 */
- (void)gdt_nativeExpressAdViewExposure:(NSInteger)adType;

//************************banner ************************
/**
 加载成功的回调
 */
- (void)didLoadBannerAd;

/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadBannerAd:(NSError*)error Type:(NSInteger)adType;

/**
 广告点击后回调
 */
- (void)didClickedBannerAd;
/**
 广告曝光回调
 */
- (void)didBannerAdExposure;
/**
 广告点击删除键
 */
- (void)didClickedRemoveBanner;

@end

@interface SFGDTADViewController : UIViewController<GDTNativeExpressAdDelegete,GDTUnifiedBannerViewDelegate>

+ (instancetype)defaultManger;

@property (nonatomic, strong) id<SFADViewDelegate> delegate;
@property (nonatomic, strong) UIViewController *showController;

- (void)getGDTADWithAppId:(NSString *)appid PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height AdCount:(NSInteger)count;

- (UIView *)getGDTBannerADWithAppId:(NSString *)appid PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height isLoop:(BOOL)isLoop autoSwitchInterval:(NSInteger)interval;

@end

NS_ASSUME_NONNULL_END
