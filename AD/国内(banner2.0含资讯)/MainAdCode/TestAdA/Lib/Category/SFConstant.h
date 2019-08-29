//
//  SFConstant.h
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求配置接口接口
#define SEVERIN @"http://www.yunqingugm.com:8081"//请求接口
#define TRACKIN @"http://www.yunqingugm.com:8082"//上报接口
#define TASK_SEVERIN @"https://nr.beilamusi.com"//资讯、任务、活动接口

//#define SEVERIN @"http://119.29.146.103:8073"
//#define TRACKIN @"http://119.29.146.103:8074"
//#define TASK_SEVERIN @"https://content.i-xiaoma.com.cn"

//#define SEVERIN @"http://47.99.227.46:8081"
//#define TRACKIN @"http://47.99.227.46:8082"
//#define TASK_SEVERIN @"https://content.i-xiaoma.com.cn"

#pragma mark - NSUserDefaultsKey
//媒体位ID
extern NSString * const KeyMediaId;
//内容位ID
extern NSString * const KeyLocationId;
//城市代码
extern NSString * const KeyADSDKCityCode;
//APP 语言key
extern NSString * const KeyAppleLanguages;
//活动 渠道ID
extern NSString * const KeyChannel;
//活动 userID
extern NSString * const KeyVuid;

#pragma mark - 接口类
//展示成果
extern NSString * const APIShow;
//曝光上报
extern NSString * const APIExposured;
//点击上报
extern NSString * const APIClick;
//错误上报
extern NSString * const APIError;
//请求第三方上报
extern NSString * const APIRequest;
//请求配置接口接口
extern NSString * const APICongfig;
//S2S接口
extern NSString * const APIMview;
//添加黑名单
extern NSString * const APIAddBlack;
//移除黑名单
extern NSString * const APIRemoveBlack;
//版本号
extern NSString * const SDKVersionKey;
