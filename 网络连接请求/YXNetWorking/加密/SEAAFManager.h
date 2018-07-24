//
//  SEAAFManager.h
//  SEAAFManager
//
//  Created by MacBook Air on 15/10/21.
//  Copyright (c) 2015年 SEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSUInteger {
    YXNetUnknown = 0,
    YXNetNotReachable,
    YXNetReachableViaWiFi,
    YXNetReachableViaWWAN
} YXNetState;

//传输图片二进制流
typedef void (^constructingBodyBlock)(id<AFMultipartFormData>formData);

typedef void( ^ DownloadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
typedef void( ^ ResponseSuccess)(id response);
typedef void( ^ ResponseFail)(NSError *error);
/**
 *  方便管理请求任务。执行取消，暂停，继续等任务.
 *  - (void)cancel，取消任务
 *  - (void)suspend，暂停任务
 *  - (void)resume，继续任务
 */
typedef NSURLSessionTask URLSessionTask;

@interface SEAAFManager : NSObject

@property (nonatomic,assign)YXNetState yxNetState;
+ (instancetype)sharedInstance;
//开始网络检测
+ (void)startMonitoring;

#pragma mark - GET

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

#pragma mark - POST

//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;
 

//POST从工程中上传文件
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;

/*
 POST上传二进制文件 单个文件

 @param url 请求头url
 @param parameters 参数
 @param data 上传文件的二进制流
 @param name 别名
 @param fileName 文件名
 @param mimeType 文件类型
 @param success 上传数据成功
 @param fail 上传数据失败
 */
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;


/**
 *  POST上传图片和数据POST上传二进制文件 多个文件
 *
 *  @param url     请求头url
 *  @param dict    参数
 *  @param constructBody 上传图片的二进制流
 *  @param success 上传数据成功
 *  @param failed  上传数据失败
 */
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(constructingBodyBlock)constructBody success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;

//下载文件
+ (void)sessionDownLoadWithURL:(NSString *)url success:(void(^)(id responseObject))success fail:(void(^)(NSError * error))fail;
/**
 *  下载文件方法
 *
 *  @param url           下载地址
 *  @param saveToPath    文件保存的路径,如果不传则保存到Documents目录下，以文件本来的名字命名
 *  @param progressBlock 下载进度回调
 *  @param success       下载完成
 *  @param fail          失败
 *  @return 返回请求任务对象，便于操作
 */
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                         saveToPath:(NSString *)saveToPath
                           progress:(DownloadProgress)progressBlock
                            success:(ResponseSuccess)success
                            failure:(ResponseFail)fail;

@end
