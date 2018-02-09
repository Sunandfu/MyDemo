//
//  LHFileCache.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/25.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHFileCache.h"
#define CachePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"com.sancai.lhfilecache"]

#define LOCK dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER)
#define UNLOCK dispatch_semaphore_signal(_lock)

typedef void(^readCallback)(NSData* data);

static const CFOptionFlags kFileOperationEvents =  kCFStreamEventHasBytesAvailable| kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred;


static dispatch_semaphore_t _lock;

static void LHCreateLock()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lock = dispatch_semaphore_create(1);
        if (![[NSFileManager defaultManager] fileExistsAtPath:CachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:CachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
}

@implementation LHFileCache{
    @package
    readCallback readBlock;
    CFReadStreamRef ref;
    LHFileCache* _cache;
}

static void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo)
{
    LHFileCache* context = (__bridge LHFileCache *)(clientCallBackInfo);
    switch (type) {
        case kCFStreamEventHasBytesAvailable:
        {
            
            long long bufferSize = context.bufferSize;
            UInt8 buffer[bufferSize];
            CFIndex bytesRead = CFReadStreamRead(context->ref, buffer, bufferSize);
            NSData* data = [NSData dataWithBytes:buffer length:bytesRead];
            if (context->readBlock) {
                context->readBlock(data);
            }
        }
            break;
            
        case kCFStreamEventEndEncountered:
        {
            CFReadStreamSetClient(context->ref, kCFStreamEventNone, NULL, NULL);
            CFReadStreamUnscheduleFromRunLoop(context->ref, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamClose(context->ref);
            CFRelease(context->ref);
            
        }
            break;
            
        case kCFStreamEventErrorOccurred:
        {
            CFReadStreamSetClient(context->ref, kCFStreamEventNone, NULL, NULL);
            CFReadStreamUnscheduleFromRunLoop(context->ref, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamClose(context->ref);
            CFRelease(context->ref);
        }
            
            break;
            
        default:
            break;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        LHCreateLock();
        _bufferSize = 1024;
        _cacheShouldAppend = NO;
    }
    return self;
}

- (BOOL)setData:(NSData*)data forKey:(NSString*)key
{
    if (![key isKindOfClass:[NSString class]]||key.length == 0) return NO;
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    LOCK;
    NSString* filePath = [CachePath stringByAppendingPathComponent:key];
    if (!_cacheShouldAppend) {
        BOOL isSuccess = [data writeToFile:filePath atomically:NO];
        UNLOCK;
        return isSuccess;
    }else {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            BOOL isSuccess = [self appendData:data forFilePath:filePath];
            UNLOCK;
            return isSuccess;
        }else {
            BOOL isSuccess = [data writeToFile:filePath atomically:NO];
            UNLOCK;
            return isSuccess;
        }
    }
}

- (NSData*)dataForKey:(NSString*)key
{
    if (![key isKindOfClass:[NSString class]]||key.length == 0) return nil;
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    LOCK;
    NSString* filePath = [CachePath stringByAppendingPathComponent:key];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        UNLOCK;
        return nil;
    }else {
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        UNLOCK;
        return data;
    }
}

- (void)readLargerDataForKey:(NSString*)key readCallback:(void(^)(NSData* data))callback
{
    if (![key isKindOfClass:[NSString class]]||key.length == 0) return;
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    LOCK;
    ref = CFReadStreamCreateWithFile(kCFAllocatorDefault, (__bridge CFURLRef)[NSURL fileURLWithPath:[CachePath stringByAppendingPathComponent:key]]);
    readBlock = [callback copy];
    _cache = self;
    CFStreamClientContext context = {0,(__bridge void *)(_cache),NULL,NULL,NULL};
    CFReadStreamSetClient(ref, kFileOperationEvents, ReadStreamClientCallBack, &context);
    CFReadStreamScheduleWithRunLoop(ref, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    CFReadStreamOpen(ref);
    UNLOCK;
}

- (void)removeDataForKey:(NSString*)key
{
    if (![key isKindOfClass:[NSString class]]||key.length == 0) return;
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    LOCK;
    NSString* filePath = [CachePath stringByAppendingPathComponent:key];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    UNLOCK;
}

- (BOOL)appendData:(NSData*)data forFilePath:(NSString*)filePath
{
    NSFileHandle* handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    [handle seekToEndOfFile];
    [handle writeData:data];
    [handle closeFile];
    return YES;
}

- (void)removeAllData
{
    LOCK;
    NSArray* fileArray = [[NSFileManager defaultManager] subpathsAtPath:CachePath];
    for (NSString* filePath in fileArray) {
        [[NSFileManager defaultManager] removeItemAtPath:[CachePath stringByAppendingPathComponent:filePath] error:nil];
    }
    UNLOCK;
}

- (NSUInteger)length
{
    NSArray* fileArray = [[NSFileManager defaultManager] subpathsAtPath:CachePath];
    if (fileArray.count == 0) {
        return 0;
    }
    unsigned long long length = 0;
    for (NSString* filePath in fileArray) {
        length += [[[NSFileManager defaultManager] attributesOfItemAtPath:[CachePath stringByAppendingPathComponent:filePath] error:nil] fileSize];
    }
    return length;
}

- (void)dealloc
{
    if (ref) {
        CFRelease(ref);
        _cache = nil;
    }
}

@end
