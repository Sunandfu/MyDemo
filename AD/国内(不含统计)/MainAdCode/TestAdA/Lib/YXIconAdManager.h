//
//  YXIconAdManager.h
//  LunchAd
//
//  Created by shuai on 2018/6/11.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXLaunchConfiguration.h"


@protocol YXIconAdManagerDelegate<NSObject>
@optional
/**
 加载成功的回调
 
 @param view  回调的view
 */
- (void)didLoadIconAd:(UIView*)view;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadIconAd:(NSError* _Nonnull)error;
/**
 广告点击后回调
 */
- (void)didClickedIconAd;

@end


@interface YXIconAdManager : UIView

@property (nonatomic,weak) id<YXIconAdManagerDelegate> delegate;

/**
 图片frame
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**  媒体位Id  */
@property (nonatomic,copy) NSString *mediaId;

/** 广告类型 */
@property(nonatomic,assign) YXADTYPE adType;

/*
 *  viewControllerForPresentingModalView
 *  详解：[必选]开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *controller;

/**  开始加载广告  */
- (void)loadIconAd;

@end
