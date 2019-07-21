//
//  YXGGAdView.m
//  LunchAd
//
//  Created by shuai on 2018/9/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXGGAdView.h"
#import "YXLaunchAdConst.h"

@implementation YXGGAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self customUI];
    }
    return self;
}
- (void)customUI
{
    [self addSubview:self.adCoverMediaView];
    [self addSubview:self.adIconImageView];
    [self addSubview:self.headlineLabel];

    [self addSubview:self.adSocialContext];
    [self addSubview:self.adBodyLabel];
    [self addSubview:self.adCallToActionButton];
    
//    super.mediaView = self.adCoverMediaView;
    super.iconView = self.adIconImageView;
    super.headlineView = self.headlineLabel;
    super.bodyView = self.adBodyLabel;
    super.callToActionView = self.adCallToActionButton;
    super.advertiserView = self.adSocialContext;
    super.nativeAd = self.adNativeAd;
}

//- (void)setMediaView:(GADMediaView *)mediaView
//{
//    [super setMediaView:mediaView];
//    
//}
-(void)setIconView:(UIView *)iconView
{
    [super setIconView:iconView];
    
}
- (void)setHeadlineView:(UIView *)headlineView
{
    [super setHeadlineView:headlineView];
}
- (void)setBodyView:(UIView *)bodyView
{
    [super setBodyView:bodyView];
}
- (void)setCallToActionView:(UIView *)callToActionView
{
    [super setCallToActionView:callToActionView];
}
-(void)setAdvertiserView:(UIView *)advertiserView
{
    [super setAdvertiserView:advertiserView];
}
- (void)setNativeAd:(GADUnifiedNativeAd *)nativeAd
{
    [super setNativeAd:nativeAd];
}

-(UIImageView *)adCoverMediaView
{
    if (!_adCoverMediaView) {
        CGFloat y = 0;
        _adCoverMediaView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, self.frame.size.width , IMAGEHEIGHT - y)];
    }
    _adIconImageView.contentMode =  UIViewContentModeScaleAspectFill;
    _adIconImageView.clipsToBounds = YES;
    return _adCoverMediaView;
}

-(UIImageView *)adIconImageView
{
    if (!_adIconImageView) {
        _adIconImageView = [UIImageView new];
        _adIconImageView.frame = ({
            CGRect frame;
            
            frame = CGRectMake(self.frame.size.width / 2 - 75/2, CGRectGetMaxY(_adCoverMediaView.frame) + 48, WIDTH(75), WIDTH(75));
            frame;
        }); 
        _adIconImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _adIconImageView.clipsToBounds = YES;
        _adIconImageView.layer.masksToBounds = YES;
        _adIconImageView.layer.cornerRadius = 5;
    }
    return _adIconImageView;
}

- (UILabel *)headlineLabel
{
    if (!_headlineLabel) {
        _headlineLabel = [UILabel new];
        _headlineLabel.frame = ({
            CGRect frame;
            frame = CGRectMake(40, CGRectGetMaxY(_adIconImageView.frame) + 20, self.frame.size.width - 80, HEIGHT(40));
            frame;
        });
        _headlineLabel.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0];
        _headlineLabel.font = [UIFont systemFontOfSize:HFont(21) weight:UIFontWeightBold];
        _headlineLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headlineLabel;
}


- (UILabel *)adSocialContext
{
    if (!_adSocialContext) {
        _adSocialContext = [UILabel new];
        _adSocialContext.frame = ({
            CGRect frame;
            frame = CGRectMake(20, CGRectGetMaxY(_headlineLabel.frame) + 15, self.frame.size.width - 40, HEIGHT(35));
            frame;
        });
        _adSocialContext.textColor = [UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:1];
        _adSocialContext.numberOfLines = 2;
        _adSocialContext.font = [UIFont systemFontOfSize:HFont(15) weight:UIFontWeightMedium];
        _adSocialContext.textAlignment = NSTextAlignmentCenter;
    }
    return _adSocialContext;
}

-(UILabel *)adBodyLabel
{
    if (!_adBodyLabel) {
        _adBodyLabel = [UILabel new];
        _adBodyLabel.frame = ({
            CGRect frame;
            frame = CGRectMake(20, CGRectGetMaxY(_adSocialContext.frame) + 15, self.frame.size.width-40, HEIGHT(60));
            frame;
        });
        _adBodyLabel.textColor = [UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:1];
        _adBodyLabel.numberOfLines = 5;
        _adBodyLabel.font = [UIFont systemFontOfSize:HFont(15) weight:UIFontWeightMedium];
        _adBodyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _adBodyLabel;
}
-(UIButton *)adCallToActionButton
{
    if (!_adCallToActionButton) {
        _adCallToActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _adCallToActionButton.frame = ({
            CGRect frame;
            frame = CGRectMake(self.frame.size.width/2  - WIDTH(244)/2 , CGRectGetMaxY(_adBodyLabel.frame) + 20, WIDTH(244), HEIGHT(48));
            frame;
        });
        _adCallToActionButton.backgroundColor = [UIColor redColor];
        [_adCallToActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _adCallToActionButton.layer.cornerRadius = HEIGHT(24);
        _adCallToActionButton.layer.masksToBounds = YES;
        _adCallToActionButton.titleLabel.font = [UIFont systemFontOfSize:HFont(25) weight:UIFontWeightMedium];
        _adCallToActionButton.userInteractionEnabled = NO;
    }
    return _adCallToActionButton;
}

@end
