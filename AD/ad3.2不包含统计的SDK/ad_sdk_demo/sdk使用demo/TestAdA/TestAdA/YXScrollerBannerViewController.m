//
//  YXScrollerBannerViewController.m
//  LunchAd
//
//  Created by shuai on 2018/11/21.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXScrollerBannerViewController.h" 
#import <YXLaunchAds/YXMutBannerAdManager.h>
static  NSString * feedMediaID = @"ckej_ios_feed";

@interface YXScrollerBannerViewController ()<YXMutBannerAdManagerDelegate>
{
    
    YXMutBannerAdManager * mutBanner;
}

@property (nonatomic,strong) UIView *BannerView;

@end

@implementation YXScrollerBannerViewController

- (void)dealloc
{
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = 388 * self.view.frame.size.width / 690;
    
    self.BannerView = [[UIView alloc]initWithFrame:CGRectMake(0,100 , self.view.frame.size.width, height)];
    
    
    [self.view addSubview:self.BannerView];
    
    [self loadAd];
    
//    NSString * str = NSStringFromClass([self class]);
    
//    [HMTAgentSDK postAction:str];
    // Do any additional setup after loading the view.
}

- (void)loadAd
{
    mutBanner = [YXMutBannerAdManager new];
    mutBanner.delegate = self;
    mutBanner.adSize = YXADSize690X388;
    
    mutBanner.controller = self;
    mutBanner.adCount = 3;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
