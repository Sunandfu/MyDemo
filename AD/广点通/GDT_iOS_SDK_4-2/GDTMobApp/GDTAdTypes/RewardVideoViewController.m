//
//  RewardVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2018/9/5.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "RewardVideoViewController.h"
#import "GDTRewardVideoAd.h"
#import "GDTAppDelegate.h"

@interface RewardVideoViewController () <GDTRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
@property (weak, nonatomic) IBOutlet UITextField *portraitPlacementIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) UIInterfaceOrientation supportOrientation;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UIButton *botnButton;

@end

@implementation RewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (IBAction)loadAd:(id)sender {
    if (sender == self.portraitButton) {
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:kGDTMobSDKAppId placementId:self.portraitPlacementIdTextField.text];
    } else {
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:kGDTMobSDKAppId placementId:self.placementIdTextField.text];
    }
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAd];
}

- (IBAction)playVideo:(UIButton *)sender {
    
    if (self.rewardVideoAd.expiredTimestamp <= [[NSDate date] timeIntervalSince1970]) {
        self.statusLabel.text = @"广告已过期，请重新拉取";
        return;
    }
    if (!self.rewardVideoAd.isAdValid) {
        self.statusLabel.text = @"广告失效，请重新拉取";
        return;
    }
    [self.rewardVideoAd showAdFromRootViewController:self];
}

- (IBAction)changeOrientation:(UIButton *)sender {
    // 仅为方便调试提供的逻辑，应用接入流程中不需要程序设置方向
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        self.supportOrientation = UIInterfaceOrientationLandscapeRight;
    } else {
        self.supportOrientation = UIInterfaceOrientationPortrait;
    }
    [[UIDevice currentDevice] setValue:@(self.supportOrientation) forKey:@"orientation"];
}

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    self.statusLabel.text = @"广告数据加载成功";
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    self.statusLabel.text = @"视频文件加载成功";
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"视频播放页即将打开");
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"广告已曝光");
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    self.statusLabel.text = @"广告已关闭";
    NSLog(@"广告已关闭");
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"广告已点击");
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
        self.statusLabel.text = @"请拉取到广告后再调用展示接口";
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
        self.statusLabel.text = @"应用方向与广告位支持方向不一致";
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
        self.statusLabel.text = @"广告已过期";
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
        self.statusLabel.text = @"广告已经播放过，请重新拉取";
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
        self.statusLabel.text = @"视频下载失败";
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
        self.statusLabel.text = @"视频播放失败";
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
        self.statusLabel.text = @"没有合适的广告";
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    }
    NSLog(@"ERROR: %@", error);
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"播放达到激励条件");
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"视频播放结束");
}

@end
