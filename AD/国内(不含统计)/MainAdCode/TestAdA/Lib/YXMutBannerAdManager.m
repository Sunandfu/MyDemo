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
#import "YXLCdes.h"
#import "YXFeedAdData.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXWebViewController.h"

#import "YXNewPagedFlowView.h"
#import "YXPGIndexBannerSubiew.h"
//
#import "GDTNativeAd.h"
#import "GDTNativeExpressAdView.h"

#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeAdsManager.h>

@interface YXMutBannerAdManager()<BUNativeAdDelegate,BUNativeAdsManagerDelegate,YXNewPagedFlowViewDelegate, YXNewPagedFlowViewDataSource,GDTNativeAdDelegate>
{
    NSDictionary*_currentAD;
    CGFloat _width;
    CGFloat _height;
    NSInteger _chazhi;
    NSDictionary *_resultDict;
}

@property (nonatomic, strong) NSDictionary *netAdDict;

@property (nonatomic,strong) NSArray * adArr;

@property (nonatomic, strong) GDTNativeAd *nativeAd;

@property (nonatomic,strong) NSArray * gdtArr;

@property (nonatomic, strong) BUNativeAdsManager *adManager;

@property (nonatomic,strong) UIView *registerAdView;

@property (nonatomic,strong) NSArray * adMArry;

@property (nonatomic,assign) BOOL isLoadS;//是否s2s加载成功

@property (nonatomic,assign) BOOL isWMAd;//是否穿山甲加载成功

@property (nonatomic,assign) BOOL isGDTLoadOK;//是否广点通加载成功

@property (nonatomic,strong) YXNewPagedFlowView *pageFlowView;

@property (nonatomic,strong) NSMutableArray *adShowArr;//存储上报 数组

@property (nonatomic,strong) UIImageView  *tmpImageView;

@property (nonatomic, strong) NSMutableArray *feedArray;

@end


@implementation YXMutBannerAdManager

#pragma mark YXNewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(YXNewPagedFlowView *)flowView {
    if (self.isWMAd) {
        return self.adMArry.count;
    } else if (self.isGDTLoadOK) {
        return self.gdtArr.count;
    }else{
        return self.adArr.count;
    }
}
- (YXPGIndexBannerSubiew *)flowView:(YXNewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    YXPGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[YXPGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.mainImageView.tag = index;
        if (self.isWMAd) {
            BUNativeAd *wmAdData = self.adMArry[index];
            wmAdData.delegate = self;
            BUMaterialMeta *adMeta = wmAdData.data;
            NSString * imgUrl;
            if (adMeta.imageAry.count > 0) {
                BUImage *adImage = adMeta.imageAry.firstObject;
                if (adImage.imageURL.length > 0) {
                    imgUrl =  adImage.imageURL;
                    [NetTool setImage:bannerView.mainImageView WithURLStr:imgUrl placeholderImage:self.placeImage?self.placeImage:nil];
                    [wmAdData registerContainer:bannerView withClickableViews:nil];
                }
            }
        } else if (self.isGDTLoadOK) {
            GDTNativeAdData *wmAdData = self.gdtArr[index];
            NSDictionary * properties = wmAdData.properties;
            YXFeedAdData *backdata = [YXFeedAdData new];
            backdata.adContent = [properties objectForKey:GDTNativeAdDataKeyDesc];
            backdata.adTitle = [properties objectForKey:GDTNativeAdDataKeyTitle];
            backdata.imageUrl = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
            backdata.IconUrl = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
            backdata.adID = index;
            
            if (backdata.imageUrl.length > 0) {
                [NetTool setImage:bannerView.mainImageView WithURLStr:[properties objectForKey:GDTNativeAdDataKeyImgUrl] placeholderImage:self.placeImage?self.placeImage:nil];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
                [bannerView.mainImageView addGestureRecognizer:tap];
            }
        }else{
            _resultDict = self.adArr[index];
            if (_resultDict) {
                NSString * imgUrl = [NSString stringWithFormat:@"%@",_resultDict[@"img_url"]];
                [NetTool setImage:bannerView.mainImageView WithURLStr:imgUrl placeholderImage:self.placeImage?self.placeImage:nil];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
                [bannerView.mainImageView addGestureRecognizer:tap];
                
            }
            
        }
    }
    return bannerView;
}
- (void)clearMutBannerAdImageChace{
    [NetTool clearNetImageChace];
}
- (void)didSelectCell:(YXPGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:)]){
        [self.delegate didClickedMutBannerAdWithIndex:subIndex];
    }
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(YXNewPagedFlowView *)flowView {
    return CGSizeMake(_pageFlowView.bounds.size.width, _pageFlowView.bounds.size.height);
}
-(void)didScrollToPage:(NSInteger)pageNumber inFlowView:(YXNewPagedFlowView *)flowView
{
//    NSLog(@"didScrollToPage:%ld",pageNumber);
    NSString * pages = [NSString stringWithFormat:@"%ld",(long)pageNumber];
    if (self.adShowArr.count == 0) {
        [self.adShowArr addObject:pages];
        [self adShowUpToSever:pageNumber sts:self.isWMAd];
    }else{
        BOOL hasIndex = NO;
        for (NSString * str in self.adShowArr) {
            if ([str isEqualToString:pages]) {
                hasIndex = YES;
            }
        }
        if (!hasIndex) {
            [self.adShowArr addObject:pages];
            [self adShowUpToSever:pageNumber sts:self.isWMAd];
        }
    }
}

/**
 展示上报

 @param index 第几个广告
 @param isBU 是否BU yes 是  NO  不是
 */
- (void)adShowUpToSever:(NSInteger)index sts:(BOOL)isBU
{
    if (self.isWMAd) {
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId];
    } else if (self.isGDTLoadOK) {
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId];
    }else{
        
        NSDictionary * dic = self.adArr[index];
        NSArray * viewS = dic[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
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
    self.isOpenAutoScroll = YES;
    self.isCarousel = YES;
    self.autoTime = 3;
    self.orientation = YXNewPagedFlowViewOrientationHorizontal;
    self.isShowPageControl = YES;
    self.adCount = 1;
    
    self.adArr = [[NSArray alloc]init];
    self.gdtArr = [[NSArray alloc]init];
    self.adMArry = [[NSArray alloc]init];
    
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    
}


#pragma mark 开始加载广告
-(void)loadMutBannerAdViewsInView:(UIView *)view
{
    self.isLoadS = NO;
    self.isWMAd = NO;
    self.isGDTLoadOK = NO;
    [self.adShowArr  removeAllObjects];
    
    view.userInteractionEnabled = YES;
    self.tmpImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    self.tmpImageView.image = self.placeImage?self.placeImage:nil;
    self.tmpImageView.userInteractionEnabled = YES;
    self.tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tmpImageView.clipsToBounds = YES;
    [view addSubview:self.tmpImageView];
    
    _pageFlowView = [[YXNewPagedFlowView alloc] initWithFrame:view.bounds];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0;
    _pageFlowView.isCarousel = self.isCarousel;
    _pageFlowView.isOpenAutoScroll = self.isOpenAutoScroll;
    _pageFlowView.autoTime = self.autoTime;
    _pageFlowView.orientation = self.orientation;
    
    if (self.isShowPageControl) {
        //初始化pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 30, _pageFlowView.bounds.size.width, 30)];
        if (CGRectGetWidth(self.pageFrame)) {
            pageControl.frame = self.pageFrame;
        }
        _pageFlowView.pageControl = pageControl;
        if (self.pageIndicatorTintColor) {
            pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
        }
        if (self.currentPageIndicatorTintColor) {
            pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        }
        [_pageFlowView addSubview:pageControl];
    }
    [_pageFlowView reloadData];
    
    [view addSubview:_pageFlowView];
    
    
    [self requestADSourceFromNet];
    
}

#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    NSString *macId = [Network sharedInstance].ipStr;
    
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
    
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:self->_width height:self->_height macID:macId uid:[NetTool getOpenUDID] adCount:self.adCount];
    [self initXAD];
}
- (void)initXAD
{
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                self.adArr = json[@"adInfos"];
                if (self.adArr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                //                self->_resultDict = dict;
                //                self->_adDict = dict;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isLoadS = YES;
                    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithCapacity:0];
                    for (NSDictionary *dict in self.adArr) {
                        
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
                        [dataArr addObject:backdata];
                    }
                    
                    [self.pageFlowView reloadData];
                    
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                        [self.tmpImageView removeFromSuperview];
                        [self.delegate didLoadMutBannerAdView];
                    }
                    
                    [self.adShowArr addObject:[NSString stringWithFormat:@"%d",0]];
                    
                    [self adShowUpToSever:0 sts:NO];
                    
                });
            }else{
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                [self failedError:errors];
            }
        }else{
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [self failedError:errors];
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
    
    _resultDict = self.adArr[recognizer.view.tag];
    
    //    NSString *dicStr =  [NSString stringWithFormat:@"{%@:%@,%@:%@,%@:%@,%@:%@}",@"down_x",x,@"down_y",y,@"up_x",x,@"up_y",y];
    if(!_resultDict){
        return;
    }
    // 1.跳转链接
    NSString *urlStr = _resultDict[@"click_url"];
    NSString * click_position = [NSString stringWithFormat:@"%@",_resultDict[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (_resultDict[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"width"]]];
        }
        if (_resultDict[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        
    }
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",_resultDict[@"ac_type"]];
    
    if ([ac_type isEqualToString:@"1"] || [ac_type isEqualToString:@"2"]) {
        
        NSURL *url = [NSURL URLWithString:urlStr];
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            [self.controller showViewController:safariVC sender:nil];
            
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if ([ac_type isEqualToString:@"7"]){
        
        NSString * miniPath = [NSString stringWithFormat:@"%@",_resultDict[@"miniPath"] ];
        miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * miniProgramOriginId = [NSString stringWithFormat:@"%@",_resultDict[@"miniProgramOriginId"]];
        
        
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = miniProgramOriginId;  //拉起的小程序的username
        launchMiniProgramReq.path = miniPath;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
        
        BOOL installWe = [WXApi isWXAppInstalled];
        if (installWe) {
            [WXApi sendReq:launchMiniProgramReq];
        }else{
            NSLog(@"未安装微信");
        }
        
        [Network notifyToServer:nil serverUrl:urlStr completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(connectionError){
                NSLog(@"#####%@\error",[connectionError debugDescription]);
            }else{
                NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (json) {
                    NSLog(@"%@",json);
                }
            }
        }];
    }else{
        if(urlStr && ![urlStr isEqualToString:@""]){
            YXWebViewController *web = [YXWebViewController new];
            web.URLString = urlStr;
            [self.controller presentViewController:web animated:YES completion:nil];
        }
    }
    
    // 2.上报服务器
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        // 上报服务器
        NSArray *viewS = _resultDict[@"click_notice_urls"];
        if ([click_position isEqualToString:@"1"]) {
            
            if (_resultDict[@"width"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"width"]]];
            }
            if (_resultDict[@"height"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"height"]]];
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:)]){
        [self.delegate didClickedMutBannerAdWithIndex:recognizer.view.tag];
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
    [self requestADSourceFromNet];
}
#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    [Network requestADSourceFromMediaId:self.mediaId adCount:self.adCount imgWidth:_width imgHeight:_height success:^(NSDictionary *dataDict) {
        self.netAdDict = dataDict;
        NSString *adCount = [NSString stringWithFormat:@"%@",self.netAdDict[@"adCount"]];
        NSArray *adInfosArr = self.netAdDict[@"adInfos"];
        if (adInfosArr.count == adCount.integerValue) {
            NSMutableArray * mArr = [[NSMutableArray alloc]initWithCapacity:0];
            for (NSDictionary *dict in adInfosArr) {
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.imageUrl = dict[@"img_url"];
                backdata.IconUrl = dict[@"img_url"];
                backdata.adContent = dict[@"description"];
                backdata.adTitle = dict[@"title"];
                backdata.adID = (NSInteger)dict[@"adid"];
                [mArr addObject:backdata];
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                [self.delegate didLoadMutBannerAdView];
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
                [self.feedArray addObject:backdata];
            }
            
            NSArray *advertiser = dataDict[@"advertiser"];
            if(advertiser && ![advertiser isKindOfClass:[NSNull class]] && advertiser.count > 0){
                [self initIDSource];
            }
        }
    } fail:^(NSError *error) {
        [self failedError:error];
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
            _currentAD = advertiser;
            break;
        }
    }
    if (_currentAD == nil) {
        [self initS2S];
    }else{
        NSString *name = _currentAD[@"name"];
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
        NSDictionary *adplaces = [self->_currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId ];
        
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
            NSMutableArray * mArr = [[NSMutableArray alloc]initWithCapacity:0];
            self.isGDTLoadOK = YES;
            for (int index = 0; index < nativeAdDataArray.count; index ++ ) {
                GDTNativeAdData *data = nativeAdDataArray[index];
                NSDictionary * properties = data.properties;
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adContent = [properties objectForKey:GDTNativeAdDataKeyDesc];
                backdata.adTitle   = [properties objectForKey:GDTNativeAdDataKeyTitle];
                backdata.imageUrl  = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
                backdata.IconUrl   = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
                backdata.adID      = index;
                [mArr addObject:backdata];
            }
            
            [self.pageFlowView reloadData];
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                [self.tmpImageView removeFromSuperview];
                [self.delegate didLoadMutBannerAdView];
            }
            [self.adShowArr addObject:[NSString stringWithFormat:@"%d",0]];
            [self adShowUpToSever:0 sts:YES];
        }
        
    });
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    //渠道暂无广点通广告
    GDTNativeAdData *currentAdData = self.gdtArr[recognizer.view.tag];
    [self.nativeAd attachAd:currentAdData toView:self.controller.view];
    [self.nativeAd clickAd:currentAdData];
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:)]){
        
        [self.delegate didClickedMutBannerAdWithIndex:recognizer.view.tag];
    }
}

-(void)nativeAdFailToLoad:(NSError *)error
{
    NSError *errors = [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId];
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
        NSDictionary *adplaces = [self->_currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId ];
        
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        
        BUNativeAdsManager *nad = [BUNativeAdsManager new];
        //        BUNativeAd *nad = [BUNativeAd new];
        
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
        self.isWMAd = YES;
        if (nativeAdDataArray.count > 0) {
            
            self.adMArry = [nativeAdDataArray mutableCopy];
            
            [self.pageFlowView reloadData];
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadMutBannerAdView)]){
                [self.tmpImageView removeFromSuperview];
                [self.delegate didLoadMutBannerAdView];
            }
            [self.adShowArr addObject:[NSString stringWithFormat:@"%d",0]];
            [self adShowUpToSever:0 sts:YES];
        }
    });
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAdWithIndex:)]){
        [self.delegate didClickedMutBannerAdWithIndex:view.tag];
    }
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
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


@end
