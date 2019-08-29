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

NS_ASSUME_NONNULL_BEGIN

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
- (void)didFailedLoadBannerAd:(NSError*)error;

/**
 广告点击后回调
 */
- (void)didClickedBannerAd;

@end

@interface YXBannerAdManager : UIView
//banner尺寸默认 600*150 的比例  无法更改
/**
 banner位置
 */
@property (nonatomic,assign) BannerLocationType bannerType;

/**
 距离顶部或者底部的间距   由 BannerLocationType  控制上还是下
 */
@property (nonatomic, assign) NSInteger  locationY;

/**
 是否轮播。 若要开启轮播。 时间选择为30-120s之间。若不符合 则不轮播
 */
@property (nonatomic, assign) BOOL isLoop;

/**
 轮播间隔，单位秒，设置时间在 30~120s 范围内，初始化时传入。若不符合，则不轮播。
 */
@property (nonatomic, assign) NSInteger interval;

/**
 媒体位ID
 */
@property (nonatomic, copy) NSString *mediaId;
/**
 [必选]开发者需传入用来弹出广告的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *controller;

@property (nonatomic, weak) id<YXBannerAdManagerDelegate> delegate;

- (void)loadBannerAD;

@end

NS_ASSUME_NONNULL_END
