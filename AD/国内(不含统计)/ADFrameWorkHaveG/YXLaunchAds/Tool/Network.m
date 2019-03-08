//
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "Network.h"

#import "YXLCdes.h"
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
 
    NSData *postDatas = [_initPar dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
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
            NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            finish(YES , json);
            //解析数据
            if (json){
                if ([json isKindOfClass:[NSDictionary class]]){
                    NSDictionary *yjfDeserializedDictionary = (NSDictionary *)json;
                    if([yjfDeserializedDictionary[@"ret"] isEqualToString:@"0"]){
                        NSDictionary *dict = yjfDeserializedDictionary[@"adInfo"];
                        self->_resultDict = dict;
                        if(dict && [dict isKindOfClass:[NSDictionary class]]){//有数据了
                            NSDictionary *adDict = self->_resultDict ;
                            if(adDict && [adDict isKindOfClass:[NSDictionary class]]){
                                // 保存本地
                                //                        [self handleAdInfo:adDict];
                                
                            }else{
                                NSError *error1 = [NSError errorWithDomain:@"返回广告数据为空" code:998 userInfo:nil];
                                [self getDataError:error1];
                            }
                        }else{
                            NSError *error1 = [NSError errorWithDomain:@"返回数据为空" code:999 userInfo:nil];
                            [self getDataError:error1];
                        }
                    }else{
                        NSDictionary *dict = yjfDeserializedDictionary[@"adInfo"];
                        if(dict && [dict isKindOfClass:[NSDictionary class]]){//有数据了
                            NSString *message = dict[@"message"];
                            NSInteger code = [dict[@"code"] integerValue];
                            if(message && ![message isKindOfClass:[NSNull class]]){
                                NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
                                [self getDataError:error];
                            }
                            
                        }else{
                            NSError *error1 = [NSError errorWithDomain:@"status error" code:10030 userInfo:nil];
                            [self getDataError:error1];
                        }
                        
                    }
                }else{
                    NSError *error1 = [NSError errorWithDomain:@"获取数据格式不正确" code:10020 userInfo:nil];
                    [self getDataError:error1];
                    
                }
            }else{
                NSError *error1 = [NSError errorWithDomain:@"数据为空" code:10010 userInfo:nil];
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
        _YXGTMDevLog(@"group notify");
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
        NSString *sid = [NSString stringWithFormat:@"%@_%@_%@",adplaces[@"adPlaceId"],[NetTool getIDFA],timeLocal];
        
        sid = [NetTool URLEncodedString:sid];
        
        NSString *encryptionString = [YXLCdes encrypt:sid];
        
        //    NSString *ip = [Network sharedInstance].ipStr;
        
        NSString *strURL =  [NSString stringWithFormat:@"%@?advId=%@&advtp=%@&sid=%@&pid=%@&mid=%@&os=%@&osv=%@&make=%@&model=%@&isDd=0&ctype=%d&rf=0&adKind=%@",
                             url,
                             adplaces[@"advertiserId"],//advId
                             @"7",                     //advtp
                             encryptionString,         //sid
                             uuid,    //pid
                             [YXLCdes UrlValueEncode:mediaID] ,                 //mid
                             @"IOS",                   //os
                             [NetTool getOS],          //osv
                             //                         ip,                       //ip
                             @"apple",                 //make
                             [NetTool gettelModel],    //model
                             netnumber,
                             adplaces[@"type"]];               //ctype
        
        if (isError) {
            NSString *codes = code;
            NSString *msgs = [NetTool URLEncodedString:msg];
            //            sid = [NetTool URLEncodedString:sid];
            strURL = [strURL stringByAppendingString:[NSString stringWithFormat:@"&code=%@&message=%@",codes,msgs]];
        }
        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Network notifyToServer:nil serverUrl:strURL completionHandler:nil];
        
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
        NSString *netStr = [NSString stringWithFormat:@"%@?advertiserId=%@&type=%@&adPlaceId=%@&appId=%@&mid=%@&os=%@&osv=%@&make=%@&model=%@&deviceType=%@&idfa=%@&cType=%@&uid=%@&brand=%@&width=%@&height=%@&mac=%@&ts=%@&adKind=%@",
                            url,
                            adplaces[@"advertiserId"],//advId
                            @"7",                     //advtp
                            adplaces[@"adPlaceId"],   //adPlaceId
                            [NetTool getPackageName], //appId
                            mediaID,           //mid
                            @"IOS",                   //os
                            [NetTool getOS],          //osv
                            @"apple",                 //make
                            [NetTool gettelModel],    //model
                            @"1",                     //deviceType
                            [NetTool getIDFA],        //idfa
                            @"2",                     //cType
                            uuid,    //uid
                            @"apple",                 //brand
                            @(widthStr),@(heightStr),macId,
                            timeLocal,
                            adplaces[@"type"]];
        
        netStr = [netStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
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
        
        NSString * desuuid = [YXLCdes encrypt:uid];
        
        NSString * urluid = [YXLCdes UrlValueEncode:desuuid];
        
        
        NSString * mid = media;
        
        NSString * desmid = [YXLCdes encrypt:mid];
        
        NSString * urlmid = [YXLCdes UrlValueEncode:desmid];
        
        __block NSInteger dayNow = day;
        
        if (!dayNow) {
            dayNow = 3;
        }
        
        NSString *time = [NSString stringWithFormat:@"%ld",(long)dayNow];
        
        NSString *netStr ;
        if (isAdd) {
            netStr = [NSString stringWithFormat:@"%@?uid=%@&mid=%@&time=%@",
                      url,
                      urluid,          //idfa
                      urlmid,           //mid
                      time
                      ];
        }else{
            netStr = [NSString stringWithFormat:@"%@?uid=%@&mid=%@",
                      url,
                      urluid,          //idfa
                      urlmid           //mid
                      ];
        }
        [Network  notifyToServer:nil serverUrl:netStr completionHandler:nil];
    });
    dispatch_group_notify(group, queue, ^{
        //        NSLog(@"log success");
    });
}
//请求配置接口
+ (void)requestADSourceFromMediaId:(NSString *)mediaId success:(void(^)(NSDictionary *dataDict))success fail:(void(^)(NSError *error))fail{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    int netnumber = [NetTool getNetTyepe];
    
    NSString *dataStr = [NSString stringWithFormat:@"pkg=%@&idfa=%@&ts=%@&os=%@&osv=%@&w=%@&h=%@&model=%@&nt=%@&mac=%@",[NetTool URLEncodedString:[NetTool getPackageName]],[NetTool getIDFA],timeLocal,@"IOS",[NetTool URLEncodedString:[NetTool getOS]],@(c_w),@(c_h),[NetTool URLEncodedString:[NetTool gettelModel]],@(netnumber),[NetTool URLEncodedString:[NetTool getMac]]];
    
    NSString *strURL =  [NSString stringWithFormat:congfigIp,[NetTool URLEncodedString:mediaId], [NetTool getPackageName],@"2",dataStr];
    [request setURL:[NSURL URLWithString:strURL]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:3];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError){
            _YXGTMDevLog(@"#####%@\error",[connectionError debugDescription]);
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            fail(errors);
        }else{
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *dataArr = [dataStr componentsSeparatedByString:@":"];
            if (dataArr.count < 2) {
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                fail(errors);
                return ;
            }
            NSString *dataDe = dataArr[1];
            dataDe = [dataDe stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            dataDe = [dataDe stringByReplacingOccurrencesOfString:@"}" withString:@""];
            NSString * datadecrypt = [YXLCdes decrypt:dataDe];
            NSDictionary *dic = [NetTool dictionaryWithJsonString:datadecrypt];
            success(dic);
        }
        
    }];
}

@end
