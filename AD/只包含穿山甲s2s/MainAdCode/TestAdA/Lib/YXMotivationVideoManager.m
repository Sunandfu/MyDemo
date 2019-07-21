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
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import <BUAdSDK/BUAdSDKManager.h>

@interface YXMotivationVideoManager ()<BURewardedVideoAdDelegate>

@property (nonatomic, strong) BURewardedVideoAd *rewardedVideoAd;

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
    [Network requestADSourceFromMediaId:self.mediaId success:^(NSDictionary *dataDict) {
        self.videoAD = dataDict ;
        NSArray *advertiser = dataDict[@"advertiser"];
        if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
            [self initIDSource];
        } else {
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [self failedError:errors];
        }
    } fail:^(NSError *error) {
        [self failedError:error];
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
        if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        }else{
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [self failedError:errors];
        }
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
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAD gdtAD:self.videoAD mediaID:self.mediaId];
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = @"";
        model.isShowDownloadBar = YES;
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
