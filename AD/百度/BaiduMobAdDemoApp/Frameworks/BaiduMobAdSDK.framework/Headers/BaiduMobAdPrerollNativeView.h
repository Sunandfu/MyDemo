//
//  BaiduMobAdPrerollNativeView.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/11/1.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdNativeVideoBaseView.h"
#import "BaiduMobAdPrerollNativeAdObject.h"
#import "BaiduMobAdCommonConfig.h"
#import "BaiduMobAdBaseNativeAdView.h"

@interface BaiduMobAdPrerollNativeView : BaiduMobAdBaseNativeAdView
/**
 * 广告标示
 */
@property (assign, nonatomic)  UIImageView *adLogoImageView;
/**
 * 百度广告logo
 */
@property (assign, nonatomic)  UIImageView *baiduLogoImageView;

/**
 * 初始化，非视频信息流，MaterialType是NORMAL的初始化方法
 */
-(id)initWithFrame:(CGRect)frame
         mainImage:(UIImageView *) mainView;

/**
 * 如果MaterialType是VIDEO的初始化方法
 * 添加品牌名称brandName
 1.开发者可用百度自带播放器组建BaiduMobAdNativeVideoView渲染，并传入视频view
 2.开发者可使用自己的视频播放控件渲染，并传入视频view
 */
-(id)initWithFrame:(CGRect)frame
         videoView:(BaiduMobAdNativeVideoBaseView *) videoView;

/*
 * 根据广告内容，在广告视图上缓存和展示广告,同时关联广告视图和点击展现行为
 * object 包含文字内容和物料地址
 */
- (void)loadAndDisplayAdWithObject:(BaiduMobAdBaseNativeAdObject *)object completion:(BaiduMobAdViewCompletionBlock)completionBlock;
/**
 * 发送展现日志
 */
- (void)trackImpression;
@end
