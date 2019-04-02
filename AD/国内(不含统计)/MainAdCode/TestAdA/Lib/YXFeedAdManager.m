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
#import "GDTNativeAd.h"
#import "GDTNativeExpressAdView.h"

#import <BUAdSDK/BUAdSDK.h>
#import <BUAdSDK/BUNativeAdsManager.h>

#import "YXLCdes.h"
#import "SFConfigModel.h"

@interface YXFeedAdManager()
<
BUNativeAdDelegate,
BUNativeAdsManagerDelegate,
GDTNativeAdDelegate
>
{
    CGFloat _width;
    CGFloat _height;
    NSInteger _chazhi;
}
@property (nonatomic, strong) NSDictionary *netAdDict;
@property (nonatomic, strong) NSDictionary *currentAdDict;

@property (nonatomic, strong) NSArray *s2sAdArray;
@property (nonatomic, strong) NSDictionary *s2sTapAdDict;

@property (nonatomic, strong) GDTNativeAd *nativeAd;
@property (nonatomic,strong) NSMutableArray * gdtArr;

@property (nonatomic, strong) BUNativeAdsManager *adManager;

@property (nonatomic,strong) UIView *registerAdView;

@property (nonatomic,assign) BOOL isLoadS;//自投

@property (nonatomic,assign) BOOL isWMAd;//穿山甲

@property (nonatomic,assign) BOOL isGDTLoadOK;//广点通

@property (nonatomic,strong) NSMutableArray *adShowArr;//存储上报 数组

@property (nonatomic,strong) NSMutableArray *timeArr;

@property (nonatomic, strong) NSMutableArray *feedArray;

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
    self.isGDTLoadOK = NO;
    
    [self.adShowArr  removeAllObjects];
    self.adShowArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.gdtArr removeAllObjects];
    self.gdtArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.timeArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.feedArray = [[NSMutableArray alloc]initWithCapacity:0];
    
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
    _width = size.width;
    _height = size.height;
    
    [self requestADSourceFromNet];
    
}
#pragma mark 注册View

- (void)registerAdViewForInteraction:(UIView *)view adData:(YXFeedAdData*)adData
{
    
    if ((self.isLoadS || self.isWMAd) || self.isGDTLoadOK ) {
        
        NSDictionary * currentAdDict;
        NSString * currentAD;
        
        if (self.isLoadS) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
            currentAD = @"1";
            for (NSDictionary *dict in self.s2sAdArray) {
                if ([dict[@"img_url"] isEqualToString:adData.imageUrl]) {
                    view.tag = [dict[@"adid"] integerValue];
                    currentAdDict = dict;
                }
            }
            [view addGestureRecognizer:tap];
        } else if (self.isWMAd){
            currentAD = @"2";
            view.tag = adData.adID;
            currentAdDict = @{@"ad":@"1"};
            BUNativeAd *wmAdData = self.gdtArr[adData.adID];
            wmAdData.delegate = self;
            [wmAdData registerContainer:view withClickableViews:nil];
        } else {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
            [view addGestureRecognizer:tap];
            currentAD = @"3";
            view.tag = adData.adID;
            currentAdDict = @{@"ad":@"1"};
            /*
             * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
             */
            GDTNativeAdData *currentAdData = self.gdtArr[adData.adID];
            [self.nativeAd attachAd:currentAdData toView:view];
        }
        
        NSInteger pageNumber = view.tag;
        //去重上传逻辑  注册展示广告的view的tag值为adid 或者 wm 的 或者gdt
        NSString * pages = [NSString stringWithFormat:@"%ld",(long)pageNumber];
        //用tag来标识  当前 zhna注册的广告
        NSDictionary * dicts = @{@"viewTag":pages,@"adDict":currentAdDict};
        //adShowArr  记录展示的广告上报数组
        if (self.adShowArr.count == 0) { //第一次注册上报一次
            
            [self.adShowArr addObject:dicts];
            [self checkIsInView:view dicts:dicts sts:currentAD];
            
        } else {
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
                [self checkIsInView:view dicts:dicts sts:currentAD];
            }
        }
    }
}

- (void)registerAdViewForInCell:(UITableViewCell *)cell adData:(YXFeedAdData*)adData
{
    
    if ((self.isLoadS || self.isWMAd) || self.isGDTLoadOK ) {
        
        NSDictionary * currentAdDict;
        NSString * currentAD;
        
        if (self.isLoadS) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
            currentAD = @"1";
            for (NSDictionary *dict in self.s2sAdArray) {
                if ([dict[@"img_url"] isEqualToString:adData.imageUrl]) {
                    cell.tag = [dict[@"adid"]integerValue];
                    currentAdDict = dict;
                }
            }
            [cell addGestureRecognizer:tap];
        }else if(self.isWMAd){
            currentAD = @"2";
            cell.tag = adData.adID;
            currentAdDict = @{@"ad":@"1"};
            BUNativeAd *wmAdData = self.gdtArr[adData.adID];
            wmAdData.delegate = self;
            [wmAdData registerContainer:cell withClickableViews:nil];
        }else{
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
            [cell addGestureRecognizer:tap];
            currentAD = @"3";
            cell.tag = adData.adID;
            currentAdDict = @{@"ad":@"1"};
            /*
             * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
             */
            GDTNativeAdData *currentAdData = self.gdtArr[adData.adID];
            [self.nativeAd attachAd:currentAdData toView:cell];
        }
        
        NSInteger pageNumber = cell.tag;
        //去重上传逻辑  注册展示广告的view的tag值为adid 或者 wm 的 或者gdt
        NSString * pages = [NSString stringWithFormat:@"%ld",(long)pageNumber];
        //用tag来标识  当前 zhna注册的广告
        NSDictionary * dicts = @{@"viewTag":pages,@"adDict":currentAdDict};
        //adShowArr  记录展示的广告上报数组
        if (self.adShowArr.count == 0) { //第一次注册上报一次
            
            [self.adShowArr addObject:dicts];
            [self checkIsInCell:cell dicts:dicts sts:currentAD];
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
                [self checkIsInCell:cell dicts:dicts sts:currentAD];
            }
            
        }
        return;
    }
}

- (void)checkIsInView:(UIView*)view dicts:(NSDictionary*)dicts sts:(NSString*)currentAD
{
//     1.获取全局子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    2.创建timer添加到队列中
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __block int timeRet = 30;
    [self.timeArr addObject:timer];
//    3.设置首次执行时间、执行间隔和精确度
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        // doSomething()
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL  isINshow = [NetTool isInScreenView:view];
            if (isINshow) {
//                NSLog(@"在屏幕内");
                [self adShowUpToSever:dicts sts:currentAD];
                dispatch_source_cancel(timer);
            }else{
//                NSLog(@"不在屏幕内");
                if (timeRet == 0) {
                    dispatch_source_cancel(timer);
                }
            }
            timeRet -- ;
        });
    });
    dispatch_resume(timer);
}
- (void)checkIsInCell:(UITableViewCell*)cell dicts:(NSDictionary*)dicts sts:(NSString*)currentAD
{
    //     1.获取全局子线程队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    2.创建timer添加到队列中
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    __block int timeRet = 30;
    [self.timeArr addObject:timer];
    //    3.设置首次执行时间、执行间隔和精确度
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        // doSomething()
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL  isINshow = [NetTool isInScreenCell:cell];
            if (isINshow) {
//                NSLog(@"在屏幕内");
                [self adShowUpToSever:dicts sts:currentAD];
                dispatch_source_cancel(timer);
            }else{
//                NSLog(@"不在屏幕内");
                if (timeRet == 0) {
                    dispatch_source_cancel(timer);
                }
            }
            timeRet -- ;
        });
    });
    dispatch_resume(timer);
}

-(void)dealloc
{
    for (dispatch_source_t timer in self.timeArr) {
        dispatch_source_cancel(timer);
    }
    self.timeArr = nil;
}
/**
 展示上报
 
 @param dict 第几个广告
 */
- (void)adShowUpToSever:(NSDictionary*)dict sts:(NSString*)isBU
{
//    NSLog(@"上报:%@",dict);
    //   1:s2s  2:wm  3:gdt
    if ([isBU isEqualToString:@"1"]) {
        NSDictionary * dic = dict[@"adDict"];
        NSArray * viewS = dic[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }else{
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    }
}

#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    NSString *macId = [Network sharedInstance].ipStr;
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:_width height:_height macID:macId uid:[NetTool getOpenUDID] adCount:_chazhi];
    
    [self initXAD];
}
- (void)initXAD
{
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                self.s2sAdArray = json[@"adInfos"];
                if (self.s2sAdArray.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isLoadS = YES;
                    NSMutableArray *dataArr = [[NSMutableArray alloc]initWithCapacity:0];
                    for (NSDictionary *dict in self.s2sAdArray) {
                        
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
    
    for (NSDictionary *dict in self.s2sAdArray) {
        if ([dict[@"adid"] integerValue] == recognizer.view.tag) {
            self.s2sTapAdDict = dict;
        }
    }
    
    if(!self.s2sTapAdDict){
        return;
    }
    // 1.跳转链接
    NSString *urlStr = self.s2sTapAdDict[@"click_url"];
    NSString * click_position = [NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (self.s2sTapAdDict[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"width"]]];
        }
        if (self.s2sTapAdDict[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
        
    }
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"ac_type"]];
    
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
        
        NSString * miniPath = [NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"miniPath"] ];
        miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * miniProgramOriginId = [NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"miniProgramOriginId"]];
        
        
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
        NSArray *viewS = self.s2sTapAdDict[@"click_notice_urls"];
        if ([click_position isEqualToString:@"1"]) {
            
            if (self.s2sTapAdDict[@"width"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"width"]]];
            }
            if (self.s2sTapAdDict[@"height"]) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:[NSString stringWithFormat:@"%@",self.s2sTapAdDict[@"height"]]];
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
        [self.delegate didFailedLoadFeedAd:error];
    }
}
#pragma mark 请求配置
- (void)requestADSourceFromNet
{
    [Network requestADSourceFromMediaId:self.mediaId adCount:self.adCount imgWidth:_width imgHeight:_height success:^(NSDictionary *dataDict) {
        if ([dataDict[@"ret"] isEqualToString:@"-1"]) {
            return ;
        }
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:mArr];
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
            } else {
                [self initS2S];
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
    if (self.currentAdDict == nil) {
        [self initS2S];
    }else{
        NSString *name = self.currentAdDict[@"name"];
        if ([name isEqualToString:@"广点通"]) {
            [self initGDTAD];
        } else if ([name isEqualToString:@"头条"]){
            [self initChuanAD];
        } else {
            [self initS2S];
        }
    }
}

// 暂无权限申请广点通的原生广告
#pragma mark 广点通
- (void)initGDTAD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
        
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
            self.isGDTLoadOK = YES;
            for (int index = 0; index < nativeAdDataArray.count; index ++ ) {
                GDTNativeAdData *data = nativeAdDataArray[index];
                NSDictionary * properties = data.properties;
                YXFeedAdData *backdata = [YXFeedAdData new];
                backdata.adContent = [properties objectForKey:GDTNativeAdDataKeyDesc];
                backdata.adTitle = [properties objectForKey:GDTNativeAdDataKeyTitle];
                backdata.imageUrl = [properties objectForKey:GDTNativeAdDataKeyImgUrl];
                backdata.IconUrl = [properties objectForKey:GDTNativeAdDataKeyIconUrl];
                backdata.adID = index;
                [self.feedArray addObject:backdata];
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:self.feedArray];
            }
        }
        
    });
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    //渠道暂无广点通广告
    GDTNativeAdData *currentAdData = self.gdtArr[recognizer.view.tag];
    [self.nativeAd clickAd:currentAdData];
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        [self.delegate didClickedFeedAd];
    }
}

-(void)nativeAdFailToLoad:(NSError *)error
{
    NSError *errors = [NSError errorWithDomain:error.userInfo[@"NSLocalizedDescription"] code:[[NSString stringWithFormat:@"201%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"201%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
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
        NSDictionary *adplaces = [self.currentAdDict[@"adplaces"] lastObject];
        if (adplaces.allKeys.count == 0) {
            [self initS2S];
            return;
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId ];
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        BUNativeAdsManager *nad = [BUNativeAdsManager new];
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
        if (nativeAdDataArray.count > 0) {
            self.gdtArr = [nativeAdDataArray mutableCopy];
            for (int index = 0; index < nativeAdDataArray.count; index++) {
                BUNativeAd * nativeAd = nativeAdDataArray[index];
                 BUMaterialMeta *adMeta = nativeAd.data;
                if (adMeta != nil) {
                    self.isWMAd = YES;
                    YXFeedAdData *backdata = [YXFeedAdData new];
                    backdata.adContent = adMeta.AdDescription;
                    backdata.adTitle =  adMeta.AdTitle;
                    backdata.buttonText = adMeta.buttonText;
                    backdata.adID = index;
                    if (adMeta.imageAry.count > 0) {
                        BUImage *adImage = adMeta.imageAry.firstObject;
                        if (adImage.imageURL.length > 0) {
                            backdata.imageUrl =  adImage.imageURL;
                        }
                    }
                    backdata.IconUrl = adMeta.icon.imageURL;
                    
                    [self.feedArray addObject:backdata];
                }
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:self.feedArray];
            }
        }
    });
}

- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd
{
    _YXGTMDevLog(@"************************广告已经展现了**************************");
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error {
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        
        [self.delegate didClickedFeedAd];
    }
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self.currentAdDict gdtAD:self.netAdDict mediaID:self.mediaId];
}

#pragma mark -上报给指定服务器
-(void) groupNotify
{
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        NSArray *viewS = self.s2sTapAdDict[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }
}

@end
