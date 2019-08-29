//
//  YXLaunchScreenViewController.m
//  LunchAd
//
//  Created by shuai on 2018/10/8.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXLaunchScreenViewController.h"
#import "YXLaunchAdManager.h"
#import "AppDelegate.h"
#import "YXAdSDKManager.h"
#import <SafariServices/SafariServices.h>

#import "YXLaunchAd.h"
#import <BUAdSDK/BUAdSDKManager.h>
#import "BUAdSDK/BUSplashAdView.h"
#import "NetTool.h"

@interface YXLaunchScreenViewController ()<YXLaunchAdManagerDelegate,BUSplashAdDelegate>

@property (nonatomic, strong) UIView *adView;

@end

@implementation YXLaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"LaunchAd";
    UIButton *launchScreenBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100, 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"LaunchADTest" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(launchScreenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:launchScreenBtn];
    
    UIButton *launchScreenBtn1 = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 400, [UIScreen mainScreen].bounds.size.width - 100, 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"ChuanADTest" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chuanshanjiaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:launchScreenBtn1];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customViewdidClickedAd) name:CUSTOMCLICKNOTIFITION object:nil];
}

- (void)chuanshanjiaBtnClicked:(UIButton*)sender{
    [self initChuanAD];
}
#pragma mark 穿山甲

- (void)initChuanAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [BUAdSDKManager setAppID:@"5000546"];
        [BUAdSDKManager setIsPaidApp:NO];
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelNone];
        //        NSLog(@"SDKVersion = %@", [BUAdSDKManager SDKVersion]);
        
        
        //        UIWindow *window = [UIApplication sharedApplication].delegate.window;
//        UIWindow *window = [UIApplication sharedApplication].delegate.window;
//
//        UIViewController *topRootViewController = window.rootViewController;
//        while (topRootViewController.presentedViewController)
//        {
//            topRootViewController = topRootViewController.presentedViewController;
//        }
        
        // frame 强烈建议为屏幕大小
        BUSplashAdView *spalshView = [[BUSplashAdView alloc] initWithSlotID:@"800546808" frame:self.view.frame];
        
        spalshView.tolerateTimeout = 5;
        spalshView.hideSkipButton = YES;
        spalshView.delegate = self;
//        spalshView.rootViewController = [NetTool getCurrentViewController];
        [spalshView loadAdData];
        
        [self.adView addSubview:spalshView];
        
    });
}
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd
{
        //配置广告数据
        YXLaunchImageAdConfiguration *imageAdconfiguration = [YXLaunchImageAdConfiguration new];
        //广告停留时间
//        imageAdconfiguration.duration = self.duration;
        imageAdconfiguration.showEnterForeground = NO;
        //广告frame
        imageAdconfiguration.frame = self.view.frame;
        
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为YXLaunchAdImageCacheInBackground,先缓存,下次显示
//        imageAdconfiguration.imageOption = self.imageOption;
//        //图片填充模式
//        imageAdconfiguration.contentMode = self.contentMode;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        //                imageAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
//        imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
//        //广告显示完成动画时间
//        imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimate;
//        //跳过按钮类型
//        imageAdconfiguration.skipButtonType = self.skipButtonType;
        //start********************自定义跳过按钮**************************
//        imageAdconfiguration.customSkipView = nil;
//        imageAdconfiguration.addSkipLeftView = self.skipLeftView;
        //********************自定义广告*****************************end
        [YXLaunchAd shareLaunchAd].customAdView = self.adView;
//        [YXLaunchAd shareLaunchAd].hiddenRightIcon = YES;
        //显示开屏广告
        [YXLaunchAd customImageViewWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd
{
    NSLog(@"spalshAdWillVisible;%s",__FUNCTION__);
}
- (void)splashAdDidClick:(BUSplashAdView *)splashAd
{
    NSLog(@"splashAdDidClick;%s",__FUNCTION__);
}
- (void)splashAdWillClose:(BUSplashAdView *)splashAd
{
    NSLog(@"spalshAdWillClose;%s",__FUNCTION__);
}
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    
    NSLog(@"spalshAdDidClose;%s",__FUNCTION__);
    [[YXLaunchAd shareLaunchAd] cancleSkip];
    [[YXLaunchAd shareLaunchAd] removeAndOnly];
}
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error
{
    [splashAd removeFromSuperview];
}
//- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType{
//    NSString *str = @"";
//    if (interactionType == BUInteractionTypePage) {
//        str = @"ladingpage";
//    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
//        str = @"videoDetail";
//    } else {
//        str = @"appstoreInApp";
//    }
//    NSLog(@"%@",str);
//}

- (void)launchScreenBtnClicked:(UIButton*)sender
{
    YXLaunchAdManager *adManager = [YXLaunchAdManager shareManager];
    adManager.waitDataDuration = 5;
    adManager.duration = 5;
    adManager.mediaId = splashMediaID;
    adManager.adType = YXScreenType;
    adManager.imageOption = YXLaunchAdImageDefault;
    adManager.contentMode = UIViewContentModeScaleAspectFill;
    adManager.showFinishAnimate = ShowFinishAnimateNone;
    adManager.showFinishAnimateTime = 0.8;
    adManager.skipButtonType = SkipTypeTimeText;
    adManager.delegate = self;
    [adManager loadLaunchAdWithShowAdWindow:[UIApplication sharedApplication].delegate.window];
    
    //    [adManager addBlackList: splashMediaID andTime:2];
    //
    //    [adManager removeBlackList:splashMediaID];
    NSLog(@"开始请求开屏广告");
}



#pragma mark ADDelegate
-(void)didLoadAd:(UIView *)view
{
    NSLog(@"广告请求ok");
}
- (void)didClickedAd
{
    NSLog(@"广告点击事件");
}
- (void)customViewdidClickedAd{
    NSLog(@"自定义 View 点击事件");
    SFSafariViewController *webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://baidu.com"]];
    //此处应获取当前显示的控制器去推出新控制器，否则将会被当前显示的控制器所盖住
    [[self getCurrentViewController] showViewController:webView sender:self];
}
//获取当前显示的控制器
- (UIViewController *)getCurrentViewController
{
    UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    return vc;
}
- (void)didPresentedAd
{
    NSLog(@"图片下载完成/或本地图片读取完成回调");
}
-(void)LaunchShowFinish
{
    NSLog(@"广告显示完成");
    YXLaunchAdManager *adManager = [YXLaunchAdManager shareManager];
    adManager.delegate = nil;
    adManager = nil;
    
}
-(void)didFailedLoadAd:(NSError *)error
{
    NSLog(@"广告请求失败%@",error);
    YXLaunchAdManager *adManager = [YXLaunchAdManager shareManager];
    adManager.delegate = nil;
    adManager = nil;
    
}
- (void)didAdShowReturn
{
    NSLog(@"落地页或者appstoe返回事件，方便用户做返回后的处理工作");
}
- (void)lunchADSkipButtonClick
{
    NSLog(@"跳过");
}
-(void)customSkipDuration:(NSInteger)duration
{
    NSLog(@"广告倒计时:%ld",duration);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
