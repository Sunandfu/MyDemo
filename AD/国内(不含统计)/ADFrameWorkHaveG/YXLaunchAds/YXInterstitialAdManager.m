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
#import "YXLCdes.h"

#import "YXWebViewController.h"
#import "WXApi.h"
#import <SafariServices/SafariServices.h>

#import <BUAdSDK/BUAdSDK.h>
#import "GDTMobInterstitial.h"

//是否缓存配置
#define ISCache 0
//直走s2s
#define GOS2S 0

#define GOGoogle 0

#define Normal 1


@interface YXInterstitialAdManager ()<GDTMobInterstitialDelegate,BUInterstitialAdDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,YXWebViewDelegate>
{
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    
    NSDictionary * _adDict;
    NSDictionary *_resultDict;
    NSDictionary *_returnDict;
    
    UIImageView *_imgView;
    UIWebView *_webView;
}

@property (nonatomic, strong) BUInterstitialAd *interstitialAd;

@property (nonatomic, strong) GDTMobInterstitial *interstitial;

@property (nonatomic,strong) UIViewController *rootViewController;

@property (nonatomic,strong) UIButton *closeBtn;

@end

@implementation YXInterstitialAdManager

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *image = [UIImage imageNamed:@"BUAdSDK.bundle/wm_fullClose"];
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

- (void)closeBtnClicked
{
    
//    if (self.bannerView) {
//        [self.bannerView removeFromSuperview];
//    }
//    if (self.wmBannerView) {
//        [self.wmBannerView removeFromSuperview];
//    }
    if (self.closeBtn) {
        [self.closeBtn removeFromSuperview];
    }
    if (_imgView) {
        [_imgView removeFromSuperview];
    }
}

- (void)showFeedAdWithViewController:(UIViewController *)rootViewController
{
    _rootViewController = rootViewController;
}

#pragma mark 开始加载广告
-(void)loadFeedAd
{
    [self requestADSourceFromNet];
}

#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    [Network requestADSourceFromMediaId:self.mediaId success:^(NSDictionary *dataDict) {
        self->_gdtAD = dataDict ;
        NSArray *advertiser = dataDict[@"advertiser"];
        if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
            [self initIDSource];
        }else{
            
        }
    } fail:^(NSError *error) {
        [self failedError:error];
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
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        } else if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
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
    NSString *macId = [Network sharedInstance].ipStr;
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:self.frame.size.width height:self.frame.size.height macID:macId uid:[NetTool getOpenUDID] adCount:1];
    [self initXAD];
}
- (void)initXAD
{
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                NSArray * arr = json[@"adInfos"];
                if (arr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                self->_resultDict = arr.lastObject;
                self->_adDict = arr.lastObject;
                
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
                    [self   showNativeAd];
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

-(void) showNativeAd
{
    //    NSLog(@"showBannerAd_resultDict %@",_resultDict) ;
    if(!_resultDict){//40041无广告
        NSError *errors = [NSError errorWithDomain:@"暂无填充广告，请重试" code:400 userInfo:nil];
        [self failedError:errors];
        return;
    }
    _YXGTMDevLog(@"Func type 1 start") ;
    NSString *img_url = _resultDict[@"img_url"];
    NSString *click_url = _resultDict[@"click_url"];
    _returnDict = [NSDictionary dictionaryWithObjectsAndKeys:click_url,@"click_url",img_url,@"img_url",@"1",@"type", nil];
    if (_resultDict[@"logo_url"]) {
        NSString * logo_url = _resultDict[@"logo_url"] ;
        _returnDict = [NSDictionary dictionaryWithObjectsAndKeys:logo_url,@"logo_url",click_url,@"click_url",img_url,@"img_url",@"1",@"type", nil];
    }
    NSString *lastCompnoments = [[img_url componentsSeparatedByString:@"/"] lastObject];
    if([lastCompnoments hasSuffix:@"gif"]){
        [self showGif];
    }else{
        [self showJpgImage];
    }
}

-(void) showGif
{
    [self addWebView];
    NSString *urlstr = _resultDict[@"img_url"];
    if(urlstr && ![urlstr isEqualToString:@""]){
        // 1.加载
        [YXImgUtil gifImgWithUrl:urlstr successBlock:^(NSData *data) {
            
            [self->_webView loadData:data MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:urlstr]];
            if (self->_resultDict[@"logo_url"]) {
                NSString * logo_url = self->_resultDict[@"logo_url"];
                UIImage *logoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logo_url]]];
                UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self->_webView.frame.size.width - 24 , self->_webView.frame.size.height - 24, 24, 24)];
                logoView.image = logoImage ;
                [self->_webView addSubview:logoView];
            }
            // 2.显示成功
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
                    
                    [self->_delegate didLoadInterstitialAd];
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

-(void)showJpgImage
{
    [self addImgView];
    
    NSString *urlstr = _resultDict[@"img_url"];
    if(urlstr && ![urlstr isEqualToString:@""]){
        
        [YXImgUtil imgWithUrl:urlstr successBlock:^(UIImage *img) {
            self->_imgView.image =img;
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
                    
                    [self->_delegate didLoadInterstitialAd];
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
            
            [self->_delegate didFailedLoadInterstitialAd:error];
        }
    });
    
}
-(void) addWebView
{
    if(_webView){
        [_webView removeFromSuperview];
        _webView = nil;
    }
    
    _webView = [[UIWebView alloc]initWithFrame:self.frame];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self ;
    [_webView setScalesPageToFit:YES];
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    [self.rootViewController.view addSubview:_webView];
    [self.rootViewController.view addSubview:self.closeBtn];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [_webView addGestureRecognizer:tap];
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) addImgView
{
    if(_imgView){
        [_imgView removeFromSuperview];
        _imgView = nil;
    }
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.frame];
    _imgView = imgView;
    
#pragma mark 设置图片展示模式
    //    imgView.contentMode
    imgView.userInteractionEnabled = YES;
    [self.rootViewController.view addSubview:_imgView];
    [self.rootViewController.view addSubview:self.closeBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    tap.numberOfTapsRequired = 1;
    [_imgView addGestureRecognizer:tap];
}
// 点击图片信息
-(void)tapImg:(UITapGestureRecognizer *)recognizer
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    CGPoint point = [recognizer locationInView:window.rootViewController.view];
    NSString * x =  [NSString stringWithFormat:@"%f",point.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",point.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%f",self.frame.size.width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",self.frame.size.height];
    
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
    
    //    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,dicStr];
    
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",_resultDict[@"ac_type"]];
    
    if ([ac_type isEqualToString:@"1"] || [ac_type isEqualToString:@"2"]) {
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YXWebViewController *web = [YXWebViewController new];
            web.URLString = urlStr;
            web.delegate = self;
            [self.rootViewController presentViewController:web animated:YES completion:nil];
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
    [[UIApplication sharedApplication] openURL:request.URL];
    return YES;
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
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId ];
        
        
        if(self.interstitial) {
            self.interstitial.delegate = nil;
        }
        self.interstitial = [[GDTMobInterstitial alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.interstitial.delegate = self;
        
        [self.interstitial loadAd];
    });
}
#pragma mark - GDTMobInterstitialDelegate
// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
        [self->_delegate didLoadInterstitialAd];
    }
    [self.interstitial presentFromRootViewController:self.rootViewController];
    
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}

// 插屏广告将要展示回调
//
// 详解: 插屏广告即将展示回调该函数
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}

// 插屏广告视图展示成功回调
//
// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    
}

// 插屏广告展示结束回调
//
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    
}

// 应用进入后台时回调
//
// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    
}
/**
 *  插屏广告点击回调
 */
- (void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedInterstitialAd)]){
        
        [self.delegate didClickedInterstitialAd];
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
        
        BUSize *imgSize1 = [[BUSize alloc] init];
        imgSize1.width = self.frame.size.width;
        imgSize1.height = self.frame.size.height;
        
        
        self.interstitialAd = [[BUInterstitialAd alloc] initWithSlotID:adplaces[@"adPlaceId"] size:[BUSize sizeBy:BUProposalSize_Interstitial600_600]];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAdData];
        
    });
}

/**
 点击插屏广告 回调该函数， 期间可能调起 AppStore ThirdApp WebView etc.
 - Parameter interstitialAd: 产生该事件的 BUInterstitialAd 对象.
 */
- (void)interstitialAdDidClick:(BUInterstitialAd *)interstitialAd
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId]; 
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedInterstitialAd)]){
        
        [self.delegate didClickedInterstitialAd];
    }
}
/**
 BUInterstitialAd 广告加载成功
 
 - Parameter interstitialAd: 产生该事件的 BUInterstitialAd 对象.
 */
- (void)interstitialAdDidLoad:(BUInterstitialAd *)interstitialAd
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadInterstitialAd)]){
        [self->_delegate didLoadInterstitialAd];
    }
    [self.interstitialAd showAdFromRootViewController:self.rootViewController];
}
/**
 即将展示 插屏广告
 - Parameter interstitialAd: 产生该事件的 BUInterstitialAd 对象.
 */
- (void)interstitialAdWillVisible:(BUInterstitialAd *)interstitialAd
{
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}

/**
 BUInterstitialAd 加载失败
 
 - Parameter interstitialAd: 产生该事件的 BUInterstitialAd 对象.
 - Parameter error: 包含详细是失败信息.
 */
- (void)interstitialAd:(BUInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}

#pragma mark -上报给指定服务器

-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSArray *viewS = _resultDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}
 

@end
