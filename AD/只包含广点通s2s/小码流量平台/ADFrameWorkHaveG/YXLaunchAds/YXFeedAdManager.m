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
//#import "WXApi.h"
#import "YXWebViewController.h"
#import "YXAdSDKManager.h"

//#import "GDTNativeAd.h"
//#import "GDTNativeExpressAdView.h"



//是否缓存配置
#define ISCache 0
//直走s2s
#define GOS2S 0

#define Normal 1

#import "YXLCdes.h"

@interface YXFeedAdManager()///<GDTNativeAdDelegate>
{
    
    NSMutableArray * adTag;
    
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    CGFloat _width;
    CGFloat _height;
    NSDictionary *_resultDict;
}
//@property (nonatomic, strong) GDTNativeAd *nativeAd;

@property (nonatomic,strong) NSMutableArray * adArr;

@property (nonatomic,strong) NSMutableArray * gdtArr;


@property (nonatomic,strong) UIView *registerAdView;

@property (nonatomic,assign) BOOL isLoadS;

@property (nonatomic,assign) BOOL isWMAd;

@property (nonatomic,assign) BOOL isGDTLoadOK;

@property (nonatomic,strong) NSMutableArray *adShowArr;//存储上报 数组

@property (nonatomic,strong) NSMutableArray *timeArr;

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
    
    [self.adArr  removeAllObjects];
    self.adArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.gdtArr removeAllObjects];
    self.gdtArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.timeArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self requestADSourceFromNet];
}
#pragma mark 注册View 
- (void)registerAdViewForInteraction:(UIView *)view adData:(YXFeedAdData*)adData
 {
    if ((self.isLoadS || self.isWMAd) || self.isGDTLoadOK ) {
        
        NSDictionary * currentAdDict;
        NSString * currentAD;
        currentAD = @"1";
        for (NSDictionary *dict in self.adArr) {
            if (dict.allKeys.count == 0) {
                return;
            }
            NSString * img = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
//            NSLog(@"%@",img);
//            NSLog(@"%@",adData.imageUrl);
            if ([img isEqualToString:adData.imageUrl]) {
                view.tag = [dict[@"adid"]integerValue];
                currentAdDict = dict;
            }
        }
        if ([currentAdDict allKeys].count == 0) {
            NSLog(@"记录为空");
            return;
        }
        NSInteger pageNumber = view.tag;
        //去重上传逻辑  注册展示广告的view的tag值为adid 或者 wm 的 或者gdt
        NSString * pages = [NSString stringWithFormat:@"%ld",(long)pageNumber];
        //用tag来标识  当前 zhna注册的广告
        NSDictionary * dicts = @{@"viewTag":pages,@"adDict":currentAdDict};
        
        //adShowArr  记录展示的广告上报数组
        if (self.adShowArr.count == 0) { //第一次注册上报一次
            
            [self.adShowArr addObject:dicts];
            [self checkIsInView:pageNumber dicts:dicts sts:currentAD];
            
        }else{
            BOOL hasIndex = NO;//在记录中 查询是否有当前注册的广告
            for (NSDictionary * addddddict in self.adShowArr) {
                if (addddddict.allKeys.count == 0) {
                    return;
                }
                NSString * str = [NSString stringWithFormat:@"%@",addddddict[@"viewTag"]];
                
                if ([str isEqualToString:pages]) {
                    hasIndex = YES;
                }
            }
            //没有记录并上报
            if (!hasIndex) {
                [self.adShowArr addObject:dicts];
                [self checkIsInView:pageNumber dicts:dicts sts:currentAD];
            }
            
        }
        return;
    }
    NSLog(@"暂无广告数据，请重试!");
}

- (void)registerAdViewForInCell:(UITableViewCell *)cell adData:(YXFeedAdData*)adData
{
    
    if ((self.isLoadS || self.isWMAd) || self.isGDTLoadOK ) {
        
        NSDictionary * currentAdDict;
        NSString * currentAD;
        
        if (self.isLoadS) {
            currentAD = @"1";
            
            for (NSDictionary *dict in self.adArr) {
                
                if (dict.allKeys.count == 0) {
                    return;
                }
                NSString * img = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
                if ([img isEqualToString:adData.imageUrl]) {
                    
                    cell.tag = [dict[@"adid"]integerValue];
                    currentAdDict = dict;
                }
            }
        }
        if ([currentAdDict allKeys].count == 0) {
            NSLog(@"记录为空");
            return;
        }
        /*
        else if(self.isWMAd){
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
            // 广告数据渲染完毕，即将展示时需调用AttachAd方法。
         
            GDTNativeAdData *currentAdData = self.gdtArr[adData.adID];
            [self.nativeAd attachAd:currentAdData toView:cell];
        }
         */
        
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
                NSString * str = [NSString stringWithFormat:@"%@",addict[@"viewTag"]];
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
    NSLog(@"暂无广告数据，请重试!");
}

- (void)checkIsInView:(NSInteger)index dicts:(NSDictionary*)dicts sts:(NSString*)currentAD
{
    [self adShowUpToSever:dicts sts:currentAD];
//    //     1.获取全局子线程队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //    2.创建timer添加到队列中
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    __block int timeRet = 30;
//    [self.timeArr addObject:timer];
//    //    3.设置首次执行时间、执行间隔和精确度
//    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), 1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
//    dispatch_source_set_event_handler(timer, ^{
//        // doSomething()
//        dispatch_async(dispatch_get_main_queue(), ^{
//            BOOL  isINshow = [NetTool isInScreenView:view];
//            if (isINshow) {
//                //                NSLog(@"在屏幕内");
//                [self adShowUpToSever:dicts sts:currentAD];
//                dispatch_source_cancel(timer);
//            }else{
//                //                NSLog(@"不在屏幕内");
//                if (timeRet == 0) {
//                    dispatch_source_cancel(timer);
//                }
//            }
//            timeRet -- ;
//        });
//    });
//    dispatch_resume(timer);
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
        if (dic.allKeys.count == 0) {
            NSLog(@"广告为空");
            return;
        }
        NSArray * viewS = dic[@"impress_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            [Network groupNotifyToSerVer:viewS];
        }
    }else{
        [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    }
    
}

#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    NSString *macId = [Network sharedInstance].ipStr;
    
    
    self->_width = self.adWidth;
    self->_height = self.adHeight;
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:_mediaId width:self->_width height:self->_height macID:macId uid:[NetTool getOpenUDID] adCount:self.adCount];
    
    [self initXAD];
}
- (void)initXAD
{
    [[Network sharedInstance] beginRequestfinished:^(BOOL isSuccess, id json) {
        
        if (isSuccess) {
            if ([json[@"ret"] isEqualToString:@"0"]) {
                
//                NSLog(@"%@",json[@"adInfos"]);
                self.adArr = json[@"adInfos"];
                
                if (self.adArr.count <= 0) {
                    NSError *errors = [NSError errorWithDomain:@"请求失败" code:400 userInfo:nil];
                    [self failedError:errors];
                    return ;
                }
                
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
                        
                        NSString * icon = [NSString stringWithFormat:@"%@",dict[@"logo_icon"]];
                        
                        backdata.IconUrl =  icon == nil ? @"" : icon;
                        
                        backdata.clickedUrl = [NSString stringWithFormat:@"%@",dict[@"click_url"]];
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

#pragma mark 点击上报

- (void)clickedEReportAdData:(YXFeedAdData*)adData;
{
    for (NSDictionary *dict in self.adArr) {
        NSString * img = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
        
        if ([img isEqualToString:adData.imageUrl]) {
            _resultDict = dict;
        }
    }
    if (!_resultDict) {
        return;
    }
    
    // 2.上报服务器
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        // 上报服务器
        NSString * click_position = [NSString stringWithFormat:@"%@",_resultDict[@"click_position"]];
        
        
        NSArray *viewS = [_resultDict objectForKey:@"click_notice_urls"];
        
        
        NSString * urlStr = [NSString stringWithFormat:@"%@",_resultDict[@"click_url"]];
        
        
        if ([click_position isEqualToString:@"1"]) {
            
            NSString *width = [NSString stringWithFormat:@"%@",_resultDict[@"width"]];
            if (width.length > 0) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:width];
            }
            NSString *height = [NSString stringWithFormat:@"%@",_resultDict[@"height"]];
            if (height) {
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQHEIGHT__" withString:height];
            }
            NSString *widthStr = [NSString stringWithFormat:@"%f",_width];
            NSString *heightStr = [NSString stringWithFormat:@"%f",_height];
            
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
            
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:@"100"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:@"100"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:@"100"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:@"100"];
        }
        [Network groupNotifyToSerVer:viewS];
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
    
    NSString *dataStr = [NSString stringWithFormat:@"pkg=%@&idfa=%@&ts=%@&os=%@&osv=%@&w=%@&h=%@&model=%@&nt=%@&mac=%@",
                         [NetTool URLEncodedString:[NetTool getPackageName]],
                         [NetTool getIDFA],
                         timeLocal,
                         @"IOS",
                         [NetTool URLEncodedString:[NetTool getOS]],
                         @(c_w),
                         @(c_h),
                         [NetTool URLEncodedString:[NetTool gettelModel]],
                         @(netnumber),
                         [NetTool URLEncodedString:[NetTool getMac]]];
    
    
    NSString *cityCode = [YXAdSDKManager defaultManager].cityCode;
    
    NSString *strURL =  [NSString stringWithFormat:congfigIp,[NetTool URLEncodedString:_mediaId], [NetTool getPackageName],@"2",dataStr,cityCode];
    
    
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
            
            if(advertiser && ![advertiser isKindOfClass:[NSNull class]]&& advertiser.count > 0){
//                [self initIDSource];
                [self initS2S];
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
//        NSString *name = _currentAD[@"name"];
//        if ([name isEqualToString:@"广点通"]) {
//            [self initGDTAD];
//        } else if ([name isEqualToString:@"头条"]){
//            [self initChuanAD];
//        }else{
            [self initS2S];
//        }
    }
}

/*
// 暂无权限申请广点通的原生广告
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
        //        self.nativeAd = [[GDTNativeAd alloc] initWithAppId:@"1105344611" placementId:@"1080215124193862"];
        self.nativeAd = [[GDTNativeAd alloc] initWithAppId:adplaces[@"appId"] placementId:adplaces[@"adPlaceId"]];
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
        if (nativeAdDataArray.count > 0) {
            self.gdtArr = [nativeAdDataArray mutableCopy];
            NSMutableArray * mArr = [[NSMutableArray alloc]initWithCapacity:0];
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
                [mArr addObject:backdata];
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:mArr];
            }
        }
        
    });
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer
{
    //渠道暂无广点通广告
    GDTNativeAdData *currentAdData = self.gdtArr[recognizer.view.tag];
    [self.nativeAd clickAd:currentAdData];
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
    //广告数据拉取成功，存储并展示
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray * mArr = [[NSMutableArray alloc]initWithCapacity:0];
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
                    
                    [mArr addObject:backdata];
                }
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadFeedAd:)]){
                [self.delegate didLoadFeedAd:mArr];
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
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view
{
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickedFeedAd)]){
        
        [self.delegate didClickedFeedAd];
    }
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error {
    //    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg: error.userInfo[@"NSLocalizedDescription"] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
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
