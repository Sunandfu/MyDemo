//
//  YXBannerViewController.m
//  LunchAd
//
//  Created by shuai on 2018/10/8.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXBannerViewController.h"
 
#import <YXLaunchAds/YXLaunchAds.h>

#import "AppDelegate.h"

static  NSString * bannerMediaID = @"wxbus_ios_banner";

@interface YXBannerViewController ()<YXBannerAdManagerDelegate>
{
    YXBannerAdManager *bannerView;
}

@end

@implementation YXBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"BannerAd";
    UIButton *iconBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100 , 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"BannerADTest" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bannerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:iconBtn];
    // Do any additional setup after loading the view from its nib.
}
- (void)bannerBtnClicked:(UIButton*)button
{
    if (bannerView) {
        [bannerView removeFromSuperview];
        bannerView = nil;
    }
    
    
    bannerView =  [[YXBannerAdManager alloc]initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 50)];
    bannerView.interval = 30;
    bannerView.isLoop = YES;
    bannerView.delegate = self;
    bannerView.mediaId = bannerMediaID;
    bannerView.bannerType = BottomBannerType;
    bannerView.adSize = YXAD_BannerCustom;
    [self.view addSubview:bannerView];
    NSLog(@"Banner请求");
    [bannerView loadBannerAD];
}
- (void)didLoadBannerAd:(UIView *)adView
{
    NSLog(@"Banner广告请求成功");
    
}


- (void)didClickedBannerAd
{
    NSLog(@"Banner广告点击");
}

- (void)didFailedLoadIconAd:(NSError *)error
{
    NSLog(@"Banner广告请求失败");
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
