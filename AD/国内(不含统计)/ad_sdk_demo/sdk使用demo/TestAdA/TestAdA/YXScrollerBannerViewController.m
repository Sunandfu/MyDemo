//
//  YXScrollerBannerViewController.m
//  LunchAd
//
//  Created by shuai on 2018/11/21.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXScrollerBannerViewController.h" 
#import <YXLaunchAds/YXMutBannerAdManager.h>
static  NSString * feedMediaID = @"wxbus_ios_native";

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
    //根据宽高比自定义适配
    CGFloat height = 388 * self.view.frame.size.width / 690;
    
    self.BannerView = [[UIView alloc]initWithFrame:CGRectMake(0,100 , self.view.frame.size.width, height)];
    
    
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
    mutBanner.adSize = YXADSize690X388;
    mutBanner.controller = self;
    mutBanner.adCount = 6;
    mutBanner.placeImage = [UIImage imageNamed:@"placeImage"];
    mutBanner.mediaId = feedMediaID;
    mutBanner.orientation = YXNewPagedFlowViewOrientationHorizontal;
    mutBanner.isOpenAutoScroll = YES;
    mutBanner.isCarousel = YES;
    mutBanner.autoTime = 3;
    
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
