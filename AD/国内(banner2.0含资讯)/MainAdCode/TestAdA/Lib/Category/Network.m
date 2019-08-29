//
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "Network.h"

@implementation Network

+ (NSString *)getrequestInfo:(NSString *)key
                       width:(CGFloat)width
                      height:(CGFloat)height
                     adCount:(NSInteger )adCount
{
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    // 1.2网络状态
    NSString *orientationStr;
    __block UIInterfaceOrientation  orientation ;
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
    });
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        orientationStr = @"2";
        //横屏
    }else{
        orientationStr = @"1";
        //竖屏
    }
    //
    int netNumber = [NetTool getNetTyepe];//网络标示
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString * adCountStr = [NSString stringWithFormat:@"%ld",(long)adCount];
    [dic setValue:adCountStr                             forKey:@"adCount"];
    [dic setValue:@"4.0"                                 forKey:@"version"] ;
    [dic setValue:@"2"                                   forKey:@"c_type"] ;
    [dic setValue:key                                    forKey:@"mid"];
    [dic setValue:[NetTool getDeviceUUID]                forKey:@"uid"];
    [dic setValue:@"zh"                                  forKey:@"language"] ;
    [dic setValue:@"IOS"                                 forKey:@"os"];
    [dic setValue:[NetTool getMac]                       forKey:@"mac"];
    [dic setValue:[NetTool getOS]                        forKey:@"osv"];
    [dic setValue:@(netNumber)                           forKey:@"networktype"];
    [dic setValue:@"apple"                               forKey:@"make"];
    [dic setValue:@"apple"                               forKey:@"brand"];
    [dic setValue:[NetTool gettelModel]                  forKey:@"model"];
    [dic setValue:@"1"                                   forKey:@"devicetype"];//1 手机  2平板
    [dic setValue:[NetTool getIDFA]                      forKey:@"idfa"];
    [dic setValue:[NetTool getPPI]                       forKey:@"dpi"];
    [dic setValue:[NSString stringWithFormat:@"%.f",c_w] forKey:@"width"];
    [dic setValue:[NSString stringWithFormat:@"%.f",c_h] forKey:@"height"];
    [dic setValue:[NetTool getPackageName]               forKey:@"appid"];
    [dic setValue:[NetTool getAppName]                   forKey:@"appname"];
    [dic setValue:orientationStr                         forKey:@"orientation"];
    [dic setValue:[NetTool getCityCode]                  forKey:@"cityCode"];
    [dic setValue:[NetTool getTimeLocal]                 forKey:@"ts"];//时间戳
    [dic setValue:@([NetTool getYunYingShang])           forKey:@"operator"];
    [dic setValue:@{@"width": @(width),@"height": @(height)}   forKey:@"image"];
    //    NSJSONSerialization 组json字符串
    NSString *jsonStr = [NSString sf_jsonStringWithJson:dic];
    return jsonStr;
}
+ (void)beginRequestWithADkey:(NSString *)adkey
                        width:(CGFloat )width
                       height:(CGFloat )height
                      adCount:(NSInteger)adCount finished:(void (^)(BOOL, id))finish{
    NSString *paramStr = [self getrequestInfo:adkey width:width height:height adCount:adCount];
    NSString *aesStr = [paramStr request_Encrypt];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@", APICongfig];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"4.4" forHTTPHeaderField:@"apiversion"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval: 3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString sf_jsonStringWithJson:@{@"data":aesStr}] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, id _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finish(NO , connectionError);
            });
        } else {
            NSDictionary *dataDict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dataDict[@"data"]) {
                NSString *aesData = dataDict[@"data"];
                NSDictionary *dict = [aesData request_Decrypt];
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish(YES , dict);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish(NO , connectionError);
                });
            }
        }
    }];
}

#pragma mark -上报给指定服务器
+ (void)notifyToServerUrl:(NSString *)serverUrl completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler{
    //加密参数
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"]) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[serverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setTimeoutInterval:5];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            handler(response,data,connectionError);
        }];
    }
}

/**
 s2s上报
 
 @param arr s2s上报
 */
+(void)groupNotifyToSerVer:(NSArray *)arr{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunqing.s2sdsp", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    for(int  i = 0;i <arr.count;i++){
        dispatch_group_async(group, queue, ^{
            [Network notifyToServerUrl:arr[i] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if(connectionError){
                    NSLog(@"#####%@\error",[connectionError debugDescription]);
                }else{
                    NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if (json) {
                        NSLog(@"%@",json);
                    }
                }
            }];
        });
    }
    dispatch_group_notify(group, queue, ^{
        NSLog(@"group notify");
    });
}

/**
 展示点击上报
 
 @param url 展示点击上报
 */
+ (void)upOutSideToServer:(NSString*)url isError:(BOOL)isError code:(NSString*)code msg:(NSString*)msg currentAD:(NSDictionary*)currentAD gdtAD:(NSDictionary*)gdtAD mediaID:(NSString*)mediaID
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunqing.zsdj", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        if (currentAD == nil) {
            return;
        }
        NSDictionary *adplaces = [currentAD[@"adplaces"] lastObject];
        NSString * uuid = gdtAD[@"uuid"];
        int netnumber = [NetTool getNetTyepe];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:[NetTool getIDFA]                forKey:@"device_id"];
        [dic setObject:[NetTool getTimeLocal]           forKey:@"ts"];
        [dic setObject:adplaces[@"adPlaceId"]           forKey:@"adPlaceId"];
        [dic setObject:adplaces[@"advertiserId"]        forKey:@"advertiserId"];
        [dic setObject:@"7"                             forKey:@"advtp"];
        [dic setObject:uuid                             forKey:@"pid"];
        [dic setObject:mediaID                          forKey:@"mid"];
        [dic setObject:@"IOS"                           forKey:@"os"];
        [dic setObject:[NetTool getOS]                  forKey:@"osv"];
        [dic setObject:@"apple"                         forKey:@"make"];
        [dic setObject:[NetTool gettelModel]            forKey:@"model"];
        [dic setObject:@"0"                             forKey:@"is_dd"];
        [dic setObject:@(netnumber)                     forKey:@"ctype"];
        [dic setObject:@"0"                             forKey:@"rf"];
        [dic setObject:adplaces[@"type"]                forKey:@"adKind"];
        
        if (isError) {
            NSString *msgs = [NetTool URLEncodedString:msg];
            [dic setObject:code?code:@"20240000"        forKey:@"code"];
            [dic setObject:msgs?msgs:@"AD error"        forKey:@"message"];
        }
        NSString *jsonStr = [NSString sf_jsonStringWithJson:dic];
        NSString *aesStr = [jsonStr sf_AESEncryptString];
        NSString *netStr = [NSString stringWithFormat:@"%@?%@",url,aesStr];
        [Network notifyToServerUrl:netStr completionHandler:nil];
    });
    dispatch_group_notify(group, queue, ^{
//        NSLog(@"request success up");
    });
}

/**
 请求上报
 
 @param url 请求上报地址
 */
+ (void)upOutSideToServerRequest:(NSString*)url currentAD:(NSDictionary*)currentAD gdtAD:(NSDictionary*)gdtAD mediaID:(NSString*)mediaID{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunqing.qqsb", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        if (currentAD == nil) {
            return;
        }
        int widthStr = [[NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.width]intValue];
        int heightStr = [[NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.height]intValue];
        NSString *macId = [NetTool getMac];
        NSString * uuid = [NSString stringWithFormat:@"%@",gdtAD[@"uuid"]];
        NSDictionary *adplaces = [currentAD[@"adplaces"] lastObject];
        NSDictionary *dict = @{
                             @"advertiserId":adplaces[@"advertiserId"],
                             @"adPlaceId":adplaces[@"adPlaceId"],
                             @"appId":[NetTool getPackageName],
                             @"type":@"7",
                             @"uid":uuid,
                             @"mid":mediaID,
                             @"os":@"IOS",
                             @"osv":[NetTool getOS],
                             @"make":@"apple",
                             @"brand":@"apple",
                             @"model":[NetTool gettelModel],
                             @"deviceType":@"1",//1手机。2平板。
                             @"idfa":[NetTool getIDFA],
                             @"cType":@"2",
                             @"width":@(widthStr),
                             @"height":@(heightStr),
                             @"mac":macId,
                             @"ts":[NetTool getTimeLocal],
                             @"adKind":adplaces[@"type"],
                             @"adCount":gdtAD[@"adCount"],
                             };
        NSString *jsonStr = [NSString sf_jsonStringWithJson:dict];
        NSString *aesStr = [jsonStr sf_AESEncryptString];
        NSString *netStr = [NSString stringWithFormat:@"%@?%@",url,aesStr];
        [Network notifyToServerUrl:netStr completionHandler:nil];
    });
    dispatch_group_notify(group, queue, ^{
//        NSLog(@"log success");
    });
}

+ (void)blackListUrl:(NSString*)url andMedia:(NSString*)media andTime:(NSInteger)day isAdd:(BOOL)isAdd{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunxiang.blacklist", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        NSString * uid = [NetTool getIDFA];
        NSString * mid = media;
        __block NSInteger dayNow = day;
        if (!dayNow) {
            dayNow = 3;
        }
        NSString *time = [NSString stringWithFormat:@"%ld",(long)dayNow];
        NSDictionary *dict;
        if (isAdd) {
            dict = @{
                    @"uid":uid,
                    @"mid":mid,
                    @"time":time,
                    };
        }else{
            dict = @{
                    @"uid":uid,
                    @"mid":mid,
                    };
        }
        NSString *jsonStr = [NSString sf_jsonStringWithJson:dict];
        NSString *aesStr = [jsonStr sf_AESEncryptString];
        NSString *netStr = [NSString stringWithFormat:@"%@?%@",url,aesStr];
        [Network  notifyToServerUrl:netStr completionHandler:nil];
    });
    dispatch_group_notify(group, queue, ^{
        //        NSLog(@"log success");
    });
}

+ (void)newsStatisticsWithType:(NSInteger)eventType NewsID:(NSString *)newsId CatID:(NSString *)catId lengthOfTime:(NSInteger)lengthOfTime{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunxiang.lsadblacklist", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        NSString *mediaId = [[NSUserDefaults standardUserDefaults] objectForKey:KeyMediaId];
        NSString *mLocationId = [[NSUserDefaults standardUserDefaults] objectForKey:KeyLocationId];
        NSString *lengthtime = [NSString stringWithFormat:@"%@",(eventType==4?@(lengthOfTime):@"0")];
        NSString *url = [NSString stringWithFormat:@"%@/social/eventStatistic?userId=%@&mLocationId=%@&catId=%@&eventType=%@&newsId=%@&stayTime=%@",TASK_SEVERIN,mediaId,mLocationId,catId,@(eventType),newsId?newsId:@"",lengthtime];
        NSDictionary *parametDict = @{
                                      @"deviceType":@"1",
                                      @"osType":@"2",
                                      @"osVersion":[NetTool getOS],
                                      @"vendor":@"apple",
                                      @"model":[NetTool gettelModel],
                                      @"imei":@"",
                                      @"androidId":@"",
                                      @"idfa":[NetTool getIDFA],
                                      @"ipv4":[NetTool getDeviceIPAdress],
                                      @"connectionType":@([NetTool getNetTyepe]),
                                      @"operateType":@([NetTool getYunYingShang])
                                      };
        [Network postJSONDataWithURL:url parameters:parametDict success:nil fail:nil];
    });
    dispatch_group_notify(group, queue, ^{
        //        NSLog(@"log success");
    });
}

+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail{
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"GET";
    if (parameters) {
        request.HTTPBody = [[NSString sf_jsonStringWithJson:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    }
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error && fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(error);
            });
        } else if (data && success) {
            if ([data isKindOfClass:[NSData class]]) {
                data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data);
            });
        }
    }];
    [task resume];
}
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail{
    NSURLSession *session=[NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"POST";
    if (parameters) {
        request.HTTPBody = [[NSString sf_jsonStringWithJson:parameters] dataUsingEncoding:NSUTF8StringEncoding];
    }
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    request.cachePolicy =  NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error && fail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(error);
            });
        } else if (data && success) {
            if ([data isKindOfClass:[NSData class]]) {
                data = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data);
            });
        }
    }];
    [task resume];
}

//请求配置接口
+ (void)requestADSourceFromMediaId:(NSString *)mediaId success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail{
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    int netnumber = [NetTool getNetTyepe];
    
    NSDictionary *dict = @{
                           @"mid":[NetTool URLEncodedString:mediaId],
                           @"version":@"4.0",
                           @"make":@"apple",
                           @"appid":[NetTool getPackageName],
                           @"idfa":[NetTool getIDFA],
                           @"ts":[NetTool getTimeLocal],
                           @"os":@"IOS",
                           @"osv":[NetTool getOS],
                           @"width":@(c_w),
                           @"height":@(c_h),
                           @"model":[NetTool gettelModel],
                           @"brand":@"apple",
                           @"networktype":@(netnumber),
                           @"mac":[NetTool getMac],
                           @"cityCode":[NetTool getCityCode],
                           @"adCount":@(1),
                           @"image":@{@"width": @(c_w),@"height": @(c_h)}
                           };
    NSString *jsonStr = [NSString sf_jsonStringWithJson:dict];
    NSString *aesStr = [jsonStr request_Encrypt];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@", APICongfig];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"4.4" forHTTPHeaderField:@"apiversion"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval: 3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString sf_jsonStringWithJson:@{@"data":aesStr}] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError && fail){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *errors = [NSError errorWithDomain:@"请求广告配置失败" code:404 userInfo:nil];
                fail(errors);
            });
        }else if (data && success && fail) {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [NetTool dictionaryWithJsonString:dataStr];
            if (dataDict[@"data"]) {
                NSString *aesData = dataDict[@"data"];
                NSDictionary *dict = [aesData request_Decrypt];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dict);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *errors = [NSError errorWithDomain:@"请求广告配置为空" code:400 userInfo:nil];
                    fail(errors);
                });
            }
        }
        
    }];
}

//请求配置接口 有参数adCount
+ (void)requestADSourceFromMediaId:(NSString *)mediaId adCount:(NSInteger)adCount imgWidth:(CGFloat)width imgHeight:(CGFloat)height success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail{
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    int netnumber = [NetTool getNetTyepe];
    NSDictionary *dic = @{
                           @"mid":mediaId,
                           @"version":@"4.0",
                           @"make":@"apple",
                           @"appid":[NetTool getPackageName],
                           @"idfa":[NetTool getIDFA],
                           @"ts":[NetTool getTimeLocal],
                           @"os":@"IOS",
                           @"osv":[NetTool getOS],
                           @"width":@(c_w),
                           @"height":@(c_h),
                           @"model":[NetTool gettelModel],
                           @"brand":@"apple",
                           @"networktype":@(netnumber),
                           @"mac":[NetTool getMac],
                           @"cityCode":[NetTool getCityCode],
                           @"adCount":adCount?@(adCount):@"",
                           @"image":@{@"width": @(width),@"height": @(height)}
                           };
    NSString *jsonStr = [NSString sf_jsonStringWithJson:dic];
    NSString *aesStr = [jsonStr request_Encrypt];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:@"%@", APICongfig];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"4.4" forHTTPHeaderField:@"apiversion"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval: 3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString sf_jsonStringWithJson:@{@"data":aesStr}] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError && fail){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *errors = [NSError errorWithDomain:@"请求广告配置失败" code:404 userInfo:nil];
                fail(errors);
            });
        }else if (data && success && fail) {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [NetTool dictionaryWithJsonString:dataStr];
            if (dataDict[@"data"]) {
                NSString *aesData = dataDict[@"data"];
                NSDictionary *dict = [aesData request_Decrypt];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dict);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *errors = [NSError errorWithDomain:@"请求广告配置为空" code:400 userInfo:nil];
                    fail(errors);
                });
            }
        }
        
    }];
}

@end
