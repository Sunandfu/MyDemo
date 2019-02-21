//
//  BaiduMobAdPrerollNativeViewController.m
//  BaiduMobAdDemoApp
//
//  Created by lishan04 on 16/11/21.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "BaiduMobAdPrerollNativeViewController.h"

#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "BaiduMobAdSDK/BaiduMobAdPrerollNative.h"
#import "BaiduMobAdSDK/BaiduMobAdPrerollNativeAdObject.h"
#import "BaiduMobAdSDK/BaiduMobAdPrerollNativeView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeVideoView.h"
#import "XScreenConfig.h"

@interface BaiduMobAdPrerollNativeViewController () <BaiduMobAdPrerollNativeDelegate>
@property (nonatomic, retain) BaiduMobAdPrerollNative *prerollNativeAd;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) BaiduMobAdPrerollNativeView * nativeAdView;
@end

@implementation BaiduMobAdPrerollNativeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadPrerollNative];
}

//原生样式贴片，返回元素，自定义渲染
- (void)loadPrerollNative {
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
    
    
    if (!self.prerollNativeAd)
    {
        self.prerollNativeAd = [[[BaiduMobAdPrerollNative alloc]init]autorelease];
        self.prerollNativeAd.delegate = self;
        self.prerollNativeAd.publisherId = @"ccb60059";
        self.prerollNativeAd.adId = @"2058633";//需要为视频广告位
        self.prerollNativeAd.width = @320;
        self.prerollNativeAd.height = @240;
    }
    //请求广告
    [self.prerollNativeAd request];
}



-(void)dealloc {
    self.prerollNativeAd.delegate = nil;
    self.prerollNativeAd = nil;
    [super dealloc];
}

-(BOOL) enableLocation {
    return YES;
}

- (void)didDismissLandingPage {
    NSLog(@"didDismissLandingPage");
    
}

#pragma BaiduMobAdPrerollNativeDelegate

- (void)onAdObjectsSuccessLoad:(NSArray *)prerollAds {
    BaiduMobAdPrerollNativeAdObject *object = [prerollAds objectAtIndex:0];
    float statusHeight = 64;
    if (ISIPHONEX) {
        statusHeight = 84;
    }
    self.nativeAdView = [self createPrerollNativeViewWithFrame:CGRectMake(0, statusHeight, 320, 240) object:object];
    if (![object isExpired]) {
        // 加载和显示广告内容
        
        [self.nativeAdView loadAndDisplayAdWithObject:object completion:^(NSArray *errors) {
            [self.nativeAdView trackImpression];
            [self.view addSubview:self.nativeAdView];
            
            if (object.materialType == NORMAL) {
                [self performSelector:@selector(timeAnimation)
                           withObject:self
                           afterDelay:1];
            }
            
        }];
    }
}

- (BaiduMobAdPrerollNativeView *)createPrerollNativeViewWithFrame:(CGRect)frame object:(BaiduMobAdPrerollNativeAdObject *)object {
    BaiduMobAdPrerollNativeView * nativeAdView = nil;
    
    UIImageView *baiduLogoView = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 220, 18, 18)]autorelease];
    UIImageView *adLogoView = [[[UIImageView alloc]initWithFrame:CGRectMake(286, 228, 24, 12)]autorelease];
    
    
    if (object.materialType == VIDEO) {
        BaiduMobAdNativeVideoView *videoView = [[[BaiduMobAdNativeVideoView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) andObject:object]autorelease];
        videoView.supportActImage = NO;
        videoView.supportControllerView = NO;
        nativeAdView = [[BaiduMobAdPrerollNativeView alloc]initWithFrame:frame videoView:videoView];
        
    } else if (object.materialType == NORMAL) {
        
        
        UIImageView *mainImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        nativeAdView = [[BaiduMobAdPrerollNativeView alloc]initWithFrame:frame mainImage:mainImageView];
        [self addTimeLabel:nativeAdView];
        
        
    } else if (object.materialType == GIF) {
        nativeAdView = [[BaiduMobAdPrerollNativeView alloc]initWithFrame:frame mainImage:nil];
        UIWebView *webview = [[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]autorelease];
        webview.backgroundColor = [UIColor redColor];
        NSString *htmlStr = [NSString stringWithFormat:@"%@", @"<html><body><img src='%@'/></body></html>"];
        NSString *imageHTML  = [[[NSString alloc] initWithFormat:htmlStr, object.mainImageURLString]autorelease];
        webview.userInteractionEnabled = NO;
        [webview loadHTMLString:imageHTML baseURL:[NSURL URLWithString:@"file://"]];
        [nativeAdView addSubview:webview];
        // 展现gif物料
    }
    nativeAdView.baiduLogoImageView = baiduLogoView;
    [nativeAdView addSubview:baiduLogoView];
    nativeAdView.adLogoImageView = adLogoView;
    [nativeAdView addSubview:adLogoView];
    
    
    return nativeAdView;
}


- (void)addTimeLabel:(UIView *)baseView {
    self.seconds = 5;
    CGRect rect =
    CGRectMake(baseView.frame.size.width - 30, 5, 20, 15);
    self.timeLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
    self.timeLabel.font = [self.timeLabel.font fontWithSize:12];
    [baseView addSubview:self.timeLabel];
    self.timeLabel.text =
    [NSString stringWithFormat:@"%ld", (long)self.seconds];
}

- (void)timeAnimation {
    if (self.seconds > 1) {
        self.seconds--;
        self.timeLabel.text =
        [NSString stringWithFormat:@"%ld", (long)self.seconds];
        [self performSelector:@selector(timeAnimation)
                   withObject:self
                   afterDelay:1];
        
    } else {
        [self.nativeAdView removeFromSuperview];
    }
}

- (void)onAdsFailLoad:(BaiduMobFailReason) reason {
}


- (void)onAdClicked:(BaiduMobAdBaseNativeAdView*)adView {
    
}

-(void)didDismissLandingPage:(BaiduMobAdBaseNativeAdView *)adView {
}

@end
