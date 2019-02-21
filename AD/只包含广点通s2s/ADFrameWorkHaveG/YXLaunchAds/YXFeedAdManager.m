//
//  YXFeedAdManager.m
//  LunchAd
//
//  Created by shuai on 2018/10/12.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedAdManager.h"
#import "NetTool.h"
#import "Network.h"
#import "YXImgUtil.h"
#import "YXFeedAdData.h"
#import <SafariServices/SafariServices.h>
#import "WXApi.h"
#import "YXWebViewController.h"
//


//是否缓存配置
#define ISCache 0
//直走s2s
#define GOS2S 0 

#define Normal 1

#import "YXLCdes.h"

@interface YXFeedAdManager()
{
    NSArray *adArr;
    
    NSMutableArray * adTag;
    
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    CGFloat _width;
    CGFloat _height;
    NSDictionary *_resultDict;
}
//@property (nonatomic, strong) GDTNativeAd *nativeAd;
//@property (nonatomic, strong) GDTNativeAdData *currentAdData;


@property (nonatomic,strong) UIView *registerAdView;

@property (nonatomic,assign) BOOL isLoadS;

@property (nonatomic,assign) BOOL isWMAd;

@property (nonatomic,strong) NSMutableArray *adShowArr;//存储上报 数组

@end

@implementation YXFeedAdManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adCount = 1;
        
    }
    return self;
}

#pragma mark 开始加载广告
-(void)loadFeedAd
{
    self.isLoadS = NO;
    self.isWMAd = NO;
    
    [self.adShowArr  removeAllObjects];
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self requestADSourceFromNet];
    
    
    
}
#pragma mark 注册View

- (void)registerAdViewForInteraction:(UIView *)view adData:(YXFeedAdData*)adData
{
    
    if (self.isLoadS || self.isWMAd) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        NSDictionary * currentAdDict;
        
        if (self.isLoadS) {
            
            for (NSDictionary *dict in self->adArr) {
                if ([dict[@"img_url"] isEqualToString:adData.imageUrl]) {
                    view.tag = [dict[@"adid"]integerValue];
                    currentAdDict = dict;
                }
            }
            [view addGestureRecognizer:tap];
        }
        
        NSInteger pageNumber = view.tag;
        //去重上传逻辑  注册展示广告的view的tag值为adid 或者 wm 的
        NSString * pages = [NSString stringWithFormat:@"%ld",pageNumber];
        //用tag来标识  当前 zhna注册的广告
        NSDictionary * dicts = @{@"viewTag":pages,@"adDict":currentAdDict};
        //adShowArr  记录展示的广告上报数组
        if (self.adShowArr.count == 0) { //第一次注册上报一次
            [self.adShowArr addObject:dicts];
            [self adShowUpToSever:dicts sts:self.isWMAd];
        }else{
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
                [self adShowUpToSever:dicts sts:self.isWMAd];
            }
            
        }
        return;
    }
    

    //if (self.nativeAd) {
    //    /*
    //     * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
    //     */
    //    [self.nativeAd attachAd:self.currentAdData toView:view];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    //    [view addGestureRecognizer:tap];
    //}

    
    NSLog(@"暂无广告数据，请重试!");
    
    
}

/**
 展示上报
 
 @param dict 第几个广告
 */
- (void)adShowUpToSever:(NSDictionary*)dict sts:(BOOL)isBU
{
//    NSLog(@"上报:%@",dict);
    if (isBU) {
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    }else{
        NSDictionary * dic = dict;
        NSArray * viewS = dic[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
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
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:size.width height:size.height macID:macId uid:[NetTool getOpenUDID] adCount:self.adCount];
    
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
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                        [self.delegate didLoadFeedAd:dataArr];
                    }
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
    
    
    
    for (NSDictionary *dict in self->adArr) {
        if ([dict[@"adid"] integerValue] == recognizer.view.tag) {
            _resultDict = dict;
        }
    }
    
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
    
    if ([ac_type isEqualToString:@"1"]) {
        
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        
        [self.delegate didClickedFeedAd];
    }
}

#pragma mark 失败
- (void)failedError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(didFailedLoadFeedAd:)]) {
        [_delegate didFailedLoadFeedAd:error];
    }
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
        }else{
            
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray *dataArr = [dataStr componentsSeparatedByString:@":"];
            
            if (dataArr.count < 2) {
                [self initS2S];
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
//        if ([name isEqualToString:@"广点通"]) {
//            [self initGDTAD];
//        } else
        
        [self initS2S]; 
    }
}
/*
 暂无权限申请广点通的原生广告
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
        
        //        self.splash = [[GDTSplashAd alloc] initWithAppId:adplaces[@"appId"] placementId:@"2123"];
        //        1105344611
        //        1080215124193862
        self.nativeAd = [[GDTNativeAd alloc] initWithAppId:@"1105344611" placementId:@"1080215124193862"];
        //        self.nativeAd = [[GDTNativeAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
        self.nativeAd.controller = self.controller;
        self.nativeAd.delegate = self;
        [self.nativeAd loadAd:((int)self.adCount)];
    });
}

#pragma mark - GDTNativeAdDelegate
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    // 广告数据拉取成功，存储并展示
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray * mArr = [[NSMutableArray alloc]initWithCapacity:0];
        self.isLoadS = YES;
        if (nativeAdDataArray.count > 0) {
            
            for (GDTNativeAdData *data in nativeAdDataArray) {
                NSDictionary * properties = data.properties;
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adContent = [properties objectForKey:GDTNativeAdDataKeyDesc];
                backdata.adTitle = [properties objectForKey:GDTNativeAdDataKeyTitle];
                backdata.imageUrl = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
                backdata.IconUrl = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
                
                [mArr addObject:backdata];
            }
            [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:mArr];
            }
        }
        
    });
}

- (void)viewTapped
{
    //渠道暂无广点通广告
    [self.nativeAd clickAd:self.currentAdData];
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        
        [self.delegate didClickedFeedAd];
    }
}

-(void)nativeAdFailToLoad:(NSError *)error
{
    NSError *errors = [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}
// 原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
- (void)nativeAdWillPresentScreen
{
    //    NSLog(@"%s",__FUNCTION__);
}

//原生广告点击之后应用进入后台时回调
 
- (void)nativeAdApplicationWillEnterBackground
{
    //    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeAdClosed
{
    //    NSLog(@"%s",__FUNCTION__);
}

*/



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
