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

/*
 config :http://119.29.146.103:8086
 
 请求上报 :http://119.29.146.103:8086
 曝光上报:http://119.29.146.103:8082
 点击上报:http://119.29.146.103:8082
 
 http://www.yunqingugm.com:8081 请求
 
 http://www.yunqingugm.com:8082 上报
 
 */

#define SEVERIN @"http://47.99.227.46:8081"

#define TRACKIN @"http://47.99.227.46:8082"

#define ADSHOW   TRACKIN @"/log/newMimpr/v2"
#define ADCLICK  TRACKIN @"/log/newMclick"
#define ADError  TRACKIN @"/log/newErrorLog"

#define ADRequest SEVERIN @"/yd3/log"

#define inLandAD @"inLandAD"

#define congfigIp SEVERIN @"/yd3/mediaconfig/v/2?mediaId=%@&aid=%@&ver=%@&%@&%@"

#define USERBLACK SEVERIN @"/yd3/user/black"

#define USERBLACKREMOVE USERBLACK @"/remove"

//#warning 正式去掉/v/2
#define S2SURL SEVERIN @"/yd3/mview/v/2"

typedef void(^NetworkSucess) (NSDictionary * response);
typedef void(^NetworkFailure) (NSError *error);

@interface Network : NSObject

+ (instancetype)sharedInstance;


@property (nonatomic,copy) NetworkSucess getdataSuccess;

@property (nonatomic,assign) BOOL isInland;

@property (nonatomic,copy) NSString *ipStr;

-(NSString *)deviceWANIPAdress;

-(BOOL) prepareDataAndRequestWithadkeyString:(NSString *)adkey
                                       width:(CGFloat )width
                                      height:(CGFloat )height
                                       macID:(NSString*)macId
                                         uid:(NSString*)uid
                                     adCount:(NSInteger)adCount;

//封装网络请求的方法:
- (void)beginRequestfinished:(void (^) (BOOL isSuccess , id json))finish;

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


+ (void) notifyToServer:(NSString *) parmams serverUrl:(NSString *)serverUrl completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;

/**
 s2s上报
 
 @param arr s2s上报
 */
+(void) groupNotifyToSerVer:(NSArray *) arr;


/**
 黑名单
 
 @param url 链接
 @param media 媒体位
 @param day 天
 @param isAdd 是否加入
 */
+ (void)blackListUrl:(NSString*)url andMedia:(NSString*)media andTime:(NSInteger)day isAdd:(BOOL)isAdd;

@end
