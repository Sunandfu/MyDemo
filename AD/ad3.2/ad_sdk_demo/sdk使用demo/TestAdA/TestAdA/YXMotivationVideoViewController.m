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
{
    YXMotivationVideoManager * motivationVideo;
    
}

@property (nonatomic,strong) UILabel *statuLabel;

@end

@implementation YXMotivationVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.title = @"激励视频demo";
    
    [self.view addSubview:self.statuLabel];
    
    UIButton *launchScreenBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, [UIScreen mainScreen].bounds.size.width - 100, 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"打开激励视频" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(launchScreenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:launchScreenBtn];
    
    motivationVideo = [YXMotivationVideoManager new];
    motivationVideo.delegate = self;
    
    
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
            label.text = @"点击按钮开始请求广告";
            label;
        });
    }
    return _statuLabel;
}

- (void)launchScreenBtnClicked
{
    [motivationVideo loadVideoPlacementWithName:@"IAPAbandon"];
}


- (void)didConnectSuccess{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"请求成功";
    });
    
}

- (void)didConnectFailed:(NSError *)error
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"请求失败";
    });
}

- (void)videoIsReadyToPlay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"视频准备OK,马上播放";
    });
    [motivationVideo openVideo:self];
}

- (void)videoContentDidAppear
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"视频已经展示";
    });
}
-(void)videoContentDidDisappear
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statuLabel.text = @"视频展示结束";
    });
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
