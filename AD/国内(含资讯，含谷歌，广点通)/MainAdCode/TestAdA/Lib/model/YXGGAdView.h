//
//  YXGGAdView.h
//  LunchAd
//
//  Created by shuai on 2018/9/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXGGAdView : GADUnifiedNativeAdView

@property(nonatomic, strong, nullable) GADUnifiedNativeAd *adNativeAd;

@property (nonatomic,strong) UIImageView *adIconImageView;
@property (nonatomic,strong) UIImageView *adCoverMediaView;

@property (nonatomic,strong) UILabel *headlineLabel;
@property (nonatomic,strong) UILabel *adBodyLabel;
@property (nonatomic,strong) UIButton *adCallToActionButton;
@property (nonatomic,strong) UILabel *adSocialContext;

@end

NS_ASSUME_NONNULL_END
