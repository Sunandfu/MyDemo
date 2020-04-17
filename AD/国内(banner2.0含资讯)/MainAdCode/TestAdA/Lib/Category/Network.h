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
#import "NetTool.h"
#import "NSString+SFAES.h"

typedef void(^NetworkSucess) (NSDictionary * response);
typedef void(^NetworkFailure) (NSError *error);

@interface Network : NSObject

//封装网络请求的方法:
+ (void)beginRequestWithADkey:(NSString *)adkey
                        width:(CGFloat )width
                       height:(CGFloat )height
                      adCount:(NSInteger)adCount finished:(void (^)(BOOL, id))finish;

/**
 展示点击上报
 
 @param url 展示点击上报
 */
+ (void)upOutSideToServer:(NSString*)url isError:(BOOL)isError code:(NSString*)code msg:(NSString*)msg currentAD:(NSDictionary*)currentAD gdtAD:(NSDictionary*)gdtAD mediaID:(NSString*)mediaID;

/**
 请求上报
 
 @param url 请求上报地址
 */
+ (void)upOutSideToServerRequest:(NSString*)url currentAD:(NSDictionary*)currentAD gdtAD:(NSDictionary*)gdtAD mediaID:(NSString*)mediaID;


+ (void)notifyToServerUrl:(NSString *)serverUrl completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;

/**
 s2s上报
 
 @param arr s2s上报
 */
+ (void)groupNotifyToSerVer:(NSArray *) arr;


/**
 黑名单

 @param url 链接
 @param media 媒体位
 @param day 天
 @param isAdd 是否加入
 */
+ (void)blackListUrl:(NSString *)url andMedia:(NSString *)media andTime:(NSInteger)day isAdd:(BOOL)isAdd;

//开屏请求配置接口
+ (void)requestADSourceFromMediaId:(NSString *)mediaId success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail;
//其他请求配置接口
+ (void)requestADSourceFromMediaId:(NSString *)mediaId adCount:(NSInteger)adCount imgWidth:(CGFloat)width imgHeight:(CGFloat)height success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail;

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//资讯统计
+ (void)newsStatisticsWithType:(NSInteger)eventType NewsID:(NSString *)newsId CatID:(NSString *)catId lengthOfTime:(NSInteger)lengthOfTime;

@end
