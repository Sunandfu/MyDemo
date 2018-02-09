//
//  AppDelegate.m
//  CYNavigationDemo
//
//  Created by 张春雨 on 2017/5/5.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CYNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //配置默认UI (更多设置可以去头文件看一下)
    [CYNavigationConfig shared].backgroundColor = [UIColor orangeColor];
    [CYNavigationConfig shared].fontColor = [UIColor whiteColor];
//    [CYNavigationConfig shared].leftBtnImageColor = [UIColor redColor];
    [CYNavigationConfig shared].borderHeight = 0.5;
    [CYNavigationConfig shared].backGesture = ^UIPanGestureRecognizer *{
        return [[UIPanGestureRecognizer alloc]init];
    }; //全屏返回
    [CYNavigationConfig shared].transitionAnimationClass = NSClassFromString(@"HighlightTransitionAnimation");//凸显的过渡动画
//    [CYNavigationConfig shared].transitionAnimationClass = NSClassFromString(@"NormalTransitionAnimation");//平移的过渡动画
    ViewController *vc = [[ViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    CYNavigationController *nav = [[CYNavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
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
