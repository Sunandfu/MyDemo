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

@interface YXMotivationVideoManager ()<GDTRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;

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
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        } else {
            NSError *errors = [NSError errorWithDomain:@"" code:500 userInfo:@{@"NSLocalizedDescription":[NSString stringWithFormat:@"没有广告资源"]}];
            [self failedError:errors];
        }
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
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAD gdtAD:self.videoAD mediaID:self.mediaId];
        
        self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.rewardVideoAd.delegate = self;
        [self.rewardVideoAd loadAd];
        
    });
}
#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
//    NSLog(@"广告数据加载成功");
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
//    NSLog(@"视频文件加载成功");
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
//    NSLog(@"视频播放页即将打开");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoWillVisible)]) {
        [self.delegate rewardedVideoWillVisible];
    }
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
//    NSLog(@"广告已曝光");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidVisible)]) {
        [self.delegate rewardedVideoDidVisible];
    }
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
//    NSLog(@"广告已关闭");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidClose)]) {
        [self.delegate rewardedVideoDidClose];
    }
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
//    NSLog(@"广告已点击");
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
//    NSLog(@"播放达到激励条件");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rewardedVideoDidPlayFinish:)]) {
        [self.delegate rewardedVideoDidPlayFinish:rewardedVideoAd.adValid];
    }
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
//    NSLog(@"视频播放结束");
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
