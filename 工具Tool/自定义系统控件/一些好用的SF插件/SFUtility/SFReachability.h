//
//  SFReachability.h
//  TestAdA
//
//  Created by lurich on 2021/4/2.
//  Copyright © 2021 . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SFNetworkStatus) {
    SFNetworkStatusNotReachable = 0,
    SFNetworkStatusUnknown = 1,
    SFNetworkStatusWWAN2G = 2,
    SFNetworkStatusWWAN3G = 3,
    SFNetworkStatusWWAN4G = 4,
    SFNetworkStatusWWAN5G = 5,
    
    SFNetworkStatusWiFi = 9,
};

extern NSString *kSFReachabilityChangedNotification;

@interface SFReachability : NSObject

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (SFNetworkStatus)currentReachabilityStatus;

@end
