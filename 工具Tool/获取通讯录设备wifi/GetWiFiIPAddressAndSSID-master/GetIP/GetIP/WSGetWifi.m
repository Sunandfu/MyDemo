//
//  WSGetWifi.m
//  GetIP
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "WSGetWifi.h"
#include <arpa/inet.h>
#include <netdb.h>

#include <net/if.h>

#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
//获取当前wifi名称的
#import <SystemConfiguration/CaptiveNetwork.h>

/*
 NSDictionary*dic=[ZCAchieveIP fetchSSIDInfo];
 需要真机测试 模拟器无效，真机测试后返回结果如下
 {
 BSSID = "c8:3a:35:3a:95:48";
 SSID = "Tenda_3A9548";
 SSIDDATA = <54656e64 615f3341 39353438>;
 }
 其中SSID为WIFI名称
 
 
 */
@implementation WSGetWifi

+(NSString *)getWiFiIPAddress {
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;

    
}
//获取当前wifi名称
+(id)getSSIDInfo {
    NSArray *ifs = (__bridge NSArray *)(CNCopySupportedInterfaces());
//    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

@end
