//
//  BUDMopub_BannerViewController.m
//  BUAdSDKDemo
//
//  Created by bytedance_yuanhuan on 2018/10/24.
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import "BUDMopub_BannerViewController.h"
#import "MPAdView.h"
#import "BUDNormalButton.h"
#import "BUDMacros.h"

@interface BUDMopub_BannerViewController () <MPAdViewDelegate>
@property(nonatomic, strong) BUDNormalButton *refreshbutton;
@property (nonatomic) MPAdView *adView;
@end

@implementation BUDMopub_BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"ca9c91eb59694afa9caef204ac622136"
                                                size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                   self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    
    //refresh Button
    CGSize size = [UIScreen mainScreen].bounds.size;
    _refreshbutton = [[BUDNormalButton alloc] initWithFrame:CGRectMake(0, size.height *0.2, 0, 0)];
    _refreshbutton.showRefreshIncon = YES;
    [_refreshbutton setTitle:[NSString localizedStringForKey:ShowBanner] forState:UIControlStateNormal];
    [_refreshbutton addTarget:self action:@selector(refreshBanner) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshbutton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.refreshbutton.center = CGPointMake(self.view.center.x, self.view.center.y*1.5);
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view
{
    CGSize size = [view adContentViewSize];
    CGFloat centeredX = (self.view.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = (self.view.bounds.size.height - size.height)/2;
    view.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view {
    BUD_Log(@"%s", __func__);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [self.adView rotateToOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGSize size = [self.adView adContentViewSize];
    CGFloat centeredX = (self.view.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = self.view.bounds.size.height - size.height;
    self.adView.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
}

//refresh按钮
-  (void)refreshBanner {
    [self.adView forceRefreshAd];
}

@end
