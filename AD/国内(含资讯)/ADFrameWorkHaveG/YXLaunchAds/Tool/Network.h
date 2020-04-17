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
//请求配置接口接口
#define SEVERIN @"http://www.yunqingugm.com:8081"
#define TRACKIN @"http://www.yunqingugm.com:8082"//上报接口
#define NewsSeverin @"https://nr.beilamusi.com"

//#define SEVERIN @"http://119.29.146.103:8073"
//#define TRACKIN @"http://119.29.146.103:8074"
//#define NewsSeverin @"https://content.i-xiaoma.com.cn"

//#define SEVERIN @"http://47.99.227.46:8081"
//#define TRACKIN @"http://47.99.227.46:8082"
//#define NewsSeverin @"https://content.i-xiaoma.com.cn"

#define ADSHOW   TRACKIN @"/log/newMimpr/v3"//展示成果
#define ADCLICK  TRACKIN @"/log/newMclick/v3"//点击
#define ADError  TRACKIN @"/log/newErrorLog/v3"//错误

#define ADRequest SEVERIN @"/yd3/log/v/3"//请求第三方上报

#define inLandAD @"inLandAD"//缓存ID
//请求配置接口接口
#define congfigIp SEVERIN @"/yd3/mediaconfig/v/3"
//S2S接口
#define S2SURL    SEVERIN @"/yd3/mview/v/3"

//添加黑名单
#define USERBLACK       SEVERIN @"/yd3/user/black"
//移除黑名单
#define USERBLACKREMOVE SEVERIN @"/yd3/user/black/remove"

typedef void(^NetworkSucess) (NSDictionary * response);
typedef void(^NetworkFailure) (NSError *error);

@interface Network : NSObject

+ (instancetype)sharedInstance;


@property (nonatomic,copy) NetworkSucess getdataSuccess;

@property (nonatomic,assign) BOOL isInland;

@property (nonatomic,copy) NSString *ipStr;

- (NSString *)deviceWANIPAdress;

- (BOOL)prepareDataAndRequestWithadkeyString:(NSString *)adkey
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


+ (void)notifyToServer:(NSString *) parmams serverUrl:(NSString *)serverUrl completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;

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

//请求配置接口
+ (void)requestADSourceFromMediaId:(NSString *)mediaId success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail;

+ (void)requestADSourceFromMediaId:(NSString *)mediaId adCount:(NSInteger)adCount imgWidth:(CGFloat)width imgHeight:(CGFloat)height success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail;

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//资讯统计
+ (void)newsStatisticsWithType:(NSInteger)eventType NewsID:(NSString *)newsId CatID:(NSString *)catId lengthOfTime:(NSInteger)lengthOfTime;

@end
