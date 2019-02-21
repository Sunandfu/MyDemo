//
//  WMDNativeViewController.m
//  WMDemo
//
//  Created by carl on 2017/8/15.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import "WMDNativeViewController.h"

#import <WMAdSDK/WMBannerAdView.h>
#import <WMAdSDK/WMNativeAd.h>
#import "UIImageView+WMNetworking.h"
#import <WMAdSDK/WMNativeAdRelatedView.h>

@interface WMDNativeViewController () <WMNativeAdDelegate>

@property (nonatomic, strong) UIView *customview; // 广告父视图
@property (nonatomic, strong) UILabel *infoLabel; // 标题
@property (nonatomic, strong) UIImageView *imageView; // 图片容器
@property (nonatomic, strong) UIButton *actionButton; // 媒体自定义按钮
@property (nonatomic, strong) WMNativeAd *ad; // 广告物料管理器
@property (nonatomic, strong) UIButton *button; // 刷新按钮
@property (nonatomic, strong) WMNativeAdRelatedView *relatedView; //需添加的广告相关视图

@end

@implementation WMDNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildupView];
    [self loadNativeAd];
}

- (void)buildupView {
    
    CGFloat cusViewWidth = 290;
    CGFloat leftMargin = cusViewWidth/20;
    // 初始化相关视图
    _relatedView = [[WMNativeAdRelatedView alloc] init];
    // Custom 视图测试
    _customview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, cusViewWidth, cusViewWidth)];
    _customview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_customview];
    _customview.frame = CGRectMake(0, 200, self.view.frame.size.width,400);
    
    CGFloat swidth = CGRectGetWidth(_customview.frame);

    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, leftMargin, swidth - leftMargin * 2, 30)];
    _infoLabel.backgroundColor = [UIColor magentaColor];
    _infoLabel.text = @"test ads";
    _infoLabel.adjustsFontSizeToFitWidth = YES;
    [_customview addSubview:_infoLabel];
    
    CGFloat buttonWidth = ceilf((swidth-4 * leftMargin)/3);
    _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_infoLabel.frame), CGRectGetMaxY(_infoLabel.frame)+5, buttonWidth, 30)];
    [_actionButton setTitle:@"自定义按钮" forState:UIControlStateNormal];
    _actionButton.userInteractionEnabled = YES;
    _actionButton.backgroundColor = [UIColor orangeColor];
    _actionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_customview addSubview:_actionButton];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor redColor];
    [_customview addSubview:_imageView];
    
    // 添加视频视图
    [_customview addSubview:self.relatedView.videoAdView];
    // 添加logo视图
    self.relatedView.logoImageView.frame = CGRectZero;
    [_customview addSubview:self.relatedView.logoImageView];
    // 添加dislike按钮
    self.relatedView.dislikeButton.frame = CGRectMake(CGRectGetMaxX(_infoLabel.frame) - 20, CGRectGetMaxY(_infoLabel.frame)+5, 24, 20);
    [_customview addSubview:self.relatedView.dislikeButton];
    // 添加广告标签
    self.relatedView.adLabel.frame = CGRectZero;
    [_customview addSubview:self.relatedView.adLabel];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.button];
    const CGFloat buttonHeight = 36;
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0) {
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.button.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [self.button.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [self.button.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [self.button.heightAnchor constraintEqualToConstant:buttonHeight];
    } else {
        CGFloat height = CGRectGetHeight(self.view.bounds);
        CGFloat width = CGRectGetWidth(self.view.bounds);
        self.button.frame = CGRectMake(0, height - buttonHeight,width , buttonHeight);
    }
    
    [self.button setBackgroundColor:[UIColor orangeColor]];
    [self.button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:NSLocalizedString(@"刷新Native广告", @"刷新Native广告")  forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
}

- (void)loadNativeAd {
    WMNativeAd *nad = [WMNativeAd new];
    WMAdSlot *slot1 = [[WMAdSlot alloc] init];
    WMSize *imgSize1 = [[WMSize alloc] init];
    imgSize1.width = 1080;
    imgSize1.height = 1920;
    slot1.ID = self.viewModel.slotID;
    slot1.AdType = WMAdSlotAdTypeFeed;
    slot1.position = WMAdSlotPositionFeed;
    slot1.imgSize = imgSize1;
    slot1.isSupportDeepLink = YES;
    nad.adslot = slot1;
    
    nad.rootViewController = self;
    nad.delegate = self;
    
    self.ad = nad;
    
    [nad loadAdData];
}

- (void)nativeAdDidLoad:(WMNativeAd *)nativeAd {
    self.infoLabel.text = nativeAd.data.AdDescription;
    WMMaterialMeta *adMeta = nativeAd.data;
    CGFloat contentWidth = CGRectGetWidth(_customview.frame) - 20;
    WMImage *image = adMeta.imageAry.firstObject;
    const CGFloat imageHeight = contentWidth * (image.height / image.width);
    CGRect rect = CGRectMake(10, CGRectGetMaxY(_actionButton.frame) + 5, contentWidth, imageHeight);
    self.relatedView.logoImageView.frame = CGRectMake(CGRectGetMaxX(rect) - 15 , CGRectGetMaxY(rect) - 15, 15, 15);
    self.relatedView.adLabel.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect) - 14, 26, 14);

    // imageMode来决定是否展示视频
    if (adMeta.imageMode == WMFeedVideoAdModeImage) {
        self.imageView.hidden = YES;
        self.relatedView.videoAdView.hidden = NO;
        self.relatedView.videoAdView.frame = rect;
        [self.relatedView refreshData:nativeAd];
    } else {
        self.imageView.hidden = NO;
        self.relatedView.videoAdView.hidden = YES;
        if (adMeta.imageAry.count > 0) {
            if (image.imageURL.length > 0) {
                self.imageView.frame = rect;
                [self.imageView setImageWithURL:[NSURL URLWithString:image.imageURL] placeholderImage:nil];
            }
        }
    }
    
    
    // Register UIView with the native ad; the whole UIView will be clickable.
    [nativeAd registerContainer:self.customview withClickableViews:@[self.infoLabel, self.actionButton]];
}


- (void)nativeAd:(WMNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    
}

- (void)nativeAdDidClick:(WMNativeAd *)nativeAd withView:(UIView *)view {
    NSString *str = NSStringFromClass([view class]);
    NSString *info = [NSString stringWithFormat:@"点击了 %@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"广告" message:info delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (void)nativeAdDidBecomeVisible:(WMNativeAd *)nativeAd {
    
}

- (void)nativeAd:(WMNativeAd *)nativeAd dislikeWithReason:(NSArray<WMDislikeWords *> *)filterWords {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)buttonTapped:(UIButton *)sender {
    [self loadNativeAd];
}

- (void)handleSingleTap {
    
}

- (void)handleSingleTap:(UIView *)view {
    
}

#pragma mark - Banner Delegate


- (void)bannerAdViewDidLoad:(WMBannerAdView * _Nonnull)bannerAdView WithAdmodel:(WMNativeAd *_Nullable)admodel {
    NSLog(@"--------- bannerAdViewDidLoad");
}

- (void)bannerAdViewDidBecomVisible:(WMBannerAdView *_Nonnull)bannerAdView WithAdmodel:(WMNativeAd *_Nullable)admodel {
    NSLog(@"--------- bannerAdViewDidBecomVisible");
}

- (void)bannerAdViewDidClick:(WMBannerAdView *_Nonnull)bannerAdView WithAdmodel:(WMNativeAd *_Nullable)admodel {
    NSLog(@"--------- bannerAdViewDidClick");
}

- (void)bannerAdView:(WMBannerAdView *_Nonnull)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    NSLog(@"--------- didLoadFailWithError");
}

@end
