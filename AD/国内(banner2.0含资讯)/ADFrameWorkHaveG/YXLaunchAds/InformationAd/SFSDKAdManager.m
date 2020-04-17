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
//
#import "GDTNativeAd.h"
#import "GDTNativeExpressAdView.h"

#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeAdsManager.h>

@interface SFSDKAdManager()
<
BUNativeAdDelegate,
BUNativeAdsManagerDelegate,
GDTNativeAdDelegate
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

@property (nonatomic, strong) NSArray *adInfoArray;

@property (nonatomic, strong) NSArray *s2sAdArray;
@property (nonatomic, strong) NSDictionary *s2sTapAdDict;

@property (nonatomic, strong) GDTNativeAd *nativeAd;
@property (nonatomic, strong) NSMutableArray * gdtArr;

@property (nonatomic, strong) BUNativeAdsManager *adManager;

@property (nonatomic, strong) UIView *registerAdView;

@property (nonatomic, strong) NSMutableArray *adShowArr;//存储上报 数组

@property (nonatomic, strong) NSMutableArray *timeArr;

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
    
    [self.adShowArr  removeAllObjects];
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.gdtArr removeAllObjects];
    self.gdtArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.timeArr = [[NSMutableArray alloc]initWithCapacity:0];
    
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
    NSDictionary * currentAdDict;

    if (adData.adType == 4) {
        NSString * x =  @"0";
        NSString * y =  @"20";
        
        NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
        NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
        
        self.s2sTapAdDict = adData.data;
        if(!self.s2sTapAdDict){
            return;
        }
        
        [self ViewClickWithDict:self.s2sTapAdDict Width:widthStr Height:heightStr X:x Y:y];
    } else if (adData.adType == 3){
        
    } else if (adData.adType == 2) {
        currentAdDict = @{@"ad":@"1"};
        /*
         * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
         */
        GDTNativeAdData *currentAdData = adData.data;
        [self.nativeAd clickAd:currentAdData];
        [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
        
    } else {
        NSString * x =  @"0";
        NSString * y =  @"20";
        
        NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
        NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
        
        self.s2sTapAdDict = adData.data;
        if(!self.s2sTapAdDict){
            return;
        }
        [self ViewClickWithDict:self.s2sTapAdDict Width:widthStr Height:heightStr X:x Y:y];
    }
}

- (void)registerAdViewForInCell:(UITableViewCell *)cell adData:(YXFeedAdData*)adData
{
    NSDictionary * currentAdDict;
    NSString * currentAD;
    NSMutableArray *newges = [NSMutableArray arrayWithArray:cell.gestureRecognizers];
    for (int i =0; i<[newges count]; i++) {
        [cell removeGestureRecognizer:[newges objectAtIndex:i]];
    }
    //adData.adType 1 直投 2 广点通  3 穿山甲  4 自投打底广告
    if (adData.adType == 4) {
        currentAD = @"1";
        currentAdDict = adData.data;
        self.s2sTapAdDict = adData.data;
    } else if(adData.adType == 3){
        currentAD = @"2";
        currentAdDict = @{@"ad":@"1"};
        BUNativeAd *wmAdData = adData.data;
        wmAdData.rootViewController = self.controller;
        [wmAdData registerContainer:cell withClickableViews:nil];
    } else if(adData.adType == 2) {
        currentAD = @"3";
        currentAdDict = @{@"ad":@"1"};
        /*
         * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
         */
        GDTNativeAdData *currentAdData = adData.data;
        [self.nativeAd attachAd:currentAdData toView:cell];
    } else {
        currentAD = @"1";
        currentAdDict = adData.data;
        self.s2sTapAdDict = adData.data;
    }
    
    NSInteger pageNumber = cell.tag;
    //去重上传逻辑  注册展示广告的view的tag值为adid 或者 wm 的 或者gdt
    NSString * pages = [NSString stringWithFormat:@"%ld",(long)pageNumber];
    //用tag来标识  当前 zhna注册的广告
    NSDictionary * dicts = @{@"viewTag":pages,@"adDict":currentAdDict};
    //adShowArr  记录展示的广告上报数组
    if (self.adShowArr.count == 0) { //第一次注册上报一次
        
        [self.adShowArr addObject:dicts];
        [self checkIsInCell:cell dicts:dicts sts:currentAD];
    }else{
        BOOL hasIndex = NO;//在记录中 查询是否有当前注册的广告
        for (NSDictionary * addict in self.adShowArr) {
            NSString * str = addict[@"viewTag"];
            if ([str isEqualToString:pages]) {
                hasIndex = YES;
            }
        }
        //没有记录并上报
        if (!hasIndex) {
            [self.adShowArr addObject:dicts];
            [self checkIsInCell:cell dicts:dicts sts:currentAD];
        }
        
    }
    return;
}

- (void)checkIsInView:(UIView*)view dicts:(NSDictionary*)dicts sts:(NSString*)currentAD
{
//     1.获取全局子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    2.创建timer添加到队列中
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __block int timeRet = 30;
    [self.timeArr addObject:timer];
//    3.设置首次执行时间、执行间隔和精确度
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        // doSomething()
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL  isINshow = [NetTool isInScreenView:view];
            if (isINshow) {
//                NSLog(@"在屏幕内");
                [self adShowUpToSever:dicts sts:currentAD];
                dispatch_source_cancel(timer);
            }else{
//                NSLog(@"不在屏幕内");
                if (timeRet == 0) {
                    dispatch_source_cancel(timer);
                }
            }
            timeRet -- ;
        });
    });
    dispatch_resume(timer);
}
- (void)checkIsInCell:(UITableViewCell*)cell dicts:(NSDictionary*)dicts sts:(NSString*)currentAD
{
    //     1.获取全局子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    2.创建timer添加到队列中
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __block int timeRet = 30;
    [self.timeArr addObject:timer];
    //    3.设置首次执行时间、执行间隔和精确度
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        // doSomething()
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL  isINshow = [NetTool isInScreenCell:cell];
            if (isINshow) {
//                NSLog(@"在屏幕内");
                [self adShowUpToSever:dicts sts:currentAD];
                dispatch_source_cancel(timer);
            }else{
//                NSLog(@"不在屏幕内");
                if (timeRet == 0) {
                    dispatch_source_cancel(timer);
                }
            }
            timeRet -- ;
        });
    });
    dispatch_resume(timer);
}

-(void)dealloc
{
    for (dispatch_source_t timer in self.timeArr) {
        dispatch_source_cancel(timer);
    }
    self.timeArr = nil;
}
/**
 展示上报
 
 @param dict 第几个广告
 */
- (void)adShowUpToSever:(NSDictionary*)dict sts:(NSString*)isBU
{
//    NSLog(@"上报:%@",dict);
    //   1:s2s  2:wm  3:gdt
    if ([isBU isEqualToString:@"1"]) {
        NSDictionary * dic = dict[@"adDict"];
        NSArray * viewS = dic[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }else{
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    }
}

#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    NSString *macId = [Network sharedInstance].ipStr;
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:_width height:_height macID:macId uid:[NetTool getOpenUDID] adCount:_chazhi];
    
    [self initXAD];
}
- (void)failedError:(NSError *)error{
    NSLog(@"error = %@",error);
}
- (void)initXAD
{
    WEAK(weakSelf);
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                weakSelf.s2sAdArray = json[@"adInfos"];
                if (weakSelf.s2sAdArray.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (NSDictionary *dict in weakSelf.s2sAdArray) {
                        
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
                        backdata.data = dict;
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
        weakSelf.adInfoArray = adInfosArr;
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
                backdata.data = dict;
                [mArr addObject:backdata];
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
                backdata.data = dict;
                [weakSelf.feedArray addObject:backdata];
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
                backdata.adTitle = [properties objectForKey:GDTNativeAdDataKeyTitle];
                backdata.imageUrl = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
                backdata.IconUrl = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
                backdata.adID = index;
                backdata.adType = 2;
                backdata.data = data;
                [self.feedArray addObject:backdata];
            }
            if (self.success && self.feedArray.count>0) {
                self.success([self.feedArray firstObject]);
            }
        }
        
    });
}

-(void)nativeAdFailToLoad:(NSError *)error
{
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
            self.currentAdDict = self.otherDict;
            isOther = NO;
            [self initChuanAD];
        }
    } else {
        [self initS2S];
    }
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
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [nativeAd unregisterView];
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
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
        NSArray *viewS = self.s2sTapAdDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}

@end
