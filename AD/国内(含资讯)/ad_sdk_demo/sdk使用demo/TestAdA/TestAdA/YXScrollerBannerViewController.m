//
//  YXScrollerBannerViewController.m
//  LunchAd
//
//  Created by shuai on 2018/11/21.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXScrollerBannerViewController.h" 
#import <YXLaunchAds/YXLaunchAds.h>

static  NSString * feedMediaID = @"beta_ios_native";

@interface YXScrollerBannerViewController ()<YXMutBannerAdManagerDelegate>
{
    
    YXMutBannerAdManager * mutBanner;
}

@property (nonatomic,strong) UIView *BannerView;

@end

@implementation YXScrollerBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.view.frame.size.width-60;
    //根据宽高比自定义适配
    CGFloat height = 388 * width / 690;
    
    self.BannerView = [[UIView alloc]initWithFrame:CGRectMake(30,100 , width, height)];
    
    
    [self.view addSubview:self.BannerView];
    
    [self loadAd];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(self.view.frame.size.width/2.0-40, 100+height+50, 80, 50);
    [button setTitle:@"刷新广告" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reloadADView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)reloadADView{
    [mutBanner reloadMutBannerAd];
}

- (void)loadAd
{
    mutBanner = [YXMutBannerAdManager new];
    mutBanner.delegate = self;
    mutBanner.adSize = YXADSizeCustom;
    mutBanner.s2sWidth = 690;
    mutBanner.s2sHeight = 388;
    mutBanner.controller = self;
    mutBanner.adCount = 4;
    mutBanner.placeholderImage = [UIImage imageNamed:@"placeImage"];
    mutBanner.mediaId = feedMediaID;
//    mutBanner.pageControlAliment = YXBannerScrollViewPageContolAlimentCenter;
    mutBanner.pageControlStyle = YXBannerScrollViewPageContolStyleClassic;
//    mutBanner.pageDotColor = UIColor.greenColor;
//    mutBanner.currentPageDotColor = UIColor.redColor;
//    mutBanner.pageControlBottomOffset = 100;
    /*
     YXBannerScrollViewPageContolStyleClassic,        // 系统自带经典样式
     YXBannerScrollViewPageContolStyleAnimated,       // 动画效果--直接显示
     YXBannerScrollViewPageControlHorizontal,         // 水平动态滑块
     YXBannerScrollViewPageImageRotation,             // 旋转前进
     YXBannerScrollViewPageImageJump,                 // 以半圆跳跃前进
     YXBannerScrollViewPageImageAnimated,             // 动画滑动前进
     YXBannerScrollViewPageContolStyleNone            // 不显示pagecontrol
     */
    mutBanner.cornerRadius = 8;
    [mutBanner loadMutBannerAdViewsInView:self.BannerView];
    NSLog(@"请求多图广告");
}

#pragma mark ADdelegate
- (void)didLoadMutBannerAdView
{
    NSLog(@"加载成功");
}
-(void)didFailedLoadMutBannerAd:(NSError *)error
{
    NSLog(@"加载失败%@",error);
}

- (void)didClickedMutBannerAd
{
    NSLog(@"点击");
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
