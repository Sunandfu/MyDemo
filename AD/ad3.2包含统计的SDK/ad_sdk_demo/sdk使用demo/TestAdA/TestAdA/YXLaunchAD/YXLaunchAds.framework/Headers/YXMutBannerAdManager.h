//
//  YXMutBannerAdManager.h
//  LunchAd
//
//  Created by shuai on 2018/11/21.
//  Copyright © 2018 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YXLaunchConfiguration.h"
#import "YXFeedAdData.h"

NS_ASSUME_NONNULL_BEGIN
@protocol YXMutBannerAdManagerDelegate<NSObject>
@optional
/**
 加载成功的回调
 */
- (void)didLoadMutBannerAdView;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadMutBannerAd:(NSError* _Nonnull)error;
/**
 广告点击后回调
 */
- (void)didClickedMutBannerAd;

@end
@interface YXMutBannerAdManager : NSObject

@property(nonatomic,weak) id<YXMutBannerAdManagerDelegate> delegate;

@property (nonatomic,assign)YXADSize  adSize;

/**  媒体位Id  */
@property (nonatomic,copy) NSString *mediaId;

/**
 广告数量 默认为1
 */
@property (nonatomic,assign) NSInteger adCount;

/**
 *  滚动方法 默认为横向
 */

@property (nonatomic,assign) YXNewPagedFlowViewOrientation orientation;

/**
 *  是否开启自动滚动 默认为开启
 */
@property (nonatomic, assign) BOOL isOpenAutoScroll;

/**
 *  是否开启无限轮播,默认为开启
 */
@property (nonatomic, assign) BOOL isCarousel;

/**
 *  自动切换视图的时间,默认是5.0
 */
@property (nonatomic, assign) CGFloat autoTime;

/**
  [必选]开发者需传入用来弹出广告的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *controller;


/**  开始加载广告  */

/**
 开始加载广告

 @param view 加载广告的View
 */
- (void)loadMutBannerAdViewsInView:(UIView*)view;



@end

NS_ASSUME_NONNULL_END
