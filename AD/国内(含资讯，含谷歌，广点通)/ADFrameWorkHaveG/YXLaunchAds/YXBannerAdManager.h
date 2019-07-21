//
//  YXBannerAdManager.h
//  LunchAd
//
//  Created by shuai on 2018/10/8.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YXLaunchConfiguration.h"

@protocol YXBannerAdManagerDelegate<NSObject>
@optional

/**
 加载成功的回调
 */
- (void)didLoadBannerAd;

/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadBannerAd:(NSError* _Nonnull)error;

/**
 广告点击后回调
 */
- (void)didClickedBannerAd;

@end

@interface YXBannerAdManager : UIView

/**
 banner尺寸   如果不设置。默认使用当前view的bounds
 */
@property (nonatomic,assign) YXAD_Banner adSize;

/**
 是否轮播。 若要开启轮播。 时间选择为30-120s之间。若不符合 则不轮播
 */
@property (nonatomic, assign) BOOL isLoop;

/**
 轮播间隔，单位秒，设置时间在 30~120s 范围内，初始化时传入。若不符合，则不轮播。
 */
@property (nonatomic, assign) NSInteger interval;

/**
 banner位置
 */
@property (nonatomic,assign) BannerLocationType bannerType;

/**
 媒体位ID
 */
@property (nonatomic, copy, nonnull) NSString *mediaId;

@property (nonatomic, assign, nullable) id<YXBannerAdManagerDelegate> delegate;

- (void)loadBannerAD;

@end
