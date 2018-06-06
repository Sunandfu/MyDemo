//
//  SEAAFManager.h
//  SEAAFManager
//
//  Created by MacBook Air on 15/10/21.
//  Copyright (c) 2015年 SEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//传输图片二进制流
typedef void (^constructingBodyBlock)(id<AFMultipartFormData>formData);

@interface SEAAFManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - GET

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//GET请求XML数据
+ (void)getXMLDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id xml))success fail:(void(^)(NSError * error))fail;

#pragma mark - POST

//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

+ (void)postSecurityUrl:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;

//POST请求XML数据
+ (void)postXMLDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id xml))success fail:(void(^)(NSError * error))fail;

//POST从工程中上传文件
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;

//POST上传二进制文件 单个文件
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;


/**
 *  POST上传图片和数据POST上传二进制文件 多个文件
 *
 *  @param url     请求头url
 *  @param parameters    参数
 *  @param constructBody 上传图片的二进制流
 *  @param success 上传数据成功
 *  @param fail  上传数据失败
 */
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(constructingBodyBlock)constructBody success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail;

//下载文件
+ (void)sessionDownLoadWithURL:(NSString *)url success:(void(^)(id responseObject))success fail:(void(^)(NSError * error))fail;

@end
