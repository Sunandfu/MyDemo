//
//  YXLaunchAdConfiguration.m
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import "YXLaunchAdConfiguration.h"

#pragma mark - 公共
@implementation YXLaunchAdConfiguration

@end

#pragma mark - 图片广告相关
@implementation YXLaunchImageAdConfiguration

+(YXLaunchImageAdConfiguration *)defaultConfiguration{
    //配置广告数据
    YXLaunchImageAdConfiguration *configuration = [YXLaunchImageAdConfiguration new];
    //广告停留时间
    configuration.duration = 8;
    //广告frame
    configuration.frame = [UIScreen mainScreen].bounds;
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    configuration.GIFImageCycleOnce = NO;
    //缓存机制
    configuration.imageOption = YXLaunchAdImageDefault;
    //图片填充模式
    configuration.contentMode = UIViewContentModeScaleToFill;
    //广告显示完成动画
    configuration.showFinishAnimate =ShowFinishAnimateFadein;
     //显示完成动画时间
    configuration.showFinishAnimateTime = showFinishAnimateTimeDefault;
    //跳过按钮类型
    configuration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    configuration.showEnterForeground = NO;
    return configuration;
}

@end

#pragma mark - 视频广告相关
@implementation YXLaunchVideoAdConfiguration
+(YXLaunchVideoAdConfiguration *)defaultConfiguration{
    //配置广告数据
    YXLaunchVideoAdConfiguration *configuration = [YXLaunchVideoAdConfiguration new];
    //广告停留时间
    configuration.duration = 8;
    //广告frame
    configuration.frame = [UIScreen mainScreen].bounds;
    //视频填充模式
    configuration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //是否只循环播放一次
    configuration.videoCycleOnce = NO;
    //广告显示完成动画
    configuration.showFinishAnimate =ShowFinishAnimateFadein;
    //显示完成动画时间
    configuration.showFinishAnimateTime = showFinishAnimateTimeDefault;
    //跳过按钮类型
    configuration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    configuration.showEnterForeground = NO;
    //是否静音播放
    configuration.muted = NO;
    return configuration;
}
@end
