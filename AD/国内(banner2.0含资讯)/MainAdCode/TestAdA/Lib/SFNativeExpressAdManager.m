//
//  YXFeedAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "SFNativeExpressAdManager.h"
#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXWebViewController.h"
#import "NSString+SFAES.h"
#import "SDKADTableViewCell.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import <BUAdSDK/BUAdSDK.h>
#import "SFGDTADViewController.h"
#import "SFChuanADViewControl.h"

@interface SFNativeExpressAdManager()<SFADViewDelegate,ChuanManngerDelegate>
{
    CGFloat _width;
    CGFloat _height;
    NSInteger _chazhi;
    BOOL isOther;
}
@property (nonatomic, strong) NSDictionary *otherDict;
@property (nonatomic, strong) NSDictionary *netAdDict;
@property (nonatomic, strong) NSDictionary *currentAdDict;

@property (nonatomic, strong) NSArray *s2sAdArray;
@property (nonatomic, strong) NSDictionary *s2sTapAdDict;

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
@property (nonatomic, strong) BUNativeExpressAdManager *nativeExpressAdManager;

@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) SFGDTADViewController *gdtDefaultVC;
@property (nonatomic, strong) SFChuanADViewControl *chuanDefaultVC;

@end

@implementation SFNativeExpressAdManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark 开始加载广告
-(void)loadNativeExpressFeedAd
{
    isOther = NO;
    self.feedArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    CGSize  size;
    if (self.adSize == YXADSize690X388) {
        size.width = 690;
        size.height = 388;
    } else if (self.adSize == YXADSize750X326) {
        size.width = 750;
        size.height = 326;
    } else if (self.adSize == YXADSize288X150) {
        size.width = 2880;
        size.height = 1500;
    } else if (self.adSize == YXADSize228X150) {
        size.width = 2280;
        size.height = 1500;
    } else {
        size.width = self.s2sWidth?self.s2sWidth:750;
        size.height = self.s2sHeight?self.s2sHeight:326;
    }
    _width = [UIScreen mainScreen].bounds.size.width;
    _height = size.height*[UIScreen mainScreen].bounds.size.width/size.width;
    
    [self requestADSourceFromNet];
    
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
                weakSelf.s2sAdArray = json[@"adInfos"];
                if (weakSelf.s2sAdArray.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"广告数据为空" code:20001 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (NSInteger i=0; i<weakSelf.s2sAdArray.count; i++) {
                        NSDictionary *dict = weakSelf.s2sAdArray[i];
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
                        SDKADTableViewCell *SDKAdCell = [[[NSBundle mainBundle] loadNibNamed:@"XibAndPng.bundle/SDKADTableViewCell" owner:nil options:nil] firstObject];
                        [SDKAdCell cellDataWithFeedAdModel:backdata];
                        [SDKAdCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)]];
                        UIView *view = [[UIView alloc] initWithFrame:SDKAdCell.bounds];
                        YXFeedAdData *s2sbackdata = [YXFeedAdData new];
                        s2sbackdata.adID = i;
                        s2sbackdata.adType = 2;
                        s2sbackdata.data = view;
                        [weakSelf.feedArray addObject:s2sbackdata];
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
    
    [self ViewClickWithDict:self.s2sTapAdDict Width:widthStr Height:heightStr X:x Y:y Controller:self.controller];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([name isEqualToString:@"广点通"]) {
                [self initGDTAD];
            } else if ([name isEqualToString:@"头条"]){
                [self initChuanAD];
            } else {
                [self initS2S];
            }
        });
    }
}

// 暂无权限申请广点通的原生广告
#pragma mark 广点通
- (void)initGDTAD
{
    
    NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
    if (adplaces.allKeys.count == 0) {
        [self initS2S];
        return;
    }
    [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
    self.gdtDefaultVC = [SFGDTADViewController defaultManger];
    self.gdtDefaultVC.delegate = self;
    self.gdtDefaultVC.showController = self.controller;
    [self.gdtDefaultVC getGDTADWithAppId:adplaces[@"appId"] PlaceId:adplaces[@"adPlaceId"] Width:_width Height:_height AdCount:self->_chazhi];
//    NSLog(@"广点通 AppID = %@;placementId = %@",adplaces[@"appId"],adplaces[@"adPlaceId"]);
}

#pragma mark 穿山甲

- (void)initChuanAD
{
    NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
    if (adplaces.allKeys.count == 0) {
        [self initS2S];
        return;
    }
    [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
    
    //        adPlaceId = 5000546;
    //        appId = 900546662;
    
    self.chuanDefaultVC = [SFChuanADViewControl defaultManger];
    self.chuanDefaultVC.delegate = self;
    self.chuanDefaultVC.showController = self.controller;
    [self.chuanDefaultVC getChuanADWithAppId:adplaces[@"appId"] Size:self.adSize PlaceId:adplaces[@"adPlaceId"] Width:_width Height:_height AdCount:self->_chazhi];
//    NSLog(@"头条 AppID = %@;placementId = %@",adplaces[@"appId"],adplaces[@"adPlaceId"]);
}


#pragma mark - 代理回调
/**
 加载成功的回调
 
 @param data  回调的广告素材
 */
- (void)didLoadFeedAd:(NSArray<YXFeedAdData *> *)data Type:(NSInteger)adType{
    [self.feedArray addObjectsFromArray:data];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
        [self.delegate didLoadFeedAd:self.feedArray];
    }
}
/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadFeedAd:(NSError *)error Type:(NSInteger)adType{
    if (adType == 2) {
        if (isOther) {
            if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
                self.currentAdDict = self.otherDict;
                isOther = NO;
                [self initChuanAD];
            }
        } else {
            [self initS2S];
        }
    } else if (adType == 3) {
        if (isOther) {
            if (![self.otherDict isEqualToDictionary:self.currentAdDict]) {
                self.currentAdDict = self.otherDict;
                isOther = NO;
                [self initGDTAD];
            }
        } else {
            [self initS2S];
        }
    }
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
//    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailedLoadFeedAd:)]){
//        [self.delegate didFailedLoadFeedAd:error];
//    }
}
/**
 广告点击后回调
 */
- (void)didClickedFeedAdType:(NSInteger)adType{
    [Network upOutSideToServer:APIClick isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        [self.delegate didClickedFeedAd];
    }
}
/**
 广告被关闭
 */
- (void)nativeExpressAdClose{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nativeExpressAdClose)]) {
        [self.delegate nativeExpressAdClose];
    }
}
/**
 广告渲染成功
 */
- (void)didFeedAdRenderSuccessFeedAd:(NSArray<YXFeedAdData *> *)data Type:(NSInteger)adType{
    if (adType == 3) {
        [Network upOutSideToServer:APIExposured isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFeedAdRenderSuccess:)]) {
        [self.delegate didFeedAdRenderSuccess:data];
    }
}
/**
 广告渲染失败
 */
- (void)didFeedAdRenderFail{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFeedAdRenderFail)]) {
        [self.delegate didFeedAdRenderFail];
    }
}
/**
 广点通原生广告曝光回调
 */
- (void)gdt_nativeExpressAdViewExposure:(NSInteger)adType{
    [Network upOutSideToServer:APIExposured isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

@end
