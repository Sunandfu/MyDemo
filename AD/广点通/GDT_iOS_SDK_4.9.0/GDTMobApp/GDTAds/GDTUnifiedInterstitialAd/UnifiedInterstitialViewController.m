//
//  UnifiedInterstitialViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/13.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedInterstitialViewController.h"
#import "GDTUnifiedInterstitialAd.h"
#import "GDTAppDelegate.h"

@interface UnifiedInterstitialViewController () <GDTUnifiedInterstitialAdDelegate>
@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitial;
@property (weak, nonatomic) IBOutlet UILabel *interstitialStateLabel;
@property (weak, nonatomic) IBOutlet UITextField *positionID;
@end

@implementation UnifiedInterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAd:(id)sender {
    if (self.interstitial) {
        self.interstitial.delegate = nil;
    }
    self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithAppId:kGDTMobSDKAppId placementId:self.positionID.text.length > 0? self.positionID.text: self.positionID.placeholder];
    self.interstitial.delegate = self;
    
    [self.interstitial loadAd];
}

- (IBAction)showAd:(id)sender {
    [self.interstitial presentAdFromRootViewController:self];
}

#pragma mark - GDTUnifiedInterstitialAdDelegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Load Success." ];
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@,Error : %@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded.",error ];
    NSLog(@"interstitial fail to load, Error : %@",error);
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
        self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present." ];
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
        self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." ];
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
        self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented." ];
}

/**
 *  当点击下载应用时会调用系统程序打开
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
        self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background." ];
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}
@end
