//
//  SFADViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/27.
//  Copyright © 2019 YX. All rights reserved.
//

#import "SFGDTADViewController.h"

@interface SFGDTADViewController ()

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic) CGSize tmpSize;

@property (nonatomic, strong) GDTUnifiedBannerView *guangBannerView;

@end

@implementation SFGDTADViewController


+ (instancetype)defaultManger{
    static dispatch_once_t onceToken;
    static SFGDTADViewController *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SFGDTADViewController alloc] init];
    });
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)feedArray{
    if (_feedArray==nil) {
        _feedArray = [NSMutableArray array];
    }
    return _feedArray;
}
- (void)getGDTADWithAppId:(NSString *)appid PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height AdCount:(NSInteger)count{
    [self.feedArray removeAllObjects];
    self.tmpSize = CGSizeMake(width, height);
    if (!self.nativeExpressAd) {
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:appid
                                                             placementId:adPlaceId
                                                                  adSize:CGSizeMake(width, height)];
    }
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:count];
}
/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    if (views.count > 0) {
        for (int index = 0; index < views.count; index ++ ) {
            GDTNativeExpressAdView *expressView = views[index];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tmpSize.width, self.tmpSize.height)];
            expressView.controller = self.showController;
            [expressView render];
            view.contentMode = UIViewContentModeScaleToFill;
            [view addSubview:expressView];
            YXFeedAdData *backdata = [YXFeedAdData new];
            backdata.adID = index;
            backdata.adType = 2;
            backdata.adID = [[NSDate date] timeIntervalSince1970]*1000;
            backdata.data = view;
            [self.feedArray addObject:backdata];
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:Type:)]){
            [self.delegate didLoadFeedAd:self.feedArray Type:2];
        }
    }
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailedLoadFeedAd:Type:)]){
        [self.delegate didFailedLoadFeedAd:error Type:2];
    }
}

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    for (YXFeedAdData *backdata in self.feedArray) {
        UIView *view = backdata.data;
        view.frame = nativeExpressAdView.bounds;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFeedAdRenderSuccessFeedAd:Type:)]){
        [self.delegate didFeedAdRenderSuccessFeedAd:self.feedArray Type:2];
    }
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFeedAdRenderFail)]){
        [self.delegate didFeedAdRenderFail];
    }
}

/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gdt_nativeExpressAdViewExposure:)]){
        [self.delegate gdt_nativeExpressAdViewExposure:2];
    }
}

/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAdType:)]){
        [self.delegate didClickedFeedAdType:2];
    }
}

/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(nativeExpressAdClose)]){
        [self.delegate nativeExpressAdClose];
    }
}

/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status{}

/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

#pragma mark - banner
- (UIView *)getGDTBannerADWithAppId:(NSString *)appid PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height isLoop:(BOOL)isLoop autoSwitchInterval:(NSInteger)interval{
    CGRect rect = {CGPointZero, CGSizeMake(width, height)};
    
    if (isLoop) {
        self.guangBannerView = [[GDTUnifiedBannerView alloc] initWithFrame:rect appId:appid placementId:adPlaceId viewController:self.showController];
        self.guangBannerView.autoSwitchInterval = (int)interval;
        self.guangBannerView.animated = YES;
    } else {
        self.guangBannerView = [[GDTUnifiedBannerView alloc] initWithFrame:rect appId:appid placementId:adPlaceId viewController:self.showController];
        self.guangBannerView.autoSwitchInterval = 0;
        self.guangBannerView.animated = NO;
    }
    self.guangBannerView.delegate = self;
    [self.guangBannerView loadAdAndShow];
    return self.guangBannerView;
}
#pragma mark - GDTMobBannerViewDelegate
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
        [self.delegate didLoadBannerAd];
    }
}

// 请求广告条数据失败后调用
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailedLoadBannerAd:Type:)]){
        [self.delegate didFailedLoadBannerAd:error Type:2];
    }
}

// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerAd)]){
        [self.delegate didClickedBannerAd];
    }
}
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didBannerAdExposure)]){
        [self.delegate didBannerAdExposure];
    }
}
// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台

- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{}
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{}
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{}
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView{}
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView{}
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedRemoveBanner)]){
        [self.delegate didClickedRemoveBanner];
    }
}

@end
