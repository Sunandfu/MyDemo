//
//  YXMutBannerAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/11/21.
//  Copyright © 2018 YX. All rights reserved.
//

#import "YXMutBannerAdManager.h"

#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"
#import "YXFeedAdData.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXWebViewController.h"

#import "YXBannerScrollView.h"
#import "GDTNativeAd.h"
#import "GDTNativeExpressAdView.h"

#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeAdsManager.h>

#import "CustomCollectionViewCell.h"

@interface YXMutBannerAdManager()<BUNativeAdDelegate,BUNativeAdsManagerDelegate,GDTNativeAdDelegate,YXBannerScrollViewDelegate>
{
    CGFloat _width;
    CGFloat _height;
    NSInteger _chazhi;
    BOOL isOther;
    BOOL isFirst;
}
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSDictionary *otherDict;
@property (nonatomic, strong) NSDictionary *netAdDict;
@property (nonatomic, strong) NSDictionary *currentAdDict;

@property (nonatomic,strong) NSArray * adInfoArr;

@property (nonatomic,strong) NSArray * adArr;

@property (nonatomic, strong) GDTNativeAd *nativeAd;
@property (nonatomic, strong) GDTNativeAdData *currentClickAdData;

@property (nonatomic,strong) NSArray * gdtArr;

@property (nonatomic, strong) BUNativeAdsManager *adManager;

@property (nonatomic,strong) UIView *registerAdView;

@property (nonatomic,strong) NSArray * adMArry;

@property (nonatomic,strong) YXBannerScrollView *bannerScrollView;
@property (nonatomic, strong) UIView *bgHeaderView;

@property (nonatomic,strong) NSMutableArray *adShowArr;//存储上报 数组

@property (nonatomic, strong) NSMutableArray *feedArray;

@property (nonatomic,strong) UIImageView  *tmpImageView;

@end


@implementation YXMutBannerAdManager


- (void)clearMutBannerAdImageChace{
    [NetTool clearNetImageChace];
}

/**
 展示上报
 */
- (void)adShowUpToSever:(YXFeedAdData *)data
{
    switch (data.adType) {
        case 1:
        {
            NSDictionary * dic = data.data;
            NSArray * viewS = dic[@"impress_notice_urls"];
            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                [Network groupNotifyToSerVer:viewS];
            } }
            break;
        case 2:
        { [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
        }
            break;
        case 3:
        {
            [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId]; }
            break;
        case 4:
        {
            NSDictionary * dic = data.data;
            NSArray * viewS = dic[@"impress_notice_urls"];
            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                [Network groupNotifyToSerVer:viewS];
            } }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    self.cornerRadius = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    self.autoScrollTimeInterval = 3.0;
    self.infiniteLoop = YES;
    self.autoScroll = YES;
    self.showPageControl = YES;
    self.hidesForSinglePage = YES;
    self.pageControlStyle = YXBannerScrollViewPageContolStyleClassic;
    self.pageControlAliment = YXBannerScrollViewPageContolAlimentCenter;
    self.pageControlBottomOffset = 0;
    self.pageControlRightOffset = 0;
    self.pageControlDotSize = CGSizeMake(10, 10);
    self.currentPageDotColor = [UIColor blackColor];
    self.pageDotColor = [UIColor lightGrayColor];
    
    isOther = NO;
    isFirst = YES;
    
    self.adArr = [[NSArray alloc]init];
    self.gdtArr = [[NSArray alloc]init];
    self.adMArry = [[NSArray alloc]init];
    self.feedArray = [NSMutableArray arrayWithCapacity:0];
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
}


#pragma mark 开始加载广告
-(void)loadMutBannerAdViewsInView:(UIView *)view
{
    [self.adShowArr  removeAllObjects];
    
    view.userInteractionEnabled = YES;
    self.bgHeaderView = view;
    self.tmpImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    self.tmpImageView.image = self.placeholderImage?self.placeholderImage:nil;
    self.tmpImageView.userInteractionEnabled = YES;
    self.tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tmpImageView.clipsToBounds = YES;
    self.tmpImageView.layer.masksToBounds = YES;
    self.tmpImageView.layer.cornerRadius = self.cornerRadius;
    [view addSubview:self.tmpImageView];
    
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
    self->_width = size.width;
    self->_height = size.height;
    
    [self requestADSourceFromNet];
    
}

#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    NSString *macId = [Network sharedInstance].ipStr;
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:self->_width height:self->_height macID:macId uid:[NetTool getOpenUDID] adCount:self->_chazhi];
    [self initXAD];
}
- (void)initXAD
{
    WEAK(weakSelf);
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                weakSelf.adArr = json[@"adInfos"];
                if (weakSelf.adArr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                //                self->self.resultDict = dict;
                //                self->_adDict = dict;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (NSDictionary *dict in weakSelf.adArr) {
                        YXFeedAdData *backdata = [YXFeedAdData new];
                        backdata.adContent = [NSString stringWithFormat:@"%@",dict[@"description"]];
                        backdata.adTitle =  [NSString stringWithFormat:@"%@",dict[@"title"]];
                        NSString * ac_type = [NSString stringWithFormat:@"%@",dict[@"ac_type"]];
                        if ([ac_type isEqualToString:@"1"]) {
                            backdata.buttonText = @"开始下载";
                        }else{
                            backdata.buttonText = @"查看详情";
                        }
                        backdata.imageUrl = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
                        backdata.IconUrl = [NSString stringWithFormat:@"%@",dict[@"logo_icon"]];
                        backdata.adType = 4;
                        backdata.data = dict;
                        [weakSelf.feedArray addObject:backdata];
                    }
                    
                    [weakSelf reloadDataScrollerView];
                    
                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                        [weakSelf.tmpImageView removeFromSuperview];
                        [weakSelf.delegate didLoadMutBannerAdView];
                    }
                });
            }else{
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                [weakSelf failedError:errors];
                if (weakSelf.feedArray.count>0) {
                    [weakSelf reloadDataScrollerView];
                }
            }
        }else{
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [weakSelf failedError:errors];
        }
    }];
}

// 点击图片信息
-(void)tapImgView:(UIView *)view WithIndex:(NSInteger)index
{
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    CGPoint point = [recognizer locationInView:window.rootViewController.view];
    
    NSString * x =  [NSString stringWithFormat:@"%f",view.frame.origin.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",view.frame.origin.y ];
    
    [self clickS2SAdWithX:x Y:y Index:index];
}
// 点击图片信息
-(void)tapImg:(UITapGestureRecognizer *)recognizer
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGPoint point = [recognizer locationInView:window.rootViewController.view];
    
    NSString * x =  [NSString stringWithFormat:@"%f",point.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",point.y ];
    [self clickS2SAdWithX:x Y:y Index:recognizer.view.tag];
}
// 点击图片信息
-(void)clickS2SAdWithX:(NSString *)x Y:(NSString *)y Index:(NSInteger)index
{
    NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
    
    if(!_resultDict){
        return;
    }
    NSString *urlStr = _resultDict[@"click_url"];
    NSDictionary *dict = [NetTool parseURLParametersWithURLStr:urlStr];
    
    if ([dict[@"lanigirOaideMsi"] isEqualToString:@"1"]) {
        if (_resultDict==nil) {
            return;
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:UrlStr:)]){
            [self.delegate didClickedMutBannerAdWithIndex:index UrlStr:urlStr];
        }
        
        NSString * click_position = [NSString stringWithFormat:@"%@",_resultDict[@"click_position"]];
        // 2.上报服务器
        if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
        {
            // 上报服务器
            NSArray *viewS = _resultDict[@"click_notice_urls"];
            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                if ([click_position isEqualToString:@"1"]) {
                    
                    if (_resultDict[@"width"]) {
                        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"width"]]];
                    }
                    if (_resultDict[@"height"]) {
                        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_HEIGHT__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"height"]]];
                    }
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
                    
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
                }
                [Network groupNotifyToSerVer:viewS];
            }
        }
    } else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:UrlStr:)]){
            [self.delegate didClickedMutBannerAdWithIndex:index UrlStr:@""];
        }
        [self ViewClickWithDict:_resultDict Width:widthStr Height:heightStr X:x Y:y Controller:self.controller];
    }
}
#pragma mark 失败
- (void)failedError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(didFailedLoadMutBannerAd:)]) {
        [_delegate didFailedLoadMutBannerAd:error];
    }
}
- (void)reloadMutBannerAd{
    [self.feedArray removeAllObjects];
    [self requestADSourceFromNet];
}
#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    WEAK(weakSelf);
    [Network requestADSourceFromMediaId:self.mediaId adCount:self.adCount imgWidth:_width imgHeight:_height success:^(NSDictionary *dataDict) {
        weakSelf.netAdDict = dataDict;
        NSString *adCount = [NSString stringWithFormat:@"%@",weakSelf.netAdDict[@"adCount"]];
        NSArray *adInfosArr = weakSelf.netAdDict[@"adInfos"];
        weakSelf.adInfoArr = adInfosArr;
        if ((adInfosArr.count == adCount.integerValue) && (adCount.integerValue > 0)) {
            for (NSDictionary *dict in adInfosArr) {
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.imageUrl = dict[@"img_url"];
                backdata.IconUrl = dict[@"img_url"];
                backdata.adContent = dict[@"description"];
                backdata.adTitle = dict[@"title"];
                backdata.adID = (NSInteger)dict[@"adid"];
                backdata.adType = 1;
                backdata.data = dict;
                [weakSelf.feedArray addObject:backdata];
            }
            [weakSelf reloadDataScrollerView];
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                [weakSelf.tmpImageView removeFromSuperview];
                [weakSelf.delegate didLoadMutBannerAdView];
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
                backdata.data = dict;
                [self.feedArray addObject:backdata];
            }
            
            NSArray *advertiser = dataDict[@"advertiser"];
            if(advertiser && ![advertiser isKindOfClass:[NSNull class]] && advertiser.count > 0){
                [weakSelf initIDSource];
            } else {
                [weakSelf initS2S];
            }
        }
    } fail:^(NSError *error) {
        [weakSelf failedError:error];
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
    
    double random = 1+ arc4random()%99;
    
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
        if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        } else if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        }else{
            [self initS2S];
        }
    }
}
#pragma mark 广点通
- (void)initGDTAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
        
        self.nativeAd = [[GDTNativeAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.nativeAd.controller = self.controller;
        self.nativeAd.delegate = self;
        [self.nativeAd loadAd:((int)self->_chazhi)];
        
    });
}
#pragma mark - GDTNativeAdDelegate
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    // 广告数据拉取成功，存储并展示
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nativeAdDataArray.count > 0) {
            self.gdtArr = [nativeAdDataArray mutableCopy];
            for (int index = 0; index < nativeAdDataArray.count; index ++ ) {
                GDTNativeAdData *data = nativeAdDataArray[index];
                NSDictionary * properties = data.properties;
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adContent = [properties objectForKey:GDTNativeAdDataKeyDesc];
                backdata.adTitle   = [properties objectForKey:GDTNativeAdDataKeyTitle];
                backdata.imageUrl  = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
                backdata.IconUrl   = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
                backdata.adID      = index;
                backdata.adType = 2;
                backdata.data = data;
                [self.feedArray addObject:backdata];
            }
            
            [self reloadDataScrollerView];
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                [self.tmpImageView removeFromSuperview];
                [self.delegate didLoadMutBannerAdView];
            }
        }
        
    });
}

-(void)nativeAdFailToLoad:(NSError *)error{
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
            self.currentAdDict = self.otherDict;
            isOther = NO;
            [self initGDTAD];
        }
    } else {
        [self initS2S];
    }
    NSError *errors = [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}
// 原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
- (void)nativeAdWillPresentScreen
{
}

//原生广告点击之后应用进入后台时回调

- (void)nativeAdApplicationWillEnterBackground
{
}

- (void)nativeAdClosed
{
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
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
        
        
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
            
            self.adMArry = [nativeAdDataArray mutableCopy];
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
                }
            }
            [self reloadDataScrollerView];
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                [self.tmpImageView removeFromSuperview];
                [self.delegate didLoadMutBannerAdView];
            }
        }
    });
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:UrlStr:)]){
        [self.delegate didClickedMutBannerAdWithIndex:view.tag UrlStr:@""];
    }
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
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

#pragma mark -上报给指定服务器

-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        for (NSDictionary * dict in self.adArr) {
            
            NSArray * viewS = dict[@"impress_notice_urls"];
            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                [Network groupNotifyToSerVer:viewS];
            }
        }
        
    }
}

- (void)reloadDataScrollerView{
    [self.bannerScrollView removeFromSuperview];
    self.bannerScrollView = [YXBannerScrollView cycleScrollViewWithFrame:self.bgHeaderView.bounds delegate:self placeholderImage:self.placeholderImage?self.placeholderImage:nil];
    NSMutableArray *imgUrlArr = [NSMutableArray arrayWithCapacity:0];
    for (YXFeedAdData *feedData in self.feedArray) {
        NSString * imgUrl = [NSString stringWithFormat:@"%@",feedData.imageUrl];
        [imgUrlArr addObject:imgUrl];
    }
    self.bannerScrollView.imageURLStringsGroup = imgUrlArr;
    self.bannerScrollView.scrollDirection = self.scrollDirection ? self.scrollDirection : UICollectionViewScrollDirectionHorizontal;
    self.bannerScrollView.autoScrollTimeInterval = self.autoScrollTimeInterval;
    self.bannerScrollView.autoScroll = self.autoScroll;
    self.bannerScrollView.infiniteLoop = self.infiniteLoop;
    self.bannerScrollView.showPageControl = self.showPageControl;
    self.bannerScrollView.hidesForSinglePage = self.hidesForSinglePage;
    self.bannerScrollView.pageControlStyle = self.pageControlStyle;
    self.bannerScrollView.pageControlAliment = self.pageControlAliment;
    self.bannerScrollView.pageControlBottomOffset = self.pageControlBottomOffset;
    self.bannerScrollView.pageControlRightOffset = self.pageControlRightOffset;
    self.bannerScrollView.pageControlDotSize = self.pageControlDotSize;
    self.bannerScrollView.currentPageDotColor = self.currentPageDotColor;
    self.bannerScrollView.pageDotColor = self.pageDotColor;
    if (self.currentPageDotImage) {
        self.bannerScrollView.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.bannerScrollView.pageDotImage = self.pageDotImage;
    }
    self.bannerScrollView.cornerRadius = self.cornerRadius;
    [self.bgHeaderView addSubview:self.bannerScrollView];
}
- (void)registerAdViewForInteraction:(UIView *)view didScrollToIndex:(NSInteger)index{
//    NSLog(@"registerAdViewForInteraction = %ld",index);
    if (self.feedArray.count>index) {
        YXFeedAdData *feedData = self.feedArray[index];
        view.tag = index;
        NSMutableArray *newges = [NSMutableArray arrayWithArray:view.gestureRecognizers];
        for (int i =0; i<[newges count]; i++) {
            [view removeGestureRecognizer:[newges objectAtIndex:i]];
        }
        switch (feedData.adType) {
            case 1:
            {
                self.resultDict = feedData.data;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
                [view addGestureRecognizer:tap];
            }
                break;
            case 2:
            {
                GDTNativeAdData *currentAdData = feedData.data;
                [self.nativeAd attachAd:currentAdData toView:view];
                self.currentClickAdData = currentAdData;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                [view addGestureRecognizer:tap];
            }
                break;
            case 3:
            {
                BUNativeAd *wmAdData = feedData.data;
                wmAdData.rootViewController = self.controller;
                [wmAdData registerContainer:view withClickableViews:view.subviews]; }
                break;
            case 4:
            {
                self.resultDict = feedData.data;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
                [view addGestureRecognizer:tap];
                
            }
                break;
                
            default:
                break;
        }
    }
}
- (void)cycleScrollView:(YXBannerScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    if (self.feedArray.count>index) {
        YXFeedAdData *feedData = self.feedArray[index];
        NSString * pages = [NSString stringWithFormat:@"%ld",(long)index];
        if (self.adShowArr.count == 0) {
            [self.adShowArr addObject:pages];
            [self adShowUpToSever:feedData];
        }else{
            BOOL hasIndex = NO;
            for (NSString * str in self.adShowArr) {
                if ([str isEqualToString:pages]) {
                    hasIndex = YES;
                }
            }
            if (!hasIndex) {
                [self.adShowArr addObject:pages];
                [self adShowUpToSever:feedData];
            }
        }
    }
    [self registerAdViewForInteraction:cycleScrollView didScrollToIndex:index];
}
- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    //渠道暂无广点通广告
    [self.nativeAd clickAd:self.currentClickAdData];
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:UrlStr:)]){
        [self.delegate didClickedMutBannerAdWithIndex:recognizer.view.tag UrlStr:@""];
    }
}
/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
- (UINib *)customCollectionViewCellNibForCycleScrollView:(YXBannerScrollView *)view{
    UINib *nib = [UINib nibWithNibName:@"XibAndPng.bundle/CustomCollectionViewCell" bundle:nil];
    return nib;
}

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(YXBannerScrollView *)view{
    if (self.feedArray.count>index) {
        YXFeedAdData *feedData = self.feedArray[index];
        CustomCollectionViewCell *customCell = (CustomCollectionViewCell *)cell;
        //    customCell.frame = CGRectMake(0, 0, _width, _height);
        if (self.isOnlyImage) {
            customCell.currentImageView.hidden = NO;
            [NetTool setImage:customCell.currentImageView WithURLStr:feedData.imageUrl placeholderImage:self.placeholderImage?self.placeholderImage:nil];
        } else {
            if (feedData.adContent.length<=0 || feedData.adContent==nil) {
                customCell.currentImageView.hidden = NO;
                [NetTool setImage:customCell.currentImageView WithURLStr:feedData.imageUrl placeholderImage:self.placeholderImage?self.placeholderImage:nil];
            } else {
                customCell.currentImageView.hidden = YES;
                customCell.AppName.text = feedData.adTitle;
                customCell.AppDesc.text = feedData.adContent;
                [NetTool setImage:customCell.bigImageView WithURLStr:feedData.imageUrl placeholderImage:self.placeholderImage?self.placeholderImage:nil];
            }
        }
    }
    if (self.adCount==1 || isFirst==YES) {
        isFirst = NO;
        [self registerAdViewForInteraction:cell didScrollToIndex:index];
    }
}

@end
