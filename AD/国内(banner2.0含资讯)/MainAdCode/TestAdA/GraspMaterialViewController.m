//
//  GraspMaterialViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/6.
//  Copyright © 2019 YX. All rights reserved.
//

#import "GraspMaterialViewController.h"
#import "GDTUnifiedBannerView.h"
#import "GDTSplashAd.h"
#import "GDTSDKConfig.h"
#import "GDTNativeAd.h"
#import "GDTNativeExpressAdView.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
#import "YXFeedAdData.h"
#import "YXBannerScrollView.h"
#import "GDTMobBannerView.h"

@interface GraspMaterialViewController ()<YXBannerScrollViewDelegate,GDTNativeAdDelegate,GDTUnifiedNativeAdDelegate,GDTUnifiedBannerViewDelegate,GDTMobBannerViewDelegate>

@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) YXBannerScrollView *bannerScrollView;

@end

@implementation GraspMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.feedArray = [NSMutableArray arrayWithCapacity:0];
    [self createBannerView];
    // Do any additional setup after loading the view.
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器（dispatch_source_t本质上还是一个OC对象）
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置定时器的各种属性
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(120*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    //设置回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        //定时器需要执行的操作
//        [weakSelf createBannerView];
        [weakSelf createLaunds];
//        [weakSelf createNative];
    });
    //启动定时器（默认是暂停）
    dispatch_resume(self.timer);
}
- (void)createBannerView{
    GDTUnifiedBannerView *bannerView = [[GDTUnifiedBannerView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width*10/64) appId:@"1108051488" placementId:@"6020975748132235" viewController:self];
    bannerView.autoSwitchInterval = 30;
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    [bannerView loadAdAndShow];
    
    GDTMobBannerView *bannerView1 = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.width*10/64) appId:@"1108051488" placementId:@"9060247803981845"];
    bannerView1.currentViewController = self;
    bannerView1.interval = 30;
    bannerView1.showCloseBtn = YES;
    bannerView1.isAnimationOn = YES;
    bannerView1.delegate = self;
    [self.view addSubview:bannerView1];
    [bannerView1 loadAdAndShow];
}
- (void)bannerViewDidReceived{
    NSLog(@"请求广告banner1.0数据成功后调用");
}

- (void)bannerViewFailToReceived:(NSError *)error{
    NSLog(@"请求广告banner1.0数据失败后调用 error = %@",error);
}
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView{
    NSLog(@"请求广告banner2.0数据成功后调用");
}

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error{
    NSLog(@"请求广告banner2.0数据失败后调用 error = %@",error);
}

- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView{
    NSLog(@"banner2.0曝光回调");
}

- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView{
    NSLog(@"banner2.0点击回调");
}
- (void)createLaunds{
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppId:@"1108051488" placementId:@"4030347873887869"];
    splash.fetchDelay = 5;
    [splash loadAdAndShowInWindow:[UIApplication sharedApplication].delegate.window];
}
- (void)createNative{
    GDTNativeAd *nativeAd = [[GDTNativeAd alloc] initWithAppId:@"1108101304" placementId:@"5060554044925571"];
    nativeAd.controller = self;
    nativeAd.delegate = self;
    [nativeAd loadAd:5];
//    GDTUnifiedNativeAd *unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:@"1108101304" placementId:@"5060554044925571"];
//    unifiedNativeAd.delegate = self;
//    unifiedNativeAd.maxVideoDuration = 1; // 如果需要设置视频最大时长，可以通过这个参数来进行设置
//    [unifiedNativeAd loadAd];
}
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    NSLog(@"原生1.0数据获取成功");
    [self.feedArray removeAllObjects];
    // 广告数据拉取成功，存储并展示
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nativeAdDataArray.count > 0) {
            for (int index = 0; index < nativeAdDataArray.count; index ++ ) {
                GDTNativeAdData *data = nativeAdDataArray[index];
                NSDictionary * properties = data.properties;
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adContent = [properties objectForKey:GDTNativeAdDataKeyDesc];
                backdata.adTitle = [properties objectForKey:GDTNativeAdDataKeyTitle];
                backdata.imageUrl = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
                backdata.IconUrl = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
                backdata.adID = index;
                backdata.adType = 2;
                backdata.data = data;
                [self.feedArray addObject:backdata];
            }
        }
    });
    [self.bannerScrollView removeFromSuperview];
    self.bannerScrollView = [YXBannerScrollView cycleScrollViewWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 200) delegate:self placeholderImage:nil];
    NSMutableArray *imgUrlArr = [NSMutableArray arrayWithCapacity:0];
    for (YXFeedAdData *feedData in self.feedArray) {
        NSString * imgUrl = [NSString stringWithFormat:@"%@",feedData.imageUrl];
        [imgUrlArr addObject:imgUrl];
    }
    self.bannerScrollView.imageURLStringsGroup = imgUrlArr;
    [self.view addSubview:self.bannerScrollView];
}
- (void)nativeAdFailToLoad:(NSError *)error{
    NSLog(@"原生1.0数据获取失败 error = %@",error);
}
/** 点击图片回调 */
- (void)cycleScrollView:(YXBannerScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击图片回调%ld",index);
}

/** 图片滚动回调 */
- (void)cycleScrollView:(YXBannerScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"图片滚动回调%ld",index);
}
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error{
    if (error) {
        NSLog(@"原生2.0数据获取失败 error = %@",error);
    } else {
        NSLog(@"原生2.0数据获取成功 %@",unifiedNativeAdDataObjects);
    }
    
    [self.feedArray removeAllObjects];
    if (unifiedNativeAdDataObjects.count > 0) {
        for (int index = 0; index < unifiedNativeAdDataObjects.count; index ++ ) {
            GDTUnifiedNativeAdDataObject *data = unifiedNativeAdDataObjects[index];
            YXFeedAdData *backdata = [YXFeedAdData new];
            backdata.adContent = data.desc;
            backdata.adTitle = data.title;
            backdata.imageUrl = data.imageUrl;
            backdata.IconUrl = data.iconUrl;
            backdata.adID = index;
            backdata.adType = 2;
            backdata.data = data;
            if (data.isVideoAd) {
                continue;
            }
            [self.feedArray addObject:backdata];
        }
        
        [self.bannerScrollView removeFromSuperview];
        self.bannerScrollView = [YXBannerScrollView cycleScrollViewWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 200) delegate:self placeholderImage:nil];
        NSMutableArray *imgUrlArr = [NSMutableArray arrayWithCapacity:0];
        for (YXFeedAdData *feedData in self.feedArray) {
            NSString * imgUrl = [NSString stringWithFormat:@"%@",feedData.imageUrl];
            [imgUrlArr addObject:imgUrl];
        }
        self.bannerScrollView.imageURLStringsGroup = imgUrlArr;
        [self.view addSubview:self.bannerScrollView];
    }
}
- (void)dealloc
{
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}

@end
