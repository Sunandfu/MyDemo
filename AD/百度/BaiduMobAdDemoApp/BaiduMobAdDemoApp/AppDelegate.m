//
//  AppDelegate.m
//  BaiduMobAdDemoApp
//
//  Created by lishan04 on 16/3/23.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTableViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdSplash.h"
#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "XScreenConfig.h"

@interface AppDelegate ()<BaiduMobAdSplashDelegate>
@property (nonatomic, strong) BaiduMobAdSplash *splash;
@property (nonatomic, retain) UIView *customSplashView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *topLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UITextView *discriptText;
@property (nonatomic, retain) UIImageView *logoImage;
@property (nonatomic, retain) UILabel *deviderLabel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    MainTableViewController *mainController  = [[[MainTableViewController alloc]init]autorelease];
    UINavigationController *naviController = [[[UINavigationController alloc]initWithRootViewController:mainController]autorelease];
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    #warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.
    [BaiduMobAdSetting sharedInstance].supportHttps = YES;
    //设置视频缓存阀值，单位M, 取值范围15M-100M,默认30M
    [BaiduMobAdSetting setMaxVideoCacheCapacityMb:30];
    //全屏开屏广告
//    [self loadFullScreenSplash];
    //自定义开屏广告
    [self loadCustomSplash];
    return YES;
}

- (NSString *)publisherId {
    return @"ccb60059";
}

- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidClicked");
}

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissLp");
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissScreen");
    [self removeSplash];
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashSuccessPresentScreen");
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason {
    NSLog(@"splashlFailPresentScreen withError %d", reason);
    [self removeSplash];
}

/**
 *  加载全屏开屏
 */
- (void) loadFullScreenSplash {
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    splash.AdUnitTag = @"2058492";
    splash.canSplashClick = YES;
    [splash loadAndDisplayUsingKeyWindow:self.window];
    self.splash = splash;
    if (ISIPHONEX) {
        self.contentLabel = [[UILabel alloc] init];
        CGFloat labelW = kScreenWidth - 8;
        CGFloat labelH = kScreenHeight - IPHONEX_TOPBAR_FIX_HEIGHT - IPHONEX_TABBAR_FIX_HEIGHT;
        CGFloat labelX = 4.0f;
        CGFloat labelY =IPHONEX_TOPBAR_FIX_HEIGHT;
        self.contentLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.layer.borderWidth=2;
        self.contentLabel.layer.borderColor=[UIColor redColor].CGColor;
        [[[UIApplication sharedApplication].delegate window] addSubview:self.contentLabel];
    }
    self.discriptText = [[UITextView alloc] init];
    self.discriptText.text = @"此为全屏开屏广告";
    CGFloat lW = kScreenWidth;
    CGFloat lH = 60;
    CGFloat lX = 0.0f;
    CGFloat lY =kScreenHeight - 60;
    if (ISIPHONEX) {
        lY =kScreenHeight - 60 - IPHONEX_TABBAR_FIX_HEIGHT;
        self.discriptText.text = @"红色方框区域为广告有效区域，建议广告主体部分置于红色方框内";
    }
    self.discriptText.frame = CGRectMake(lX, lY, lW, lH);
    self.discriptText.backgroundColor = [UIColor clearColor];
    self.discriptText.font = [UIFont systemFontOfSize:16];
    self.discriptText.textColor = [UIColor redColor];
    self.discriptText.textAlignment = NSTextAlignmentCenter;
    [[[UIApplication sharedApplication].delegate window] addSubview:self.discriptText];
}

/**
 *  加载自定义开屏
 */
- (void) loadCustomSplash {
    //Demo logo 区域120高度
    BaiduMobAdSplash *splash = [[[BaiduMobAdSplash alloc] init]autorelease];
    splash.delegate = self;
    splash.AdUnitTag = @"2058492";
    splash.canSplashClick = YES;
    self.splash = splash;
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[[UIView alloc]initWithFrame:self.window.frame]autorelease];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    CGRect spRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 120);
    if (ISIPHONEX) {
        spRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 120 -IPHONEX_TABBAR_FIX_HEIGHT);
    }
    UIView * baiduSplashContainer = [[[UIView alloc]initWithFrame:spRect]autorelease];
    [self.customSplashView addSubview:baiduSplashContainer];
    CGRect textRect = CGRectMake(0, kScreenHeight - 150, kScreenWidth, 30);
    if (ISIPHONEX) {
        textRect = CGRectMake(0, kScreenHeight - 180 - IPHONEX_TABBAR_FIX_HEIGHT, kScreenWidth, 60);
    }
    UITextView *textView = [[[UITextView alloc]initWithFrame:textRect]autorelease];
    textView.font = [UIFont systemFontOfSize:14];
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.textColor = [UIColor redColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = @"此为开屏广告位";
    if (ISIPHONEX) {
        textView.text = @"此为开屏广告位,红色方框区域为广告有效区域\n建议广告主体部分置于红色方框内";
    }
    [self.customSplashView addSubview:textView];
    //在的baiduSplashContainer里展现百度广告
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
    //添加X适配
    if (ISIPHONEX) {
        self.contentLabel = [[UILabel alloc] init];
        CGFloat labelW = kScreenWidth - 8;
        CGFloat labelH = kScreenHeight - IPHONEX_TABBAR_FIX_HEIGHT - IPHONEX_TOPBAR_FIX_HEIGHT - 120;
        CGFloat labelX = 4.0f;
        CGFloat labelY =IPHONEX_TOPBAR_FIX_HEIGHT;
        self.contentLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.layer.borderWidth=2;
        self.contentLabel.layer.borderColor=[UIColor redColor].CGColor;
        [[[UIApplication sharedApplication].delegate window] addSubview:self.contentLabel];
        
        self.deviderLabel =[[UILabel alloc] init];
        CGFloat w = kScreenWidth - 8;
        CGFloat h = 2;
        CGFloat x = 4.0f;
        CGFloat y =kScreenHeight - IPHONEX_TABBAR_FIX_HEIGHT;
        self.deviderLabel.frame = CGRectMake(x, y, w, h);
        self.deviderLabel.backgroundColor = [UIColor redColor];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.deviderLabel];
        
    }
    //logo区域
    self.logoImage = [[UIImageView alloc] init];
    CGFloat lW = kScreenWidth - 60;
    CGFloat lH = 120;
    CGFloat lX = 30.0f;
    CGFloat lY =kScreenHeight - 120;
    if (ISIPHONEX) {
        lY = kScreenHeight - 120 - IPHONEX_TABBAR_FIX_HEIGHT;
    }
    self.logoImage.frame = CGRectMake(lX, lY, lW, lH);
    self.logoImage.backgroundColor = [UIColor redColor];
    [self.logoImage setImage:[UIImage imageNamed:@"logo.png"]];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.logoImage];
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash {
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
        [self.logoImage removeFromSuperview];
        [self.customSplashView removeFromSuperview];
        [self.discriptText removeFromSuperview];
    }
    //添加X适配
    if (ISIPHONEX) {
        //移除开屏边框
        [self.contentLabel removeFromSuperview];
         [self.deviderLabel removeFromSuperview];
        //添加底部危险区域指示框
        self.label = [[UILabel alloc] init];
        CGFloat labelW = kScreenWidth;
        CGFloat labelH = IPHONEX_TABBAR_FIX_HEIGHT;
        CGFloat labelX = 0.0f;
        CGFloat labelY =[[UIScreen mainScreen] bounds].size.height - IPHONEX_TABBAR_FIX_HEIGHT;
        self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        self.label.text = @"建议不要把广告展示在红色区域";
        self.label.font = [UIFont systemFontOfSize:8];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = [UIColor redColor];
        self.label.textColor = [UIColor whiteColor];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.label];
        //添加导航栏危险区域提示框
        self.topLabel = [[UILabel alloc] init];
        CGFloat lW = kScreenWidth;
        CGFloat lH = IPHONEX_TOPBAR_FIX_HEIGHT;
        CGFloat lX = 0.0f;
        CGFloat lY = 0.0f;
        self.topLabel.frame = CGRectMake(lX, lY, lW, lH);
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.backgroundColor = [UIColor redColor];
        [[[UIApplication sharedApplication].delegate window] addSubview:self.topLabel];
    }
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
