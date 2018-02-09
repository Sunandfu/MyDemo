//
//  LHNetWorkReachability.h
//  CFNetWorkDemo
//
//  Created by 3wchina01 on 16/3/1.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

extern NSString* const LHReachabilityDidChangedNotification;

typedef enum {
    LHNetworkStatusNotReachable     = 0,
    LHNetworkStatusReachableViaWWAN = 1,
    LHNetworkStatusReachableViaWiFi = 2,
}LHNetWorkStatus;

typedef void(^LHNetWorkReachabilityDidChanged)(LHNetWorkStatus status);

@interface LHNetWorkReachability : NSObject

/*
 获取当前网络环境.
 netWorkStatus 一个枚举 
 LHNetworkStatusNotReachable  无网络,
 LHNetworkStatusReachableViaWWAN 蜂窝网络,
 LHNetworkStatusReachableViaWiFi WIFI,
 */
@property (nonatomic,assign) LHNetWorkStatus netWorkStatus;

/*
  监听网络变化回调block.
  reachabilityDidChanged 网络发送变化就会回调此block
 */
@property (nonatomic,copy) LHNetWorkReachabilityDidChanged reachabilityDidChanged;

/*
  获取单例对象
 */
+ (instancetype)instanceManager;

/*
  获取实例对象
 */
+ (instancetype)manager;


/*
  根据传入的网址获取实例对象
 domain 可以是一个网址
 */
+ (instancetype)managerForDomain:(NSString*)domain;

/*
  判断当前有无网络
  如果有返回YES，否则NO
 */
- (BOOL)isReachable;

/*
  判断当前网络是否是蜂窝网络
  如果是返回YES，否则NO
 */
- (BOOL)isReachableWWAN;

/*
  判断当前网络是否是WIFI
 如果是返回YES，否则NO
 */
- (BOOL)isReachableWIFI;

/*
  开始监测网络环境
  如果网络发生改变会回调通知 LHReachabilityDidChangedNotification
 */
- (void)StartMonitoring;

/*
  移除网络监测
 */
- (void)stopMonitoring;

/*
  当监测网络条件下 使用block回调网络变化
 */
- (void)addReachabilityDidChanged:(LHNetWorkReachabilityDidChanged)reachabilityDidChanged;

@end
