//
//  SFConstant.m
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "SFConstant.h"

//媒体位ID
NSString * const KeyMediaId = @"MediaId";
//内容位ID
NSString * const KeyLocationId = @"mLocationId";
//城市代码
NSString * const KeyADSDKCityCode = @"ADSDKCityCode";
//APP 语言key
NSString * const KeyAppleLanguages = @"AppleLanguages";
//活动 渠道ID
NSString * const KeyChannel = @"channel";
//活动 userID
NSString * const KeyVuid = @"vuid";

#pragma mark - 接口类
//展示成果
NSString * const APIShow = TRACKIN @"/log/newMimpr/v3";
//曝光上报
NSString * const APIExposured = TRACKIN @"/log/newImprEffect/v/3";
//点击上报
NSString * const APIClick = TRACKIN @"/log/newMclick/v3";
//错误上报
NSString * const APIError = TRACKIN @"/log/newErrorLog/v3";
//请求第三方上报
NSString * const APIRequest = SEVERIN @"/yd3/log/v/3";
//请求配置接口接口
NSString * const APICongfig = SEVERIN @"/yd3/mediaconfig/v/3";
//S2S接口
NSString * const APIMview = SEVERIN @"/yd3/mview/v/3";
//添加黑名单
NSString * const APIAddBlack = SEVERIN @"/yd3/user/black";
//移除黑名单
NSString * const APIRemoveBlack = SEVERIN @"/yd3/user/black/remove";
//版本号
NSString * const SDKVersionKey = SEVERIN @"4.4";

