//
//  YXInterstitialAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/25.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXInterstitialAdManager.h"
#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"

#import "YXWebViewController.h"
#import "WXApi.h"
#import <SafariServices/SafariServices.h>

#import <BUAdSDK/BUAdSDK.h>
#import "GDTUnifiedInterstitialAd.h"

@interface YXInterstitialAdManager ()<GDTUnifiedInterstitialAdDelegate,BUNativeExpresInterstitialAdDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,YXWebViewDelegate>
{
    CGFloat _width;
    CGFloat _height;
    BOOL isOther;
}

@property (nonatomic, strong) NSDictionary *AdDict;
@property (nonatomic, strong) NSDictionary *currentAD;
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSDictionary *otherDict;

@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;

@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitial;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic,strong) UIButton *closeBtn;

@end

@implementation YXInterstitialAdManager


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = self.frame.size.width;
        _height = self.frame.size.height;
    }
    return self;
}
#pragma mark 开始加载广告
-(void)loadInterstitialAd
{
    self.userInteractionEnabled = YES;
    [self requestADSourceFromNet];
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *image = [UIImage imageNamed:@"XibAndPng.bundle/sf_fullClose"];
            [button setImage:image forState:UIControlStateNormal];
            button.frame = ({
                CGRect frame;
                frame = CGRectMake(self.frame.size.width - 15 - 5, 5, 15, 15);
                frame;
            });
            [button addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _closeBtn;
}

#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    WEAK(weakSelf);
    [Network requestADSourceFromMediaId:self.mediaId success:^(NSDictionary *dataDict) {
        weakSelf.AdDict = dataDict;
        NSArray *adInfosArr = dataDict[@"adInfos"];
        if (adInfosArr.count>0) {
            weakSelf.resultDict = adInfosArr.firstObject;
            for (NSDictionary *dict in adInfosArr) {
                if(dict[@"impress_notice_urls"] && [dict[@"impress_notice_urls"] isKindOfClass:[NSArray class]]){
                    NSArray * viewS = dict[@"impress_notice_urls"];
                    [Network groupNotifyToSerVer:viewS];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showNativeAd];
            });
            return ;
        }
        NSArray *advertiser = dataDict[@"advertiser"];
        if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
            [weakSelf initIDSource];
        }else{
            [weakSelf initS2S];
        }
    } fail:^(NSError *error) {
        [weakSelf failedError:error];
    }];
}
#pragma mark 分配广告
- (void)initIDSource
{
    NSArray *advertiserArr = self.AdDict[@"advertiser"];
    
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
            self.currentAD = advertiser;
            break;
        }
    }
    if (valueArray.count>1) {
        isOther = YES;
        for (int index = 0; index < valueArray.count; index ++ ) {
            NSDictionary *advertiser = valueArray[index];
            if (![advertiser isEqualToDictionary:self.currentAD]) {
                self.otherDict = advertiser;
            }
        }
    }
    if (self.currentAD == nil) {
        [self initS2S];
    }else{
        NSString *name = self.currentAD[@"name"];
        if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        } else if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        }else{
            [self initS2S];
        }
    }
}
#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    WEAK(weakSelf);
    [Network beginRequestWithADkey:self.mediaId width:_width height:_height adCount:1 finished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                NSArray * arr = json[@"adInfos"];
                if (arr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求广告数量为空" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                weakSelf.resultDict = arr.lastObject;
                if ([json objectForKey:@"data"]) {
                    if ([[json objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *muarray = [json objectForKey:@"data"];
                        if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
                        {
                            NSArray *viewS = muarray;
                            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                                [Network groupNotifyToSerVer:viewS];
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf showNativeAd];
                });
            }else{
                NSError *errors = [NSError errorWithDomain:@"广告配置解析失败" code:403 userInfo:nil];
                [weakSelf failedError:errors];
            }
        }else{
            NSError *errors = [NSError errorWithDomain:@"广告配置请求失败" code:404 userInfo:nil];
            [weakSelf failedError:errors];
        }
    }];
}

- (void)showNativeAd
{
    if(!self.resultDict){//40041无广告
        NSError *errors = [NSError errorWithDomain:@"暂无填充广告，请重试" code:400 userInfo:nil];
        [self failedError:errors];
        return;
    }
    NSString *img_url = self.resultDict[@"img_url"];
    NSString *lastCompnoments = [[img_url componentsSeparatedByString:@"/"] lastObject];
    if([lastCompnoments hasSuffix:@"gif"]){
        [self showGif];
    }else{
        [self showJpgImage];
    }
}

- (void)showGif
{
    [self addWebView];
    NSString *urlstr = self.resultDict[@"img_url"];
    if(urlstr && ![urlstr isEqualToString:@""]){
        // 1.加载
        [YXImgUtil gifImgWithUrl:urlstr successBlock:^(NSData *data) {
            
            [self.webView loadData:data MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:urlstr]];
            if (self.resultDict[@"logo_url"]) {
                NSString * logo_url = self.resultDict[@"logo_url"];
                UIImage *logoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logo_url]]];
                UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.webView.frame.size.width - 24 , self.webView.frame.size.height - 24, 24, 24)];
                logoView.image = logoImage ;
                [self.webView addSubview:logoView];
            }
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
                    [self.delegate didLoadInterstitialAd];
                }
                // 3.上报
                [self groupNotify];
            });
            
        } failBlock:^(NSError *error) {
            NSError *errors = [NSError errorWithDomain:@"加载Gif失败,请重试" code:400 userInfo:nil];
            [self failedError:errors];
        }];
    }else{
        // 3.加载下一副广告,使用定时器
        NSError *errors = [NSError errorWithDomain:@"加载Gif失败,请重试" code:400 userInfo:nil];
        [self failedError:errors];
    }
    
}

- (void)showJpgImage
{
    [self addImgView];
    NSString *urlstr = self.resultDict[@"img_url"];
    if(urlstr && ![urlstr isEqualToString:@""]){
        [YXImgUtil imgWithUrl:urlstr successBlock:^(UIImage *img) {
            self.imgView.image =img;
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
                    [self.delegate didLoadInterstitialAd];
                }
                // 3.上报
                [self groupNotify];
            });
            
        } failBlock:^(NSError *error) {
            NSError *errors = [NSError errorWithDomain:@"加载jpg失败,请重试" code:400 userInfo:nil];
            [self failedError:errors];
        }];
        
    }else{
        // 3.加载下一副广告,使用定时器 url不存在
        NSError *errors = [NSError errorWithDomain:@"加载jpg失败,请重试" code:400 userInfo:nil];
        [self failedError:errors];
    }
}

- (void)failedError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(didFailedLoadInterstitialAd:)]) {
            [self.delegate didFailedLoadInterstitialAd:error];
        }
    });
}
-(void) addWebView
{
    if(self.webView){
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    
    [self addSubview:self.webView];
    [self.webView addSubview:self.closeBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.webView addGestureRecognizer:tap];
    
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self ;
        [_webView setScalesPageToFit:YES];
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}
#pragma mark 设置图片展示模式
-(void) addImgView
{
    if(self.imgView){
        [self.imgView removeFromSuperview];
        self.imgView = nil;
    }
    
    [self addSubview:self.imgView];
    [self.imgView addSubview:self.closeBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    tap.numberOfTapsRequired = 1;
    [self.imgView addGestureRecognizer:tap];
}
// 点击图片信息
- (void)tapImg:(UITapGestureRecognizer *)recognizer
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGPoint point = [recognizer locationInView:window.rootViewController.view];
    NSString * x =  [NSString stringWithFormat:@"%f",point.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",point.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
    
    //    NSString *dicStr =  [NSString stringWithFormat:@"{%@:%@,%@:%@,%@:%@,%@:%@}",@"down_x",x,@"down_y",y,@"up_x",x,@"up_y",y];
    if(!self.resultDict){
        return;
    }
    
    [self ViewClickWithDict:self.resultDict Width:widthStr Height:heightStr X:x Y:y Controller:self.controller];
    [self clikedADs2sPan];
}

- (void)clikedADs2sPan
{
    if(_delegate && [_delegate respondsToSelector:@selector(didClickedInterstitialAd)]){
        [_delegate didClickedInterstitialAd];
    }
}

#pragma mark -webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    [self addTimer];
    //    if(_delegate && [_delegate respondsToSelector:@selector(showNativeFail:)]){
    //        [_delegate showNativeFail:error];
    //    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    // 3.上报
    [self groupNotify];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

#pragma mark 广点通
- (void)initGDTAD
{
    NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
    if (adplaces.allKeys.count == 0) {
        [self initS2S];
        return;
    }
    [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    
    self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}
#pragma mark - GDTMobInterstitialDelegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
        [self.delegate didLoadInterstitialAd];
    }
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAD]) {
            self.currentAD = self.otherDict;
            isOther = NO;
            [self initChuanAD];
        }
    } else {
        [self initS2S];
    }
    
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [Network upOutSideToServer:APIShow isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [Network upOutSideToServer:APIExposured isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    [Network upOutSideToServer:APIClick isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedInterstitialAd)]){
        [self.delegate didClickedInterstitialAd];
    }
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

#pragma mark 穿山甲

- (void)initChuanAD
{
    NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
    if (adplaces.allKeys.count == 0) {
        [self initS2S];
        return;
    }
    [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId ];
    [BUAdSDKManager setAppID: adplaces[@"appId"]];
    
    BUSize *imgSize1 = [[BUSize alloc] init];
    imgSize1.width = _width;
    imgSize1.height = _height;
    
    self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:adplaces[@"adPlaceId"] imgSize:[BUSize sizeBy:BUProposalSize_Interstitial600_600] adSize:CGSizeMake(_width, _height)];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdData];
}

/**
 This method is called when interstitial ad material loaded successfully.
 */
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
        [self.delegate didLoadInterstitialAd];
    }
    [self.interstitialAd showAdFromRootViewController:self.controller];
}

/**
 This method is called when interstitial ad material failed to load.
 @param error : the reason of error
 */
- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError * __nullable)error{
    if (isOther) {
        if (![self.otherDict isEqualToDictionary:self.currentAD]) {
            self.currentAD = self.otherDict;
            isOther = NO;
            [self initGDTAD];
        }
    } else {
        [self initS2S];
    }
    
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

/**
 This method is called when rendering a nativeExpressAdView successed.
 */
- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd{
    [Network upOutSideToServer:APIShow isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError * __nullable)error{}

/**
 This method is called when interstitial ad slot will be showing.
 */
- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd{}

/**
 This method is called when interstitial ad is clicked.
 */
- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd{
    [Network upOutSideToServer:APIClick isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedInterstitialAd)]){
        [self.delegate didClickedInterstitialAd];
    }
}

/**
 This method is called when interstitial ad is about to close.
 */
- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd{}

/**
 This method is called when interstitial ad is closed.
 */
- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd{}
#pragma mark -上报给指定服务器

-(void) groupNotify{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"]) {
        NSArray *viewS = self.resultDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count) {
            [Network groupNotifyToSerVer:viewS];
        }
    }
}

- (void)closeBtnClicked
{
    if (self.closeBtn) {
        [self.closeBtn removeFromSuperview];
    }
    if (self.imgView) {
        [self.imgView removeFromSuperview];
    }
    if (self.webView) {
        [self.webView removeFromSuperview];
    }
}

@end
