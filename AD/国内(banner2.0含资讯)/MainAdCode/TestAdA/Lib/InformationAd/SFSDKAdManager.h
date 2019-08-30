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
@class SDKADTableViewCell;

NS_ASSUME_NONNULL_BEGIN

typedef void(^getADSucess) (YXFeedAdData *model);
typedef void(^getADFail) (NSError *error);

@interface SFSDKAdManager : NSObject

@property (nonatomic,assign) YXADSize adSize;

/**
 当adSize类型为YXADSizeCustom时，宽高必传，其余模式不用传
 */
@property (nonatomic, assign) CGFloat s2sWidth;
@property (nonatomic, assign) CGFloat s2sHeight;

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

@property (nonatomic, copy) getADSucess success;
@property (nonatomic, copy) getADFail   fail;

- (void)loadsingleFeedAdSuccess:(getADSucess)success fail:(getADFail)fail;

/**
 定义原生广告视图中可以点击的 视图区域，行为由SDK控制
 */
- (void)clickAdViewForAdData:(YXFeedAdData*)adData;

/**
 定义原生广告视图中可以点击的 视图区域，行为由SDK控制
 @param cell 原生广告的视图所在的cell，完整可点击区域
 */
- (void)registerAdViewForInCell:(SDKADTableViewCell *)cell adData:(YXFeedAdData*)adData;

@end

NS_ASSUME_NONNULL_END
