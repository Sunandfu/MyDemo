//
//  BaiduMobStat.h
//  百度移动统计iOS SDK所有功能Api接口头文件
//
//  Created by LiDongdong on 14-05-27.
//  Copyright (c) 2014-2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

/**
 *  百度移动应用统计对象
 *  V1.7
 */
@interface BaiduMobStatForSDK : NSObject

/**
 *  获取统计对象的单例
 *
 *  @return 一个统计对象实例
 */
+ (BaiduMobStatForSDK *)defaultStat;

/**
 *  以appId为标识，启动对SDK的统计，在其他行为统计api调用以前必须先调用该api.
 *
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)startWithAppId:(NSString *)appId;

/**
 *  记录一次事件的点击，eventId请在网站上创建。未创建的evenId记录将无效。
 *
 *  @param eventId 自定义事件Id，提前在网站端创建
 *  @param eventLabel 自定义事件Label，附加参数，不能为空字符串
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)logEvent:(NSString *)eventId eventLabel:(NSString *)eventLabel withAppId:(NSString *)appId;

/**
 *  记录一次事件的时长，eventId请在网站上创建。未创建的evenId记录将无效。
 *
 *  @param eventId 自定义事件Id，提前在网站端创建
 *  @param eventLabel 自定义事件Label，附加参数，不能为空字符串
 *  @param duration 已知的自定义事件时长，单位ms
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)logEventWithDurationTime:(NSString *)eventId
                      eventLabel:(NSString *)eventLabel
                    durationTime:(unsigned long)duration
                       withAppId:(NSString *)appId;
/**
 *  记录一次事件的开始，eventId请在网站上创建。未创建的evenId记录将无效。
 *
 *  @param eventId 自定义事件Id，提前在网站端创建
 *  @param eventLabel 自定义事件Label，附加参数，不能为空字符串
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)eventStart:(NSString *)eventId eventLabel:(NSString *)eventLabel withAppId:(NSString *)appId;

/**
 *  记录一次事件的结束，eventId请在网站上创建。未创建的evenId记录将无效。
 *
 *  @param eventId 自定义事件Id，提前在网站端创建
 *  @param eventLabel 自定义事件Label，附加参数，不能为空字符串
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)eventEnd:(NSString *)eventId eventLabel:(NSString *)eventLabel withAppId:(NSString *)appId;

/**
 *  标识某个页面访问的开始，请参见Example程序，在合适的位置调用。
 *
 *  @param name 页面名称
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)pageviewStartWithName:(NSString *)name withAppId:(NSString *)appId;

/**
 *  标识某个页面访问的结束，与pageviewStartWithName配对使用，请参见Example程序，在合适的位置调用。
 *
 *  @param name 页面名称
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)pageviewEndWithName:(NSString *)name withAppId:(NSString *)appId;

/**
 *  设置渠道Id。不设置时系统会处理为nil
 *
 *  @param channelId 用户自定义的渠道名称
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)setChannelId:(NSString *)channelId withAppId:(NSString *)appId;

/**
 *  获取渠道Id。当传入appId无效，则返回nil
 *
 *  @param appId 用户在mtj网站上创建的appId
 */
- (NSString *)getChannelIdWithAppId:(NSString *)appId;

/**
 *  是否只在wifi连接下才发送日志.默认值为 NO, 不管什么网络都发送日志
 *
 *  @param logSendWifiOnly 是否只在wifi连接下才发送日志
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)setLogSendWifiOnly:(BOOL)logSendWifiOnly withAppId:(NSString *)appId;

/**
 *  获取是否只在wifi连接下才发送日志。当传入appId无效，则返回NO
 *
 *  @param appId 用户在mtj网站上创建的appId
 *
 *  @return 返回当前是否只在wifi连接下才发送日志
 */
- (BOOL)getLogSendWifiOnlyWithAppId:(NSString *)appId;

/**
 *  设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
 *
 *  @param sessionResumeInterval session间隔时间
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)setSessionResumeInterval:(int)sessionResumeInterval withAppId:(NSString *)appId;

/**
 *  获取应用进入后台再回到前台为同一次session的间隔时间参数。当传入appId无效，则返回默认值30s
 *
 *  @param appId 用户在mtj网站上创建的appId
 *
 *  @return 返回当前同一次session的间隔时间
 */
- (int)getSessionResumeIntervalWithAppId:(NSString *)appId;

/**
 *  设置SDK版本号。不设置时默认值为"1.0"
 *
 *  @param sdkVersion 用户SDK的版本
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)setSDKVersion:(NSString *)sdkVersion withAppId:(NSString *)appId;

/**
 *  获取SDK版本号参数。当传入appId无效，则返回nil
 *
 *  @param appId 用户在mtj网站上创建的appId
 *
 *  @return 返回SDK版本号
 */
- (NSString *)getSDKVersionWithAppId:(NSString *)appId;

/**
 *  开发这可以调用此接口来打印SDK中的日志，用于调试
 *
 *  @param enableDebugOn 是否debug模式，控制Log打印
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)setEnableDebugOn:(BOOL)enableDebugOn withAppId:(NSString *)appId;

/**
 *  获取打印SDK中的日志参数。当传入appId无效，则返回NO
 *
 *  @param appId 用户在mtj网站上创建的appId
 *
 *  @return 返回是否debug模式
 */
- (BOOL)getEnableDebugOnWithAppId:(NSString *)appId;

/**
 *  让开发者来填写adid，让统计更加精确
 *
 *  @param adid 设备的Adid
 *  @param appId 用户在mtj网站上创建的appId
 */
- (void)setAdid:(NSString *)adid withAppId:(NSString *)appId;

/**
 *  获取adid。当传入appId无效，则返回nil
 *
 *  @param appId 用户在mtj网站上创建的appId
 *
 *  @return 返回用户传入的设备的Adid
 */
- (NSString *)getAdidWithAppId:(NSString *)appId;

@end
