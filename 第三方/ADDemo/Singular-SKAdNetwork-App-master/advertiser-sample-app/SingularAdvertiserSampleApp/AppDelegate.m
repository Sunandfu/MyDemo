//
//  AppDelegate.m
//  SingularAdvertiserSampleApp
//
//  Created by Eyal Rabinovich on 25/06/2020.
//

#import "AppDelegate.h"

// Don't forget to import this to have access to the SKAdnetwork
#import <StoreKit/SKAdNetwork.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //如果设备具有该应用的属性数据，则对RegisterAppForadNetworkAttribute的第一次调用将生成通知。
    //最好尽快调用此方法，这就是为什么我们从didFinishLaunchingWithOptions调用它。
    //当第一次打开应用程序并调用此方法时，它会启动一个24小时计时器，对UpdateCovVersionValue的任何后续调用都会重置此计时器。
    //一旦第一个24小时计时器结束，经过随机时间段后，将向广告网络发送归属通知。

    [SKAdNetwork registerAppForAdNetworkAttribution];
    
    return YES;
}

@end
