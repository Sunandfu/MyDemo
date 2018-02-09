//
//  NetRequestManager.m
//  HBGuard
//
//  Created by 小富 on 16/3/29.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "NetRequestManager.h"
static NetRequestManager *manager=nil;
@implementation NetRequestManager
//单例函数
+(NetRequestManager *)manager{
    @synchronized(self) {
        if (!manager) {
            manager=[[NetRequestManager alloc]init];
        }
    }
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
//实例化一个_manager
-(instancetype)init{
    self=[super init];
    if (self) {
        _manager=[[AFHTTPRequestOperationManager alloc]init];
    }
    return self;
}
//GET请求
-(void)GETWithUrl:(NSString *)url Parameter:(NSDictionary *)dict Success:(SuccessCallBack)success Failed:(FailedCallBack)fail{
    _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //设置加载时间
    _manager.requestSerializer.timeoutInterval = self.requestTime;
    
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
    _manager.requestSerializer.timeoutInterval = self.requestTime;
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
    _manager.requestSerializer.timeoutInterval = self.requestTime;
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
@end
