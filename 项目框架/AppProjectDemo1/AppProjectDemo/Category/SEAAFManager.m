//
//  SEAAFManager.m
//  SEAAFManager
//
//  Created by MacBook Air on 15/10/21.
//  Copyright (c) 2015年 SEA. All rights reserved.
//

#import "SEAAFManager.h"

@implementation SEAAFManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SEAAFManager *seaAFmanager;
    dispatch_once(&onceToken, ^{
        seaAFmanager = [[self alloc]init];
    });
    return seaAFmanager;
}

//GET请求JSON数据
+ (void)getJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //    * 在http头里面加东西
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
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

//GET请求XML数据
+ (void)getXMLDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id xml))success fail:(void(^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //默认是JSON格式，设置返回的数据类型是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
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

//POST请求JSON数据
+ (void)postJSONDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //    * 在http头里面加东西
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
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

+ (void)postSecurityUrl:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //    * 在http头里面加东西
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
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

//POST请求XML数据
+ (void)postXMLDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id xml))success fail:(void(^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
//POST从工程中上传文件
+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters filePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
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
    //    * 在http头里面加东西
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
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
/**
 *  POST上传图片和数据
 *
 *  @param url     请求头url
 *  @param parameters    参数
 *  @param constructBody 上传图片的二进制流
 *  @param success 上传数据成功
 *  @param fail  上传数据失败
 */

+ (void)postUpLoadFileWithURL:(NSString *)url parameters:(id)parameters Data:(constructingBodyBlock)constructBody success:(void (^)(id responseObject))success fail:(void (^)(NSError * error))fail
{
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //    * 在http头里面加东西
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:constructBody progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
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
@end
