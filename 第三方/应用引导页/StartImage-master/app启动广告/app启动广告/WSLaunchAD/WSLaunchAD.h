//
//  WSLaunchAD.h
//  APP启动图
//
//  Created by iMac on 16/9/22.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WSWebCache.h"

@class WSLaunchAD;
typedef void (^WSLaunchAdClickBlock)();
typedef void (^WSSetLaunchAdBlock)(WSLaunchAD *launchAd);

typedef NS_ENUM(NSUInteger, SkipShowType)
{
    SkipShowTypeNone = 0,       /** 无跳过 */
    SkipShowTypeDefault,        /** 跳过+倒计时*/
    SkipShowTypeAnimation,      /** 动画跳过 ⭕️ */
};

@interface WSLaunchAD : UIView

/**
 *  广告图
 */
@property(nonatomic, strong) UIImageView *launchAdImgView;

/**
 *  广告frame
 */
@property (nonatomic, assign) CGRect launchAdViewFrame;




/**
 *  底部的软件名称，大小为屏幕大小
 */
@property (nonatomic,strong ) UIImageView *bottomImgView;





/**
 *  清理缓冲
 */
+ (void)clearDiskCache;

/**
 *  初始化启动页广告
 *
 *  @param adDuration  停留时间
 *  @param hideSkip    是否隐藏跳过
 *  @param setLaunchAd launchAdView
 *
 *  @return self
 */
+ (instancetype)initImageWithAttribute:(NSInteger)adDuration showSkipType:(SkipShowType)showSkipType setLaunchAd:(WSSetLaunchAdBlock)setLaunchAd;

/**
 *  设置图片
 *
 *  @param strURL       URL
 *  @param options      图片缓冲模式
 *  @param result       UIImage *image, NSURL *url
 *  @param adClickBlock 点击图片回调
 */
- (void)setWebImageWithURL:(NSString *)strURL options:(WSWebImageOptions)options result:(WSWebImageCompletionBlock)result adClickBlock:(WSLaunchAdClickBlock)adClickBlock;

/**
 *  设置动画跳过属性
 *
 *  @param strokeColor     转动颜色
 *  @param lineWidth       宽度
 *  @param backgroundColor 背景色
 *  @param textColor       字体颜色
 */
- (void)setAnimationSkipWithAttribute:(UIColor *)strokeColor lineWidth:(NSInteger)lineWidth backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;
@end