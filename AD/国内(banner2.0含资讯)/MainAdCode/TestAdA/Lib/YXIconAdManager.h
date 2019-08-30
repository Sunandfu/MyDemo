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

NS_ASSUME_NONNULL_BEGIN
@protocol YXIconAdManagerDelegate<NSObject>
@optional
/**
 加载成功的回调
 
 @param view  回调的view
 */
- (void)didLoadIconAd:(UIView *)view;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadIconAd:(NSError *)error;
/**
 广告点击后回调
 */
- (void)didClickedIconAd;

@end


@interface YXIconAdManager : UIView

@property (nonatomic,weak) id<YXIconAdManagerDelegate> delegate;

/*
 *  controller
 *  详解：[必选]开发者需传入用来弹出目标页的ViewController，一般为当前ViewController
 */
@property (nonatomic, weak) UIViewController *controller;
/**
 图片frame
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**  媒体位Id  */
@property (nonatomic,copy) NSString *mediaId;

/** 广告类型 */
@property(nonatomic,assign) YXADTYPE adType;


/**  开始加载广告  */
- (void)loadIconAd;

/**
 icon数组形式 与mediaId互斥
 */
@property (nonatomic, strong) NSArray<NSString *> *mediaIdArray;

/**
 多icon样式时，以下参数可自定义设置
 */
//menu的颜色
@property (nonatomic, strong) UIColor *menuGroundColor;
//字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//字体大小
@property (nonatomic, strong) UIFont *titleFont;
//item宽度
@property (nonatomic, assign) CGFloat itemWidth;
//item高度
@property (nonatomic, assign) CGFloat itemHeight;
//icon的ContentMode
@property (nonatomic)         UIViewContentMode contentMode;
//箭头方向
@property(nonatomic,assign) YXPopupMenuDirection popType;

/**
 显示icon数组view

 @param point 传入点击view的point
 */
- (void)showCustomPopupMenuWithPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
