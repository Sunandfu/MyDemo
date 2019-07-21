//
//  YXHalfLaunchScreenViewController.m
//  LunchAd
//
//  Created by shuai on 2018/10/23.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXHalfLaunchScreenViewController.h"

#import <YXLaunchAds/YXLaunchAds.h>
#import "AppDelegate.h"
@interface YXHalfLaunchScreenViewController ()<YXLaunchAdManagerDelegate>

@end

@implementation YXHalfLaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"LaunchAd";
    UIButton *launchScreenBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, [UIScreen mainScreen].bounds.size.width - 100, 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"LaunchADTest" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(launchScreenBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:launchScreenBtn];
    // Do any additional setup after loading the view from its nib.
}
- (void)launchScreenBtnClicked:(UIButton*)sender
{
    YXLaunchAdManager *adManager = [YXLaunchAdManager shareManager];
    
    adManager.waitDataDuration = 10;
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
    
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 0.8, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.2)];
    bottom.backgroundColor = [UIColor clearColor];
    
    
    adManager.bottomView = bottom;
    
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
