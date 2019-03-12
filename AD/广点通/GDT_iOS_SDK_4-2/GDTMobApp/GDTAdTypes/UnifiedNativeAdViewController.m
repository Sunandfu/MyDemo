//
//  UnifiedNativeAdViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2018/10/12.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "UnifiedNativeAdViewInTableViewViewController.h"
#import "UnifiedNativeAdViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
#import "GDTAppDelegate.h"
#import "UnifiedNativeAdViewController.h"

@interface UnifiedNativeAdViewController ()<GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *playVideoOnWWANSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shouldMuteOnVideoSwitch;
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITextField *placementTextField;
@end

@implementation UnifiedNativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadUnifiedNativeAd:(id)sender {
    self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:kGDTMobSDKAppId placementId:self.placementTextField.text];
    self.unifiedNativeAd.delegate = self;
    [self.unifiedNativeAd loadAdWithAdCount:1];
}

- (IBAction)loadUnifiedNativeAdInTableView:(id)sender {
    UnifiedNativeAdViewInTableViewViewController *unifiedNativeAdInTableVC = [[UnifiedNativeAdViewInTableViewViewController alloc] initWithPlacementId:self.placementTextField.text];
    unifiedNativeAdInTableVC.shouldPlayOnWWAN = self.playVideoOnWWANSwitch.on;
    unifiedNativeAdInTableVC.shouldMuteOnVideo = self.shouldMuteOnVideoSwitch.on;
    [self.navigationController pushViewController:unifiedNativeAdInTableVC animated:YES];
}


/**
 拼装三小图类型广告

 @param dataObject 数据对象
 */
- (void)setupThreeImgsAdRelatedViews:(GDTUnifiedNativeAdDataObject *)dataObject
{
    UIView *subView = [self.view viewWithTag:1001];
    if ([subView superview]) {
        [subView removeFromSuperview];
    }
    /*自渲染2.0视图类*/
    GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 2 * 10, 120)];
    unifiedNativeAdView.delegate = self;
    
    /*广告标题*/
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 220, 35)];
    txt.text = dataObject.title;
    [unifiedNativeAdView addSubview:txt];
    
    /*广告Logo*/
    GDTLogoView *logoView = [[GDTLogoView alloc] initWithFrame:CGRectMake(CGRectGetWidth(unifiedNativeAdView.frame) - 54, CGRectGetHeight(unifiedNativeAdView.frame) - 18, 54, 18)];
    [unifiedNativeAdView addSubview:logoView];
    
    /*定义三小图视图*/
    UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(unifiedNativeAdView.frame), 176)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 100, 70)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *image1Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataObject.mediaUrlList[0]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView1.image = [UIImage imageWithData:image1Data];
        });
    });
    [imageContainer addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(130, 0, 100, 70)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *image2Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataObject.mediaUrlList[1]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView2.image = [UIImage imageWithData:image2Data];
        });
    });
    [imageContainer addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(240, 0, 100, 70)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *image3Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataObject.mediaUrlList[2]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView3.image = [UIImage imageWithData:image3Data];
        });
    });
    
    [imageContainer addSubview:imageView3];
    [unifiedNativeAdView addSubview:imageContainer];
    [unifiedNativeAdView registerDataObject:dataObject logoView:logoView viewController:self clickableViews:@[imageContainer]];
    
    unifiedNativeAdView.tag = 1001;
    [self.view addSubview:unifiedNativeAdView];
}


/**
 拼装视频类型广告

 @param dataObject 数据对象
 */
- (void)setupVideoAdRelatedViews:(GDTUnifiedNativeAdDataObject *)dataObject
{
    UIView *subView = [self.view viewWithTag:1001];
    if ([subView superview]) {
        [subView removeFromSuperview];
    }
    
    /*自渲染2.0视图类*/
    GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 2 * 10, 250)];
    unifiedNativeAdView.delegate = self;
    
    /*广告标题*/
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 35)];
    txt.text = dataObject.title;
    [unifiedNativeAdView addSubview:txt];
    
    /*广告Logo*/
    GDTLogoView *logoView = [[GDTLogoView alloc] initWithFrame:CGRectMake(CGRectGetWidth(unifiedNativeAdView.frame) - 54, CGRectGetHeight(unifiedNativeAdView.frame) - 23, 54, 18)];
    [unifiedNativeAdView addSubview:logoView];
    
    /*广告Icon*/
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    NSURL *iconURL = [NSURL URLWithString:dataObject.iconUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            iconV.image = [UIImage imageWithData:iconData];
        });
    });
    [unifiedNativeAdView addSubview:iconV];
    
    /*广告描述*/
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 230, 20)];
    desc.text = dataObject.desc;
    [unifiedNativeAdView addSubview:desc];
    
    /*定义视频媒体视图*/
    GDTMediaView *mediaView = [[GDTMediaView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(unifiedNativeAdView.frame), 176)];
    mediaView.videoMuted = self.shouldMuteOnVideoSwitch.on;
    mediaView.videoAutoPlayOnWWAN = self.playVideoOnWWANSwitch.on;
    [unifiedNativeAdView addSubview:mediaView];
    [unifiedNativeAdView registerDataObject:dataObject mediaView:mediaView logoView:logoView viewController:self clickableViews:@[mediaView]];
    unifiedNativeAdView.tag = 1001;
    [self.view addSubview:unifiedNativeAdView];
}

/**
 拼装图文类型广告

 @param dataObject 数据对象
 */
- (void)setupImageAdRelatedViews:(GDTUnifiedNativeAdDataObject *)dataObject
{
    UIView *subView = [self.view viewWithTag:1001];
    if ([subView superview]) {
        [subView removeFromSuperview];
    }
    
    /*自渲染2.0视图类*/
    GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(10, 180, self.view.frame.size.width - 2 * 10, 250)];
    unifiedNativeAdView.delegate = self;
    
    /*广告标题*/
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 35)];
    txt.text = dataObject.title;
    [unifiedNativeAdView addSubview:txt];
    
    /*广告Logo*/
    GDTLogoView *logoView = [[GDTLogoView alloc] init];
    [unifiedNativeAdView addSubview:logoView];
    
    /*广告Icon*/
    logoView.frame = CGRectMake(CGRectGetWidth(unifiedNativeAdView.frame) - 54, CGRectGetHeight(unifiedNativeAdView.frame) - 23, 54, 18);
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    NSURL *iconURL = [NSURL URLWithString:dataObject.iconUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            iconV.image = [UIImage imageWithData:iconData];
        });
    });
    [unifiedNativeAdView addSubview:iconV];
    
    /*广告描述*/
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 230, 20)];
    desc.text = dataObject.desc;
    [unifiedNativeAdView addSubview:desc];
    
    /*广告详情图*/
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(unifiedNativeAdView.frame), 176)];
    [unifiedNativeAdView addSubview:imgV];
    NSURL *imageURL = [NSURL URLWithString:dataObject.imageUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgV.image = [UIImage imageWithData:imageData];
        });
    });
    [unifiedNativeAdView registerDataObject:dataObject logoView:logoView viewController:self clickableViews:@[imgV]];
    
    unifiedNativeAdView.tag = 1001;
    [self.view addSubview:unifiedNativeAdView];
}

/**
 * 拉取广告的回调，包含成功和失败情况
 */
#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (unifiedNativeAdDataObjects) {
        NSLog(@"成功请求到广告数据");
        GDTUnifiedNativeAdDataObject *dataObject = unifiedNativeAdDataObjects[0];
        if (dataObject.isThreeImgsAd) {
            [self setupThreeImgsAdRelatedViews:dataObject];
        } else if (dataObject.isVideoAd) {
            [self setupVideoAdRelatedViews:dataObject];
        } else {
            [self setupImageAdRelatedViews:dataObject];
        }
    }
    
    if (error.code == 5004) {
        NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    } else if (error.code == 5005) {
        NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    } else if (error.code == 5009) {
        NSLog(@"流量控制导致没有广告，超过小时限额");
    } else if (error.code == 5006) {
        NSLog(@"包名错误");
    } else if (error.code == 5010) {
        NSLog(@"广告样式校验失败");
    } else if (error.code == 3001) {
        NSLog(@"网络错误");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    } else if (error) {
        NSLog(@"ERROR: %@", error);
    }
}

#pragma mark - GDTUnifiedNativeAdViewDelegate
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"广告被点击");
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"广告被曝光");
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"广告详情页已关闭");
}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"广告进入后台");
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView
{
    NSLog(@"广告详情页面即将打开");
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo
{
    NSLog(@"视频广告状态变更");
    switch (status) {
        case GDTMediaPlayerStatusInitial:
            NSLog(@"视频初始化");
            break;
        case GDTMediaPlayerStatusLoading:
            NSLog(@"视频加载中");
            break;
        case GDTMediaPlayerStatusStarted:
            NSLog(@"视频开始播放");
            break;
        case GDTMediaPlayerStatusPaused:
            NSLog(@"视频暂停");
            break;
        case GDTMediaPlayerStatusStoped:
            NSLog(@"视频停止");
            break;
        case GDTMediaPlayerStatusError:
            NSLog(@"视频播放出错");
        default:
            break;
    }
    if (userInfo) {
        long videoDuration = [userInfo[kGDTUnifiedNativeAdKeyVideoDuration] longValue];
        NSLog(@"视频广告长度为 %ld s", videoDuration);
    }
}

@end
