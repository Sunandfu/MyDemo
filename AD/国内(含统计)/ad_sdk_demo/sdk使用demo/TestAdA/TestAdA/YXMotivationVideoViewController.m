//
//  YXMotivationVideoViewController.m
//  LunchAd
//
//  Created by shuai on 2018/11/29.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXMotivationVideoViewController.h"

#import <YXLaunchAds/YXLaunchAds.h>

@interface YXMotivationVideoViewController ()<YXMotivationDelegate>

@property (nonatomic,strong) UILabel *statuLabel;
@property (nonatomic, strong) YXMotivationVideoManager * motivationVideo;

@end

@implementation YXMotivationVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"激励视频demo";
    
    [self.view addSubview:self.statuLabel];
    
    self.motivationVideo = [YXMotivationVideoManager new];
    self.motivationVideo.delegate = self;
    self.motivationVideo.showAdController = self;
    self.motivationVideo.isVertical = YES;
    self.motivationVideo.mediaId = @"beta_ios_video";
    
    UIButton *launchScreenBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, [UIScreen mainScreen].bounds.size.width - 100, 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"打开激励视频" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(launchScreenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:launchScreenBtn];
    
    // Do any additional setup after loading the view.
}

- (UILabel *)statuLabel
{
    if (!_statuLabel) {
        _statuLabel = ({
            
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50);
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"点击按钮开始请求视频";
            label;
        });
    }
    return _statuLabel;
}

- (void)launchScreenBtnClicked
{
    //    [self.motivationVideo loadVideoPlacementWithName:@"IAPAbandon"];
    [self.motivationVideo loadVideoPlacement];
}

/**
 adValid 激励视频广告-视频-加载成功
 @param adValid 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
- (void)rewardedVideoDidLoad:(BOOL)adValid{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"激励视频广告-视频-加载成功";
    });
}

/**
 adValid 广告位即将展示
 */
- (void)rewardedVideoWillVisible{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"广告位即将展示";
    });
}

/**
 adValid 广告位已经展示
 */
- (void)rewardedVideoDidVisible{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"广告位已经展示";
    });
}

/**
 adValid 激励视频广告即将关闭
 */
- (void)rewardedVideoWillClose{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"激励视频广告即将关闭";
    });
}

/**
 adValid 激励视频广告已经关闭
 */
- (void)rewardedVideoDidClose{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"激励视频广告已经关闭";
    });
}

/**
 adValid 激励视频广告点击下载
 
 @param adValid 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
- (void)rewardedVideoDidClick:(BOOL)adValid{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"激励视频广告点击下载";
    });
}

/**
 adValid 激励视频广告素材加载失败
 @param error 错误对象
 */
- (void)rewardedVideoDidFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"激励视频广告素材加载失败";
    });
}

/**
 adValid 激励视频广告播放完成
 
 @param adValid 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
- (void)rewardedVideoDidPlayFinish:(BOOL)adValid{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"激励视频广告播放完成";
    });
}

/**
 服务器校验后的结果,异步 adValid publisher 终端返回 20000
 @param verify 有效性验证结果
 */
- (void)rewardedVideoServerRewardDidSucceedVerify:(BOOL)verify{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = [NSString stringWithFormat:@"验证结果有效性->%d",verify];
    });
}

/**
 adValid publisher 终端返回非 20000
 @param error 错误对象
 */
- (void)rewardedVideoServerRewardDidFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = [NSString stringWithFormat:@"终端返回错误->%@",error];
    });
}

- (void)dealloc
{
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
