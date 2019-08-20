//
//  ChuanshanjiaObject.m
//  TestAdA
//
//  Created by lurich on 2019/8/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import "ChuanshanjiaObject.h"
#import "YXLaunchAdManager.h"

@implementation ChuanshanjiaObject

- (void)initChuanADWithAppId:(NSString *)appid Size:(YXADSize)adSize PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height AdCount:(NSInteger)count
{
    [BUAdSDKManager setAppID:appid];
    
    BUAdSlot *slot1 = [[BUAdSlot alloc] init];
    slot1.ID = adPlaceId;
    slot1.AdType = BUAdSlotAdTypeFeed;
    BUSize *imgSize1 ;
    if (adSize == YXADSize288X150) {
        imgSize1 = [BUSize sizeBy:BUProposalSize_Feed228_150];
    }else{
        imgSize1 = [BUSize sizeBy:BUProposalSize_Feed690_388];
    }
    BUSize *imgSize = imgSize1;
    slot1.imgSize = imgSize;
    slot1.position = BUAdSlotPositionFeed;
    slot1.isSupportDeepLink = YES;
    
    // self.nativeExpressAdManager可以重用
    if (!self.nativeExpressAdManager) {
        self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot1 adSize:CGSizeMake(width, height)];
    }
    self.nativeExpressAdManager.adSize = CGSizeMake(width, height);
    self.nativeExpressAdManager.delegate = self;
    [self.nativeExpressAdManager loadAd:count];
}
/**
 * Sent when views successfully load ad
 */
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views{
    
}

/**
 * Sent when views fail to load ad
 */
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error{
    
}

/**
 * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updated
 */
- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView{
    NSLog(@"BU原生模板广告渲染成功");
}

/**
 * This method is called when a nativeExpressAdView failed to render
 */
- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
    NSLog(@"BU原生模板广告渲染失败");
}

/**
 * Sent when an ad view is about to present modal content
 */
- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView{}

/**
 * Sent when an ad view is clicked
 */
- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    
}

/**
 * Sent when a user clicked dislike reasons.
 * @param filterWords : the array of reasons why the user dislikes the ad
 */
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords{}

/**
 * Sent after an ad view is clicked, a ad landscape view will present modal content
 */
- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView{}

@end
