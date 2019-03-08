//
//  YXFeedAdManager.h
//  LunchAd
//
//  Created by shuai on 2018/10/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "YXFeedAdData.h"
#import "YXLaunchAdManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YXFeedAdManagerDelegate<NSObject>
@optional
/**
 加载成功的回调
 
 @param data  回调的广告素材
 */
- (void)didLoadFeedAd:(NSArray<YXFeedAdData*>*_Nullable)data;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadFeedAd:(NSError* _Nonnull)error;
/**
 广告点击后回调
 */
- (void)didClickedFeedAd;


/**
 广告渲染成功
 */
- (void)didFeedAdRenderSuccess;

@end

@interface YXFeedAdManager : NSObject

@property(nonatomic,weak) id<YXFeedAdManagerDelegate> delegate;

/**
 图片宽
 */
@property (nonatomic,assign) CGFloat adWidth;

/**
 图片高
 */
@property (nonatomic,assign) CGFloat adHeight;

/**  媒体位Id  */
@property (nonatomic,copy) NSString *mediaId;

/**
 广告数量 默认为1
 */
@property (nonatomic,assign) NSInteger adCount;

/*
 *  viewControllerForPresentingModalView
 *  详解：[必选]开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *controller;

/**  开始加载广告  */
- (void)loadFeedAd;

/**
 展示上报
 @param view 原生广告的视图，完整可点击区域
 */
- (void)registerAdViewForInteraction:(UIView *)view adData:(YXFeedAdData*)adData;

/**
 展示上报
 @param cell 原生广告的视图所在的cell，完整可点击区域
 */
- (void)registerAdViewForInCell:(UITableViewCell *)cell adData:(YXFeedAdData*)adData;

/**
 点击上报，要在注册成功，有返回点击url 的时候调用
 */
- (void)clickedEReportAdData:(YXFeedAdData*)adData;

@end

NS_ASSUME_NONNULL_END
