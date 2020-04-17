//
//  AppDelegate.m
//  TestAdA
//
//  Created by shuai on 2018/3/24.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <YXLaunchAds/YXLaunchAds.h>

@interface AppDelegate ()<YXLaunchAdManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    /** 开屏广告初始化 */
    [self initLaunchAd];
    
    NSLog(@"开始加载广告");
    
    return YES;
}

/**
 开屏广告初始化 建议放在 didFinishLaunchingWithOptions中调用
 */
- (void)initLaunchAd
{
    YXAdSDKManager *sdkManager = [YXAdSDKManager defaultManager];
    sdkManager.cityCode = @"4CCDBE264F0EB13C";
    YXLaunchAdManager *adManager = [YXLaunchAdManager shareManager];
    adManager.waitDataDuration = 5;
    adManager.duration = 5;
    adManager.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.8);
    adManager.mediaId = splashMediaID;
    adManager.adType = YXScreenType;
    adManager.imageOption = YXLaunchAdImageDefault;
    adManager.contentMode = UIViewContentModeScaleAspectFill;
    adManager.showFinishAnimate = ShowFinishAnimateFadein;
    adManager.showFinishAnimateTime = 0.8;
    adManager.skipButtonType = SkipTypeTimeText;
    
    adManager.delegate = self;
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    [adManager loadLaunchAdWithShowAdWindow:window];
    
//
//    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 0.8, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.2)];
////    bottom.backgroundColor = [UIColor whiteColor];
//    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yxadlogo"]];
//    //把logo置于 bottom 中心
//    logoImageView.frame = bottom.bounds;
//    logoImageView.contentMode =  UIViewContentModeCenter;
//
//    [bottom addSubview:logoImageView];
//    adManager.bottomView = bottom;
    
    
}
#pragma mark ADDelegate
-(void)didLoadAd
{
    NSLog(@"广告请求ok");
}
- (void)didClickedAdUrl:(NSString *)clickedUrl
{
    NSLog(@"广告点击事件%@",clickedUrl);
}
- (void)didPresentedAd
{
    NSLog(@"图片下载完成/或本地图片读取完成回调");
}
-(void)LaunchShowFinish
{
    NSLog(@"广告显示完成");
}
-(void)didFailedLoadAd:(NSError *)error
{
    NSLog(@"广告请求失败%@",error);
}
- (void)didAdShowReturn
{
    NSLog(@"落地页或者appstoe返回事件，方便用户做返回后的处理工作");
}
-(void)customSkipDuration:(NSInteger)duration
{
    NSLog(@"广告倒计时:%ld",(long)duration);
}
- (void)lunchADSkipButtonClick
{
    NSLog(@"跳过");
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
