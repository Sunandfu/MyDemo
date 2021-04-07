//
//  AppDelegate.m
//  ReadBook
//
//  Created by lurich on 2020/5/13.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "AppDelegate.h"
#import "SFNetWork.h"
#import "BaiduMobStatForSDK.h"
#import "SFLocalAuthViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DCFileTool.h"
#import "SFBookSave.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        @"textViewFontSize":@20.0,
        @"currentBright":@0.5,
        @"selModelIndex":@0,
        KeyBlurEffect:@1,
        KeyBrightSwitch:@1,
        KeyBookRate:@0.5,
        KeyBookPitch:@1.0,
        KeyBookLineHeight:@2.0,
        KeyBookParagraphHeight:@2.0,
        KeyBookUpdateReminder:@0,
        KeyBookAutoReadSpeed:@10,
        KeyBookHiddleStatus:@1,
        KeyBookHiddleTitle:@0,
        KeyCacheBooks:@0,
        KeyExitAlert:@0,
        KeyPageStyle:@"2",
        KeyClickArea:@"1",
        KeyDarkMode:@"1",
        KeyReadBookStudy:@0,
        KeySplashAuthTime:@"1",
        KeySplashAuthID:@0,
        KeyTapClickExchange:@0,
        KeyTimerDisabled:@1,
        KeyBookReadTimeSolt:@0,
        KeyBookJiugongStyle:@0,
        KeyMenuReverse:@0,
        KeySwipeBack:@0,
        KeySelectGroup:@1,
        KeySelectNight:@0,
        KeyNightFollowingSystem:@1,
        KeyFontName:@"PingFangSC-Regular",
        KeyUserAgent:@"",
        @"userOptChoose":@"0"
        
    }
     ];
    //创建根目录
    [DCFileTool creatRootDirectory];
    NSLog(@"%@",DCBooksPath);
    
    if (![[NSFileManager defaultManager] contentsAtPath:DCBookSourcesPath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SFRequestJson" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //首先判断能否转化为一个json数据，如果能，接下来先把foundation对象转化为NSData类型，然后写入文件
        if ([NSJSONSerialization isValidJSONObject:list]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:1 error:nil];
            [jsonData writeToFile:DCBookSourcesPath atomically:YES];
            NSLog(@"书源存储成功：%@",DCBookSourcesPath);
        }
    }
    
    if (![[NSFileManager defaultManager] contentsAtPath:DCBookThemePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SFReadTheme" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //首先判断能否转化为一个json数据，如果能，接下来先把foundation对象转化为NSData类型，然后写入文件
        if ([NSJSONSerialization isValidJSONObject:list]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:1 error:nil];
            [jsonData writeToFile:DCBookThemePath atomically:YES];
            NSLog(@"主题存储成功：%@",DCBookThemePath);
        }
    }
    
    [[BaiduMobStatForSDK defaultStat] startWithAppId:@"718527995f"];
    [[BaiduMobStatForSDK defaultStat] setSDKVersion:[SFTool getAppVersion] withAppId:@"718527995f"];
    [[NSUserDefaults standardUserDefaults] setFloat:[UIScreen mainScreen].brightness forKey:@"oldBright"];
    NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyFontName];
    [SFTool sf_asynchronouslySetFontName:fontName];
    
    if (@available(iOS 13.0, *)) {
        BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
        if (isFollSys) {
            if ([UITraitCollection currentTraitCollection].userInterfaceStyle==UIUserInterfaceStyleLight) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeySelectNight];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeySelectNight];
            }
            self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        } else {
            BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
            if (isNignt) {
                self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
            } else {
                self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
            }
        }
    }
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    if (url) {
        NSString *fileNameStr = [url lastPathComponent];
        fileNameStr = [fileNameStr stringByRemovingPercentEncoding];
        
        NSString *toPath = [DCBooksPath stringByAppendingPathComponent:fileNameStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:toPath atomically:YES];
        
        DCBookModel *book = [[DCBookModel alloc]init];
        book.path = fileNameStr;
        NSArray *arr = [fileNameStr componentsSeparatedByString:@"."];
        book.name = arr.firstObject;
        book.type = arr.lastObject;
        book.bookIndex = 0;
        book.bookPage = 0;
        book.pageOffset = 0.0;
        
        BOOL insert = [SFBookSave insertLocalBook:book];
        if (insert) {
            NSLog(@"加入书架成功");
        }
        
        //用阅读器打开这个文件
        DCPageVC *vc = [[DCPageVC alloc]init];
        vc.bookModel = book;
        vc.hidesBottomBarWhenPushed = YES;
        [[SFTool topViewController].navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground = %@",application);
    BOOL isBlurEffect = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBlurEffect];
    if (isBlurEffect) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.window.bounds;
        [self.window addSubview:effectView];
        UILabel *tipDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, self.window.bounds.size.height-30, self.window.bounds.size.width, 30)];
        tipDetail.text = [NSString stringWithFormat:@"小富全力保护您的阅读隐私"];
        tipDetail.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        tipDetail.textColor = [SFTool colorWithHexString:@"#999999"];
        tipDetail.textAlignment = NSTextAlignmentCenter;
        [effectView.contentView addSubview:tipDetail];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground = %@",application);
    BOOL isBlurEffect = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBlurEffect];
    if (isBlurEffect) {
        [self.window.subviews.lastObject removeFromSuperview];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //超过两小时后验证身份
    BOOL isSplashAuthID = [[NSUserDefaults standardUserDefaults] boolForKey:KeySplashAuthID];
    if (isSplashAuthID) {
        NSTimeInterval lastTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"LastAuthTimeKey"];
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        NSString *splashAuthTime = [[NSUserDefaults standardUserDefaults] objectForKey:KeySplashAuthTime];
        NSArray *timeArr = @[
        @{@"show":@"一分钟",@"time":@60,@"type":@"1"},
        @{@"show":@"十分钟",@"time":@600,@"type":@"2"},
        @{@"show":@"一小时",@"time":@3600,@"type":@"3"},
        @{@"show":@"十小时",@"time":@36000,@"type":@"4"},
        @{@"show":@"一天",@"time":@86400,@"type":@"5"}];
        NSNumber *time;
        for (NSDictionary *dict in timeArr) {
            if ([dict[@"type"] isEqualToString:splashAuthTime]) {
                time = dict[@"time"];
                continue;
            }
        }
        if (nowTime - lastTime >= time.integerValue) {
            if (self.authVc == nil) {
                SFLocalAuthViewController *authVc = [[SFLocalAuthViewController alloc] init];
                authVc.view.frame = self.window.bounds;
                [self.window addSubview:authVc.view];
                self.authVc = authVc;
            }
        } else{
            [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:@"LastAuthTimeKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
