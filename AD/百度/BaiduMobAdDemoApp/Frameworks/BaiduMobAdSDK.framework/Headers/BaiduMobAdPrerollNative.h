//
//  BaiduMobAdPrerollNative.h
//  BaiduMobAdSDK
//
//  Created by lishan04 on 16/10/31.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdPrerollNativeDelegate.h"

@interface BaiduMobAdPrerollNative : NSObject
/**
 *  应用的APPID
 */
@property(nonatomic, copy) NSString *publisherId;
/**
 *  设置/获取代码位id
 */
@property(nonatomic, copy) NSString *adId;
/**
 * 广告delegate
 */
@property (nonatomic ,assign) id<BaiduMobAdPrerollNativeDelegate> delegate;

/**
 * 视频高度
 */
@property (nonatomic ,retain)  NSNumber *height;

/**
 * 视频宽度
 */
@property (nonatomic ,retain)  NSNumber *width;

/**
 * 请求广告
 */
- (void)request;

@end
