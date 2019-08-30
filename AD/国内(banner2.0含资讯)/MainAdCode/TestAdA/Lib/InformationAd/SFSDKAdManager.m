//
//  YXFeedAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "SFSDKAdManager.h"
#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"
#import "YXFeedAdData.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXWebViewController.h"
#import "SDKADTableViewCell.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"

#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeAdsManager.h>

@interface SFSDKAdManager()
<
BUNativeAdDelegate,
BUNativeAdsManagerDelegate,
GDTUnifiedNativeAdDelegate,
GDTUnifiedNativeAdViewDelegate
>
{
    CGFloat _width;
    CGFloat _height;
    NSInteger _chazhi;
    BOOL isOther;
}
@property (nonatomic, strong) NSDictionary *otherDict;
@property (nonatomic, strong) NSDictionary *netAdDict;
@property (nonatomic, strong) NSDictionary *currentAdDict;

@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property (nonatomic, strong) BUNativeAdsManager *adManager;
@property (nonatomic, strong) NSMutableArray * gdtArr;

@property (nonatomic, strong) NSMutableArray *feedArray;

@end

@implementation SFSDKAdManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark 开始加载广告
- (void)loadsingleFeedAdSuccess:(getADSucess)success fail:(getADFail)fail{
    
    isOther = NO;
    
    [self.gdtArr removeAllObjects];
    self.gdtArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.feedArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    CGSize  size;
    if (self.adSize == YXADSize690X388) {
        size.width = 690;
        size.height = 388;
    } else if (self.adSize == YXADSize750X326) {
        size.width = 750;
        size.height = 326;
    } else if (self.adSize == YXADSize288X150) {
        size.width = 288;
        size.height = 150;
    } else {
        size.width = self.s2sWidth?self.s2sWidth:750;
        size.height = self.s2sHeight?self.s2sHeight:326;
    }
    _width = size.width;
    _height = size.height;
    
    self.success = success;
    self.fail = fail;
    
    [self requestADSourceFromNet];
}
#pragma mark 注册View

- (void)clickAdViewForAdData:(YXFeedAdData*)adData
{
    if (adData.adType == 4) {
        NSString * x =  @"0";
        NSString * y =  @"20";
        
        NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
        NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
        
        NSString *s2sTapAdStr = adData.data;
        NSDictionary *s2sTapAdDict = [s2sTapAdStr sf_AESDecryptString];
        if(!s2sTapAdDict){
            return;
        }
        [self ViewClickWithDict:s2sTapAdDict Width:widthStr Height:heightStr X:x Y:y Controller:self.controller];
    } else if (adData.adType == 3){
        
    } else if (adData.adType == 2) {
        
    } else {
        NSString * x =  @"0";
        NSString * y =  @"20";
        
        NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
        NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
        
        NSString *s2sTapAdStr = adData.data;
        NSDictionary *s2sTapAdDict = [s2sTapAdStr sf_AESDecryptString];
        if(!s2sTapAdDict){
            return;
        }
        [self ViewClickWithDict:s2sTapAdDict Width:widthStr Height:heightStr X:x Y:y Controller:self.controller];
    }
}

- (void)registerAdViewForInCell:(SDKADTableViewCell *)cell adData:(YXFeedAdData*)adData
{
    cell.backView.logoView.hidden = YES;
    NSMutableArray *newges = [NSMutableArray arrayWithArray:cell.backView.gestureRecognizers];
    for (int i =0; i<[newges count]; i++) {
        [cell.backView removeGestureRecognizer:[newges objectAtIndex:i]];
    }
    //adData.adType 1 直投 2 广点通  3 穿山甲  4 自投打底广告
    if (adData.adType == 4) {
        
    } else if(adData.adType == 3){
        BUNativeAd *wmAdData = adData.data;
        wmAdData.rootViewController = self.controller;
        [wmAdData registerContainer:cell.backView withClickableViews:@[cell.backView]];
    } else if(adData.adType == 2) {
        [cell.backView unregisterDataObject];
        cell.backView.viewController = self.controller;
        cell.backView.delegate = self;
        GDTUnifiedNativeAdDataObject *currentAdData = adData.data;
        [cell.backView registerDataObject:currentAdData clickableViews:@[cell.backView]];
    } else {
        
    }
}

- (void)failedError:(NSError *)error{
    
}
#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S{
    WEAK(weakSelf);
    [Network beginRequestWithADkey:self.mediaId width:_width height:_height adCount:_chazhi finished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                NSArray *s2sAdArray = json[@"adInfos"];
                if (s2sAdArray.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"广告数据为空" code:20001 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (NSDictionary *dict in s2sAdArray) {
                        
                        YXFeedAdData *backdata = [YXFeedAdData new];
                        
                        backdata.adContent = [NSString stringWithFormat:@"%@",dict[@"description"]];
                        //
                        backdata.adTitle =  [NSString stringWithFormat:@"%@",dict[@"title"]];
                        //
                        NSString * ac_type = [NSString stringWithFormat:@"%@",dict[@"ac_type"]];
                        if ([ac_type isEqualToString:@"1"]) {
                            backdata.buttonText = @"开始下载";
                        }else{
                            backdata.buttonText = @"查看详情";
                        }
                        
                        backdata.imageUrl = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
                        backdata.adID = [NSString stringWithFormat:@"%@",dict[@"adid"]].integerValue;
                        backdata.IconUrl = [NSString stringWithFormat:@"%@",dict[@"logo_icon"]];
                        backdata.adType = 4;
                        backdata.data = [[NSString sf_jsonStringWithJson:dict] sf_AESEncryptString];
                        [weakSelf.feedArray addObject:backdata];
                    }
                    if (weakSelf.success && weakSelf.feedArray.count > 0) {
                        weakSelf.success([weakSelf.feedArray firstObject]);
                    }
                });
            }else{
                if (weakSelf.feedArray.count>0) {
                    
                } else {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                    if (weakSelf.fail) {
                        weakSelf.fail(errors);
                    }
                }
            }
        }else{
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [weakSelf failedError:errors];
            if (weakSelf.fail) {
                weakSelf.fail(errors);
            }
        }
    }];
}

#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    WEAK(weakSelf);
    [Network requestADSourceFromMediaId:self.mediaId adCount:self.adCount imgWidth:_width imgHeight:_height success:^(NSDictionary *dataDict) {
        if ([dataDict[@"ret"] isEqualToString:@"-1"]) {
            return ;
        }
        weakSelf.netAdDict = dataDict;
        NSString *adCount = [NSString stringWithFormat:@"%@",self.netAdDict[@"adCount"]];
        NSArray *adInfosArr = weakSelf.netAdDict[@"adInfos"];
        if ((adInfosArr.count == adCount.integerValue) && (adCount.integerValue > 0)) {
            NSMutableArray * mArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (NSDictionary *dict in adInfosArr) {
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.imageUrl = dict[@"img_url"];
                backdata.IconUrl = dict[@"img_url"];
                backdata.adContent = dict[@"description"];
                backdata.adTitle = dict[@"title"];
                backdata.adID = (NSInteger)dict[@"adid"];
                backdata.adType = 1;
                backdata.data = [[NSString sf_jsonStringWithJson:dict] sf_AESEncryptString];
                [mArr addObject:backdata];
                if(dict[@"impress_notice_urls"] && [dict[@"impress_notice_urls"] isKindOfClass:[NSArray class]]){
                    NSArray * viewS = dict[@"impress_notice_urls"];
                    [Network groupNotifyToSerVer:viewS];
                }
            }
            if (weakSelf.success && mArr.count>0) {
                weakSelf.success([mArr firstObject]);
            }
            return ;
        } else {
            self->_chazhi = adCount.integerValue - adInfosArr.count;
            if (self->_chazhi<=0) {
                return ;
            }
            for (NSDictionary *dict in adInfosArr) {
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.imageUrl = dict[@"img_url"];
                backdata.IconUrl = dict[@"img_url"];
                backdata.adContent = dict[@"description"];
                backdata.adTitle = dict[@"title"];
                backdata.adID = (NSInteger)dict[@"adid"];
                backdata.adType = 1;
                backdata.data = [[NSString sf_jsonStringWithJson:dict] sf_AESEncryptString];
                [weakSelf.feedArray addObject:backdata];
                if(dict[@"impress_notice_urls"] && [dict[@"impress_notice_urls"] isKindOfClass:[NSArray class]]){
                    NSArray * viewS = dict[@"impress_notice_urls"];
                    [Network groupNotifyToSerVer:viewS];
                }
            }
            
            NSArray *advertiser = dataDict[@"advertiser"];
            if(advertiser && ![advertiser isKindOfClass:[NSNull class]] && advertiser.count > 0){
                [weakSelf initIDSource];
            } else {
                [weakSelf initS2S];
            }
        }
    } fail:^(NSError *error) {

    }];
}

#pragma mark 分配广告
- (void)initIDSource
{
    NSArray *advertiserArr = self.netAdDict[@"advertiser"];
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
    
    double random = 1 + arc4random()%99;
    
    double sumWeight = 0;
    
    for (int index = 0; index < valueArray.count; index ++ ) {
        NSDictionary *advertiser = valueArray[index];
        sumWeight += [advertiser[@"weight"] doubleValue];
        if (sumWeight >= random) {
            self.currentAdDict = advertiser;
            break;
        }
    }
    if (valueArray.count>1) {
        isOther = YES;
        for (int index = 0; index < valueArray.count; index ++ ) {
            NSDictionary *advertiser = valueArray[index];
            if (![advertiser isEqualToDictionary:self.currentAdDict]) {
                self.otherDict = advertiser;
            }
        }
    }
    
    if (self.currentAdDict == nil) {
        [self initS2S];
    }else{
        NSString *name = self.currentAdDict[@"name"];
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        } else if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        } else {
            [self initS2S];
        }
    }
}

// 暂无权限申请广点通的原生广告
#pragma mark 广点通
- (void)initGDTAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
        
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.unifiedNativeAd.delegate = self;
        self.unifiedNativeAd.maxVideoDuration = 15;
        [self.unifiedNativeAd loadAdWithAdCount:((int)self->_chazhi)];
    });
}

#pragma mark - GDTNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error{
    if (!error && unifiedNativeAdDataObjects.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gdtArr = [unifiedNativeAdDataObjects mutableCopy];
            for (int index = 0; index < unifiedNativeAdDataObjects.count; index ++ ) {
                GDTUnifiedNativeAdDataObject *properties = unifiedNativeAdDataObjects[index];
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adContent = properties.desc;
                backdata.adTitle = properties.title;
                backdata.imageUrl = properties.imageUrl;
                backdata.IconUrl = properties.iconUrl;
                backdata.adID = index;
                backdata.adType = 2;
                backdata.data = properties;
                [self.feedArray addObject:backdata];
                [Network upOutSideToServer:APIShow isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
            }
            if (self.success && self.feedArray.count>0) {
                self.success([self.feedArray firstObject]);
            }
            
        });
        return;
    }
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
            self.currentAdDict = self.otherDict;
            isOther = NO;
            [self initChuanAD];
        }
    } else {
        [self initS2S];
    }
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

/**
 广告曝光回调
 
 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    [Network upOutSideToServer:APIExposured isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}


/**
 广告点击回调
 
 @param unifiedNativeAdView GDTUnifiedNativeAdView 实例
 */
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView{
    //渠道暂无广点通广告
    [Network upOutSideToServer:APIClick isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}



#pragma mark 穿山甲

- (void)initChuanAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        BUNativeAdsManager *nad = [BUNativeAdsManager new];
        BUAdSlot *slot1 = [[BUAdSlot alloc] init];
        BUSize *imgSize1 ;
        
        if (self.adSize == YXADSize288X150) {
            imgSize1 = [BUSize sizeBy:BUProposalSize_Feed228_150];
        }else{
            imgSize1 = [BUSize sizeBy:BUProposalSize_Feed690_388];
        }
        slot1.ID = adplaces[@"adPlaceId"];
        slot1.AdType = BUAdSlotAdTypeFeed;
        slot1.position = BUAdSlotPositionTop;
        slot1.imgSize = imgSize1;
        slot1.isSupportDeepLink = YES;
        nad.adslot = slot1;
        nad.delegate = self;
        self.adManager = nad;
        [nad loadAdDataWithCount:self->_chazhi];
    });
}
- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray{
    /*广告数据拉取成功，存储并展示*/
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nativeAdDataArray.count > 0) {
            self.gdtArr = [nativeAdDataArray mutableCopy];
            for (int index = 0; index < nativeAdDataArray.count; index++) {
                BUNativeAd * nativeAd = nativeAdDataArray[index];
                 BUMaterialMeta *adMeta = nativeAd.data;
                if (adMeta != nil) {
                    YXFeedAdData *backdata = [YXFeedAdData new];
                    backdata.adContent = adMeta.AdDescription;
                    backdata.adTitle =  adMeta.AdTitle;
                    backdata.buttonText = adMeta.buttonText;
                    backdata.adID = index;
                    if (adMeta.imageAry.count > 0) {
                        BUImage *adImage = adMeta.imageAry.firstObject;
                        if (adImage.imageURL.length > 0) {
                            backdata.imageUrl =  adImage.imageURL;
                        }
                    }
                    backdata.IconUrl = adMeta.icon.imageURL;
                    backdata.adType = 3;
                    backdata.data = nativeAd;
                    [self.feedArray addObject:backdata];
                    [Network upOutSideToServer:APIShow isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
                }
            }
            if (self.success && self.feedArray.count>0) {
                self.success([self.feedArray firstObject]);
            }
        }
    });
}

- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd
{
//    NSLog(@"************************广告已经展现了**************************");
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
            self.currentAdDict = self.otherDict;
            isOther = NO;
            [self initGDTAD];
        }
    } else {
        [self initS2S];
    }
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [nativeAd unregisterView];
    [Network upOutSideToServer:APIClick isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
            self.currentAdDict = self.otherDict;
            isOther = NO;
            [self initGDTAD];
        }
    } else {
        [self initS2S];
    }
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

@end
