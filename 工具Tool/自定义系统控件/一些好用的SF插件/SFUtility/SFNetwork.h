//
//  Network.h
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SFNetTool.h"
#import "NSString+SFAES.h"
#import "SFConfigModel.h"

typedef void(^GetNetworkTimeSucess) (NSString *timeStr,BOOL success);

@interface SFNetwork : NSObject

/** 获取固定设备信息字典 */
+ (NSMutableDictionary *)getDeviceInfoDict;
/** 获取固定APP信息字典 */
+ (NSMutableDictionary *)getAppInfoDict;


+ (void)notifyToServerUrl:(NSString *)serverUrl;

/**
 s2s上报
 @param arr s2s上报
 */
+ (void)groupNotifyToSerVer:(NSArray *) arr;

//上报
+ (void)notifyToServerUrl:(NSString *)url Model:(SFConfigModelAdplace *)model SourceModel:(SFConfigModelAd_Sources *)sourceModel;
+ (void)notifyToServerUrl:(NSString *)url Model:(SFConfigModelAdplace *)model SourceModel:(SFConfigModelAd_Sources *)sourceModel Ecpm:(NSNumber *)ecpm;
+ (void)notifyToServerUrl:(NSString *)url Model:(SFConfigModelAdplace *)model SourceModel:(SFConfigModelAd_Sources *)sourceModel Ecpm:(NSNumber *)ecpm Time:(NSNumber *)time;

//请求配置接口
+ (void)requestADConfigFromMediaId:(NSString *)mediaId
                           success:(void(^)(NSDictionary *dataDict))success
                              fail:(void(^)(NSError *error))fail;

//请求直投广告
+ (void)requestS2SADFromSource:(SFConfigModelAd_Sources *)sourceModel
                        AdCount:(NSString *)adcount
                        success:(void(^)(NSDictionary *dataDict))success
                           fail:(void(^)(NSError *error))fail;

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

@end
