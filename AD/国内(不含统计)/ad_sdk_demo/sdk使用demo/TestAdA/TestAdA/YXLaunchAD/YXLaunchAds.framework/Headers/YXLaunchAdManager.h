//
//  YXLaunchAdManager.h
//  YXLaunchAdExample

//  Created by shuai on 2018/3/23.
//  Copyright © 2018年 M. All rights reserved.
//  Version 2.4

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXLaunchConfiguration.h"

//广告代理
@protocol YXLaunchAdManagerDelegate <NSObject>
@optional
/**
 加载成功的回调

 @param view  回调的view（开屏的时候返回nil）
 */
- (void)didLoadAd:(UIView *_Nullable)view;
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadAd:(NSError *_Nonnull)error;

/**
 广告结束 移除window中的视图
 */
- (void)LaunchShowFinish;
/**
 广告点击后回调
 */
- (void)didClickedAd;
/**
 落地页或者appstoe返回事件，方便用户做返回后的处理工作
 */
-(void)didAdShowReturn;
/**
 跳过按钮点击回调
 */
- (void)lunchADSkipButtonClick;
/**
 *  倒计时回调
 *
 *  @param duration 倒计时时间
 */
-(void)customSkipDuration:(NSInteger)duration; 

@end

@interface YXLaunchAdManager : NSObject
/**
 初始化方法

 @return 广告管理器初始化
 */
+(YXLaunchAdManager *_Nonnull)shareManager;

@property(nonatomic, weak) id<YXLaunchAdManagerDelegate> delegate;

/** 设置开屏广告的frame(default [UIScreen mainScreen].bounds) */
@property (nonatomic,assign) CGRect frame;

/**  媒体位Id  */
@property (nonatomic, copy, nonnull) NSString *mediaId;
 

//
///** 缓存机制(default YXLaunchImageDefault) */
@property(nonatomic,assign)YXLaunchAdImageOptions imageOption;

/** 设置开屏广告的停留时间(default 5 ,单位:秒) */
@property(nonatomic,assign)NSInteger duration;
/**
 设置开屏广告的等待时间 default 5
 1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
 2.设为5即表示:启动页将停留5s等待服务器返回广告数据,5s内等到广告数据,将正常显示广告,否则将不显示
 3.数据获取成功,配置广告数据后,自动结束等待,显示广告
 */
@property(nonatomic,assign)NSInteger waitDataDuration;

/** 显示完成动画时间(default 0.8 , 单位:秒) */
@property(nonatomic,assign)CGFloat showFinishAnimateTime;

/** 显示完成动画(default ShowFinishAnimateFadein) */
@property(nonatomic,assign)ShowFinishAnimate showFinishAnimate;
 

/** 广告类型 */
@property(nonatomic,assign) YXADTYPE adType;

/** 跳过按钮类型(default SkipTypeTimeText) */
@property(nonatomic,assign)SkipType skipButtonType;

/** 图片广告缩放模式(default UIViewContentModeScaleToFill) */
@property(nonatomic,assign)UIViewContentMode contentMode;

/** 自定义跳过按钮 (不再使用) */
@property (nonatomic,strong) UIView * _Nullable customSkipView;

@property (nonatomic,strong) UIView * _Nullable bottomView;

/**  开始加载广告  */
- (void)loadLaunchAdWithShowAdWindow:(UIWindow *_Nonnull)showAdWindow;
/**
 设置自定义跳过按钮的时候需要手动 手动移除广告
 
 @param animated 是否需要动画
 */
+(void)removeAndAnimated:(BOOL)animated;
 

@end
