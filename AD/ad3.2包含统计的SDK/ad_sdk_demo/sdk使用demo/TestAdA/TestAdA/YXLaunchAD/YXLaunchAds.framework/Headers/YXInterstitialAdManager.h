//
//  YXInterstitialAdManager.h
//  LunchAd
//
//  Created by shuai on 2018/10/25.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YXInterstitialAdManagerDelegate <NSObject>

@optional
/**
 加载成功的回调
 */
- (void)didLoadInterstitialAd;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadInterstitialAd:(NSError* _Nonnull)error;
/**
 广告点击后回调
 */
- (void)didClickedInterstitialAd;


@end

@interface YXInterstitialAdManager : NSObject

@property (nonatomic,weak) id<YXInterstitialAdManagerDelegate> delegate;

/**
 插屏尺寸
 */
@property (nonatomic,assign) CGRect frame;

/**  媒体位Id  */
@property (nonatomic,copy) NSString *mediaId;

/**  开始加载广告  */
- (void)loadFeedAd;

- (void)showFeedAdWithViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
