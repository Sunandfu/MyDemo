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

#import "SFGDTADViewController.h"
#import "SFChuanADViewControl.h"

#import "NetTool.h"
#import "YXImgUtil.h"
#import "Network.h"
#import "YXWebViewController.h"

@interface YXBannerAdManager()<SFADViewDelegate,ChuanManngerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,YXWebViewDelegate>
{
    CGFloat _width;
    CGFloat _height;
    BOOL isOther;
}

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic, strong) NSDictionary *AdDict;
@property (nonatomic, strong) NSDictionary *currentAD;
@property (nonatomic, strong) NSDictionary *resultDict;
@property (nonatomic, strong) NSDictionary *otherDict;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YXBannerAdManager

- (void)loadBannerAD{
    self.userInteractionEnabled = YES;
    isOther = NO;
    const CGFloat bannerScreenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    _width = bannerScreenWidth;
    _height = _width * 150 / 600;
    if (self.mediaId==nil) {
        NSLog(@"请正确传入媒体位");
    }
    [self requestADSourceFromNet];
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_fullClose"] forState:UIControlStateNormal];
        _closeBtn.frame = CGRectMake(self.frame.size.width - 20 - 5, 5, 20, 20);
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
            for (NSDictionary *dict in adInfosArr) {
                if(dict[@"impress_notice_urls"] && [dict[@"impress_notice_urls"] isKindOfClass:[NSArray class]]){
                    NSArray * viewS = dict[@"impress_notice_urls"];
                    [Network groupNotifyToSerVer:viewS];
                }
            }
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
                    NSError *errors = [NSError errorWithDomain:@"广告数据请求为空" code:400 userInfo:nil];
                    [weakSelf failedError:errors];
                    return ;
                }
                weakSelf.resultDict = arr.lastObject;
                if ([json objectForKey:@"data"] && [[json objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *muarray = [json objectForKey:@"data"];
                    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
                    {
                        NSArray *viewS = muarray;
                        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                            [Network groupNotifyToSerVer:viewS];
                        }
                    }
                }
                [weakSelf ShowDirectAd];
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
- (void)ShowDirectAd{
    self.frame = ({
        CGRect frame = self.frame;
        CGFloat y = frame.origin.y;
        if (self.bannerType == BottomBannerType) {
            y = [UIScreen mainScreen].bounds.size.height - _height - self.locationY;
        } else {
            y = self.locationY;
        }
        frame = CGRectMake(0, y, _width, _height);
        frame;
    });
    [self showNativeAd];
}
- (void)showNativeAd{
    if(!self.resultDict){//40041无广告
        NSError *errors = [NSError errorWithDomain:@"暂无填充广告，请重试" code:40041 userInfo:nil];
        [self failedError:errors];
        return;
    }
    NSString *img_url = [NSString stringWithFormat:@"%@",self.resultDict[@"img_url"]];
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
    NSString *urlstr = [NSString stringWithFormat:@"%@",self.resultDict[@"img_url"]];
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
    
    NSString *urlstr = [NSString stringWithFormat:@"%@",self.resultDict[@"img_url"]];
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
        [_webView addSubview:self.closeBtn];
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
        [_imgView addSubview:self.closeBtn];
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
    if(_delegate && [_delegate respondsToSelector:@selector(didClickedBannerAd)]){
        [_delegate didClickedBannerAd];
    }
}

#pragma mark -webView delegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    // 3.上报
    [self groupNotify];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

#pragma mark -上报给指定服务器
-(void) groupNotify{
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
    NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
    if (adplaces.allKeys.count == 0) {
        [self initS2S];
        return;
    }
    [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId ];
    
    SFGDTADViewController *gdtVc = [SFGDTADViewController defaultManger];
    gdtVc.showController = self.controller;
    UIView *view = [gdtVc getGDTBannerADWithAppId:adplaces[@"appId"] PlaceId:adplaces[@"adPlaceId"] Width:_width Height:_height isLoop:self.isLoop autoSwitchInterval:self.interval];
    [self addSubview:view];
    self.frame = ({
        CGRect frame = self.frame;
        CGFloat y = frame.origin.y;
        if (self.bannerType == BottomBannerType) {
            y = [UIScreen mainScreen].bounds.size.height - self->_height - self.locationY;
        } else {
            y = self.locationY;
        }
        frame = CGRectMake(0, y, self->_width, self->_height);
        frame;
    });
}
//************************banner ************************
/**
 加载成功的回调
 */
- (void)didLoadBannerAd{
    [Network upOutSideToServer:APIShow isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadBannerAd)]){
        [self.delegate didLoadBannerAd];
    }
}

/**
 取广告失败调用
 
 @param error 为错误信息
 */
- (void)didFailedLoadBannerAd:(NSError*)error Type:(NSInteger)adType{
    if (adType==2) {
        if (isOther) {
            if (![self.otherDict isEqualToDictionary:self.currentAD]) {
                self.currentAD = self.otherDict;
                isOther = NO;
                [self initChuanAD];
            }
        } else {
            [self initS2S];
        }
    } else if (adType==3) {
        if (isOther) {
            if (![self.otherDict isEqualToDictionary:self.currentAD]) {
                self.currentAD = self.otherDict;
                isOther = NO;
                [self initGDTAD];
            }
        } else {
            [self initS2S];
        }
    } else {
        [self initS2S];
    }
    [Network upOutSideToServer:APIError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}

/**
 广告点击后回调
 */
- (void)didClickedBannerAd{
    [Network upOutSideToServer:APIClick isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerAd)]){
        [self.delegate didClickedBannerAd];
    }
}
/**
 广告曝光回调
 */
- (void)didBannerAdExposure{
    [Network upOutSideToServer:APIExposured isError:NO code:nil msg:nil currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId];
}
/**
 广告点击删除键
 */
- (void)didClickedRemoveBanner{
    [self closeBtnClicked];
}
- (void)closeBtnClicked{
    if (self.closeBtn) {
        [self.closeBtn removeFromSuperview];
        self.closeBtn = nil;
    }
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    if (self.imgView) {
        [self.imgView removeFromSuperview];
        self.imgView = nil;
    }
    [self removeFromSuperview];
}



#pragma mark 穿山甲

- (void)initChuanAD{
    NSDictionary *adplaces = [self.currentAD[@"adplaces"] lastObject];
    if (adplaces.allKeys.count == 0) {
        [self initS2S];
        return;
    }
    [Network upOutSideToServerRequest:APIRequest currentAD:self.currentAD gdtAD:self.AdDict mediaID:self.mediaId ];
    SFChuanADViewControl *chuanVC = [SFChuanADViewControl defaultManger];
    chuanVC.showController = self.controller;
    UIView *view = [chuanVC getChuanBannerADWithAppId:adplaces[@"appId"] PlaceId:adplaces[@"adPlaceId"] Width:_width Height:_height isLoop:self.isLoop autoSwitchInterval:self.interval];
    [self addSubview:view];
    self.frame = ({
        CGRect frame = self.frame;
        CGFloat y = frame.origin.y;
        if (self.bannerType == BottomBannerType) {
            y = [UIScreen mainScreen].bounds.size.height - self->_height - self.locationY;
        } else {
            y = self.locationY;
        }
        frame = CGRectMake(0, y, self->_width, self->_height);
        frame;
    });
}

@end
