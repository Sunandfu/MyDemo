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

#import "NetTool.h"
#import "YXImgUtil.h"
#import "Network.h"
#import "YXWebViewController.h"

@interface YXBannerAdManager()<GDTMobBannerViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,YXWebViewDelegate>
{
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, strong) GDTMobBannerView *bannerView;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic, strong) NSDictionary *AdDict;
@property (nonatomic, strong) NSDictionary *currentAD;
@property (nonatomic, strong) NSDictionary *resultDict;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YXBannerAdManager

- (void)loadBannerAD{
    self.userInteractionEnabled = YES;
    if (self.adSize == YXAD_Banner600_90) {
        _width = self.bounds.size.width;
        _height = _width * 90 / 600;
    } else if (self.adSize == YXAD_Banner600_100) {
        _width = self.bounds.size.width;
        _height = _width * 100 / 600;
    } else if (self.adSize == YXAD_Banner600_150) {
        _width = self.bounds.size.width;
        _height = _width * 150 / 600;
    } else if (self.adSize == YXAD_Banner600_260) {
        _width = self.bounds.size.width;
        _height = _width * 260 / 600;
    } else if (self.adSize == YXAD_Banner600_286) {
        _width = self.bounds.size.width;
        _height = _width * 286 / 600;
    } else if (self.adSize == YXAD_Banner600_300) {
        _width = self.bounds.size.width;
        _height = _width * 300 / 600;
    } else if (self.adSize == YXAD_Banner600_388) {
        _width = self.bounds.size.width;
        _height = _width * 388 / 600;
    } else if (self.adSize == YXAD_Banner600_400) {
        _width = self.bounds.size.width;
        _height = _width * 400 / 600;
    } else if (self.adSize == YXAD_Banner600_500) {
        _width = self.bounds.size.width;
        _height = _width * 500 / 600;
    } else {
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
    }
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
    [Network requestADSourceFromMediaId:self.mediaId adCount:1 imgWidth:_width imgHeight:_height success:^(NSDictionary *dataDict) {
        weakSelf.AdDict = dataDict;
        NSArray *adInfosArr = dataDict[@"adInfos"];
        if (adInfosArr.count>0) {
            weakSelf.resultDict = adInfosArr.firstObject;
            [weakSelf ShowDirectAd];
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
    
    double random = 1 + arc4random()%99;
    
    double sumWeight = 0;
    
    for (int index = 0; index < valueArray.count; index ++ ) {
        NSDictionary *advertiser = valueArray[index];
        sumWeight += [advertiser[@"weight"] doubleValue];
        if (sumWeight >= random) {
            self.currentAD = advertiser;
            break;
        }
    }
    
    if (self.currentAD == nil) {
        [self initS2S];
    }else{
        NSString *name = self.currentAD[@"name"];
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        }
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
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:self.mediaId
                                                             width:_width
                                                            height:_height
                                                             macID:macId
                                                               uid:[NetTool getOpenUDID]
                                                           adCount:1];
    [self initXAD];
}
- (void)initXAD
{
    WEAK(weakSelf);
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                NSArray * arr = json[@"adInfos"];
                if (arr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
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
                [weakSelf ShowDirectAd];
            }else{
                NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                [weakSelf failedError:errors];
            }
        }else{
            NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
            [weakSelf failedError:errors];
        }
    }];
}
- (void)ShowDirectAd{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = ({
            CGRect frame = self.frame;
            CGFloat y = frame.origin.y;
            if (self.bannerType == BottomBannerType) {
                y = [UIScreen mainScreen].bounds.size.height - self->_height - frame.origin.y;
            } else {
                y = frame.origin.y;
            }
            frame = CGRectMake(frame.origin.x, y, self->_width, self->_height);
            frame;
        });
        [self showNativeAd];
    });
}
- (void)showNativeAd
{
    if(!self.resultDict){//40041无广告
        NSError *errors = [NSError errorWithDomain:@"暂无填充广告，请重试" code:400 userInfo:nil];
        [self failedError:errors];
        return;
    }
    NSString *img_url = self.resultDict[@"img_url"];
//    NSString *click_url = self.resultDict[@"click_url"];
//    _returnDict = [NSDictionary dictionaryWithObjectsAndKeys:click_url,@"click_url",img_url,@"img_url",@"1",@"type", nil];
//    if (self.resultDict[@"logo_url"]) {
//        NSString * logo_url = self.resultDict[@"logo_url"] ;
//        _returnDict = [NSDictionary dictionaryWithObjectsAndKeys:logo_url,@"logo_url",click_url,@"click_url",img_url,@"img_url",@"1",@"type", nil];
//    }
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
            // 2.显示成功
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
                    [self.delegate didLoadBannerAd];
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
                if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
                    [self.delegate didLoadBannerAd];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFailedLoadBannerAd:)]) {
            [self.delegate didFailedLoadBannerAd:error];
        }
    });
}
-(void) addWebView
{
    if(self.webView){
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.webView];
    
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
    [self addSubview:self.closeBtn];
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
    
    [self ViewClickWithDict:self.resultDict Width:widthStr Height:heightStr X:x Y:y];
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
    return YES;
}

#pragma mark -上报给指定服务器
-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSArray *viewS = self.resultDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}

#pragma mark 广点通
- (void)initGDTAD
{
    //    4090812164690039
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId ];
        
//        CGRect rect = {0,0, GDTMOB_AD_SUGGEST_SIZE_320x50};
        CGRect rect = {0,0, self->_width,50};
        if (self.isLoop) {
            self.bannerView = [[GDTMobBannerView alloc] initWithFrame:rect appId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
            self.bannerView.currentViewController = [NetTool getCurrentViewController];
            self.bannerView.interval = (int)self.interval;
            self.bannerView.showCloseBtn = NO;
            self.bannerView.delegate = self;
            [self addSubview:self.bannerView];
            [self.bannerView addSubview:self.closeBtn];
        } else {
            self.bannerView = [[GDTMobBannerView alloc] initWithFrame:rect appId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
            self.bannerView.currentViewController = [NetTool getCurrentViewController];
            self.bannerView.interval = 0;
            self.bannerView.isAnimationOn = NO;
            self.bannerView.showCloseBtn = NO;
            self.bannerView.isGpsOn = NO;
            self.bannerView.delegate = self;
            [self addSubview:self.bannerView];
            [self.bannerView addSubview:self.closeBtn];
        }
//        self.bannerView.frame = CGRectMake(0, 0, self->_width, self->_height);
        [self.bannerView loadAdAndShow];
        self.frame = ({
            CGRect frame = self.frame;
            CGFloat y = frame.origin.y;
            if (self.bannerType == BottomBannerType) {
                y = [UIScreen mainScreen].bounds.size.height - self.bannerView.frame.size.height - frame.origin.y;
            } else {
                y = frame.origin.y;
            }
            frame = CGRectMake(frame.origin.x, y, frame.size.width, 50);
            frame;
        });
    });
}
- (void)closeBtnClicked
{
    
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
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
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
        [self.delegate didLoadBannerAd];
    }
}

// 请求广告条数据失败后调用
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    [self initS2S];
    NSError *errors = [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
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
}


-(void)bannerViewDidDismissFullScreenModal
{
}

-(void)bannerViewWillDismissFullScreenModal
{
}

-(void)bannerViewWillPresentFullScreenModal
{
}

-(void)bannerViewDidPresentFullScreenModal
{
}

@end
