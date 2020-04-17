//
//  BURewardedVideoAd.h
//  BUAdSDK
//
//  Copyright © 2018年 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BURewardedVideoAdDelegate;
@class BURewardedVideoModel;

@interface BURewardedVideoAd : NSObject
@property (nonatomic, strong) BURewardedVideoModel *rewardedVideoModel;
@property (nonatomic, weak, nullable) id<BURewardedVideoAdDelegate> delegate;

/**
 Whether material is effective.
 Setted to YES when data is not empty and has not been displayed.
 Repeated display is not billed.
 */
@property (nonatomic, getter=isAdValid, readonly) BOOL adValid;

- (instancetype)initWithSlotID:(NSString *)slotID rewardedVideoModel:(BURewardedVideoModel *)model;
- (void)loadAdData;
- (BOOL)showAdFromRootViewController:(UIViewController *)rootViewController;

@end

@protocol BURewardedVideoAdDelegate <NSObject>

@optional

/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error;

/**
 This method is called when cached successfully.
 */
- (void)rewardedVideoAdVideoDidLoad:(BURewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad slot will be showing.
 */
- (void)rewardedVideoAdWillVisible:(BURewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad slot has been shown.
 */
- (void)rewardedVideoAdDidVisible:(BURewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is about to close.
 */
- (void)rewardedVideoAdWillClose:(BURewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd;

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd;


/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error;

/**
 Server verification which is requested asynchronously is succeeded.
 @param verify :return YES when return value is 2000.
 */
- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify;

/**
 Server verification which is requested asynchronously is failed.
 Return value is not 2000.
 */
- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd;
/**
 This method is called when the user clicked skip button.
 */
- (void)rewardedVideoAdDidClickSkip:(BURewardedVideoAd *)rewardedVideoAd;
@end

NS_ASSUME_NONNULL_END
