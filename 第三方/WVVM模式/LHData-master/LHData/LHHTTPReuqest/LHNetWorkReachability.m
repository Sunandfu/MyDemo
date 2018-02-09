//
//  LHNetWorkReachability.m
//  CFNetWorkDemo
//
//  Created by 3wchina01 on 16/3/1.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHNetWorkReachability.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSString *const LHReachabilityDidChangedNotification = @"LHReachabilityDidChangedNotification";

#define Main_Queue(callback) dispatch_async\
(dispatch_get_main_queue(), ^{\
(callback);\
})


@interface LHNetWorkReachability()

@property (nonatomic,assign) SCNetworkReachabilityRef reachabilityRef;

@property (nonatomic,strong) dispatch_queue_t reachabilityQueue;

@end
@implementation LHNetWorkReachability

+ (instancetype)instanceManager
{
    static LHNetWorkReachability* reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [self manager];
    });
    return reachability;
}

+ (instancetype)manager
{
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    return [[self alloc] initWithAddress:&address];
}

+ (instancetype)managerForDomain:(NSString*)domain
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    LHNetWorkReachability* reachability = [[self alloc] init];
    reachability.reachabilityRef =  CFRetain(ref);
    CFRelease(ref);
    reachability.reachabilityQueue = dispatch_queue_create("runQueue", NULL);
    return reachability;
}

- (instancetype)initWithAddress:(const void*)address
{
    self = [super init];
    if (self) {
        SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *) address);
        self.reachabilityRef = CFRetain(ref);
        CFRelease(ref);
        self.reachabilityQueue = dispatch_queue_create("runQueue", NULL);
    }
    return self;
}

static void LHNetWorkReachabilityCallback(SCNetworkReachabilityRef target,SCNetworkReachabilityFlags flags,void *	__nullable info)
{
    LHNetWorkReachability* reachability = (__bridge LHNetWorkReachability *)(info);
    Main_Queue([[NSNotificationCenter defaultCenter] postNotificationName:LHReachabilityDidChangedNotification object:reachability]);
    if (reachability.reachabilityDidChanged) {
        dispatch_async(dispatch_get_main_queue(), ^{
            reachability.reachabilityDidChanged(reachability.netWorkStatus);
        });
    }
}

- (LHNetWorkStatus)netWorkStatus
{
    SCNetworkReachabilityFlags flags;
    if (!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))   return LHNetworkStatusNotReachable;
    else if (flags&kSCNetworkReachabilityFlagsReachable) {
        if (flags&kSCNetworkReachabilityFlagsIsWWAN) {
            return LHNetworkStatusReachableViaWWAN;
        }else return LHNetworkStatusReachableViaWiFi;
    }
    return LHNetworkStatusNotReachable;
}

- (BOOL)isReachable
{
    return self.netWorkStatus != LHNetworkStatusNotReachable;
}

- (BOOL)isReachableWWAN
{
    return self.netWorkStatus == LHNetworkStatusReachableViaWWAN;
}

- (BOOL)isReachableWIFI
{
    return self.netWorkStatus == LHNetworkStatusReachableViaWiFi;
}

- (void)StartMonitoring
{
    if (!self.reachabilityRef) {
        return;
    }
    SCNetworkReachabilityContext context = {0,(__bridge void*)self,NULL,NULL,NULL};
    SCNetworkReachabilitySetCallback(self.reachabilityRef,LHNetWorkReachabilityCallback, &context);
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilityQueue);
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
        LHNetWorkReachabilityCallback(self.reachabilityRef, flags, (__bridge void *)(self));
    }
}

- (void)stopMonitoring
{
    if (!self.reachabilityRef) {
        return;
    }
    SCNetworkReachabilitySetCallback(self.reachabilityRef,NULL, NULL);
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);
}

- (void)dealloc
{
    [self stopMonitoring];
    if (self.reachabilityRef) {
        CFRelease(self.reachabilityRef);
    }
}

- (void)addReachabilityDidChanged:(LHNetWorkReachabilityDidChanged)reachabilityDidChanged
{
    self.reachabilityDidChanged = [reachabilityDidChanged copy];
}

@end
