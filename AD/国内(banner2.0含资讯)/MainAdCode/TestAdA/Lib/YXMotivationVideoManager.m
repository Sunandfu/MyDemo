//
//  YXMotivationVideoManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/29.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXMotivationVideoManager.h"
#import "NetTool.h"
#import "YXImgUtil.h"
#import "Network.h"
#import "YXLaunchAdConst.h"
#import "GDTRewardVideoAd.h"
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import <BUAdSDK/BUAdSDKManager.h>
#import "AdCompvideo.h"

@interface YXMotivationVideoManager ()<GDTRewardedVideoAdDelegate,BURewardedVideoAdDelegate,AdCompVideoDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;
@property (strong, nonatomic) AdCompVideo *video;

@property (nonatomic, strong) NSDictionary *videoAD;
@property (nonatomic, strong) NSDictionary *currentAD;

@end

@implementation YXMotivationVideoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self videoSDK];
    }
    return self;
}

- (void)loadVideoPlacement{
    WEAK(weakSelf);
    [Network requestADSourceFromMediaId:self.mediaId success:^(NSDictionary *dataDict) {
        weakSelf.videoAD = dataDict ;
        NSArray *advertiser = dataDict[@"advertiser"];
        if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
            [weakSelf initIDSource];
        } else {
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [weakSelf failedError:errors];
        }
    } fail:^(NSError *error) {
        [weakSelf failedError:error];
    }];
}

#pragma mark 分配广告
- (void)initIDSource
{
    NSArray *advertiserArr = self.videoAD[@"advertiser"];
    //    暂时不用priority
    NSMutableArray * mArrPriority = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (NSDictionary *advertiser in advertiserArr) {
        NSString * priority = [NSString stringWithFormat:@"%@",advertiser[@"priority"]];
        [mArrPriority addObject:priority];
    }
    NSArray *afterSortKeyArray = [mArrPriority sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        obj1 = [obj1 lowercaseString];
        obj2 = [obj2 lowercaseString];
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //排序后的列表
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (int index = 0; index < afterSortKeyArray.count; index++) {
        NSString * priority = afterSortKeyArray[index];
        for (NSDictionary *advertiser in advertiserArr) {
            if ([priority isEqualToString:[NSString stringWithFormat:@"%@",advertiser[@"priority"]]]) {
                [valueArray addObject:advertiser];
            }
        }
    }
    
    double random = 1+ arc4random()%99;
    double sumWeight = 0;
    for (int index = 0; index < valueArray.count; index ++ ) {
        NSDictionary *advertiser = valueArray[index];
        sumWeight += [advertiser[@"weight"] doubleValue];
        if (sumWeight >= random) {
            self.currentAD = advertiser;
            break;
        }
    }
    
    if (self.currentAD == nil) {
        NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
        [self failedError:errors];
    }else{
        NSString *name = self.currentAD[@"name"];
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        } else if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        } else if ([name isEqualToString:@"快友"]){
            [self initKuaiyouAD];
        }else{
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [self failedError:errors];
        }
    }
}
#pragma mark - 快有激励视频
- (void)initKuaiyouAD{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
        AdCompVideoType videoType = AdCompVideoTypeInstl;
    //    self.video.enableGPS = YES;                              //根据自己需求设定
        self.video = [AdCompVideo playVideoWithAppId:adplaces[@"appId"] positionId:adplaces[@"adPlaceId"] videoType:videoType delegate:self];
        if (videoType ==  AdCompVideoTypeInstl) {
//            self.video.enableGPS = YES;
            [self.video setInterfaceOrientations:UIInterfaceOrientationPortrait];
        }
        [self.video getVideoAD];
    });
}
#pragma mark - videoDelegate
/*
 * 视频可以开始播放该回调调用后可以调用showVideoWithController:展示视频广告
 */
- (void)adCompVideoIsReadyToPlay:(AdCompVideo*)video{
    [self.video showVideoWithController:self.showAdController];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidLoad:)]) {
        [self.delegate rewardedVideoDidLoad:YES];
    }
}

/*
 * 视频广告播放开始回调
 */
- (void)adCompVideoPlayStarted{
    NSLog(@"视频广告播放开始回调");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidVisible)]) {
        [self.delegate rewardedVideoDidVisible];
    }
}

/*
 * 视频广告播放结束回调
 */
- (void)adCompVideoPlayEnded{
    NSLog(@"视频广告播放结束回调");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidPlayFinish:)]) {
        [self.delegate rewardedVideoDidPlayFinish:YES];
    }
}

/*
 * 视频广告关闭回调
 */
- (void)adCompVideoClosed{
    NSLog(@"视频广告关闭回调");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidClose)]) {
        [self.delegate rewardedVideoDidClose];
    }
}

//***** 两种模式共用部分回调
/*
 * 请求广告数据成功回调
 * @param vastString:贴片模式下返回视频内容字符串(vast协议标准);非贴片模式下返回为nil;
 */
- (void)adCompVideoDidReceiveAd:(NSString *)vastString{
    NSLog(@"请求广告数据成功回调 success = %@",vastString);
}

/*
 * 请求广告数据失败回调
 * @param error:数据加载失败错误信息;(播放失败回调也包含再该回调中)
 */
- (void)adCompVideoFailReceiveDataWithError:(NSError*)error{
    NSLog(@"请求广告数据失败回调 error = %@",error);
    if (error) {
        [self failedError:error];
    }
}

#pragma mark BURewardedVideoAdDelegate  穿山甲激励视频
- (void)initChuanAD{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [self failedError:errors];
            return;
        }
        [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAD gdtAD:self.videoAD mediaID:self.mediaId];
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = @"";
        self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:adplaces[@"adPlaceId"] rewardedVideoModel:model];
        self.rewardedVideoAd.delegate = self;
        [self.rewardedVideoAd loadAdData];
    });
}

- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"激励视频广告-物料-加载成功");
}

- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"激励视频广告-视频-加载成功");
    [self.rewardedVideoAd showAdFromRootViewController:self.showAdController];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidLoad:)]) {
        [self.delegate rewardedVideoDidLoad:rewardedVideoAd.adValid];
    }
}

- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"广告位即将展示");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoWillVisible)]) {
        [self.delegate rewardedVideoWillVisible];
    }
}

- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd{
    NSLog(@"广告位已经展示");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidVisible)]) {
        [self.delegate rewardedVideoDidVisible];
    }
}

- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"激励视频广告关闭");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidClose)]) {
        [self.delegate rewardedVideoDidClose];
    }
}

- (void)rewardedVideoAdDidClickDownload:(BURewardedVideoAd *)rewardedVideoAd{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidClick:)]) {
        [self.delegate rewardedVideoDidClick:rewardedVideoAd.adValid];
    }
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"激励视频广告素材加载失败");
    if (error) {
        [self failedError:error];
    }
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (error) {
        NSLog(@"激励视频广告发生错误");
        [self failedError:error];
    } else {
        NSLog(@"激励视频广告播放完成");
        if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidPlayFinish:)]) {
            [self.delegate rewardedVideoDidPlayFinish:rewardedVideoAd.adValid];
        }
    }
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd {
    NSLog(@"rewarded verify failed");
}

- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@"rewarded verify succeed");
    NSLog(@"verify result: %@", verify ? @"success" : @"fail");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoServerRewardDidSucceedVerify:)]) {
        [self.delegate rewardedVideoServerRewardDidSucceedVerify:verify];
    }
}
#pragma mark - 广点通激励视频
- (void)initGDTAD{
    //配置数据接口。 广点通
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [self failedError:errors];
            return;
        }
        [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAD gdtAD:self.videoAD mediaID:self.mediaId];
        
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.rewardVideoAd.delegate = self;
        [self.rewardVideoAd loadAd];
        
    });
}
#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"广告数据加载成功");
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"视频文件加载成功");
    if (self.rewardVideoAd.expiredTimestamp <= [[NSDate date] timeIntervalSince1970]) {
        NSLog(@"广告已过期，请重新拉取");
        return;
    }
    if (!self.rewardVideoAd.isAdValid) {
        NSLog(@"广告失效，请重新拉取");
        return;
    }
    [self.rewardVideoAd showAdFromRootViewController:self.showAdController];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidLoad:)]) {
        [self.delegate rewardedVideoDidLoad:rewardedVideoAd.adValid];
    }
}

- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"视频播放页即将打开");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoWillVisible)]) {
        [self.delegate rewardedVideoWillVisible];
    }
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"广告已曝光");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidVisible)]) {
        [self.delegate rewardedVideoDidVisible];
    }
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"广告已关闭");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidClose)]) {
        [self.delegate rewardedVideoDidClose];
    }
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"广告已点击");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidClick:)]) {
        [self.delegate rewardedVideoDidClick:rewardedVideoAd.adValid];
    }
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
    }
    NSLog(@"ERROR: %@", error);
    if (error) {
        [self failedError:error];
    }
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"播放达到激励条件");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidPlayFinish:)]) {
        [self.delegate rewardedVideoDidPlayFinish:rewardedVideoAd.adValid];
    }
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"视频播放结束");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidPlayFinish:)]) {
        [self.delegate rewardedVideoDidPlayFinish:rewardedVideoAd.adValid];
    }
}
#pragma mark 失败
- (void)failedError:(NSError*)error
{
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidFailWithError:)]) {
            [self.delegate rewardedVideoDidFailWithError:error];
        }
    }
}

@end
