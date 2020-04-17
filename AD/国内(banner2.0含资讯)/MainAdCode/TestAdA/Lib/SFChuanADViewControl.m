//
//  ChuanshanjiaObject.m
//  TestAdA
//
//  Created by lurich on 2019/8/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import "SFChuanADViewControl.h"

@interface SFChuanADViewControl ()

@property (nonatomic, strong) BUNativeExpressAdManager *nativeExpressAdManager;
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic) CGSize tmpSize;

@property (nonatomic, strong) BUNativeExpressBannerView *chuanBannerView;

@end

@implementation SFChuanADViewControl

+ (instancetype)defaultManger{
    static dispatch_once_t onceToken;
    static SFChuanADViewControl *chuanInstance;
    dispatch_once(&onceToken, ^{
        if(chuanInstance == nil)
            chuanInstance = [[SFChuanADViewControl alloc] init];
    });
    return chuanInstance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)feedArray{
    if (_feedArray==nil) {
        _feedArray = [NSMutableArray array];
    }
    return _feedArray;
}
- (void)getChuanADWithAppId:(NSString *)appid Size:(YXADSize)adSize PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height AdCount:(NSInteger)count
{
    [self.feedArray removeAllObjects];
    [BUAdSDKManager setAppID:appid];
    self.tmpSize = CGSizeMake(width, height);
    
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
    if (views.count > 0) {
        for (int index = 0; index < views.count; index ++ ) {
            BUNativeExpressAdView *expressView = views[index];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tmpSize.width, self.tmpSize.height)];
            expressView.rootViewController = self.showController;
            [expressView render];
            [view addSubview:expressView];
            view.contentMode = UIViewContentModeScaleToFill;
            YXFeedAdData *backdata = [YXFeedAdData new];
            backdata.adID = index;
            backdata.adType = 3;
            backdata.adID = [[NSDate date] timeIntervalSince1970]*1000;
            backdata.data = view;
            [self.feedArray addObject:backdata];
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:Type:)]){
            [self.delegate didLoadFeedAd:self.feedArray Type:3];
        }
    }
}

/**
 * Sent when views fail to load ad
 */
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailedLoadFeedAd:Type:)]) {
        [self.delegate didFailedLoadFeedAd:error Type:3];
    }
}

/**
 * This method is called when rendering a nativeExpressAdView successed, and nativeExpressAdView.size.height has been updatedBU原生模板广告渲染成功
 */
- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView{
    for (YXFeedAdData *backdata in self.feedArray) {
        UIView *view = backdata.data;
        view.frame = nativeExpressAdView.bounds;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFeedAdRenderSuccessFeedAd:Type:)]){
        [self.delegate didFeedAdRenderSuccessFeedAd:self.feedArray Type:2];
    }
}

/**
 * This method is called when a nativeExpressAdView failed to renderBU原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFeedAdRenderFail)]) {
        [self.delegate didFeedAdRenderFail];
    }
}

/**
 * Sent when an ad view is about to present modal content
 */
- (void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView{}

/**
 * Sent when an ad view is clicked
 */
- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAdType:)]) {
        [self.delegate didClickedFeedAdType:3];
    }
}

/**
 * Sent when a user clicked dislike reasons.
 * @param filterWords : the array of reasons why the user dislikes the ad
 */
- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nativeExpressAdClose)]) {
        [self.delegate nativeExpressAdClose];
    }
}

/**
 * Sent after an ad view is clicked, a ad landscape view will present modal content
 */
- (void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView{}

#pragma mark - banner  BUBannerAdViewDelegate implementation

- (UIView *)getChuanBannerADWithAppId:(NSString *)appid PlaceId:(NSString *)adPlaceId Width:(CGFloat)width Height:(CGFloat)height isLoop:(BOOL)isLoop autoSwitchInterval:(NSInteger)interval{
    
    [BUAdSDKManager setAppID:appid];
    [BUAdSDKManager setIsPaidApp:NO];
#if DEBUG
    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
#endif
    
    BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_150];
    
    if (isLoop) {
        self.chuanBannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:adPlaceId rootViewController:self.showController imgSize:imgSize adSize:CGSizeMake(width, height) IsSupportDeepLink:YES interval:interval];
    } else {
        self.chuanBannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:adPlaceId rootViewController:self.showController imgSize:imgSize adSize:CGSizeMake(width, height) IsSupportDeepLink:YES];
    }
    self.chuanBannerView.frame = CGRectMake(0, 0, width, height);
    self.chuanBannerView.delegate = self;
    return self.chuanBannerView;
}
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
        [self.delegate didLoadBannerAd];
    }
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailedLoadBannerAd:Type:)]){
        [self.delegate didFailedLoadBannerAd:error Type:3];
    }
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didBannerAdExposure)]){
        [self.delegate didBannerAdExposure];
    }
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {
    
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerAd)]){
        [self.delegate didClickedBannerAd];
    }
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    [bannerAdView removeFromSuperview];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedRemoveBanner)]){
        [self.delegate didClickedRemoveBanner];
    }
}

@end
