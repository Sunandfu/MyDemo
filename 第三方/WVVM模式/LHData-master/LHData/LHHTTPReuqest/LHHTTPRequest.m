//
//  LHHttpRequest.m
//  CFNetWorkDemo
//
//  Created by 3wchina01 on 16/3/9.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHHTTPRequest.h"
#import <CFNetwork/CFNetwork.h>
#import <UIKit/UIKit.h>

#define run_in_queue(...)  dispatch_async(self.completeQueue?:\
                                    dispatch_get_main_queue(), ^{\
                                            __VA_ARGS__;\
                                                    })

static const CFOptionFlags kNetworkEvents =  kCFStreamEventOpenCompleted|kCFStreamEventHasBytesAvailable| kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred;

static unsigned int LHConnectionNumber;

@interface LHHTTPRequest();

@property (nonatomic,assign) BOOL isComplet;

@property (nonatomic,strong) NSTimer* timer;

@property (nonatomic,assign) BOOL canJudgeTimeOut;

@property (nonatomic,strong) NSOperationQueue* queue;

@end

@implementation LHHTTPRequest

#pragma mark- 读流

static void readStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo)
{
    LHHTTPRequest* request = (__bridge LHHTTPRequest *)(clientCallBackInfo);
    [request handleNetworkEvent:type];
    
}

- (void)handleNetworkEvent:(CFStreamEventType)type
{
    switch (type) {
        case kCFStreamEventOpenCompleted:
        {
            [self.timer setFireDate:[NSDate distantFuture]];
            CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)self.timer, (__bridge CFStringRef)self.runLoop);
        }
            break;
            
        case kCFStreamEventHasBytesAvailable:
            [self handleEventHasBytesAvailable];
            break;
            
        case kCFStreamEventEndEncountered:
            [self handleEventEndEncountered];
            break;
            
        case kCFStreamEventErrorOccurred:
            [self handleEventErrorOccurred];
            break;
            
        default:
            break;
    }
}

- (void)handleEventHasBytesAvailable
{
    [self readResponseHeader];
    if (!CFReadStreamHasBytesAvailable((CFReadStreamRef)[self readStream])) {
        return;
    }
    NSString* contentLength = [self.responseHeader objectForKey:@"Content-Length"];
    unsigned long long length = 0;
    if (contentLength.length>0) {
        length = strtoull([contentLength UTF8String], NULL, 0);
    }
    self.totalBytesRead = length;
    long long bufferSize = 16384;
    if (length > 262144) {
        bufferSize = 262144;
    } else if (length > 65536) {
        bufferSize = 65536;
    }
    UInt8 buffer[bufferSize];
    CFIndex bytesRead = CFReadStreamRead(self.readStream, buffer, bufferSize);
    if (bytesRead>0) {
        self.currentBytesRead = bytesRead;
        self.receiveBytesRead = self.receiveBytesRead + bytesRead;
        NSData* receiveData = [NSData dataWithBytes:buffer length:bytesRead];
        if (self.totalBytesRead != 0) {
            if (self.requestProgress) {
                self.requestProgress(self.currentBytesRead,self.receiveBytesRead,self.totalBytesRead);
            }
            if (self.downloadProgress) {
                self.downloadProgress(self.receiveBytesRead*1.0/self.totalBytesRead,self.urlString);
            }
        }else {
            if (self.requestProgress) {
                self.requestProgress(self.currentBytesRead,self.receiveBytesRead,self.receiveBytesRead+self.currentBytesRead);
            }
            if (self.downloadProgress) {
                self.downloadProgress(self.receiveBytesRead*1.0/(self.receiveBytesRead+self.currentBytesRead),self.urlString);
            }
        }
        if (self.receiveData) {
            run_in_queue(self.receiveData(receiveData,self));
        }
        [self.resultData appendBytes:buffer length:bytesRead];
        
        
        //如果指定了下载路径,则数据流会写入指定路径,相应的block还是会回调
        if (self.downloadPath.length>0) {
            CFWriteStreamOpen(self.writeStream);
            CFWriteStreamWrite(self.writeStream, buffer, bytesRead);
        }
    }
}

- (void)handleEventEndEncountered
{
    if (self.totalBytesRead == 0) {
        self.totalBytesRead = self.receiveBytesRead;
    }
    if (self.responseHeader.count == 0) {
        [self readResponseHeader];
    }
    if (self.requestFinish) {
        run_in_queue(self.requestFinish(self.resultData,self.urlString));
    }
    if (self.requestProgress) {
        run_in_queue(self.requestProgress(self.receiveBytesRead,self.receiveBytesRead,self.receiveBytesRead));
    }
    if (self.downloadProgress) {
        self.downloadProgress(1.0,self.urlString);
    }
    if (self.completeRequest) {
        run_in_queue(self.completeRequest(nil));
    }
    [self cancelRequest];
}

- (void)handleEventErrorOccurred
{
    [self.timer setFireDate:[NSDate distantFuture]];
    CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)self.timer, (__bridge CFStringRef)self.runLoop);
    NSError* error = CFBridgingRelease(CFReadStreamCopyError(self.readStream));
    if (self.requestError) {
        run_in_queue(self.requestError(error));
    }
    if (self.completeRequest) {
        run_in_queue(self.completeRequest(error));
    }
    [self cancelRequest];
}

- (void)readResponseHeader
{
    CFHTTPMessageRef message = (CFHTTPMessageRef)CFReadStreamCopyProperty(self.readStream, kCFStreamPropertyHTTPResponseHeader);
    if (!message) {
        return;
    }
    if (!CFHTTPMessageIsHeaderComplete(message)) {
        CFRelease(message);
        return;
    }
    self.responseHeader = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary * _Nonnull)(CFHTTPMessageCopyAllHeaderFields(message))];
    CFRelease(message);
}

#pragma mark- 懒加载

- (NSMutableDictionary*)requestHeaderField
{
    if (!_requestHeaderField) {
        _requestHeaderField = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _requestHeaderField;
}

- (NSMutableData*)requestDataBody
{
    if (!_requestDataBody) {
        _requestDataBody = [NSMutableData data];
    }
    return _requestDataBody;
}

- (NSMutableDictionary*)requestBody
{
    if (!_requestBody) {
        _requestBody = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _requestBody;
}

- (NSMutableData*)resultData
{
    if (!_resultData) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}

- (NSMutableDictionary*)connectionInfo
{
    if (!_connectionInfo) {
        _connectionInfo = [NSMutableDictionary dictionary];
    }
    return _connectionInfo;
}

- (NSOperationQueue*)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setSuspended:NO];
    }
    return _queue;
}

- (CFWriteStreamRef)writeStream
{
    if (!_writeStream) {
        if (self.downloadPath.length>0) {
            _writeStream = CFWriteStreamCreateWithFile(kCFAllocatorDefault,(__bridge CFURLRef)[NSURL fileURLWithPath:self.downloadPath]);
            CFWriteStreamSetProperty(_writeStream, kCFStreamPropertyAppendToFile, kCFBooleanTrue);
        }else
            return nil;
        
    }
    return _writeStream;
}

- (NSTimer*)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.requestTimeOut target:self selector:@selector(checkRequestStart) userInfo:nil repeats:YES];
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), (__bridge CFRunLoopTimerRef)_timer, (__bridge CFStringRef)self.runLoop);
    }
    return _timer;
}

#pragma mark- 请求超时

- (void)checkRequestStart
{
    if (self.canJudgeTimeOut) {
        [self.timer setFireDate:[NSDate distantFuture]];
        if (self.requestError) {
            self.requestError([NSError errorWithDomain:@"请求超时" code:LHHTTPTimeOutError userInfo:@{@"urlString":self.urlString}]);
        }
        [self cancelRequest];
    }
    self.canJudgeTimeOut = YES;
}

#pragma mark- 构建请求对象

- (instancetype)initWithUrlString:(NSString*)urlString
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.url = [NSURL URLWithString:urlStr];
        self.requestMethod = @"GET";
        self.requestTimeOut = 30.0f;
        self.HTTPVersion = kCFHTTPVersion1_1;
        self.runLoop = NSDefaultRunLoopMode;
        self.allowCompressedResponse = YES;
    }
    return self;
}

- (instancetype)initWithUrl:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.urlString = [url absoluteString];
        self.url = url;
        self.requestMethod = @"GET";
        self.requestTimeOut = 30.0f;
        self.HTTPVersion = kCFHTTPVersion1_1;
        self.runLoop = NSDefaultRunLoopMode;
        self.allowCompressedResponse = YES;
    }
    return self;
}

+ (instancetype)requestWithUrlString:(NSString*)urlString
{
    LHHTTPRequest* request = [[self alloc] initWithUrlString:urlString];
    return request;
}

+ (instancetype)requestWithUrl:(NSURL*)url
{
    LHHTTPRequest* request = [[self alloc] initWithUrl:url];
    return request;
}

#pragma mark- 开始请求

- (void)startSynchronous
{
    self.canJudgeTimeOut = NO;
    [self go];
    while (!self.isComplet) {
        [[NSRunLoop currentRunLoop] runMode:self.runLoop beforeDate:[NSDate distantFuture]];
    }
}
- (void)startAsynchronous
{
    __block LHHTTPRequest* request = self;
    [self.queue addOperationWithBlock:^{
        [request startSynchronous];
    }];
}

- (void)startRequestWithRange:(LHRange *)range
{
    self.range = range;
}

#pragma mark- 阻塞下载
- (void)downloadToFilePath:(NSString *)filePath
{
    self.downloadPath = filePath;
//    self.allowResumRequest = YES;
    [self startSynchronous];
}

#pragma mark- 非阻塞下载
- (void)downloadToFilePath:(NSString *)filePath complete:(LHHTTPErrorRequest)complete
{
    self.downloadPath = filePath;
    self.completeRequest = [complete copy];
    [self startAsynchronous];
}

#pragma mark- 封装的网络请求
+ (void)requestWith:(NSString*)urlString parameter:(id)parameter success:(LHHTTPFinishRequest)success fail:(LHHTTPErrorRequest)error
{
    LHHTTPRequest* request = [LHHTTPRequest requestWithUrlString:urlString];
    if ([parameter isKindOfClass:[NSDictionary class]]) {
        request.requestBody = [NSMutableDictionary dictionaryWithDictionary:parameter];
    }else if ([parameter isKindOfClass:[NSData class]]) {
        request.requestDataBody = [NSMutableData dataWithData:parameter];
    }else if ([parameter isKindOfClass:[NSString class]]) {
        request.requestDataBody = [NSMutableData dataWithData:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    }else if (parameter){
        error([NSError errorWithDomain:@"不能确定的请求体" code:LHHTTPUnknownRequstbodyError userInfo:@{@"urlString":urlString}]);
        return;
    }
    request.requestFinish = [success copy];
    request.requestError = [error copy];
    [request startAsynchronous];
}

#pragma mark- 建立长连接

- (void)createConnectionInfo
{
    if (self.connectionInfo.count>0) {
        [self.connectionInfo removeAllObjects];
    }
    LHConnectionNumber++;
    [self.connectionInfo setObject:[NSNumber numberWithInt:LHConnectionNumber] forKey:@"id"];
    if ([self.url host]) {
        [self.connectionInfo setObject:[self.url host] forKey:@"host"];
    }
    if ([self.url port]) {
        [self.connectionInfo setObject:[NSNumber numberWithInt:[[self.url port] intValue]] forKey:@"port"];
    }
    if ([self.url scheme]) {
        [self.connectionInfo setObject:[self.url scheme] forKey:@"scheme"];
    }
    [[self connectionInfo] setObject:(NSInputStream*)self.readStream forKey:@"stream"];
     CFReadStreamSetProperty(self.readStream,  kCFStreamPropertyHTTPAttemptPersistentConnection, kCFBooleanTrue);
     CFReadStreamSetProperty(self.readStream, CFSTR("LHStreamID"), (__bridge CFTypeRef)([self.connectionInfo objectForKey:@"id"]));
}

#pragma mark- 取消请求

- (void)cancel
{
    self.isComplet = YES;
    CFReadStreamSetClient(self.readStream, kCFStreamEventNone, NULL, NULL);
    CFReadStreamUnscheduleFromRunLoop(self.readStream, CFRunLoopGetCurrent(), (__bridge CFStringRef _Nullable)self.runLoop);
    CFReadStreamClose(self.readStream);
    if (self.requestCancel) {
        self.requestCancel();
    }
}

- (void)cancelRequest
{
    self.isComplet = YES;
    CFReadStreamSetClient(self.readStream, kCFStreamEventNone, NULL, NULL);
    CFReadStreamUnscheduleFromRunLoop(self.readStream, CFRunLoopGetCurrent(), (__bridge CFStringRef _Nullable)self.runLoop);
    CFReadStreamClose(self.readStream);
    if (_writeStream) {
        CFWriteStreamClose(self.writeStream);
        CFRelease(self.writeStream);
    }
    CFRelease(self.readStream);
}

#pragma mark- 设置请求头

- (void)setRequestHeader
{
    if (![self.requestHeaderField objectForKey:@"User-Agent"]) {
        NSString* userAgent = [LHHTTPRequest defaultUserAgentString];
        if (userAgent.length>0) {
            [self addRequestHeader:@"User-Agent" value:userAgent];
        }
    }
    if (self.allowCompressedResponse) {
        [self addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    }
    if (self.shouldCompressRequestBody) {
        [self addRequestHeader:@"Content-Encoding" value:@"gzip"];
    }
    if (self.range.startPosition>0.0) {
        if (self.range.endPosition == 0) {
            [self addRequestHeader:@"Range" value:[NSString stringWithFormat:@"bytes=%llu-",self.range.startPosition]];
        }else {
            [self addRequestHeader:@"Range" value:[NSString stringWithFormat:@"bytes=%llu-%llu",self.range.startPosition,self.range.endPosition]];
        }
    }
    if (self.allowResumRequest) {
        self.receiveBytesRead = [self resumRequestSize];
        [self addRequestHeader:@"Range" value:[NSString stringWithFormat:@"bytes=%llu-",[self resumRequestSize]]];
    }
    if (self.requestBody.count>0) {
        self.requestDataBody = (NSMutableData*)[NSJSONSerialization dataWithJSONObject:self.requestBody options:NSJSONWritingPrettyPrinted error:nil];
        [self addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu",(unsigned long)self.requestDataBody.length]];
    }else if (self.requestDataBody.length>0)
        [self addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu",(unsigned long)self.requestDataBody.length]];
}

- (void)go
{
    if (self.isCanceled) {
        if (self.requestCancel) {
            run_in_queue(self.requestCancel());
        }
        if (self.completeRequest) {
            self.completeRequest([NSError errorWithDomain:@"下载取消" code:LHHTTPCancelError userInfo:@{@"urlString":self.urlString,@"filePath":self.downloadPath}]);
        }
        self.isComplet = YES;
        return;
    }
    if (self.mainHTTPMessage) {
        CFRelease(self.mainHTTPMessage);
    }
    if (self.requestBody.count > 0||self.requestDataBody.length>0) {
        self.requestMethod = @"POST";
    }
    self.mainHTTPMessage = CFHTTPMessageCreateRequest(kCFAllocatorDefault, (__bridge CFStringRef)self.requestMethod, (__bridge CFURLRef)self.url, self.HTTPVersion);
    if (!self.mainHTTPMessage) {
        if (self.requestError) {
            run_in_queue(self.requestError([NSError errorWithDomain:@"创建请求失败" code:LHHTTPCreateRequestError userInfo:@{@"url":self.urlString}]));
        }
        if (self.completeRequest) {
            run_in_queue(self.completeRequest([NSError errorWithDomain:@"创建请求失败" code:LHHTTPCreateRequestError userInfo:@{@"url":self.urlString,@"filePath":self.downloadPath}]));
        }
        self.isComplet = YES;
        return;
    }
    
    [self setRequestHeader];
    for (NSString* header in self.requestHeaderField.allKeys) {
        CFHTTPMessageSetHeaderFieldValue(self.mainHTTPMessage, (__bridge CFStringRef _Nonnull)(header), (__bridge CFStringRef _Nullable)(self.requestHeaderField[header]));
    }
    BOOL issuccess = [self createReadStream];
    if (!issuccess) {
        self.isComplet = YES;
        [self cancelRequest];
        return;
    }
    
    if ([[[self.url scheme] lowercaseString] isEqualToString:@"https"]) {
        NSMutableDictionary *sslProperties = [NSMutableDictionary dictionaryWithCapacity:1];
        if (!self.clientCertificateIdentity) {
            [sslProperties setObject:(NSNumber *)kCFBooleanFalse forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
        }else {
            NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[self.clientCertificates count]+1];
            [certificates addObject:(id)self.clientCertificateIdentity];
            for (id cert in self.clientCertificates) {
                [certificates addObject:cert];
            }
            [sslProperties setObject:certificates forKey:(NSString *)kCFStreamSSLCertificates];
        }
        CFReadStreamSetProperty(self.readStream, kCFStreamPropertySSLSettings, (__bridge CFTypeRef)(sslProperties));
    }
    [self createConnectionInfo];
    self.mainRequest = self;
    CFStreamClientContext ctxt = {0, (__bridge void *)(self.mainRequest), NULL, NULL, NULL};
    if (CFReadStreamSetClient(self.readStream, kNetworkEvents, readStreamClientCallBack, &ctxt)) {
        CFReadStreamScheduleWithRunLoop(self.readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        if (CFReadStreamOpen(self.readStream)) {
            self.timer.fireDate = [NSDate distantPast];
            if (self.requestStart) {
                run_in_queue(self.requestStart());
            }
        }else {
            [self cancelRequest];
            if (self.requestError) {
                run_in_queue(self.requestError([NSError errorWithDomain:@"打开流失败" code:LHHTTPOpenStreamError userInfo:@{@"urlSting":self.urlString}]));
            }
            if (self.completeRequest) {
                run_in_queue(self.completeRequest([NSError errorWithDomain:@"打开流失败" code:LHHTTPOpenStreamError userInfo:@{@"urlSting":self.urlString,@"filePath":self.downloadPath}]));
            }
        }
        
    }else {
        [self cancelRequest];
        if (self.requestError) {
            run_in_queue(self.requestError([NSError errorWithDomain:@"设置回调失败" code:LHHTTPSetReadStreamClientError userInfo:@{@"url":self.urlString}]));
        }
        if (self.completeRequest) {
            run_in_queue(self.completeRequest([NSError errorWithDomain:@"设置回调失败" code:LHHTTPOpenStreamError userInfo:@{@"urlSting":self.urlString,@"filePath":self.downloadPath}]));
        }
        self.isComplet = YES;
        return;
    }
}

- (BOOL)createReadStream
{
    NSInputStream* stream;
    if (self.requestBody.count>0) {
        NSError* error;
        self.requestDataBody = (NSMutableData*)[NSJSONSerialization dataWithJSONObject:self.requestBody options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            if (self.requestError) {
                run_in_queue(self.requestError(error));
            }
            return NO;
        }
        stream = [NSInputStream inputStreamWithData:self.requestDataBody];
    }else if (self.requestDataBody.length>0) {
        stream = [NSInputStream inputStreamWithData:self.requestDataBody];
    }
    if (stream) {
        self.readStream = CFReadStreamCreateForStreamedHTTPRequest(kCFAllocatorDefault, self.mainHTTPMessage, (__bridge CFReadStreamRef _Nonnull)(stream));
    }else {
        self.readStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, self.mainHTTPMessage);
    }
    if (!self.readStream) {
        
        if (self.requestError) {
            run_in_queue(self.requestError([NSError errorWithDomain:@"创建读取流失败" code:LHHTTPCreateReadStreamError userInfo:@{@"urlString":self.urlString}]));
            return NO;
        }
    }
    return YES;
}

- (unsigned long long)resumRequestSize
{
    unsigned long long resumSize = 0;
    NSFileManager* manager = [NSFileManager defaultManager];
    if (self.downloadPath.length>0&&[manager fileExistsAtPath:self.downloadPath]) {
        NSError *err = nil;
        resumSize = [[manager attributesOfItemAtPath:self.downloadPath error:&err] fileSize];
        if (err) {
            NSLog(@"%@",err);
        }
    }
    return resumSize;
}

+ (NSString *)defaultUserAgentString
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    }
    
    NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
    appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
    if (!appName) {
        return nil;
    }
    
    NSString *appVersion = nil;
    NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (marketingVersionNumber && developmentVersionNumber) {
        if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
            appVersion = marketingVersionNumber;
        } else {
            appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
        }
    } else {
        appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
    }
    
    
    NSString *deviceName;
    NSString *OSName;
    NSString *OSVersion;
    
    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
#if TARGET_OS_IPHONE
    UIDevice *device = [UIDevice currentDevice];
    deviceName = [device model];
    OSName = [device systemName];
    OSVersion = [device systemVersion];
    
#else
    deviceName = @"Macintosh";
    OSName = @"Mac OS X";
    OSErr err;
    SInt32 versionMajor, versionMinor, versionBugFix;
    err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
    if (err != noErr) return nil;
    err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
    if (err != noErr) return nil;
    err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
    if (err != noErr) return nil;
    OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
    
#endif
    return [NSString stringWithFormat:@"%@ %@ (%@; %@ %@; %@)", appName, appVersion, deviceName, OSName, OSVersion, locale];
}

#pragma mark- 添加请求头

- (void)addRequestHeader:(NSString *)header value:(NSString *)value
{
    [self.requestHeaderField setValue:value forKey:header];
}

#pragma mark- 设置回调

- (void)requestStart:(LHHTTPStartRequest)requestStart
{
    self.requestStart = [requestStart copy];
}

- (void)requestReceiveData:(LHHTTPReceiveData)receiveData
{
    self.receiveData = [receiveData copy];
}

- (void)requestUpdateProgress:(LHHTTPProgressRequest)progress
{
    self.requestProgress = [progress copy];
}

- (void)requestFinish:(LHHTTPFinishRequest)requestFinish
{
    self.requestFinish = [requestFinish copy];
}

- (void)requestCancel:(LHHTTPCancelRequest)requestCancel
{
    self.requestCancel = [requestCancel copy];
}

- (void)requestError:(LHHTTPErrorRequest)requestError
{
    self.requestError = [requestError copy];
}

@end

@implementation LHRange

- (instancetype)initWithStart:(LHProgressLong)start withEnd:(LHProgressLong)end
{
    self = [super init];
    if (self) {
        self.startPosition = start;
        self.endPosition = end;
    }
    return self;
}

+ (instancetype)rangeWithStart:(LHProgressLong)start withEnd:(LHProgressLong)end
{
    LHRange* range = [[LHRange alloc] initWithStart:start withEnd:end];
    return range;
}

@end
