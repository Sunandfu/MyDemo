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
 广告点击后回调的index
 */
- (void)didClickedMutBannerAdWithIndex:(NSInteger)index;

@end
@interface YXMutBannerAdManager : NSObject

@property(nonatomic,weak) id<YXMutBannerAdManagerDelegate> delegate;

@property (nonatomic,assign) YXADSize  adSize;

/**
 当adSize类型为YXADSizeCustom时，宽高必传，其余模式不用传
 */
@property (nonatomic, assign) CGFloat s2sWidth;
@property (nonatomic, assign) CGFloat s2sHeight;

/**
 轮播图背景占位图
 */
@property (nonatomic,strong) UIImage  *placeImage;

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
 *  是否显示pageControl,默认为开启
 */
@property (nonatomic, assign) BOOL isShowPageControl;

/**
 改变PageControl位置（位置相对于轮播图），默认在底部中间
 */
@property (nonatomic) CGRect pageFrame;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 左右间距,默认10
 */
@property (nonatomic, assign) CGFloat leftRightMargin;

/**
 上下间距,默认10
 */
@property (nonatomic, assign) CGFloat topBottomMargin;

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


/**
 刷新广告数据
 */
- (void)reloadMutBannerAd;

/**
 清空轮播广告缓存数据
 */
- (void)clearMutBannerAdImageChace;

@end

NS_ASSUME_NONNULL_END
