//
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "Network.h"
#import "NSString+SFAES.h"
#import "NetTool.h"

@interface Network()
{
    NSString *_initPar;
    NSDictionary *_adDict;
    
    NSMutableData *_receivedData;
    NSDictionary *_resultDict;//data数据
    
    CGFloat _frameWidth;// 宽度
    CGFloat _frameHeight;// 高度
    NSString * _adValue;
    NSThread *getIpthread;
    NSInteger _adCount;
}

@end

@implementation Network

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static Network *seaAFmanager;
    dispatch_once(&onceToken, ^{
        seaAFmanager = [[self alloc]init];
    });
    return seaAFmanager;
} 
- (void)beginRequestfinished:(void (^)(BOOL, id))finish{
 //[_initPar dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]
    NSString *aesStr = [_initPar sf_AESEncryptString];
    NSData *postDatas = [[NSString sf_jsonStringWithJson:@{@"data":aesStr}] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:S2SURL];
    [request setURL:[NSURL URLWithString:url]];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Content-Type application/json" forHTTPHeaderField:@"Content-Type"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval: 3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postDatas];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, id _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            finish(NO , data);
        } else {
            NSDictionary *dataDict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dataDict[@"data"]) {
                NSString *aesData = dataDict[@"data"];
                NSDictionary *dict = [aesData sf_AESDecryptString];
                finish(YES , dict);
            } else {
                NSError *error1 = [NSError errorWithDomain:@"获取数据格式不正确" code:10020 userInfo:nil];
                [self getDataError:error1];
            }
        }
    }];
}

-(void)CrashSQL{
    NSLog(@"CrashSQL");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *strURL =  [NSString stringWithFormat:@"http://ad/getReportList?idfa=%@",[NetTool getIDFA] ];
    [request setURL:[NSURL URLWithString:strURL]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:5];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
-(NSString *)deviceWANIPAdress
{
    return [NetTool deviceWANIPAdress];
}
- (NSString *)ipStr
{
    if (!_ipStr) {
        __block NSString *macId;  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            macId = [[Network sharedInstance] deviceWANIPAdress];
        });
        [NSThread sleepForTimeInterval:1];
        if (macId) {
            _ipStr = macId;
        }
    }
    return _ipStr;
}
-(BOOL) prepareDataAndRequestWithadkeyString:(NSString *)adkey
                                       width:(CGFloat )width
                                      height:(CGFloat )height
                                       macID:(NSString*)macId
                                         uid:(NSString*)uid
                                     adCount:(NSInteger)adCount
{
    
    _adValue = adkey;
    _frameHeight = height ;
    _frameWidth = width ;
    _adCount = adCount;
    _initPar = [NetTool getrequestInfo:_adValue
                                 width:[NSString stringWithFormat:@"%.0f",_frameWidth]
                                height:[NSString stringWithFormat:@"%.0f",_frameHeight]
                                 macID:macId
                                   uid:uid
                               adCount:adCount];
    if ([NetTool connectedToNetwork]) {
//        [self getInterstitialData];//请求数据
        return YES;
    }else{
//        if (_delegate&&[_delegate respondsToSelector:@selector(initPopFrameAdFail:)])
//        {
//            NSError *error = [NSError errorWithDomain:@"could't connect the net" code:404 userInfo:nil];
//            [_delegate initPopFrameAdFail:error];
//        }
        return NO;
    }
    
}

-(void) getDataError:(NSError *)error
{
//    if (_delegate&&[_delegate respondsToSelector:@selector(initPopFrameAdFail:)]) {
//        [_delegate initPopFrameAdFail:error];
//    }
}

#pragma mark -上报给指定服务器
+ (void) notifyToServer:(NSString *) parmams serverUrl:(NSString *)serverUrl completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler
{
    //加密参数
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:serverUrl]];
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
+(void) groupNotifyToSerVer:(NSArray *) arr
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.adwalker.dsp", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    for(int  i = 0;i <arr.count;i++){
        dispatch_group_async(group, queue, ^{
            [Network notifyToServer:nil serverUrl:arr[i] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
    dispatch_queue_t queue = dispatch_queue_create("com.yunxiang.lsad", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        
        if (currentAD == nil) {
            return;
        }
        NSDictionary *adplaces = [currentAD[@"adplaces"] lastObject];
        NSString * uuid = gdtAD[@"uuid"];
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
        
        int netnumber = [NetTool getNetTyepe];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:[NetTool getIDFA]                forKey:@"device_id"];
        [dic setObject:timeLocal                        forKey:@"ts"];
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
            [dic setObject:code                forKey:@"code"];
            [dic setObject:msgs                forKey:@"message"];
        }
        NSString *jsonStr = [NSString sf_jsonStringWithJson:dic];
        NSString *aesStr = [jsonStr sf_AESEncryptString];
        NSString *netStr = [NSString stringWithFormat:@"%@?%@",url,aesStr];
//        netStr = [netStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Network notifyToServer:nil serverUrl:netStr completionHandler:nil];
        
    });
    dispatch_group_notify(group, queue, ^{
        //        NSLog(@"request success up");
    });
}

/**
 请求上报
 
 @param url 请求上报地址
 */
+ (void)upOutSideToServerRequest:(NSString*)url currentAD:(NSDictionary*)currentAD gdtAD:(NSDictionary*)gdtAD mediaID:(NSString*)mediaID
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunxiang.lsadlog", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        
        if (currentAD == nil) {
            return;
        }
        int widthStr = [[NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.width]intValue];
        int heightStr = [[NSString stringWithFormat:@"%.0f",[UIScreen mainScreen].bounds.size.height]intValue];
        NSString *macId = [NetTool getMac];
        
        NSString * uuid = gdtAD[@"uuid"];
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
        
        NSDictionary *adplaces = [currentAD[@"adplaces"] lastObject];
        
//        netStr = [netStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
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
                             @"ts":timeLocal,
                             @"adKind":adplaces[@"type"],
                             @"adCount":gdtAD[@"adCount"],
                             };
        NSString *jsonStr = [NSString sf_jsonStringWithJson:dict];
        NSString *aesStr = [jsonStr sf_AESEncryptString];
        NSString *netStr = [NSString stringWithFormat:@"%@?%@",url,aesStr];
        [Network notifyToServer:nil serverUrl:netStr completionHandler:nil];
    });
    dispatch_group_notify(group, queue, ^{
        //        NSLog(@"log success");
    });
}

+ (void)blackListUrl:(NSString*)url andMedia:(NSString*)media andTime:(NSInteger)day isAdd:(BOOL)isAdd
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.yunxiang.lsadblacklist", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        
        NSString * uid = [NetTool getIDFA];
        
//        NSString * desuuid = [YXLCdes encrypt:uid];
//
//        NSString * urluid = [YXLCdes UrlValueEncode:desuuid];
        
        NSString * mid = media;
        
//        NSString * desmid = [YXLCdes encrypt:mid];
//
//        NSString * urlmid = [YXLCdes UrlValueEncode:desmid];
        
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
        [Network  notifyToServer:nil serverUrl:netStr completionHandler:nil];
    });
    dispatch_group_notify(group, queue, ^{
        //        NSLog(@"log success");
    });
}
//请求配置接口
+ (void)requestADSourceFromMediaId:(NSString *)mediaId success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail{
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    int netnumber = [NetTool getNetTyepe];
    
    NSDictionary *dict = @{
                           @"mid":[NetTool URLEncodedString:mediaId],
                           @"version":@"4.0",
                           @"appid":[NetTool getPackageName],
                           @"idfa":[NetTool getIDFA],
                           @"ts":timeLocal,
                           @"os":@"IOS",
                           @"osv":[NetTool getOS],
                           @"width":@(c_w),
                           @"height":@(c_h),
                           @"model":[NetTool gettelModel],
                           @"brand":@"apple",
                           @"networktype":@(netnumber),
                           @"mac":[NetTool getMac],
                           @"adCount":@(1),
                           @"image":@{@"width": @(c_w),@"height": @(c_h)}
                           };
    NSString *jsonStr = [NSString sf_jsonStringWithJson:dict];
    NSString *aesStr = [jsonStr sf_AESEncryptString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:congfigIp];
    [request setURL:[NSURL URLWithString:url]];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Content-Type application/json" forHTTPHeaderField:@"Content-Type"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval: 3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString sf_jsonStringWithJson:@{@"data":aesStr}] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError){
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            fail(errors);
        }else{
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [NetTool dictionaryWithJsonString:dataStr];
            if (dataDict[@"data"]) {
                NSString *aesData = dataDict[@"data"];
                NSDictionary *dict = [aesData sf_AESDecryptString];
                success(dict);
            } else {
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                fail(errors);
            }
        }
        
    }];
}

//请求配置接口 有参数adCount
+ (void)requestADSourceFromMediaId:(NSString *)mediaId adCount:(NSInteger)adCount imgWidth:(CGFloat)width imgHeight:(CGFloat)height success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail{
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    int netnumber = [NetTool getNetTyepe];
    
    NSDictionary *dict = @{
                           @"mid":[NetTool URLEncodedString:mediaId],
                           @"version":@"4.0",
                           @"appid":[NetTool getPackageName],
                           @"idfa":[NetTool getIDFA],
                           @"ts":timeLocal,
                           @"os":@"IOS",
                           @"osv":[NetTool getOS],
                           @"width":@(c_w),
                           @"height":@(c_h),
                           @"model":[NetTool gettelModel],
                           @"brand":@"apple",
                           @"networktype":@(netnumber),
                           @"mac":[NetTool getMac],
                           @"adCount":@(adCount),
                           @"image":@{@"width": @(width),@"height": @(height)}
                           };
    NSString *jsonStr = [NSString sf_jsonStringWithJson:dict];
    NSString *aesStr = [jsonStr sf_AESEncryptString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString * url = [NSString stringWithFormat:congfigIp];
    [request setURL:[NSURL URLWithString:url]];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"Content-Type application/json" forHTTPHeaderField:@"Content-Type"];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];//缓存策略
    [request setTimeoutInterval: 3];//超时时间
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString sf_jsonStringWithJson:@{@"data":aesStr}] dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError){
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            fail(errors);
        }else{
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dataDict = [NetTool dictionaryWithJsonString:dataStr];
            if (dataDict[@"data"]) {
                NSString *aesData = dataDict[@"data"];
                NSDictionary *dict = [aesData sf_AESDecryptString];
                success(dict);
            } else {
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                fail(errors);
            }
        }
        
    }];
}

@end
