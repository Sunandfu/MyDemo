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
 
 @param view  回调的view
 */
- (void)didLoadBannerAd:(UIView*)view;
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
 初始化方法
 
 @param frame 初始化方法
 @param delegate 广告请求结果回调代理
 @param mediaId 媒体位Id
 @param bannerType banner广告位置
 @return 广告层所在的父视图View
 */
-(instancetype _Nullable ) initWithFrame:(CGRect)frame
                                delegate:(id <YXBannerAdManagerDelegate> _Nullable) delegate
                                 mediaId:(NSString*)mediaId
                          BannerLocation:(BannerLocationType)bannerType ;

@end
