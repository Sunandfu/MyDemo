//
//  BaiduMobAdPrerollNativeAdObject.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/10/31.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"
#import "BaiduMobAdBaseNativeAdObject.h"

@interface BaiduMobAdPrerollNativeAdObject :BaiduMobAdBaseNativeAdObject
/**
 * 大图 url
 */
@property (copy, nonatomic) NSString *mainImageURLString;

/**
 * 广告标识图标 url
 */
@property (copy, nonatomic) NSString *adLogoURLString;

/**
 * 百度logo图标 url
 */
@property (copy, nonatomic) NSString *baiduLogoURLString;

/**
 * 视频url
 */
@property (copy, nonatomic)  NSString *videoURLString;
/**
 * 视频时长，单位为s
 */
@property (copy, nonatomic)  NSNumber *videoDuration;
/**
 * 对返回的广告单元，需先判断MaterialType再决定使用何种渲染组件
 */
@property MaterialType materialType;

/**
 * 返回广告单元的点击类型
 */
@property (nonatomic) BaiduMobNativeAdActionType actType;

/**
 * 是否过期，默认为false，30分钟后过期，需要重新请求广告
 */
-(BOOL) isExpired;

//#warning 重要，一定要调用这个方法发送视频状态事件和当前视频播放的位置
/**
 * 发送视频广告相关日志
 * @param currentPlaybackTime 播放器当前时间，单位为s
 */
- (void)trackVideoEvent:(BaiduAdNativeVideoEvent)event withCurrentTime:(NSTimeInterval)currentPlaybackTime;
@end
