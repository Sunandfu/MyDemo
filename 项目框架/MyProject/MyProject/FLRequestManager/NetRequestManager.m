//
//  NetRequestManager.m
//  HBGuard
//
//  Created by 小富 on 16/3/29.
//  Copyright © 2016年 yunxiang. All rights reserved.
//


#ifdef DEBUG
#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define NSLog(...)
#endif

#import "NetRequestManager.h"
#import "AFNetworkActivityIndicatorManager.h"

#define time self.requestTime>0?self.requestTime:30

static NSMutableArray *tasks;
static NetRequestManager *manager = nil;
@implementation NetRequestManager

+(NSMutableArray *)tasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tasks = [[NSMutableArray alloc] init];
    });
    return tasks;
}

//单例函数
+ (NetRequestManager *)sharedNetworking
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetRequestManager alloc] init];
    });
    return manager;
}

/**
 *  GET请求数据
 *
 *  @param url     请求头url
 *  @param dict    参数
 *  @param success 请求数据成功
 *  @param failed  请求数据失败
 */
+(void)GET:(NSString *)url parame:(NSDictionary *)dict SUccess:(SuccessCallBack)success failed:(FailedCallBack)failed{
    [manager GETWithUrl:url Parameter:dict Success:success Failed:failed];
}
/**
 *  POST上传数据
 *
 *  @param url     请求头url
 *  @param dict    参数
 *  @param success 上传数据成功
 *  @param failed  上传数据失败
 */
+(void)POST:(NSString *)url parame:(NSDictionary *)dict SUccess:(SuccessCallBack)success failed:(FailedCallBack)failed{
    [manager POSTWithUrl:url Parameter:dict Success:success Failed:failed];
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
+ (void)POST:(NSString *)url parame:(NSDictionary *)dict constructingBodyWithBlock:(constructingBodyBlock)constructBody SUccess:(SuccessCallBack)success failed:(FailedCallBack)failed{
    [manager POSTWithUrl:url Parame:dict ConstructingBodyWithBlock:constructBody SUccess:success Failed:failed];
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
    AFHTTPSessionManager *manager = [self getAFManager];
    
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

+(AFHTTPSessionManager *)getAFManager{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.requestSerializer.timeoutInterval=10;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    
    return manager;
    
}
#pragma makr - 开始监听网络连接

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [NetRequestManager sharedNetworking].networkStats=StatusUnknown;
                [NetRequestManager sharedNetworking].name = @"未知网络";
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络");
                [NetRequestManager sharedNetworking].networkStats=StatusNotReachable;
                [NetRequestManager sharedNetworking].name = @"没有网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"2G/3G/4G网络");
                [NetRequestManager sharedNetworking].networkStats=StatusReachableViaWWAN;
                [NetRequestManager sharedNetworking].name = @"2G/3G/4G网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [NetRequestManager sharedNetworking].networkStats=StatusReachableViaWiFi;
                [NetRequestManager sharedNetworking].name = @"WIFI";
                NSLog(@"WIFI");
                break;
        }
    }];
    [mgr startMonitoring];
}
+(NSString *)strUTF8Encoding:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
//GET请求
-(void)GETWithUrl:(NSString *)url Parameter:(NSDictionary *)dict Success:(SuccessCallBack)success Failed:(FailedCallBack)fail{
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //设置加载时间
    _manager.requestSerializer.timeoutInterval = time;
    
    [_manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        fail(operation,error);
    }];
}
//POST请求
-(void)POSTWithUrl:(NSString *)url Parameter:(NSDictionary *)dict Success:(SuccessCallBack)success Failed:(FailedCallBack)fail{
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //设置加载时间
    _manager.requestSerializer.timeoutInterval = time;
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        fail(operation,error);
    }];
}
//POST同时上传图片和数据的请求
-(void)POSTWithUrl:(NSString *)url Parame:(NSDictionary *)dict ConstructingBodyWithBlock:(constructingBodyBlock)constructBody SUccess:(SuccessCallBack)success Failed:(FailedCallBack)fail{
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //设置加载时间
    _manager.requestSerializer.timeoutInterval = time;
    [_manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        constructBody(formData);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        fail(operation,error);
    }];
}
//实例化一个_manager
-(instancetype)init{
    self=[super init];
    if (self) {
        _manager=[[AFHTTPRequestOperationManager alloc]init];
    }
    return self;
}
@end
