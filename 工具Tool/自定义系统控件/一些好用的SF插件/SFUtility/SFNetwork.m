//
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "SFNetwork.h"

@implementation SFNetwork

+ (NSMutableDictionary *)getDeviceInfoDict{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[SFNetTool getUserAgent]                    forKey:@"ua"];//浏览器UA
    [dic setValue:@"iOS"                                      forKey:@"os"];//操作系统 Android/iOS
    [dic setValue:[SFNetTool getOS]                           forKey:@"osv"];//操作系统版本号
    [dic setValue:SF_iPad?@"1":@"0"                           forKey:@"devicetype"];//0—手机，1—平板，2—PC，3=tv/户外设备
    [dic setValue:@([SFNetTool getNetTyepe])                  forKey:@"connectiontype"];
    [dic setValue:@([SFNetTool getYunYingShang])              forKey:@"carrier"];
    //屏幕方向，0=未知，1=竖屏,2=横屏
    __block NSString *orientationStr = @"0";
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        orientationStr = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?@"2":@"1";
    });
    [dic setValue:orientationStr                              forKey:@"orientation"];
    [dic setValue:@([UIScreen mainScreen].bounds.size.width)  forKey:@"sw"];
    [dic setValue:@([UIScreen mainScreen].bounds.size.height) forKey:@"sh"];
    [dic setValue:@"apple"                                    forKey:@"brand"];
    [dic setValue:[SFNetTool gettelModel]                     forKey:@"model"];
    [dic setValue:[SFNetTool getPPI]                          forKey:@"density"];
    
    [dic setValue:@""                                         forKey:@"imei"];
    [dic setValue:@""                                         forKey:@"oaid"];
    [dic setValue:@""                                         forKey:@"android"];
    [dic setValue:[SFNetTool getIDFA]                         forKey:@"idfa"];
    [dic setValue:[SFNetTool getIDFV]                         forKey:@"idfv"];
    [dic setValue:[SFNetTool getMac]                          forKey:@"mac"];
    [dic setValue:[SFNetTool getBoot]                         forKey:@"boot_mark"];
    [dic setValue:[SFNetTool getUpdate]                       forKey:@"update_mark"];
    [dic setValue:[SFNetTool getLanguage]                     forKey:@"language"];
    [dic setValue:@{@"lon":@"",@"lat":@""}                    forKey:@"geo"];//地理位置
    [dic setValue:[SFNetTool getAppVersion]                   forKey:@"appver"];
    [dic setValue:[SFNetTool getPackageName]                  forKey:@"appid"];
    [dic setValue:[SFNetTool getAppName]                      forKey:@"appname"];
    return dic;
}
+ (NSMutableDictionary *)getAppInfoDict{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KeyChannel] forKey:@"channel"];
    [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:KeyAppId]   forKey:@"id"];
    [dic setValue:[SFNetTool getAppName]                                           forKey:@"name"];
    [dic setValue:[SFNetTool getPackageName]                                       forKey:@"bundle"];
    [dic setValue:[SFNetTool getAppVersion]                                        forKey:@"version"];
    return dic;
}
#pragma mark -上报给指定服务器
+ (void)notifyToServerUrl:(NSString *)serverUrl{
    //加密参数
    if (![[SFNetTool gettelModel] isEqualToString:@"iPhone Simulator"]) {
        [[SFNetTool defaultManager].thred executeTask:^{
            NSURLSession *session = [NSURLSession sharedSession];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverUrl]];
            request.HTTPMethod = @"GET";
            request.allHTTPHeaderFields = @{@"Content-Type":@"application/json",@"apiversion":KeySDKVersion};
            request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            request.timeoutInterval = 5;
            NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            }];
            [task resume];
        }];
    }
}
/**
 s2s上报
 @param arr s2s上报
 */
+(void)groupNotifyToSerVer:(NSArray *)arr{
    if (arr.count==0) {
        return;
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunqing.s2sdsp", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        for (NSString *noticeUrl in arr) {
            [SFNetwork notifyToServerUrl:noticeUrl];
        }
    });
    dispatch_group_notify(group, queue, ^{
        SFLog(@"group notify");
    });
}
//上报
+ (void)notifyToServerUrl:(NSString *)url Model:(SFConfigModelAdplace *)model SourceModel:(SFConfigModelAd_Sources *)sourceModel{
    [self notifyToServerUrl:url Model:model SourceModel:sourceModel Ecpm:nil Time:nil];
}
+ (void)notifyToServerUrl:(NSString *)url Model:(SFConfigModelAdplace *)model SourceModel:(SFConfigModelAd_Sources *)sourceModel Ecpm:(NSNumber *)ecpm{
    [self notifyToServerUrl:url Model:model SourceModel:sourceModel Ecpm:ecpm Time:nil];
}
+ (void)notifyToServerUrl:(NSString *)url Model:(SFConfigModelAdplace *)model SourceModel:(SFConfigModelAd_Sources *)sourceModel Ecpm:(NSNumber *)ecpm Time:(NSNumber *)time{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[SFNetTool getUniqueID]                                         forKey:@"id"];
    [dic setObject:KeySDKVersion                                                   forKey:@"version"];
    [dic setValue:model.place_id                                                   forKey:@"place_id"];
    [dic setValue:model.group_id                                                   forKey:@"group_id"];
    [dic setValue:@(sourceModel.adv_id)                                            forKey:@"adv_id"];
    [dic setValue:sourceModel.tagid                                                forKey:@"tagid"];
    [dic setValue:[self getDeviceInfoDict]                                         forKey:@"device"];
    if (ecpm) {
        [dic setValue:ecpm                                                         forKey:@"price"];
    }
    if (time) {
        [dic setValue:time                                                         forKey:@"time"];
    }
    NSString *aesStr = [[NSString sf_jsonStringWithJson:dic] sf_AESEncryptString];
    NSString *urlStr = [NSString stringWithFormat:@"%@?e=%@&place_id=%@",url,aesStr,model.place_id];
//    SFLog(@"urlStr = %@",SF_DEBUG_MODE_TYPE ? urlStr : SF_DEBUG_MODE_MESSAGE);
    [SFNetwork notifyToServerUrl:urlStr];
}
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail{
    if (url==nil) {
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *newUrl = [SFNetTool urlStrWithDict:parameters UrlStr:url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrl.sf_stringByEncodingUserInputQuery]];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json",@"User-Agent":[SFNetTool getUserAgent],@"version":KeySDKVersion};
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
    if (url==nil) {
        return;
    }
    NSURLSession *session=[NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url.sf_stringByEncodingUserInputQuery]];
    request.HTTPMethod = @"POST";
    if (parameters) {
        if (!parameters[@"param"]) {
            NSString *paramStr = [NSString sf_jsonStringWithJson:@{@"param":[[NSString sf_jsonStringWithJson:parameters] sf_AESEncryptString]}];
            request.HTTPBody = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            request.HTTPBody = [[NSString sf_jsonStringWithJson:parameters] dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json",@"User-Agent":[SFNetTool getUserAgent],@"version":KeySDKVersion};
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
/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(!data) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
}

//该接口用于插件请求广告位配置
+ (void)requestADConfigFromMediaId:(NSString *)mediaId
                           success:(void(^)(NSDictionary *dataDict))success
                              fail:(void(^)(NSError *error))fail
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:mediaId ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    success(dictionary);
//    SFLog(@"数据请求成功 response:\n%@",SF_DEBUG_MODE_TYPE ? [self jsonToString:dictionary] : SF_DEBUG_MODE_MESSAGE);
//    return;
    
    NSMutableDictionary *deviceInfo = [self getDeviceInfoDict];
    NSMutableDictionary *appInfo = [self getAppInfoDict];
    NSDictionary *parameters = @{@"id":[SFNetTool setUniqueID],@"version":KeySDKVersion,@"place_id":mediaId?:@"",@"app":appInfo,@"device":deviceInfo};
    //    NSJSONSerialization 组json字符串
    NSString *aesStr = [[NSString sf_jsonStringWithJson:parameters] sf_AESEncryptString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@",APICongfig];
    [request setURL:[NSURL URLWithString:url.sf_stringByEncodingUserInputQuery]];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[SFNetTool getUserAgent] forHTTPHeaderField:@"User-Agent"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval:3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[aesStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && success) {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [dataStr sf_AESDecryptString];
            SFLog(@"%@",SF_DEBUG_MODE_TYPE ? SFStringFormat(@"\n URL = %@ \n parameters: = %@ \n AESEncrypt = %@ \n responseObject = %@",url,parameters,aesStr,dataDict) : SF_DEBUG_MODE_MESSAGE);
            if ([SFStringFormat(@"%@",dataDict[@"code"]) isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dataDict);
                });
            } else if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *errors = [NSError errorWithDomain:Error401 code:401 userInfo:nil];
                    fail(errors);
                });
            }
        } else if (error && fail) {
            SFLog(@"%@",SF_DEBUG_MODE_TYPE ? SFStringFormat(@"error = %@",error) : SF_DEBUG_MODE_MESSAGE);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *errors = [NSError errorWithDomain:Error401 code:401 userInfo:nil];
                fail(errors);
            });
        }
    }];
    [task resume];
}
//该接口用于客户端请求直投广告
+ (void)requestS2SADFromSource:(SFConfigModelAd_Sources *)sourceModel
                        AdCount:(NSString *)adcount
                        success:(void(^)(NSDictionary *dataDict))success
                           fail:(void(^)(NSError *error))fail
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"s2sresponse" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    success(dictionary);
//    SFLog(@"数据请求成功 response:\n%@",SF_DEBUG_MODE_TYPE ? [self jsonToString:dictionary] : SF_DEBUG_MODE_MESSAGE);
//    return;
    
    NSMutableDictionary *deviceInfo = [self getDeviceInfoDict];
    NSMutableDictionary *appInfo = [self getAppInfoDict];
    NSDictionary *parameters = @{@"id":[SFNetTool setUniqueID],@"version":KeySDKVersion,@"imp":@{@"adcount":adcount?:@"1",@"place_id":sourceModel.tagid,@"tagid":sourceModel.tagid,@"bidfloor":@(sourceModel.bidfloor)},@"app":appInfo,@"device":deviceInfo,@"timeout":@"3"};
    //    NSJSONSerialization 组json字符串
    NSString *aesStr = [[NSString sf_jsonStringWithJson:parameters] sf_AESEncryptString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@",APICongfig];
    [request setURL:[NSURL URLWithString:url.sf_stringByEncodingUserInputQuery]];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[SFNetTool getUserAgent] forHTTPHeaderField:@"User-Agent"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval:3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[aesStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && success) {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [dataStr sf_AESDecryptString];
            SFLog(@"%@",SF_DEBUG_MODE_TYPE ? SFStringFormat(@"\n URL = %@ \n parameters: = %@ \n AESEncrypt = %@ \n responseObject = %@",url,parameters,aesStr,dataDict) : SF_DEBUG_MODE_MESSAGE);
            if ([SFStringFormat(@"%@",dataDict[@"code"]) isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(dataDict);
                });
            } else if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *errors = [NSError errorWithDomain:Error401 code:401 userInfo:nil];
                    fail(errors);
                });
            }
        } else if (error && fail) {
            SFLog(@"%@",SF_DEBUG_MODE_TYPE ? SFStringFormat(@"error = %@",error) : SF_DEBUG_MODE_MESSAGE);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *errors = [NSError errorWithDomain:Error401 code:401 userInfo:nil];
                fail(errors);
            });
        }
    }];
    [task resume];
}

@end
