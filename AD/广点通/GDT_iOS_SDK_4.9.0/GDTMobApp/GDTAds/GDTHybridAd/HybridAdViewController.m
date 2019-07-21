//
//  HybridAdViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "HybridAdViewController.h"
#import "GDTAppDelegate.h"
#import "GDTHybridAd.h"

@interface HybridAdViewController () <GDTHybridAdDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;

@end

@implementation HybridAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickOpenUrl:(id)sender {
    GDTHybridAd *hybridAd = [[GDTHybridAd alloc] initWithAppId:kGDTMobSDKAppId type:GDTHybridAdOptionRewardVideo];
    hybridAd.delegate = self;
    hybridAd.navigationBarColor = [UIColor whiteColor];
    hybridAd.titleFont = [UIFont systemFontOfSize:16];
    [hybridAd loadWithUrl:self.urlTextField.text];
    [hybridAd showWithRootViewController:self];
}

- (void)gdt_hybridAdDidPresented:(GDTHybridAd *)hybridAd
{
    NSLog(@"浏览器展示成功");
}

- (void)gdt_hybridAdDidClose:(GDTHybridAd *)hybridAd
{
    NSLog(@"浏览器关闭");
}

- (void)gdt_hybridAdLoadURLSuccess:(GDTHybridAd *)hybridAd
{
    NSLog(@"URL 加载成功");
}

- (void)gdt_hybridAd:(GDTHybridAd *)hybridAd didFailWithError:(NSError *)error
{
    if ([error code] == 3001) {
        NSLog(@"URL 加载失败");
    }
}


@end
