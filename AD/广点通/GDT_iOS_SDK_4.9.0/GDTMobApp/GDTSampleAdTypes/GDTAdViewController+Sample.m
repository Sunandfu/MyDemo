//
//  GDTAdViewController+Sample.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/3/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTAdViewController+Sample.h"

@implementation GDTAdViewController (Sample)

- (void)loadView
{
    [super loadView];
    self.demoArray = [@[
                        @[@"Banner", @"BannerViewController"],
                        @[@"插屏", @"InterstitialViewController"],
                        @[@"原生广告", @"NativeViewController"],
                        @[@"开屏广告", @"SplashViewController"],
                        @[@"原生模板广告", @"NativeExpressAdViewController"],
                        @[@"原生视频模板广告", @"NativeExpressVideoAdViewController"],
                        @[@"激励视频广告", @"RewardVideoViewController"],
                        @[@"自渲染2.0", @"UnifiedNativeAdViewController"],
                        @[@"HybridAd", @"HybridAdViewController"],
                        @[@"Banner2.0", @"UnifiedBannerViewController"],
                        @[@"插屏2.0", @"UnifiedInterstitialViewController"],
                        @[@"获取IDFA", @(1)]
                        ] mutableCopy];
}

@end
