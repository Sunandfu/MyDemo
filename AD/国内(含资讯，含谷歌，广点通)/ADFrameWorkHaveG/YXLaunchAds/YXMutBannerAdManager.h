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

//轮播图弧度
@property (nonatomic, assign) CGFloat cornerRadius;

/**  媒体位Id  */
@property (nonatomic,copy) NSString *mediaId;

/** 是否只显示图片 */
@property (nonatomic, assign) BOOL isOnlyImage;

/**
 广告数量 默认为1
 */
@property (nonatomic,assign) NSInteger adCount;

/**
 *  滚动方法 默认为横向
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 轮播 View 的底色 */
@property (nonatomic, strong) UIImage *backgroundImage;

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/**
 pagecontrol 样式，默认为系统自带经典样式
 当为 YXBannerScrollViewPageImage 前缀样式时，必须传入分页控件小图标的图片，否则展示无效果
 */
@property (nonatomic, assign) YXBannerScrollViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) YXBannerScrollViewPageContolAliment pageControlAliment;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

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
