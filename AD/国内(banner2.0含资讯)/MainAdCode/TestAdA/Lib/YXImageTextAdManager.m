//
//  YXFeedAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXImageTextAdManager.h"
#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXWebViewController.h"
#import "NSString+SFAES.h"

#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

#import <BUAdSDK/BUAdSDK.h>

@interface YXImageTextAdManager()
<
BUNativeExpressAdViewDelegate,
GDTNativeExpressAdDelegete
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

@property (nonatomic, strong) NSMutableArray * viewsArray;

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
@property (nonatomic, strong) BUNativeExpressAdManager *nativeExpressAdManager;

@property (nonatomic, strong) UIView *registerAdView;

@property (nonatomic, strong) NSMutableArray *adShowArr;//存储上报 数组

@property (nonatomic, strong) NSMutableArray *timeArr;

@property (nonatomic, strong) NSMutableArray *feedArray;

@end

@implementation YXImageTextAdManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark 开始加载广告
-(void)loadFeedAd
{
    isOther = NO;
    
    [self.adShowArr  removeAllObjects];
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.viewsArray removeAllObjects];
    self.viewsArray = [[NSMutableArray alloc]initWithCapacity:0];
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
    
    [self requestADSourceFromNet];
    
}

#pragma mark 注册View

- (void)registerAdViewForInteraction:(UIView *)view adData:(YXFeedAdData*)adData
{

    NSDictionary * currentAdDict;
    NSString * currentAD;

    if (adData.adType == 4) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        currentAD = @"1";
        NSString *dataStr = adData.data;
        currentAdDict = [dataStr sf_AESDecryptString];
        self.s2sTapAdDict = [dataStr sf_AESDecryptString];
        [view addGestureRecognizer:tap];
    } else if (adData.adType == 3){
        currentAD = @"2";
        view.tag = adData.adID;
        currentAdDict = @{@"ad":@"1"};
        BUNativeAd *wmAdData = adData.data;
        wmAdData.delegate = self;
        wmAdData.rootViewController = self.controller;
        [wmAdData registerContainer:view withClickableViews:nil];
    } else if (adData.adType == 2) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [view addGestureRecognizer:tap];
        currentAD = @"3";
        view.tag = adData.adID;
        currentAdDict = @{@"ad":@"1"};
        /*
         * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
         */
//        GDTNativeExpressAd *currentAdData = adData.data;
//        self.nativeExpressAd = adData.data;
//        [self.nativeAd attachAd:currentAdData toView:view];
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        currentAD = @"1";
        NSString *dataStr = adData.data;
        currentAdDict = [dataStr sf_AESDecryptString];
        self.s2sTapAdDict = [dataStr sf_AESDecryptString];
        [view addGestureRecognizer:tap];
    }

    NSInteger pageNumber = view.tag;
    //去重上传逻辑  注册展示广告的view的tag值为adid 或者 wm 的 或者gdt
    NSString * pages = [NSString stringWithFormat:@"%ld",(long)pageNumber];
    //用tag来标识  当前 zhna注册的广告
    NSDictionary * dicts = @{@"viewTag":pages,@"adDict":currentAdDict};
    //adShowArr  记录展示的广告上报数组
    if (self.adShowArr.count == 0) { //第一次注册上报一次
        
        [self.adShowArr addObject:dicts];
        [self checkIsInView:view dicts:dicts sts:currentAD];
        
    } else {
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
            [self checkIsInView:view dicts:dicts sts:currentAD];
        }
    }
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
                        
                        backdata.IconUrl = [NSString stringWithFormat:@"%@",dict[@"logo_icon"]];
                        backdata.adType = 4;
                        backdata.data = [[NSString sf_jsonStringWithJson:dict] sf_AESEncryptString];
                        [weakSelf.feedArray addObject:backdata];
                    }
                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                        [weakSelf.delegate didLoadFeedAd:weakSelf.feedArray];
                    }
                });
            }else{
                if (weakSelf.feedArray.count>0) {
                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                        [weakSelf.delegate didLoadFeedAd:weakSelf.feedArray];
                    }
                } else {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                }
            }
        }else{
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [weakSelf failedError:errors];
        }
    }];
}

// 点击图片信息
-(void)tapImg:(UITapGestureRecognizer *)recognizer
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGPoint point = [recognizer locationInView:window.rootViewController.view];
    NSString * x =  [NSString stringWithFormat:@"%f",point.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",point.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
    
    for (NSDictionary *dict in self.s2sAdArray) {
        if ([dict[@"adid"] integerValue] == recognizer.view.tag) {
            self.s2sTapAdDict = dict;
        }
    }
    
    if(!self.s2sTapAdDict){
        return;
    }
    
    [self ViewClickWithDict:self.s2sTapAdDict Width:widthStr Height:heightStr X:x Y:y];
    [self clikedADs2sPan];
}

- (void)clikedADs2sPan
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        [self.delegate didClickedFeedAd];
    }
}

#pragma mark 失败
- (void)failedError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(didFailedLoadFeedAd:)]) {
        [self.delegate didFailedLoadFeedAd:error];
    }
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
                backdata.data = [[NSString sf_jsonStringWithJson:dict] sf_AESEncryptString];
                [mArr addObject:backdata];
            }
            if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [weakSelf.delegate didLoadFeedAd:mArr];
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
        
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:adplaces[@"appId"]
                                                             placementId:adplaces[@"adPlaceId"]
                                                                  adSize:CGSizeMake(self->_width, self->_height)];
        self.nativeExpressAd.delegate = self;
        [self.nativeExpressAd loadAd:((int)self->_chazhi)];
    });
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    
}

/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    // 广告数据拉取成功，存储并展示
    dispatch_async(dispatch_get_main_queue(), ^{
        if (views.count > 0) {
            self.viewsArray = [views mutableCopy];
            for (int index = 0; index < views.count; index ++ ) {
                GDTNativeExpressAdView *data = views[index];
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adID = index;
                backdata.adType = 2;
                backdata.data = data;
                [self.feedArray addObject:backdata];
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:self.feedArray];
            }
        }
        
    });
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
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

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSLog(@"原生模板广告渲染成功");
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSLog(@"原生模板广告渲染失败");
}

/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView{
    [Network upOutSideToServer:ADExposured isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        [self.delegate didClickedFeedAd];
    }
}

/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(nativeExpressAdClose)]){
        [self.delegate nativeExpressAdClose];
    }
}

/**
 * 点击原生模板广告以后即将弹出全屏广告页
 */
- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 点击原生模板广告以后弹出全屏广告页
 */
- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewWillDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 全屏广告页将要关闭
 */
- (void)nativeExpressAdViewDidDissmissScreen:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生模板视频广告 player 播放状态更新回调
 */
- (void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status{}

/**
 * 原生视频模板详情页 WillPresent 回调
 */
- (void)nativeExpressAdViewWillPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生视频模板详情页 DidPresent 回调
 */
- (void)nativeExpressAdViewDidPresentVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生视频模板详情页 WillDismiss 回调
 */
- (void)nativeExpressAdViewWillDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

/**
 * 原生视频模板详情页 DidDismiss 回调
 */
- (void)nativeExpressAdViewDidDismissVideoVC:(GDTNativeExpressAdView *)nativeExpressAdView{}

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
        
        BUAdSlot *slot1 = [[BUAdSlot alloc] init];
        slot1.ID = adplaces[@"adPlaceId"];
        slot1.AdType = BUAdSlotAdTypeFeed;
        BUSize *imgSize1 ;
        if (self.adSize == YXADSize288X150) {
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
            self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot1 adSize:CGSizeMake(_width, _height)];
        }
        self.nativeExpressAdManager.adSize = CGSizeMake(_width, _height);
        self.nativeExpressAdManager.delegate = self;
        [self.nativeExpressAdManager loadAd:self->_chazhi];
    });
}
- (void)chuanshanjiaAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views{
    /*广告数据拉取成功，存储并展示*/
    dispatch_async(dispatch_get_main_queue(), ^{
        if (views.count > 0) {
            self.viewsArray = [views mutableCopy];
            for (int index = 0; index < views.count; index ++ ) {
                BUNativeExpressAdView *data = views[index];
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adID = index;
                backdata.adType = 3;
                backdata.data = data;
                [self.feedArray addObject:backdata];
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:self.feedArray];
            }
        }
    });
}
- (void)chuanshanjiaAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        
        [self.delegate didClickedFeedAd];
    }
}
- (void)chuanshanjiaAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error{
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
