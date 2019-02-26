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

#import "YXNewPagedFlowView.h"
#import "YXPGIndexBannerSubiew.h"

#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeAdsManager.h>




//是否缓存配置
#define ISCache 0
//直走s2s
#define GOS2S 0

#define Normal 1

#import "YXLCdes.h"

@interface YXMutBannerAdManager()<BUNativeAdDelegate,BUNativeAdsManagerDelegate,YXNewPagedFlowViewDelegate, YXNewPagedFlowViewDataSource>
{
    NSArray *adArr;
    
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    CGFloat _width;
    CGFloat _height;
    NSDictionary *_resultDict;
}

@property (nonatomic, strong) BUNativeAdsManager *adManager;

@property (nonatomic,strong) UIView *registerAdView;

@property (nonatomic,strong) NSMutableArray * adMArry;

@property (nonatomic,assign) BOOL isLoadS;//是否s2s加载成功

@property (nonatomic,assign) BOOL isWMAd;//是否穿山甲加载成功

@property (nonatomic,strong) YXNewPagedFlowView *pageFlowView;

@property (nonatomic,strong) NSMutableArray *adShowArr;//存储上报 数组

@end


@implementation YXMutBannerAdManager

#pragma mark YXNewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(YXNewPagedFlowView *)flowView {
    if (self.isWMAd) {
        return self.adMArry.count;
    }else{
        return self->adArr.count;
    }
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
//    NSLog(@"上报:%ld",(long)index);
    
    if (isBU) {
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    }else{
        
        NSDictionary * dic = self->adArr[index];
        NSArray * viewS = dic[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
    
}

- (YXPGIndexBannerSubiew *)flowView:(YXNewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    YXPGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[YXPGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.mainImageView.tag = index;
    }
    if (self.isWMAd) {
        BUNativeAd *wmAdData = self.adMArry[index];
        BUMaterialMeta *adMeta = wmAdData.data;
        NSString * imgUrl;
        if (adMeta.imageAry.count > 0) {
            BUImage *adImage = adMeta.imageAry.firstObject;
            if (adImage.imageURL.length > 0) {
                imgUrl =  adImage.imageURL;
                [NetTool setImage:bannerView.mainImageView WithURL:[NSURL URLWithString:imgUrl] placeholderImage:self.placeImage?self.placeImage:nil];
                [wmAdData registerContainer:bannerView withClickableViews:nil];
            }
        }
    }else{
        _resultDict = self->adArr[index];
        if (_resultDict) {
            NSString * imgUrl = [NSString stringWithFormat:@"%@",_resultDict[@"img_url"]];
            [NetTool setImage:bannerView.mainImageView WithURL:[NSURL URLWithString:imgUrl] placeholderImage:self.placeImage?self.placeImage:nil];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
            [bannerView.mainImageView addGestureRecognizer:tap];
            
        }
        
    }
    return bannerView;
}
#pragma mark -
#pragma mark Private Methods
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
    
    self.adCount = 1;
    
    self->adArr = nil;
    self->adArr = [[NSArray alloc]init];
    
    [self.adMArry  removeAllObjects];
    self.adMArry = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.adShowArr  removeAllObjects];
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    
}


#pragma mark 开始加载广告
-(void)loadMutBannerAdViewsInView:(UIView *)view
{
    self.isLoadS = NO;
    self.isWMAd = NO;
    [self.adMArry  removeAllObjects];
    [self.adShowArr  removeAllObjects];
    
    view.userInteractionEnabled = YES;
    _pageFlowView = [[YXNewPagedFlowView alloc] initWithFrame:view.bounds];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0;
    _pageFlowView.isCarousel = self.isCarousel;
    _pageFlowView.isOpenAutoScroll = self.isOpenAutoScroll;
    _pageFlowView.autoTime = self.autoTime;
    
    _pageFlowView.orientation = self.orientation;
    
    
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
    }else if(self.adSize == YXADSize750X326) {
        size.width = 750;
        size.height = 326;
    }else{
        size.width = 288;
        size.height = 150;
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
                self->adArr = json[@"adInfos"];
                if (self->adArr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                //                self->_resultDict = dict;
                //                self->_adDict = dict;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isLoadS = YES;
                    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithCapacity:0];
                    for (NSDictionary *dict in self->adArr) {
                        
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
    
    _resultDict = self->adArr[recognizer.view.tag];
    
    //    NSString *dicStr =  [NSString stringWithFormat:@"{%@:%@,%@:%@,%@:%@,%@:%@}",@"down_x",x,@"down_y",y,@"up_x",x,@"up_y",y];
    if(!_resultDict){
        return;
    }
    // 1.跳转链接
    NSString *urlStr = _resultDict[@"click_url"];
//
//    NSLog(@"%@",_resultDict[@"img_url"]);
    
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
            UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
            [rootVC showViewController:safariVC sender:nil];
            
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
    [self clikedADs2sPan];
}

- (void)clikedADs2sPan
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAd)]){
        
        [self.delegate didClickedMutBannerAd];
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    
    int netnumber = [NetTool getNetTyepe];
    
    NSString *dataStr = [NSString stringWithFormat:@"pkg=%@&idfa=%@&ts=%@&os=%@&osv=%@&w=%@&h=%@&model=%@&nt=%@&mac=%@",[NetTool URLEncodedString:[NetTool getPackageName]],[NetTool getIDFA],timeLocal,@"IOS",[NetTool URLEncodedString:[NetTool getOS]],@(c_w),@(c_h),[NetTool URLEncodedString:[NetTool gettelModel]],@(netnumber),[NetTool URLEncodedString:[NetTool getMac]]];
    
    
    NSString *strURL =  [NSString stringWithFormat:congfigIp,[NetTool URLEncodedString:_mediaId], [NetTool getPackageName],@"2",dataStr];
    
    
    [request setURL:[NSURL URLWithString:strURL]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    [request setTimeoutInterval:3];
    
    [request setHTTPMethod:@"GET"];
    [NSURLConnection  sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //            handler(response,data,connectionError);
        if(connectionError){
            _YXGTMDevLog(@"#####%@\error",[connectionError debugDescription]);
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [self failedError:errors];
        }else{
            
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray *dataArr = [dataStr componentsSeparatedByString:@":"];
            
            if (dataArr.count < 2) {
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                [self failedError:errors];
                return ;
            }
            
            NSString *dataDe = dataArr[1];
            
            dataDe = [dataDe stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            dataDe = [dataDe stringByReplacingOccurrencesOfString:@"}" withString:@""];
            
            NSString * datadecrypt = [YXLCdes decrypt:dataDe];
            
            NSDictionary *dic = [self dictionaryWithJsonString:datadecrypt];
            
            //            NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            self->_gdtAD = dic ;
            NSArray *advertiser = dic[@"advertiser"];
            
            NSString *adNetCount = [NSString stringWithFormat:@"%@",dic[@"adCount"]];
            self.adCount = self.adCount<1?adNetCount.integerValue:self.adCount;
            
            if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
                [self initIDSource];
            }else{
                [self initS2S];
            }
        }
        
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        //        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark 分配广告
- (void)initIDSource
{
    NSArray *advertiserArr = _gdtAD[@"advertiser"];
    
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
    //
#if GOS2S
    random = 60;
#endif
    
    
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
        }else{
            [self initS2S];
        }
    }
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
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId ];
        
        
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
        
        [nad loadAdDataWithCount:self.adCount];
        
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
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedMutBannerAd)]){
        
        [self.delegate didClickedMutBannerAd];
    }
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark -上报给指定服务器

-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        for (NSDictionary * dict in self->adArr) {
            
            NSArray * viewS = dict[@"impress_notice_urls"];
            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                [Network groupNotifyToSerVer:viewS];
            }
        }
        
    }
}


@end
