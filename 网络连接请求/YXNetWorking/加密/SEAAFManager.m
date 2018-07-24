//
//  SEAAFManager.m
//  SEAAFManager
//
//  Created by MacBook Air on 15/10/21.
//  Copyright (c) 2015年 SEA. All rights reserved.
//

#import "SEAAFManager.h"
#import <CommonCrypto/CommonDigest.h>

static NSMutableArray *tasks;

@implementation SEAAFManager

+(NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SEAAFManager *seaAFmanager;
    dispatch_once(&onceToken, ^{
        seaAFmanager = [[self alloc]init];
    });
    return seaAFmanager;
}

//检测网络状态
+ (void)startMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail{
    if (parameters==nil) {
        parameters = @{};
    }
    NSLog(@"发送请求url=%@,params=%@",url,parameters);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    //1  编码字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *base64EncodeStr = [self encode:jsonStr];
    NSDictionary *params;
    if (token) {
        NSString *timeStampStr = [self currentTimeStr];
        NSString *sha1Str = [NSString stringWithFormat:@"%@,%@,%@,%@",token,account,timeStampStr,base64EncodeStr];
        NSString *sha1EncodeStr = [self sha1:sha1Str];
        params = @{@"data":base64EncodeStr,@"signature":sha1EncodeStr,@"timestamp":timeStampStr};
    } else {
        params = @{@"data":base64EncodeStr};
    }
    
    /** 在http头里面加东西 */
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *currentMacStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastConnectMacStr"];
    [request setValue:currentMacStr forHTTPHeaderField:@"User-Mac"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            }
            if ([responseObject[@"auth_code"] isEqualToString:@"0"]) {
                [self loginSignOut];
            }
            if (responseObject && success) {
                success(responseObject);
            }
        } else {
            if (error && fail) {
                [YXLoading showMiddleStatus:@"网络错误,请检查网络连接!"];
                fail(error);
            }
        }
    }];
    [task resume];
}


//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail{
    if (parameters==nil) {
        parameters = @{};
    }
    NSLog(@"发送请求url=%@,原始params=%@",url,parameters);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    //1  编码字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *base64EncodeStr = [self encode:jsonStr];
    NSDictionary *params;
    if (token) {
        NSString *timeStampStr = [self currentTimeStr];
        NSString *sha1Str = [self sortStringArrayWithArray:[NSArray arrayWithObjects:token,account,timeStampStr,base64EncodeStr, nil]];
        NSString *sha1EncodeStr = [self sha1:sha1Str];
        params = @{@"data":base64EncodeStr,@"signature":sha1EncodeStr,@"timestamp":timeStampStr};
    } else {
        params = @{@"data":base64EncodeStr};
    }
    
    /** 在http头里面加东西 */
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *currentMacStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastConnectMacStr"];
    [request setValue:currentMacStr forHTTPHeaderField:@"User-Mac"];
    NSLog(@"发送请求url=%@,上传params=%@",url,params);
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if ([responseObject isKindOfClass:[NSData class]]) {
                responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            }
            if ([responseObject[@"auth_code"] isEqualToString:@"0"]) {
                [self loginSignOut];
            }
            if (responseObject && success) {
                [self logSuccessJson:responseObject];
                success(responseObject);
            }
        } else {
            if (error && fail) {
                [YXLoading showMiddleStatus:@"网络错误,请检查网络连接!"];
                fail(error);
            }
        }
    }];
    [task resume];
}
+ (void)logSuccessJson:(NSDictionary *)responseObject{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //2. 去掉所有空格和换行符
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"需要model的数据：\n%@",jsonStr);
}
//POST从工程中上传文件
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:name fileName:fileName mimeType:mimeType error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (responseObject && success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error && fail) {
            fail(error);
        }
    }];
    
}
//POST上传二进制文件
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    /** 在http头里面加东西 */
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[YXTool getCustomPassword] forHTTPHeaderField:@"Xtk"];
    [manager.requestSerializer setValue:[YXDataSave selectUser].uid forHTTPHeaderField:@"Ukey"];
    NSString *currentMacStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastConnectMacStr"];
    [manager.requestSerializer setValue:currentMacStr?currentMacStr:@"" forHTTPHeaderField:@"User-Mac"];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (data) {
            //开始拼接数据
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([responseObject[@"auth_code"] isEqualToString:@"0"]) {
            [self loginSignOut];
        }
        if (responseObject && success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error && fail) {
            fail(error);
        }
    }];
}
+ (void)loginSignOut{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"dengluchaoshi", @"登录超时") message:NSLocalizedString(@"qingchongxindenglu", @"请重新登录") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"queding", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YXNotificationLogoutSuccess object:nil];
    }]];
    [[YXTool getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}
/**
 *  POST上传图片和数据
 *
 *  @param url     请求头url
 *  @param dict    参数
 *  @param constructBody 上传图片的二进制流
 *  @param success 上传数据成功
 *  @param failed  上传数据失败
 */

+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(constructingBodyBlock)constructBody success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    /** 在http头里面加东西 */
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSString *currentMacStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastConnectMacStr"];
    [manager.requestSerializer setValue:currentMacStr?currentMacStr:@"" forHTTPHeaderField:@"User-Mac"];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:constructBody progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        if ([responseObject[@"auth_code"] isEqualToString:@"0"]) {
            [self loginSignOut];
        }
        if (responseObject && success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (error && fail) {
            fail(error);
        }
    }];
}
//下载文件
+ (void)sessionDownLoadWithURL:(NSString *)url success:(void(^)(id responseObject))success fail:(void(^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    NSURL * URL = [NSURL URLWithString:url];
    NSURLRequest * request = [NSURLRequest requestWithURL:URL];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //下载文件保存到缓存路径
        NSURL * downLoad = [[NSFileManager defaultManager]URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downLoad URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (filePath && success) {
            success(filePath);
        }
        if (error && fail) {
            fail(error);
        }
        
    }];

    [task resume];//挂起进入下载
}
//下载文件
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                         saveToPath:(NSString *)saveToPath
                           progress:(DownloadProgress)progressBlock
                            success:(ResponseSuccess)success
                            failure:(ResponseFail)fail{
    NSLog(@"请求地址----%@\n    ",url);
    if (url==nil) {
        return nil;
    }
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager * manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    
    URLSessionTask *sessionTask = nil;
    
    sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (!saveToPath) {
            
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSLog(@"默认路径--%@",downloadURL);
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
            
        }else{
            return [NSURL fileURLWithPath:saveToPath];
            
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载文件成功");
        
        [[self tasks] removeObject:sessionTask];
        
        if (error == nil) {
            if (success) {
                success([filePath path]);//返回完整路径
            }
            
        } else {
            if (fail) {
                fail(error);
            }
        }
    }];
    //开始启动任务
    [sessionTask resume];
    if (sessionTask) {
        [[self tasks] addObject:sessionTask];
    }
    return sessionTask;
}
//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
//sha1编码
+ (NSString *)sha1:(NSString *)inputString{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
}
//base64编码
+ (NSString *)encode:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //2. 去掉所有空格和换行符
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
//数组升序排列
+ (NSString *)sortStringArrayWithArray:(NSArray *)charArray{
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
    NSArray *myary = [charArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    NSString *ageSha1Str = @"";
    for (NSString *tmpStr in myary) {
        ageSha1Str = [ageSha1Str stringByAppendingString:tmpStr];
    }
    return ageSha1Str;
}

@end
