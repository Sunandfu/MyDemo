//
//  LHHttpRequest.h
//  CFNetWorkDemo
//
//  Created by 3wchina01 on 16/3/9.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHHTTPRequest,LHRange;
typedef unsigned long long LHProgressLong;
typedef void(^LHHTTPDownloadProgress)(float progress,NSString* urlString);
typedef void(^LHHTTPStartRequest)(void);
typedef void(^LHHTTPCancelRequest)(void);
typedef void(^LHHTTPFinishRequest)(NSData* resultData,NSString* urlString);
typedef void(^LHHTTPErrorRequest)(NSError* error);
typedef void(^LHHTTPReceiveData)(NSData* data,LHHTTPRequest* request);
typedef void(^LHHTTPProgressRequest)(LHProgressLong currentBytes,LHProgressLong alreadyReceiveBytes,LHProgressLong totalBytes);

typedef NS_ENUM(NSInteger,LHHTTPRequestError){
    LHHTTPCreateRequestError = 1001,
    LHHTTPTimeOutError = 1002,
    LHHTTPOpenStreamError = 1003,
    LHHTTPCreateReadStreamError = 1004,
    LHHTTPSetReadStreamClientError = 1005,
    LHHTTPCancelError = 1006,
    LHHTTPUnknownRequstbodyError = 1007
}NS_ENUM_AVAILABLE_IOS(2_0);

@interface LHHTTPRequest : NSObject

/*
 当前请求的url字符串
 */
@property (nonatomic,strong) NSString* urlString;

/*
 当前请求的url
 */
@property (nonatomic,strong) NSURL* url;

/*
 请求的超时时间
 */
@property (nonatomic,assign) NSTimeInterval requestTimeOut;

/*
 请求方式:GET,POST,HEAD
 */
@property (nonatomic,strong) NSString* requestMethod;

/*
 HTTP版本
 */
@property (nonatomic) CFStringRef HTTPVersion;

/*
 运行RunLoop
 */
@property (nonatomic,strong) NSString* runLoop;

/*
 请求头
 */
@property (nonatomic,strong) NSMutableDictionary* requestHeaderField;

/*
 请求体:
    POST请求作为参数
 */
@property (nonatomic,strong) NSMutableDictionary* requestBody;

/*
 请求体:
    二进制数据参数
 */
@property (nonatomic,strong) NSMutableData* requestDataBody;

/*
 响应头
 */
@property (nonatomic,strong) NSMutableDictionary* responseHeader;

/*
 返回数据
 */
@property (nonatomic,strong) NSMutableData* resultData;

/*
 读取流
 */
@property (nonatomic) CFReadStreamRef readStream;

/*
 写入流
 */
@property (nonatomic) CFWriteStreamRef writeStream;

/*
 HTTP请求对象
 */
@property (nonatomic) CFHTTPMessageRef mainHTTPMessage;

/*
 如果请求是https,客户端需要发送的证书,如果为空,则不需要客户端验证证书
 */
@property (nonatomic) SecIdentityRef clientCertificateIdentity;
@property (nonatomic,strong) NSArray* clientCertificates;

/*
 本次读到数据的大小
 */
@property (nonatomic,assign) unsigned long long currentBytesRead;

/*
 已经读出的数据大小
 */
@property (nonatomic,assign) unsigned long long receiveBytesRead;

/*
 全部读取到的数据大小
 */
@property (nonatomic,assign) unsigned long long totalBytesRead;

/*
 用于存储长连接请求数据
 */
@property (nonatomic,strong) NSMutableDictionary* connectionInfo;

/*
 允许返回数据压缩
 */
@property (nonatomic,assign) BOOL allowCompressedResponse;

/*
 允许请求体压缩
 */
@property (nonatomic,assign) BOOL shouldCompressRequestBody;

/*
 允许恢复这个请求:
 可以用于下载数据大的文件
 */
@property (nonatomic,assign) BOOL allowResumRequest;

/*
 文件下载路径
 */
@property (nonatomic,strong) NSString* downloadPath;

@property (nonatomic,strong) NSString* tempPath;

/*
 用于分段下载:
    range 表示一个区域
 */
@property (nonatomic,strong) LHRange* range;

/*
 取消请求标志
 */
@property (nonatomic,assign) BOOL isCanceled;

/*
 开始请求回调
 */
@property (nonatomic,copy) LHHTTPStartRequest requestStart;

/*
 收到数据的回调:数据量比较大时可能调用多次
 */
@property (nonatomic,copy) LHHTTPReceiveData receiveData;

/*
 回调进度,可能返回失败
 */
@property (nonatomic,copy) LHHTTPProgressRequest requestProgress;

/*
 完成请求回调
 */
@property (nonatomic,copy) LHHTTPFinishRequest requestFinish;

/*
 取消请求回调
 */
@property (nonatomic,copy) LHHTTPCancelRequest requestCancel;

/*
 请求错误回调
 */
@property (nonatomic,copy) LHHTTPErrorRequest requestError;

/*
 下载完成的回调
 */
@property (nonatomic,copy) LHHTTPErrorRequest completeRequest;

@property (nonatomic,copy) LHHTTPDownloadProgress downloadProgress;



@property (nonatomic) dispatch_queue_t completeQueue;

@property (nonatomic,strong) LHHTTPRequest* mainRequest;


- (instancetype)initWithUrlString:(NSString*)urlString;

- (instancetype)initWithUrl:(NSURL*)url;

+ (instancetype)requestWithUrlString:(NSString*)urlString;

+ (instancetype)requestWithUrl:(NSURL*)url;

/*
 callback
 */
- (void)requestStart:(LHHTTPStartRequest)requestStart;

- (void)requestReceiveData:(LHHTTPReceiveData)receiveData;

- (void)requestUpdateProgress:(LHHTTPProgressRequest)progress;

- (void)requestFinish:(LHHTTPFinishRequest)requestFinish;

- (void)requestCancel:(LHHTTPCancelRequest)requestCancel;

- (void)requestError:(LHHTTPErrorRequest)requestError;

/*
 开始一个同步请求
 */
- (void)startSynchronous;

/*
 开始一个异步请求
 */

- (void)startAsynchronous;

/*
 取消当前请求
 */

- (void)cancel;

/*
 分段请求
 @param range:指定一个请求区域,一个开始点，一个结束点
 */
- (void)startRequestWithRange:(LHRange*)range;

/*
 阻塞下载数据到指定路径
 */
- (void)downloadToFilePath:(NSString*)filePath;

/*
 非阻塞下载到指定路径
 @param filePath:指定的下载路径
 @param complete:当下载完成后会回调的block,如果下载错误则会带一个error，如果下载成功，
 error = nil;
 */

- (void)downloadToFilePath:(NSString *)filePath complete:(LHHTTPErrorRequest)complete;

/*
 添加请求头
 */
- (void)addRequestHeader:(NSString *)header value:(NSString *)value;


/*
 封装GET,POST请求
 如果只进行简单的GET,POST请求,可以使用LHHTTPRequest封装的方法
 如果希望有更强大的功能,可以自己封装
 */

/*
 GET,POST 公用一个方法
 @param urlString: 请求地址
 @param parameter: 请求体   当请求体!=nil时，请求为POST请求，请求体==nil时，为GET请求
 */
+ (void)requestWith:(NSString*)urlString parameter:(id)parameter success:(LHHTTPFinishRequest)success fail:(LHHTTPErrorRequest)error;

@end

@interface LHRange : NSObject

@property (nonatomic,assign) LHProgressLong startPosition;
@property (nonatomic,assign) LHProgressLong endPosition;

- (instancetype)initWithStart:(LHProgressLong)start withEnd:(LHProgressLong)end;

+ (instancetype)rangeWithStart:(LHProgressLong)start withEnd:(LHProgressLong)end;

@end
