//
//  YXBannerAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/8.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXBannerAdManager.h"
#import "GDTMobBannerView.h"

#import "WXApi.h"
#import <SafariServices/SafariServices.h>

#import <BUAdSDK/BUAdSDK.h>


#import "NetTool.h"
#import "YXImgUtil.h"
#import "YXLCdes.h"
#import "Network.h"
#import "YXWebViewController.h"
//直走s2s
#define GOS2S 0

@interface YXBannerAdManager()<GDTMobBannerViewDelegate,BUBannerAdViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,YXWebViewDelegate>
{
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    CGFloat _width;
    CGFloat _height;
    NSDictionary * _adDict;
    NSDictionary *_resultDict;
    NSDictionary *_returnDict;
    
    UIImageView *_imgView;
    UIWebView *_webView;
    
    NSString *_mediaId;
    NSString*_initID;
    
}
@property(nonatomic,assign) id<YXBannerAdManagerDelegate> delegate;

@property (nonatomic, strong) GDTMobBannerView *bannerView;
@property (nonatomic, strong) BUBannerAdView *wmBannerView;

@property (nonatomic,assign) BannerLocationType myBannerType;

@property (nonatomic,strong) UIButton *closeBtn;




@end
@implementation YXBannerAdManager

-(instancetype)initWithFrame:(CGRect)frame
                    delegate:(id<YXBannerAdManagerDelegate>)delegate
                     mediaId:(NSString *)mediaId
              BannerLocation:(BannerLocationType)bannerType
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.userInteractionEnabled = YES;
        _width = frame.size.width;
        _height = frame.size.height;
        _mediaId = mediaId;
        _myBannerType = bannerType;
        [self requestADSourceFromNet];
        //        [self initChuanAD];
        //        [self initGDTAD];
    }
    return self;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *image = [UIImage imageNamed:@"YDSource.bundle/yd_fullClose"];
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
    [Network requestADSourceFromMediaId:_mediaId success:^(NSDictionary *dataDict) {
        self->_gdtAD = dataDict;
        NSArray *advertiser = dataDict[@"advertiser"];
        if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
            [self initIDSource];
        }else{
            [self initS2S];
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
        }else if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        }
        //        else if ([name isEqualToString:@"百度SDK"]){
        //            [self initBaiduAD];
        //        }
        else{
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
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId
                                                             width:_width
                                                            height:_height
                                                             macID:macId
                                                               uid:[NetTool getOpenUDID]
                                                           adCount:1];
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
                //                self->_resultDict = dict;
                //                self->_adDict = dict;
                
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
                    self.frame = ({
                        CGRect frame = self.frame;
                        
                        CGFloat y = frame.origin.y;
                        if (self.myBannerType == BottomBannerType) {
                            y = [UIScreen mainScreen].bounds.size.height  - frame.origin.y - frame.size.height;
                        }
                        
                        frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
                        frame;
                    });
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
                
                if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadBannerAd:)]){
                    
                    [self->_delegate didLoadBannerAd:self];
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
                
                if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadBannerAd:)]){
                    
                    [self->_delegate didLoadBannerAd:self];
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
        if ([self.delegate respondsToSelector:@selector(didFailedLoadBannerAd:)]) {
            
            [self->_delegate didFailedLoadBannerAd:error];
        }
    });
    
}
-(void) addWebView
{
    if(_webView){
        [_webView removeFromSuperview];
        _webView = nil;
    }
    
    _webView = [[UIWebView alloc]initWithFrame:self.bounds];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self ;
    [_webView setScalesPageToFit:YES];
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    [self addSubview:self.closeBtn];
    
    [self addSubview:_webView];
    
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
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    _imgView = imgView;
    
#pragma mark 设置图片展示模式
    //    imgView.contentMode
    imgView.userInteractionEnabled = YES;
    [self addSubview:_imgView];
    [self addSubview:self.closeBtn];
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
    
    NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
    NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
    
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
            
            [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
            
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
    if(_delegate && [_delegate respondsToSelector:@selector(didClickedBannerAd)]){
        [_delegate didClickedBannerAd];
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
    
    //    [[UIApplication sharedApplication] openURL:request.URL];
    return YES;
}

#pragma mark -上报给指定服务器
-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSArray *viewS = _adDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}

#pragma mark 广点通

//- (GDTMobBannerView *)bannerView
//{
//    if (!_bannerView) {
//        CGRect rect = {0,0, GDTMOB_AD_SUGGEST_SIZE_320x50};
//        _bannerView = [[GDTMobBannerView alloc] initWithFrame:rect appId:@"9040714184494018" placementId:@"4090812164690039"];
//        _bannerView.currentViewController = [NetTool getCurrentViewController];
//        _bannerView.interval = 0;
//        _bannerView.isAnimationOn = NO;
//        _bannerView.showCloseBtn = NO;
//        _bannerView.isGpsOn = YES;
//        _bannerView.delegate = self;
//    }
//    return _bannerView;
//}

- (void)initGDTAD
{
    //    4090812164690039
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = ({
            CGRect frame = self.frame;
            
            CGFloat y = frame.origin.y;
            if (self.myBannerType == BottomBannerType) {
                y = [UIScreen mainScreen].bounds.size.height - 50 - frame.origin.y;
            }
            
            frame = CGRectMake(frame.origin.x, y, frame.size.width, 50);
            frame;
        });
        
        NSDictionary *adplaces = [self->_currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId ];
        
        CGRect rect = {0,0, GDTMOB_AD_SUGGEST_SIZE_320x50};
        
        self.bannerView = [[GDTMobBannerView alloc] initWithFrame:rect appId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        
        self.bannerView.currentViewController = [NetTool getCurrentViewController];
        self.bannerView.interval = 0;
        self.bannerView.isAnimationOn = NO;
        self.bannerView.showCloseBtn = NO;
        self.bannerView.isGpsOn = NO;
        self.bannerView.delegate = self;
        
        [self.bannerView loadAdAndShow];
        
        [self addSubview:self.bannerView];
        
        self.bannerView.frame = ({
            CGRect frame;
            frame = CGRectMake(0, 0, self.frame.size.width, 50);
            frame;
        });
        
        [self.bannerView addSubview:self.closeBtn];
        
        
    });
}
- (void)closeBtnClicked
{
    
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
    if (self.wmBannerView) {
        [self.wmBannerView removeFromSuperview];
    }
    if (self.closeBtn) {
        [self.closeBtn removeFromSuperview];
    }
    [self removeFromSuperview];
}
#pragma mark - GDTMobBannerViewDelegate
// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    //    NSLog(@"banner Received");
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId];
    if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadBannerAd:)]){
        
        [self->_delegate didLoadBannerAd:self];
    }
    
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    //    NSLog(@"banner failed to Received : %@",error);
    NSError *errors = [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId];
}

// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerAd)]){
        
        [self.delegate didClickedBannerAd];
    }
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    //    NSLog(@"banner leave application");
}


-(void)bannerViewDidDismissFullScreenModal
{
    //    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewWillDismissFullScreenModal
{
    //    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewWillPresentFullScreenModal
{
    //    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewDidPresentFullScreenModal
{
    //    NSLog(@"%s",__FUNCTION__);
}


#pragma mark 穿山甲

//- (BUBannerAdView *)wmBannerView
//{
//    if (!_wmBannerView) {
//        BUSize *size = [BUSize sizeBy:BUProposalSize_Banner600_150];
//        _wmBannerView = [[BUBannerAdView alloc] initWithSlotID:@"900546859" size:size rootViewController:[NetTool getCurrentViewController]];
//
//        const CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
//        CGFloat bannerHeight = screenWidth * size.height / size.width;
//        _wmBannerView.frame = CGRectMake(0, 0, screenWidth, bannerHeight);
//        _wmBannerView.delegate = self;
//        [_wmBannerView loadAdData];
//    }
//    return _wmBannerView;
//}

- (void)initChuanAD
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSDictionary *adplaces = [self->_currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        
        [BUAdSDKManager setIsPaidApp:NO];
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
        //        NSLog(@"SDKVersion = %@", [BUAdSDKManager SDKVersion]);
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId ];
        
        BUSize *size = [BUSize sizeBy:BUProposalSize_Banner600_100];
        self.wmBannerView = [[BUBannerAdView alloc] initWithSlotID:adplaces[@"adPlaceId"] size:size rootViewController:[NetTool getCurrentViewController]];
        const CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat bannerHeight = screenWidth * size.height / size.width;
        self.wmBannerView.frame = CGRectMake(0, 0, screenWidth, bannerHeight);
        self.wmBannerView.delegate = self;
        //        self.wmBannerView.
        [self.wmBannerView loadAdData];
        
        [self addSubview:self.wmBannerView];
        
        [self.wmBannerView addSubview:self.closeBtn];
        
        self.frame = ({
            CGRect frame = self.frame;
            
            CGFloat y = frame.origin.y;
            if (self.myBannerType == BottomBannerType) {
                y = [UIScreen mainScreen].bounds.size.height - self.wmBannerView.frame.size.height - frame.origin.y;
            }
            
            frame = CGRectMake(frame.origin.x, y, frame.size.width, self.wmBannerView.frame.size.height);
            frame;
        });
    });
    
}
#pragma mark -  BUBannerAdViewDelegate implementation

- (void)bannerAdViewDidLoad:(BUBannerAdView * _Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    //    NSLog(@"***********banner load**************");
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId];
    if(self->_delegate && [self->_delegate respondsToSelector:@selector(didLoadBannerAd:)]){
        
        [self->_delegate didLoadBannerAd:self];
    }
    
}

- (void)bannerAdViewDidBecomVisible:(BUBannerAdView *_Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    
}

- (void)bannerAdViewDidClick:(BUBannerAdView *_Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerAd)]){
        
        [self.delegate didClickedBannerAd];
    }
}

- (void)bannerAdView:(BUBannerAdView *_Nonnull)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    //    NSLog(@"%s %@", __PRETTY_FUNCTION__, error.localizedDescription);
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self->_mediaId];
}

- (void)bannerAdView:(BUBannerAdView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    [UIView animateWithDuration:0.25 animations:^{
        bannerAdView.alpha = 0;
    } completion:^(BOOL finished) {
        [bannerAdView removeFromSuperview];
        self.wmBannerView = nil;
    }];
}


@end
