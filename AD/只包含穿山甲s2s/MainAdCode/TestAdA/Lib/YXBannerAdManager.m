//
//  YXBannerAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/8.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXBannerAdManager.h"

#import "WXApi.h"
#import <SafariServices/SafariServices.h>

#import <BUAdSDK/BUAdSDK.h>

#import "NetTool.h"
#import "YXImgUtil.h"
#import "Network.h"
#import "YXWebViewController.h"

@interface YXBannerAdManager()<BUBannerAdViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,YXWebViewDelegate>
{
    CGFloat _width;
    CGFloat _height;
}

@property (nonatomic, strong) BUBannerAdView *wmBannerView;
@property (nonatomic, assign) BUProposalSize BUSize;

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
        self.BUSize = BUProposalSize_Banner600_90;
    } else if (self.adSize == YXAD_Banner600_100) {
        _width = self.bounds.size.width;
        _height = _width * 100 / 600;
        self.BUSize = BUProposalSize_Banner600_100;
    } else if (self.adSize == YXAD_Banner600_150) {
        _width = self.bounds.size.width;
        _height = _width * 150 / 600;
        self.BUSize = BUProposalSize_Banner600_150;
    } else if (self.adSize == YXAD_Banner600_260) {
        _width = self.bounds.size.width;
        _height = _width * 260 / 600;
        self.BUSize = BUProposalSize_Banner600_260;
    } else if (self.adSize == YXAD_Banner600_286) {
        _width = self.bounds.size.width;
        _height = _width * 286 / 600;
        self.BUSize = BUProposalSize_Banner600_286;
    } else if (self.adSize == YXAD_Banner600_300) {
        _width = self.bounds.size.width;
        _height = _width * 300 / 600;
        self.BUSize = BUProposalSize_Banner600_300;
    } else if (self.adSize == YXAD_Banner600_388) {
        _width = self.bounds.size.width;
        _height = _width * 388 / 600;
        self.BUSize = BUProposalSize_Banner600_388;
    } else if (self.adSize == YXAD_Banner600_400) {
        _width = self.bounds.size.width;
        _height = _width * 400 / 600;
        self.BUSize = BUProposalSize_Banner600_400;
    } else if (self.adSize == YXAD_Banner600_500) {
        _width = self.bounds.size.width;
        _height = _width * 500 / 600;
        self.BUSize = BUProposalSize_Banner600_500;
    } else {
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        self.BUSize = BUProposalSize_DrawFullScreen;
    }
    [self requestADSourceFromNet];
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *image = [UIImage imageNamed:@"BUAdSDK.bundle/bu_fullClose"];
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
    [Network requestADSourceFromMediaId:self.mediaId adCount:1 imgWidth:_width imgHeight:_height success:^(NSDictionary *dataDict) {
        self.AdDict = dataDict;
        NSArray *adInfosArr = dataDict[@"adInfos"];
        if (adInfosArr.count>0) {
            self.resultDict = adInfosArr.firstObject;
            [self ShowDirectAd];
            return ;
        }
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
        if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
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
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                NSArray * arr = json[@"adInfos"];
                if (arr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                self.resultDict = arr.lastObject;
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
                [self ShowDirectAd];
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
    // 1.跳转链接
    NSString *urlStr = self.resultDict[@"click_url"];
    
    NSString * click_position = [NSString stringWithFormat:@"%@",self.resultDict[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (self.resultDict[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",self.resultDict[@"width"]]];
        }
        if (self.resultDict[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",self.resultDict[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        
    }
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",self.resultDict[@"ac_type"]];
    
    if ([ac_type isEqualToString:@"1"] || [ac_type isEqualToString:@"2"]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
            [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
            
        } else {
            // Fallback on earlier versions
            YXWebViewController *web = [YXWebViewController new];
            web.URLString = urlStr;
            [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
        }
    } else if ([ac_type isEqualToString:@"6"]) {
        NSString *deeplick = _resultDict[@"deep_url"];
        NSURL *deeplickUrl = [NSURL URLWithString:deeplick];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:deeplickUrl options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    NSURL *url = [NSURL URLWithString:urlStr];
                    if (@available(iOS 9.0, *)) {
                        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                        [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
                        
                    } else {
                        YXWebViewController *web = [YXWebViewController new];
                        web.URLString = urlStr;
                        [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
                    }
                }
            }];
        }else{
            NSURL *url = [NSURL URLWithString:urlStr];
            if (@available(iOS 9.0, *)) {
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
                [[NetTool getCurrentViewController] showViewController:safariVC sender:nil];
                
            } else {
                YXWebViewController *web = [YXWebViewController new];
                web.URLString = urlStr;
                [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
            }
        }
        
    } else if ([ac_type isEqualToString:@"7"]){
        
        NSString * miniPath = [NSString stringWithFormat:@"%@",self.resultDict[@"miniPath"] ];
        miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * miniProgramOriginId = [NSString stringWithFormat:@"%@",self.resultDict[@"miniProgramOriginId"]];
        
        
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
        NSArray *viewS = self.resultDict[@"click_notice_urls"];
        if ([click_position isEqualToString:@"1"]) {
            
            if (self.resultDict[@"width"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",self.resultDict[@"width"]]];
            }
            if (self.resultDict[@"height"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",self.resultDict[@"height"]]];
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

- (void)closeBtnClicked
{
    if (self.wmBannerView) {
        [self.wmBannerView removeFromSuperview];
    }
    if (self.closeBtn) {
        [self.closeBtn removeFromSuperview];
    }
    [self removeFromSuperview];
}

#pragma mark 穿山甲

- (void)initChuanAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        [BUAdSDKManager setIsPaidApp:NO];
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId ];
        
        BUSize *size = [BUSize sizeBy:self.BUSize];
        if (self.isLoop) {
            self.wmBannerView = [[BUBannerAdView alloc] initWithSlotID:adplaces[@"adPlaceId"] size:size rootViewController:[NetTool getCurrentViewController] interval:self.interval];
        } else {
            self.wmBannerView = [[BUBannerAdView alloc] initWithSlotID:adplaces[@"adPlaceId"] size:size rootViewController:[NetTool getCurrentViewController]];
        }
        self.wmBannerView.frame = CGRectMake(0, 0, self->_width, self->_height);
        self.wmBannerView.delegate = self;
        [self addSubview:self.wmBannerView];
        [self.wmBannerView addSubview:self.closeBtn];
        
        [self.wmBannerView loadAdData];
        
        self.frame = ({
            CGRect frame = self.frame;
            CGFloat y = frame.origin.y;
            if (self.bannerType == BottomBannerType) {
                y = [UIScreen mainScreen].bounds.size.height - self.wmBannerView.frame.size.height - frame.origin.y;
            } else {
                y = frame.origin.y;
            }
            frame = CGRectMake(frame.origin.x, y, self->_width, self->_height);
            frame;
        });
    });
    
}
#pragma mark -  BUBannerAdViewDelegate implementation

- (void)bannerAdViewDidLoad:(BUBannerAdView * _Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
        [self.delegate didLoadBannerAd];
    }
    
}

- (void)bannerAdViewDidBecomVisible:(BUBannerAdView *_Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    
}

- (void)bannerAdViewDidClick:(BUBannerAdView *_Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerAd)]){
        [self.delegate didClickedBannerAd];
    }
}

- (void)bannerAdView:(BUBannerAdView *_Nonnull)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    [self initS2S];
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
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
