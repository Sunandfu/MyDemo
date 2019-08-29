//
//  YXScrollerBannerViewController.m
//  LunchAd
//
//  Created by shuai on 2018/11/21.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXScrollerBannerViewController.h" 
#import "YXMutBannerAdManager.h"

static  NSString * feedMediaID = @"dev_ios_native";

@interface YXScrollerBannerViewController ()<YXMutBannerAdManagerDelegate>
{
    
    YXMutBannerAdManager * mutBanner;
}

@property (nonatomic,strong) UIView *BannerView;
@property (nonatomic, strong) dispatch_source_t timer;

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
    
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器（dispatch_source_t本质上还是一个OC对象）
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置定时器的各种属性
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(120*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    //设置回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        //定时器需要执行的操作
        [weakSelf reloadADView];
    });
    //启动定时器（默认是暂停）
    dispatch_resume(self.timer);
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
    mutBanner.isOnlyImage = YES;
//    mutBanner.autoScrollTimeInterval = 10;
    mutBanner.adCount = 5;
    mutBanner.placeholderImage = [UIImage imageNamed:@"placeImage"];
//    mutBanner.backgroundImage = [UIImage imageNamed:@"placeImage"];
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

- (void)didClickedMutBannerAdWithIndex:(NSInteger)index
{
    NSLog(@"点击%ld",index);
}

- (void)dealloc
{
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
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
