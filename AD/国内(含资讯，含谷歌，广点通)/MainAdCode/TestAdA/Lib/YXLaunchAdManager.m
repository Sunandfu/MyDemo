//
//  YXLaunchAdManager.m
//  YXLaunchAdExample
//
//  Created by shuai on 2018/3/23.
//  Copyright © 2018年 M. All rights reserved.
//  Version 2.3
//  开屏广告初始化 除了金康特专用（金康特用了广点通）

#import "YXLaunchAdManager.h"
#import "YXLaunchAd.h"
#import "Network.h"
#import "NetTool.h"
#import "LaunchAdModel.h"
#import "WXApi.h"

#import "GDTSplashAd.h"
#import "GDTSDKConfig.h"

#import "YXGTMDefines.h"
#import <StoreKit/StoreKit.h>
#import <SafariServices/SafariServices.h>
#import "YXLaunchAdController.h"
#import "YXWebViewController.h"

#import <AdSupport/ASIdentifierManager.h>

#import <GoogleMobileAds/GoogleMobileAds.h>
#import "YXGGAdView.h"
#import <AdSupport/ASIdentifierManager.h>

@interface YXLaunchAdManager()<YXLaunchAdDelegate,YXWebViewDelegate,GADVideoControllerDelegate,GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate,GDTSplashAdDelegate,SKStoreProductViewControllerDelegate>
{
    NSDictionary *_resultDict;
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    
    NSInteger cuttentTime;
    
    BOOL isGDTClicked;
    
    BOOL isOther;
}
@property (nonatomic, strong) NSDictionary *otherDict;
@property ( strong , nonatomic ) GDTSplashAd *splash;
@property (nonatomic,assign) BOOL isgoogleEnd;
@property(nonatomic,copy)dispatch_source_t skipTimer;

@property(nonatomic,copy)dispatch_source_t googleTimer;
@property (nonatomic,strong) YXLaunchAdButton *skipButton;

@property (nonatomic, strong) YXGGAdView *ggAdUIView;
@property (nonatomic, strong) GADAdLoader *adLoader;

@property (nonatomic, retain) UIView *customSplashView;

@property (nonatomic,strong) UIView *yxADView;

@property (nonatomic,strong) UIWindow *showAdWindow;

@property (nonatomic,strong)YXLaunchImageAdConfiguration *imageAdconfiguration;

@property (nonatomic,strong) UIView *skipLeftView;

@end

@implementation YXLaunchAdManager

static YXLaunchAdManager *instance = nil;

+(instancetype)shareManager
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[YXLaunchAdManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)setLaunch
{
    _gdtAD = nil;
    _currentAD = nil;
    isGDTClicked = NO;
    isOther = NO;
    
    [YXLaunchAd setLaunchSource];
    
    [YXLaunchAd setWaitDataDuration:self.waitDataDuration];
    
    [YXLaunchAd shareLaunchAd].delegate = self;
    if (nil!=[YXAdSDKManager defaultManager].kpCustomView) {
        self.skipLeftView = [YXAdSDKManager defaultManager].kpCustomView;
    }
    self.yxADView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.yxADView.userInteractionEnabled = YES;
    
}


- (void)setContentMode:(UIViewContentMode)contentMode
{
    _contentMode = contentMode;
}

- (void)loadLaunchAdWithShowAdWindow:(UIWindow *)showAdWindow
{
    
    [self setLaunch];
    
    self.showAdWindow = showAdWindow;
    
    [self requestADSource];
    
    //配置广告数据
    _imageAdconfiguration = [YXLaunchImageAdConfiguration new];
    _imageAdconfiguration.imageOption = self.imageOption;
    _imageAdconfiguration.contentMode = self.contentMode;
    _imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
    _imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimateTime;
    _imageAdconfiguration.skipButtonType = self.skipButtonType;
    
}


- (void)requestADSource
{
    [self requestADSourceFromNet];
}

#pragma mark 分配广告
- (void)initIDSource
{
    NSArray *advertiserArr = _gdtAD[@"advertiser"];
    
    //    暂时不用priority
    NSMutableArray * mArrPriority = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (NSDictionary *advertiser in advertiserArr) {
        NSString * priority = [NSString stringWithFormat:@"%@",advertiser[@"priority"]];
        [mArrPriority addObject:priority];
    }
    NSArray *afterSortKeyArray = [mArrPriority sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        obj1 = [obj1 lowercaseString];
        obj2 = [obj2 lowercaseString];
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //排序后的列表
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (int index = 0; index < afterSortKeyArray.count; index++) {
        NSString * priority = afterSortKeyArray[index];
        for (NSDictionary *advertiser in advertiserArr) {
            if ([priority isEqualToString:[NSString stringWithFormat:@"%@",advertiser[@"priority"]]]) {
                [valueArray addObject:advertiser];
            }
        }
    }
    
    double random = 1+ arc4random()%99;
    
    double sumWeight = 0;
    
    for (int index = 0; index < valueArray.count; index ++ ) {
        NSDictionary *advertiser = valueArray[index];
        sumWeight += [advertiser[@"weight"] doubleValue];
        if (sumWeight >= random) {
            _currentAD = advertiser;
            break;
        }
    }
    if (valueArray.count>1) {
        isOther = YES;
        for (int index = 0; index < valueArray.count; index ++ ) {
            NSDictionary *advertiser = valueArray[index];
            if (![advertiser isEqualToDictionary:_currentAD]) {
                self.otherDict = advertiser;
            }
        }
    }
    
    if (_currentAD == nil) {
        [self initS2S];
    }else{
        NSString *name = _currentAD[@"name"];
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        }else if ([name isEqualToString:@"Google"]){
            [self initGGNativeAd];
        } else {
            [self initS2S];
        }
    }
}
#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    WEAK(weakSelf);
    [Network requestADSourceFromMediaId:self.mediaId success:^(NSDictionary *dataDict) {
        self->_gdtAD = dataDict ;
        NSArray *adInfosArr = dataDict[@"adInfos"];
        if (adInfosArr.count>0) {
            self->_resultDict = adInfosArr.firstObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showLaunchAd];
            });
            return ;
        }
        NSArray *advertiser = dataDict[@"advertiser"];
        if(advertiser && ![advertiser isKindOfClass:[NSNull class]] && advertiser.count > 0){
            [weakSelf initIDSource];
        }else{
            [weakSelf initS2S];
        }
    } fail:^(NSError *error) {
        [weakSelf failedError:error];
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark 谷歌原生
- (void)initGGNativeAd
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [YXLaunchAd shareLaunchAd].adWindow;
        
        UIViewController *topRootViewController = window.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
//        GADMultipleAdsAdLoaderOptions *multipleAdsOptions =
//        [[GADMultipleAdsAdLoaderOptions alloc] init];
//        multipleAdsOptions.numberOfAds = 1;
        
//        GADNativeAdViewAdOptions *adViewOptions = [[GADNativeAdViewAdOptions alloc] init];
//        adViewOptions.preferredAdChoicesPosition = GADAdChoicesPositionBottomLeftCorner;
        
        GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
        videoOptions.startMuted = NO;
        
#if GOGoogle
        
        [GADMobileAds configureWithApplicationID:@"ca-app-pub-3940256099942544~1458002511"];
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/3986624511"
                                           rootViewController:topRootViewController
                                                      adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
                                                      options:@[ videoOptions,adViewOptions ]];
#else
        
        NSDictionary *adplaces = [self->_currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
//        [GADMobileAds configureWithApplicationID:adplaces[@"appId"]];
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:adplaces[@"adPlaceId"]
                                           rootViewController:topRootViewController adTypes:@[kGADAdLoaderAdTypeUnifiedNative]
                                                      options:@[videoOptions]];
        
#endif
        self.adLoader.delegate = self;
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ kGADSimulatorID ];
        [self.adLoader loadRequest:request];
        
        
        
//        [self.ggAdUIView setTranslatesAutoresizingMaskIntoConstraints:YES];
        
        self.ggAdUIView = [[YXGGAdView alloc] initWithFrame:self.frame];
        
        
//        self.ggAdUIView.userInteractionEnabled = YES;
        
        
        [self.yxADView addSubview:self.ggAdUIView];
        
        if (self.bottomView) {
            [self.yxADView addSubview:self.bottomView];
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId ];
        
        
    });
}
#pragma mark GADAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:_currentAD]) {
            _currentAD = self.otherDict;
            isOther = NO;
            [self initGDTAD];
        }
    } else {
        [self initS2S];
    }
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"101%ld",(long)error.code] msg:[NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]] currentAD:_currentAD gdtAD:_gdtAD mediaID:self.mediaId];
}

#pragma mark GADUnifiedNativeAdLoaderDelegate implementation

- (void)adLoader:(GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        GADUnifiedNativeAdView *nativeAdView = self.ggAdUIView;
        
        // Deactivate the height constraint that was set when the previous video ad loaded.
        
        self.ggAdUIView.nativeAd = nativeAd;
        nativeAd.delegate = self;
        if (nativeAd.images.count>0) {
            GADNativeAdImage *imgModel = [nativeAd.images firstObject];
            ((UIImageView *)self.ggAdUIView.adCoverMediaView).image = imgModel.image;
        } else {
            if (nativeAd.icon != nil) {
                ((UIImageView *)self.ggAdUIView.adIconImageView).image = nativeAd.icon.image;
            }
        }
//        self.ggAdUIView.adCoverMediaView.frame = CGRectMake(0, 0, self.frame.size.width, IMAGEHEIGHT);
        ((UILabel *)self.ggAdUIView.headlineLabel).text = nativeAd.headline;
        ((UILabel *)self.ggAdUIView.adBodyLabel).text = nativeAd.body;
        [((UIButton *)self.ggAdUIView.adCallToActionButton) setTitle:nativeAd.callToAction forState:UIControlStateNormal];

        ((UILabel *)self.ggAdUIView.adSocialContext).text = nativeAd.advertiser;
        if (nativeAd.advertiser) {
            self.ggAdUIView.adSocialContext.hidden = NO;
        } else {
            self.ggAdUIView.adSocialContext.hidden = YES;
        }
        ((UIImageView *)self.ggAdUIView.adIconImageView).image = nativeAd.icon.image;
        
        if (nativeAd.icon != nil) {
            self.ggAdUIView.adIconImageView.hidden = NO;
        } else {
            self.ggAdUIView.adIconImageView.hidden = YES;
        }
        self.ggAdUIView.adCallToActionButton.userInteractionEnabled = NO;
        
//        [nativeAd registerAdView:self.ggAdUIView clickableAssetViews:@{GADUnifiedNativeCallToActionAsset:self.ggAdUIView} nonclickableAssetViews:@{GADUnifiedNativeBodyAsset:self.ggAdUIView.adBodyLabel}];
        //配置广告数据
        YXLaunchImageAdConfiguration *imageAdconfiguration = [YXLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = self.duration;
        imageAdconfiguration.showEnterForeground = NO;
        //广告frame
        imageAdconfiguration.frame = self.frame;
        
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为YXLaunchAdImageCacheInBackground,先缓存,下次显示
        imageAdconfiguration.imageOption = self.imageOption;
        //图片填充模式
        imageAdconfiguration.contentMode = self.contentMode;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        //                imageAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
        //广告显示完成动画时间
        imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimate;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = self.skipButtonType;
        //start********************自定义跳过按钮**************************
        imageAdconfiguration.customSkipView = nil;
        //********************自定义广告*****************************end
        [YXLaunchAd shareLaunchAd].isCustomAdView = YES;
        [YXLaunchAd shareLaunchAd].customAdView = self.yxADView;
        //显示开屏广告
        [YXLaunchAd customImageViewWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadAdSuccess)]) {
            [self.delegate didLoadAdSuccess];
        }
    });
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:_currentAD gdtAD:_gdtAD mediaID:self.mediaId];
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    
}
- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    if (cuttentTime > 1) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedAd)]){
            [self.delegate didClickedAd];
        }
        [[YXLaunchAd shareLaunchAd] cancleSkip];
        [[YXLaunchAd shareLaunchAd] removeAndAnimate];
        [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:_currentAD gdtAD:_gdtAD mediaID:self.mediaId];
    }
}
- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd
{
    [[YXLaunchAd shareLaunchAd] cancleSkip];
    [[YXLaunchAd shareLaunchAd] removeAndAnimate];
}
- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd
{
    
}
- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd
{
    
}
- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd
{
    //admob view 没有点击回调 在离开app的时候回调 点击
    if (cuttentTime > 1) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedAd)]){
            [self.delegate didClickedAd];
        }
        [[YXLaunchAd shareLaunchAd] cancleSkip];
        [[YXLaunchAd shareLaunchAd] removeAndAnimate];
        [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:_currentAD gdtAD:_gdtAD mediaID:self.mediaId];
    }
}

#pragma mark 广点通
- (void)initGDTAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self->_currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId ];
        self->isGDTClicked = NO;
        
        [[YXLaunchAd shareLaunchAd] setCusAdConfi: self->_imageAdconfiguration];
        
        self->cuttentTime = 5;
        //        self.splash = [[GDTSplashAd alloc] initWithAppId:adplaces[@"appId"] placementId:@"2123"];
        
        self.splash = [[GDTSplashAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.splash.delegate = self;
        
        UIImage *launchImage = [NetTool getLauchImage];
        self.splash.backgroundColor = [UIColor colorWithPatternImage:launchImage];
        
        self.splash.fetchDelay = self.waitDataDuration;
        
//                UIWindow *window = [YXLaunchAd shareLaunchAd].adWindow;
//
//                [window makeKeyAndVisible];
        
        UIWindow *window = self.showAdWindow;
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:launchImage];
        UIImage * images = [NetTool snapshotScreenInView:imageView WithFrame:self.bottomView.frame];
        UIImageView * bottoms = [[UIImageView alloc]initWithFrame:self.bottomView.frame];
        bottoms.image = images;
        [bottoms addSubview:self.bottomView];
        
        YXLaunchAdButton *button = [YXLaunchAd shareLaunchAd].skipButton;
        
        if ([YXAdSDKManager defaultManager].kpCustomView) {
            self.skipLeftView.autoresizesSubviews =YES;
            for (UIView *view in self.skipLeftView.subviews) {
                view.autoresizingMask =
                UIViewAutoresizingFlexibleLeftMargin   |
                UIViewAutoresizingFlexibleWidth        |
                UIViewAutoresizingFlexibleRightMargin  |
                UIViewAutoresizingFlexibleTopMargin    |
                UIViewAutoresizingFlexibleHeight       |
                UIViewAutoresizingFlexibleBottomMargin ;
            }
            CGFloat topBottomSpace = [button getTopBottomSpace];
            CGFloat viewHeight = button.frame.size.height-topBottomSpace*2;
            CGFloat viewWidth = self.skipLeftView.bounds.size.width * viewHeight / self.skipLeftView.bounds.size.height;
            button.frame = CGRectMake(button.frame.origin.x-viewWidth-8, button.frame.origin.y, button.bounds.size.width, button.bounds.size.height);
            self.skipLeftView.frame = CGRectMake(button.frame.origin.x+button.bounds.size.width+8, button.frame.origin.y+topBottomSpace, viewWidth, viewHeight);
            self.skipLeftView.layer.masksToBounds = YES;
            self.skipLeftView.layer.cornerRadius = viewHeight / 2.0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewClick)];
            [self.skipLeftView addGestureRecognizer:tap];
            [window addSubview:self.skipLeftView];
            
            if (self.bottomView) {
                [self.splash loadAdAndShowInWindow:window withBottomView:bottoms skipView:button];
            }else{
                [self.splash loadAdAndShowInWindow:window withBottomView:self.bottomView skipView:button];
            }
        } else {
            if (self.bottomView) {
                [self.splash loadAdAndShowInWindow:window withBottomView:bottoms skipView:button];
            }else{
                [self.splash loadAdAndShowInWindow:window withBottomView:self.bottomView skipView:button];
            }
        }
        [[YXLaunchAd shareLaunchAd] startSkipDispathTimer];
        
    });
}
-(void)splashAdLifeTime:(NSUInteger)time
{
//    NSLog(@"splashAdLifeTime:%lu",(unsigned long)time);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 开发者在该回调函数中对传入的URL进行分析，展示详情页面。
    return YES;
}
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    dispatch_async(dispatch_get_main_queue(), ^{
        [YXLaunchAd shareLaunchAd].adWindow.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadAdSuccess)]) {
            [self.delegate didLoadAdSuccess];
        }
    });
}


#pragma mark 40043 广点通 splashAdFail
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:_currentAD]) {
            _currentAD = self.otherDict;
            isOther = NO;
            [self initGGNativeAd];
        }
    } else {
        [self initS2S];
    }
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg:[NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}

#pragma mark 广点通的结束
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    //    NSLog(@"splashAdWillClosed;%s",__FUNCTION__);
    [self.skipLeftView removeFromSuperview];
    self.skipLeftView = nil;
    
}
-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    //    NSLog(@"splashAdClosed;%s",__FUNCTION__);
    //    NSLog(@"self->cuttentTime:%ld",self->cuttentTime);
    self.splash = nil;
    
    if (isGDTClicked) {
        [[YXLaunchAd shareLaunchAd] cancleSkip];
        [[YXLaunchAd shareLaunchAd] removeAndAnimate];
    }else{
        if (cuttentTime > 1) {
            [[YXLaunchAd shareLaunchAd] cancleSkip];
            [[YXLaunchAd shareLaunchAd] removeAndAnimate];
            [self skipBtnClicked];
        }
    }
    
    
}
- (void)customViewClick{
    [self.skipLeftView removeFromSuperview];
    self.skipLeftView = nil;
    self.splash = nil;
    [[YXLaunchAd shareLaunchAd] cancleSkip];
    [[YXLaunchAd shareLaunchAd] removeAndAnimate];
    [[NetTool getCurrentViewController] dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMCLICKNOTIFITION object:nil];
    }];
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    [self.skipLeftView removeFromSuperview];
    self.skipLeftView = nil;
    self.splash = nil;
    [[YXLaunchAd shareLaunchAd] cancleSkip];
    [[YXLaunchAd shareLaunchAd] removeAndAnimate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[YXLaunchAd shareLaunchAd]cancleSkip];
        self->isGDTClicked = YES;
        [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedAd)]){
            
            [self.delegate didClickedAd];
        }
    });
    
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    
}


- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    [self backClicked];
}

#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [self setupYXLaunchAd];
}

-(void)setupYXLaunchAd{
    
    /** 1.图片开屏广告 - 网络数据 */
    [self example01];
}

#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据 s2s
-(void)example01{
    
    NSString *ip = [Network sharedInstance].ipStr;
    
    if (_gdtAD.allKeys.count == 0) {
        NSError *error = [NSError errorWithDomain:@"" code:40041 userInfo:@{@"NSLocalizedDescription":@"请检查网络"}];
        [self failedError:error];
        return;
    }
    NSString * uuid = self->_gdtAD[@"uuid"];
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:self.mediaId width:_frame.size.width height:_frame.size.height macID:ip uid:uuid adCount:1];
    
    WEAK(weakSelf);
    //广告数据请求
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                
                NSArray * arr = json[@"adInfos"];
                if (arr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                self->_resultDict = arr.lastObject;
                
                if ([json objectForKey:@"data"]) {
                    if ([[json objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *muarray = [json objectForKey:@"data"];
                        if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
                        {
                            NSArray *viewS = muarray;
                            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                                //                                [self groupNotifyToSerVer:viewS];
                            }
                        }
                    }
                }
                [weakSelf showLaunchAd];
                
            }else{
                NSError *error = [NSError errorWithDomain:@"" code:40041 userInfo:@{@"NSLocalizedDescription":@"请检查网络"}];
                [weakSelf failedError:error];
                
            }
        }else{
            NSError *error = [NSError errorWithDomain:@"" code:40041 userInfo:@{@"NSLocalizedDescription":@"请检查网络"}];
            [weakSelf failedError:error];
        }
        
    }];
}

- (void)showLaunchAd{
    //配置广告数据
    YXLaunchImageAdConfiguration *imageAdconfiguration = [YXLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = self->_duration;
    imageAdconfiguration.showEnterForeground = NO;
    //广告frame
    imageAdconfiguration.frame = self->_frame;
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = self->_resultDict[@"img_url"];
    //设置GIF动图是否只循环播放一次(仅对动图设置有效)
    imageAdconfiguration.GIFImageCycleOnce = NO;
    //缓存机制(仅对网络图片有效)
    //为告展示效果更好,可设置为YXLaunchAdImageCacheInBackground,先缓存,下次显示
    imageAdconfiguration.imageOption = self.imageOption;
    //图片填充模式
    imageAdconfiguration.contentMode = self.contentMode;
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    //                imageAdconfiguration.openModel = model.openUrl;
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimate;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = self.skipButtonType;
    //start********************自定义跳过按钮**************************
    imageAdconfiguration.customSkipView = nil;
    imageAdconfiguration.addSkipLeftView = self.skipLeftView;
    //********************自定义跳过按钮*****************************end
    
    //显示开屏广告
    [YXLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration bottomView:self.bottomView delegate:self];
}
#pragma mark 失败
- (void)failedError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(didFailedLoadAd:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self remove];
            [[YXLaunchAd shareLaunchAd]failedRemove];
        });
        [_delegate didFailedLoadAd:error];
    }
}

#pragma mark - 视频开屏广告-网络数据-示例
//视频开屏广告 - 网络数据
-(void)example03{
    
    //    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    //    [YXLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //
    //    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    //    [YXLaunchAd setWaitDataDuration:3];
    //
    //    //广告数据请求
    //    [Network getLaunchAdVideoDataSuccess:^(NSDictionary * response) {
    //
    //
    //        //广告数据转模型
    //        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
    //
    //        //配置广告数据
    //        YXLaunchVideoAdConfiguration *videoAdconfiguration = [YXLaunchVideoAdConfiguration new];
    //        //广告停留时间
    //        videoAdconfiguration.duration = model.duration;
    //        //广告frame
    //        videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //        //广告视频URLString/或本地视频名(请带上后缀)
    //        //注意:视频广告只支持先缓存,下次显示(看效果请二次运行)
    //        videoAdconfiguration.videoNameOrURLString = model.content;
    //        //是否关闭音频
    //        videoAdconfiguration.muted = NO;
    //        //视频缩放模式
    //        videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //        //是否只循环播放一次
    //        videoAdconfiguration.videoCycleOnce = NO;
    //        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    //        videoAdconfiguration.openModel = model.openUrl;
    //        //广告显示完成动画
    //        videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //        //广告显示完成动画时间
    //        videoAdconfiguration.showFinishAnimateTime = 0.8;
    //        //后台返回时,是否显示广告
    //        videoAdconfiguration.showEnterForeground = NO;
    //        //跳过按钮类型
    //        videoAdconfiguration.skipButtonType = SkipTypeTimeText;
    //        //视频已缓存 - 显示一个 "已预载" 视图 (可选)
    //        if([YXLaunchAd checkVideoInCacheWithURL:[NSURL URLWithString:model.content]]){
    //            //设置要添加的自定义视图(可选)
    //            videoAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
    //
    //        }
    //
    //        [YXLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
}


#pragma mark - 批量下载并缓存
/**
 *  批量下载并缓存图片
 */
-(void)batchDownloadImageAndCache{
    
    //    [YXLaunchAd downLoadImageAndCacheWithURLArray:@[[NSURL URLWithString:imageURL1],[NSURL URLWithString:imageURL2],[NSURL URLWithString:imageURL3],[NSURL URLWithString:imageURL4],[NSURL URLWithString:imageURL5]] completed:^(NSArray * _Nonnull completedArray) {
    //
    //        /** 打印批量下载缓存结果 */
    //
    //        //url:图片的url字符串,
    //        //result:0表示该图片下载失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
    //    }];
}

/**
 *  批量下载并缓存视频
 */
-(void)batchDownloadVideoAndCache{
    
    //    [YXLaunchAd downLoadVideoAndCacheWithURLArray:@[[NSURL URLWithString:videoURL1],[NSURL URLWithString:videoURL2],[NSURL URLWithString:videoURL3]] completed:^(NSArray * _Nonnull completedArray) {
    //
    //        /** 打印批量下载缓存结果 */
    //
    //        //url:视频的url字符串,
    //        //result:0表示该视频下载失败,1表示该视频下载并缓存完成或本地缓存中已有该视频
    //
    //    }];
    
}

#pragma mark - subViews
-(NSArray<UIView *> *)launchAdSubViews_alreadyView{
    
    CGFloat y = SF_iPhoneXStyle ? 46:22;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, y, 60, 30)];
    label.text  = @"已预载";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}

-(NSArray<UIView *> *)launchAdSubViews{
    
    CGFloat y = SF_iPhoneXStyle ? 54 : 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-170, y, 60, 30)];
    label.text  = @"subViews";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
}

#pragma mark - 手动移除广告Action
/**
 手动移除广告
 
 @param animated 是否需要动画
 */
+(void)removeAndAnimated:(BOOL)animated
{
    [YXLaunchAd removeAndAnimated:animated];
}
#pragma mark - YXLaunchAd delegate - 倒计时回调
/**
 *  倒计时回调
 *
 *  @param launchAd YXLaunchAd
 *  @param duration 倒计时时间
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration{
    cuttentTime = duration;
    if (duration > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customSkipDuration:)]) {
            [self.delegate customSkipDuration:duration];
        }
    }
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - YXLaunchAd delegate - 其他
/**
 广告点击事件回调
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    //     if(openModel==nil) return;
    NSString * x =  [NSString stringWithFormat:@"%f",clickPoint.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",clickPoint.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%.0f",_frame.size.width];
    NSString *heightStr = [NSString stringWithFormat:@"%.0f",_frame.size.height];
    
    //    NSString *dicStr =  [NSString stringWithFormat:@"{%@:%@,%@:%@,%@:%@,%@:%@}",@"down_x",x,@"down_y",y,@"up_x",x,@"up_y",y];
    if(!_resultDict){
        return;
    }
    
    [self ViewClickWithDict:_resultDict Width:widthStr Height:heightStr X:x Y:y];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAd)]) {
        [self.delegate didClickedAd];
    }
}
#pragma mark 落地页返回
- (void)backClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAdShowReturn)]) {
        [self.delegate didAdShowReturn];
    }
}

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  YXLaunchAd
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData{
    
    [self groupNotify];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadAdSuccess)]) {
        [self.delegate didLoadAdSuccess];
    }
}

/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd YXLaunchAd
 *  @param pathURL  视频保存在本地的path
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL{
    
}

/**
 *  视频下载进度回调
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current{
    
}
/**
 移除视图
 */
- (void)remove
{
    if (self.customSkipView) [self.customSkipView removeFromSuperview];
    if (self.skipLeftView) {
        [self.skipLeftView removeFromSuperview];
        self.skipLeftView = nil;
    }
    if (self.skipButton)[self.skipButton removeFromSuperview];
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
        self.bottomView = nil;
    }
    if (self.yxADView) {
        [self.yxADView removeFromSuperview];
        self.yxADView = nil;
    }
}
/**
 *  广告显示完成
 */
-(void)YXLaunchAdShowFinish:(YXLaunchAd *)launchAd{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LaunchShowFinish)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self remove];
            
            [self.delegate LaunchShowFinish];
        });
        
    }
}
- (void)YXLaunchAdShowFailed
{
    NSError *errors = [NSError errorWithDomain:@"" code:7423 userInfo:@{@"NSLocalizedDescription":@"请求超时"}];
    
    if (self.splash) {//GDT
        self.splash.delegate = nil;
        errors = [NSError errorWithDomain:@"" code:2017423 userInfo:@{@"NSLocalizedDescription":@"请求超时"}];
    }
    
    [self failedError:errors];
}
-(void)skipBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lunchADSkipButtonClick)]) {
        [self.delegate lunchADSkipButtonClick];
    }
}
-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSArray *viewS = _resultDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}

@end
