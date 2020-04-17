//
//  YXLaunchAdConfiguration.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXLaunchAdButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "YXLaunchAdImageManager.h"
#import "YXLaunchAdConst.h"

#import "YXLaunchConfiguration.h"

NS_ASSUME_NONNULL_BEGIN



#pragma mark - 公共属性
@interface YXLaunchAdConfiguration : NSObject

/** 停留时间(default 5 ,单位:秒) */
@property(nonatomic,assign)NSInteger duration;

/** 跳过按钮类型(default SkipTypeTimeText) */
@property(nonatomic,assign)SkipType skipButtonType;

/** 显示完成动画(default ShowFinishAnimateFadein) */
@property(nonatomic,assign)ShowFinishAnimate showFinishAnimate;

/** 显示完成动画时间(default 0.8 , 单位:秒) */
@property(nonatomic,assign)CGFloat showFinishAnimateTime;

/** 设置开屏广告的frame(default [UIScreen mainScreen].bounds) */
@property (nonatomic,assign) CGRect frame;

/** 程序从后台恢复时,是否需要展示广告(defailt NO) */
@property (nonatomic,assign) BOOL showEnterForeground;

/** 点击打开页面地址(请使用openModel,点击事件代理方法请对应使用YXLaunchAd:clickAndOpenModel:clickPoint:) */
@property(nonatomic,copy)NSString *openURLString YXLaunchAdDeprecated("请使用openModel,点击事件代理方法请对应使用YXLaunchAd:clickAndOpenModel:clickPoint:");

/** 点击打开页面参数 */
@property (nonatomic, strong) id openModel;

/** 自定义跳过按钮(若定义此视图,将会自定替换系统跳过按钮) */
@property(nonatomic,strong,nullable) UIView * customSkipView;

@property(nonatomic,strong,nullable) UIView * addSkipLeftView;

/** 子视图(若定义此属性,这些视图将会被自动添加在广告视图上,frame相对于window) */
@property(nonatomic,copy,nullable) NSArray<UIView *> *subViews;

@end

#pragma mark - 图片广告相关
@interface YXLaunchImageAdConfiguration : YXLaunchAdConfiguration

/** image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL string */
@property(nonatomic,copy)NSString *imageNameOrURLString;

/** 图片广告缩放模式(default UIViewContentModeScaleToFill) */
@property(nonatomic,assign)UIViewContentMode contentMode;

/** 缓存机制(default YXLaunchImageDefault) */
@property(nonatomic,assign)YXLaunchAdImageOptions imageOption;

/** 设置GIF动图是否只循环播放一次(YES:只播放一次,NO:循环播放,default NO,仅对动图设置有效) */
@property (nonatomic, assign) BOOL GIFImageCycleOnce;

+(YXLaunchImageAdConfiguration *)defaultConfiguration;

@end

#pragma mark - 视频广告相关
@interface YXLaunchVideoAdConfiguration : YXLaunchAdConfiguration

/** video本地名或网络链接URL string */
@property(nonatomic,copy)NSString *videoNameOrURLString;

/** 视频缩放模式(default MPMovieScalingModeAspectFill) */
@property(nonatomic,assign)MPMovieScalingMode scalingMode YXLaunchAdDeprecated("请使用videoGravity");

/** 视频缩放模式(default AVLayerVideoGravityResizeAspectFill) */
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

/** 设置视频是否只循环播放一次(YES:只播放一次,NO循环播放,default NO) */
@property (nonatomic, assign) BOOL videoCycleOnce;

/** 是否关闭音频(default NO) */
@property (nonatomic, assign) BOOL muted;

+(YXLaunchVideoAdConfiguration *)defaultConfiguration;

@end

NS_ASSUME_NONNULL_END
