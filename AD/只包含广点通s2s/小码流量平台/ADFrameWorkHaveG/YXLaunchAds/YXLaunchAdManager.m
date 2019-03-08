//
//  YXLaunchAdManager.m
//  YXLaunchAdExample
//
//  Created by shuai on 2018/3/23.
//  Copyright © 2018年 M. All rights reserved.
//  Version 2.3
//  开屏广告初始化 除了金康特专用（金康特用了广点通）

#import "YXLaunchAdManager.h"
#import "YXLaunchAd.h"
#import "Network.h"
#import "NetTool.h"
#import "LaunchAdModel.h"

#import "YXAdSDKManager.h"


#import "YXGTMDefines.h"
#import <StoreKit/StoreKit.h>
#import <SafariServices/SafariServices.h>
#import "YXLaunchAdController.h"
#import "YXWebViewController.h"


#import <AdSupport/ASIdentifierManager.h>

#import <BUAdSDK/BUAdSDKManager.h>
#import "BUAdSDK/BUSplashAdView.h"


//是否缓存配置
#define ISCache 0
//直走s2s
#define GOS2S 0

#define GOGoogle 0

#define Normal 1

#import "YXLCdes.h"

#import "HMTAgentSDK.h"
@interface YXLaunchAdManager()<YXLaunchAdDelegate,YXWebViewDelegate,SKStoreProductViewControllerDelegate,BUSplashAdDelegate>
{
    NSDictionary *_resultDict;
    NSDictionary*_gdtAD;
    NSDictionary*_currentAD;
    __block NSInteger outTimes;
    
    NSInteger cuttentTime;
    
    BOOL isGDTClicked;
    
    BOOL launchTimeOut;
    
    BOOL isGDLaunchOK;
}
@property (nonatomic,assign) BOOL isgoogleEnd;
@property(nonatomic,copy)dispatch_source_t skipTimer;

@property(nonatomic,copy)dispatch_source_t googleTimer;
@property (nonatomic,strong) YXLaunchAdButton *skipButton;


@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;


@property (nonatomic, retain) UIView *customSplashView;

@property (nonatomic,strong) UIView *yxADView;

@property (nonatomic,strong) UIWindow *showAdWindow;

@property (nonatomic,strong)YXLaunchImageAdConfiguration *imageAdconfiguration;

@end

@implementation YXLaunchAdManager

static YXLaunchAdManager *instance = nil;

+(instancetype)shareManager
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[YXLaunchAdManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)setLaunch
{
    _gdtAD = nil;
    _currentAD = nil;
    launchTimeOut = NO;
    isGDTClicked = NO;
    isGDLaunchOK = NO;
    
    [YXLaunchAd setLaunchSource];
    
    [YXLaunchAd setWaitDataDuration:self.waitDataDuration];
    
    [YXLaunchAd shareLaunchAd].delegate = self;
    self.yxADView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.yxADView.userInteractionEnabled = YES;
    
}


- (void)setContentMode:(UIViewContentMode)contentMode
{
    _contentMode = contentMode;
}

- (void)loadLaunchAdWithShowAdWindow:(UIWindow *)showAdWindow
{
    
    [self setLaunch];
    
    self.showAdWindow = showAdWindow;
    isGDLaunchOK = NO;
    
    
#if GOGoogle
    [self initGGNativeAd];
#elif Normal
    [self requestADSource];
#endif
    
    self->outTimes = 1;
    
    //配置广告数据
    _imageAdconfiguration = [YXLaunchImageAdConfiguration new];
    _imageAdconfiguration.imageOption = self.imageOption;
    _imageAdconfiguration.contentMode = self.contentMode;
    _imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
    _imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimateTime;
    _imageAdconfiguration.skipButtonType = self.skipButtonType;
    
}


- (void)requestADSource
{
#if ISCache
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *inlandDic = [userDefault objectForKey:inLandAD];
    
    if (inlandDic.allKeys.count > 0) {
        NSString *time = inlandDic[@"time"];
        NSInteger hour = [NetTool getSpendTimeWithStartDate:time stopDate:[NetTool getNowDateStr_2]];
        if (hour <= 6) {
            _gdtAD = inlandDic[inLandAD];
            [self initIDSource];
        }else{
            [self requestADSourceFromNet];
        }
    }else{
        [self requestADSourceFromNet];
    }
#else
    
    [self requestADSourceFromNet];
    
#endif
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
        if([name isEqualToString:@"头条"]){
            [self initChuanAD];
        }else{
            [self initS2S];
        }
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
    
    NSString *cityCode = [YXAdSDKManager defaultManager].cityCode;
    
    NSString *dataStr = [NSString stringWithFormat:@"pkg=%@&idfa=%@&ts=%@&os=%@&osv=%@&w=%@&h=%@&model=%@&nt=%@&mac=%@&cityCode=%@",[NetTool URLEncodedString:[NetTool getPackageName]],[NetTool getIDFA],timeLocal,@"IOS",[NetTool URLEncodedString:[NetTool getOS]],@(c_w),@(c_h),[NetTool URLEncodedString:[NetTool gettelModel]],@(netnumber),[NetTool URLEncodedString:[NetTool getMac]],cityCode];
    
    NSString *strURL =  [NSString stringWithFormat:congfigIp,[NetTool URLEncodedString:_mediaId], [NetTool getPackageName],@"2",dataStr];
    
    
    [request setURL:[NSURL URLWithString:strURL]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    if (self.waitDataDuration) {
        [request setTimeoutInterval:self.waitDataDuration];
    }else{
        [request setTimeoutInterval:3];
    }
    
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
                [self initIDSource];
                [self saveInlandInfro];
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
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (void)saveInlandInfro
{
#if ISCache
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *inlandadDic = @{inLandAD:_gdtAD,@"time":[NetTool getNowDateStr_2]};
    [userDefault setObject:inlandadDic forKey:inLandAD];
    [userDefault synchronize];
#else
#endif
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
        self->isGDTClicked = NO;
        
        [[YXLaunchAd shareLaunchAd] setCusAdConfi: self->_imageAdconfiguration];
        
        self->cuttentTime = 5;
        
        [BUAdSDKManager setAppID: adplaces[@"appId"]];
        [BUAdSDKManager setIsPaidApp:NO];
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelNone];
        //        NSLog(@"SDKVersion = %@", [BUAdSDKManager SDKVersion]);
        
        
        //        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        
        UIWindow *window = self.showAdWindow;
        
        UIViewController *topRootViewController = window.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        
        // frame 强烈建议为屏幕大小
        BUSplashAdView *spalshView = [[BUSplashAdView alloc] initWithSlotID:adplaces[@"adPlaceId"] frame:self.frame];
        
        spalshView.tolerateTimeout = self.waitDataDuration;
        spalshView.hideSkipButton = YES;
        spalshView.delegate = self;
        [spalshView loadAdData];
        spalshView.rootViewController = topRootViewController;
        
        [self.yxADView addSubview:spalshView];
        
        if (self->_bottomView) {
            [self.yxADView addSubview:self.bottomView];
        }
        [Network upOutSideToServerRequest:ADRequest currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId ];
        
    });
}
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd
{
    //     NSLog(@"spalshAdDidLoad;%s",__FUNCTION__);
    if (launchTimeOut) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //配置广告数据
        YXLaunchImageAdConfiguration *imageAdconfiguration = [YXLaunchImageAdConfiguration new];
        //广告停留时间
        imageAdconfiguration.duration = self.duration;
        imageAdconfiguration.showEnterForeground = NO;
        //广告frame
        imageAdconfiguration.frame = self.frame;
        
        //设置GIF动图是否只循环播放一次(仅对动图设置有效)
        imageAdconfiguration.GIFImageCycleOnce = NO;
        //缓存机制(仅对网络图片有效)
        //为告展示效果更好,可设置为YXLaunchAdImageCacheInBackground,先缓存,下次显示
        imageAdconfiguration.imageOption = self.imageOption;
        //图片填充模式
        imageAdconfiguration.contentMode = self.contentMode;
        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
        //                imageAdconfiguration.openModel = model.openUrl;
        //广告显示完成动画
        imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
        //广告显示完成动画时间
        imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimate;
        //跳过按钮类型
        imageAdconfiguration.skipButtonType = self.skipButtonType;
        //start********************自定义跳过按钮**************************
        imageAdconfiguration.customSkipView = nil;
        //********************自定义广告*****************************end
        [YXLaunchAd shareLaunchAd].customAdView = self.yxADView;
        [YXLaunchAd shareLaunchAd].hiddenRightIcon = YES;
        //显示开屏广告
        [YXLaunchAd customImageViewWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLoadAd)]){
            [self.delegate didLoadAd];
            
        }
    });
    [Network upOutSideToServer:ADSHOW isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd
{
    
    //    NSLog(@"spalshAdWillVisible;%s",__FUNCTION__);
    
    
}
- (void)splashAdDidClick:(BUSplashAdView *)splashAd
{
    //    NSLog(@"spalshAdDidClick;%s",__FUNCTION__);
    
    if(_delegate && [_delegate respondsToSelector:@selector(didClickedAdUrl:)]){
        [_delegate didClickedAdUrl:@""];
    }
    
    [Network upOutSideToServer:ADCLICK isError:NO code:nil msg:nil currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
}
- (void)splashAdWillClose:(BUSplashAdView *)splashAd
{
    //    NSLog(@"spalshAdWillClose;%s",__FUNCTION__);
}
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    
    [splashAd removeFromSuperview];
    //    NSLog(@"spalshAdDidClose;%s",__FUNCTION__);
    if (cuttentTime > 1) {
        
        [[YXLaunchAd shareLaunchAd]cancleSkip];
        [[YXLaunchAd shareLaunchAd] removeAndOnly];
    }
    
}
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error
{
    [splashAd removeFromSuperview];
    NSError *errors = [NSError errorWithDomain:@"" code:[[NSString stringWithFormat:@"202%ld",(long)error.code]integerValue] userInfo:nil];
    [self failedError:errors];
    
    [Network upOutSideToServer:ADError isError:YES code:[NSString stringWithFormat:@"202%ld",(long)error.code] msg:[NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]] currentAD:self->_currentAD gdtAD:self->_gdtAD mediaID:self.mediaId];
    
}


#pragma mark s2sAD
/**
 s2s广告初始化
 */
- (void)initS2S
{
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [self setupYXLaunchAd];
}

-(void)setupYXLaunchAd{
    
    /** 1.图片开屏广告 - 网络数据 */
    [self example01];
}

#pragma mark - 图片开屏广告-网络数据-示例
//图片开屏广告 - 网络数据 s2s
-(void)example01{
    
    NSString *ip = [Network sharedInstance].ipStr;
    
    if (_gdtAD.allKeys.count == 0) {
        NSError *error = [NSError errorWithDomain:@"" code:40041 userInfo:@{@"NSLocalizedDescription":@"请检查网络"}];
        [self failedError:error];
        return;
    }
    
    NSString * uuid = self->_gdtAD[@"uuid"];
    
    [[Network sharedInstance] prepareDataAndRequestWithadkeyString:self.mediaId width:_frame.size.width height:_frame.size.height macID:ip uid:uuid adCount:1];
    
    
    //广告数据请求
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
                
                if ([json objectForKey:@"data"]) {
                    if ([[json objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        NSMutableArray *muarray = [json objectForKey:@"data"];
                        if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
                        {
                            NSArray *viewS = muarray;
                            if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
                                //                                [self groupNotifyToSerVer:viewS];
                            }
                        }
                    }
                }
                //配置广告数据
                YXLaunchImageAdConfiguration *imageAdconfiguration = [YXLaunchImageAdConfiguration new];
                //广告停留时间
                imageAdconfiguration.duration = self->_duration;
                imageAdconfiguration.showEnterForeground = NO;
                //广告frame
                imageAdconfiguration.frame = self->_frame;
                //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
                imageAdconfiguration.imageNameOrURLString = self->_resultDict[@"img_url"];
                //设置GIF动图是否只循环播放一次(仅对动图设置有效)
                imageAdconfiguration.GIFImageCycleOnce = NO;
                //缓存机制(仅对网络图片有效)
                //为告展示效果更好,可设置为YXLaunchAdImageCacheInBackground,先缓存,下次显示
                imageAdconfiguration.imageOption = self.imageOption;
                //图片填充模式
                imageAdconfiguration.contentMode = self.contentMode;
                //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
                //                imageAdconfiguration.openModel = model.openUrl;
                //广告显示完成动画
                imageAdconfiguration.showFinishAnimate = self.showFinishAnimate;
                //广告显示完成动画时间
                imageAdconfiguration.showFinishAnimateTime = self.showFinishAnimate;
                //跳过按钮类型
                imageAdconfiguration.skipButtonType = self.skipButtonType;
                //start********************自定义跳过按钮**************************
                imageAdconfiguration.customSkipView = nil;
                //********************自定义跳过按钮*****************************end
                
                //显示开屏广告
                [YXLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration bottomView:self.bottomView delegate:self];
                
            }else{
                NSError *error = [NSError errorWithDomain:@"" code:40041 userInfo:@{@"NSLocalizedDescription":@"请检查网络"}];
                [self failedError:error];
                
            }
        }else{
            NSError *error = [NSError errorWithDomain:@"" code:40041 userInfo:@{@"NSLocalizedDescription":@"请检查网络"}];
            [self failedError:error];
        }
        
    }];
}

#pragma mark 失败
- (void)failedError:(NSError*)error
{
    if ([self.delegate respondsToSelector:@selector(didFailedLoadAd:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self remove];
            [[YXLaunchAd shareLaunchAd]failedRemove];
        });
        [_delegate didFailedLoadAd:error];
    }
}

#pragma mark - 视频开屏广告-网络数据-示例
//视频开屏广告 - 网络数据
-(void)example03{
    
    //    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    //    [YXLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //
    //    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
    //    [YXLaunchAd setWaitDataDuration:3];
    //
    //    //广告数据请求
    //    [Network getLaunchAdVideoDataSuccess:^(NSDictionary * response) {
    //
    //
    //        //广告数据转模型
    //        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
    //
    //        //配置广告数据
    //        YXLaunchVideoAdConfiguration *videoAdconfiguration = [YXLaunchVideoAdConfiguration new];
    //        //广告停留时间
    //        videoAdconfiguration.duration = model.duration;
    //        //广告frame
    //        videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //        //广告视频URLString/或本地视频名(请带上后缀)
    //        //注意:视频广告只支持先缓存,下次显示(看效果请二次运行)
    //        videoAdconfiguration.videoNameOrURLString = model.content;
    //        //是否关闭音频
    //        videoAdconfiguration.muted = NO;
    //        //视频缩放模式
    //        videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //        //是否只循环播放一次
    //        videoAdconfiguration.videoCycleOnce = NO;
    //        //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    //        videoAdconfiguration.openModel = model.openUrl;
    //        //广告显示完成动画
    //        videoAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //        //广告显示完成动画时间
    //        videoAdconfiguration.showFinishAnimateTime = 0.8;
    //        //后台返回时,是否显示广告
    //        videoAdconfiguration.showEnterForeground = NO;
    //        //跳过按钮类型
    //        videoAdconfiguration.skipButtonType = SkipTypeTimeText;
    //        //视频已缓存 - 显示一个 "已预载" 视图 (可选)
    //        if([YXLaunchAd checkVideoInCacheWithURL:[NSURL URLWithString:model.content]]){
    //            //设置要添加的自定义视图(可选)
    //            videoAdconfiguration.subViews = [self launchAdSubViews_alreadyView];
    //
    //        }
    //
    //        [YXLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    //
    //    } failure:^(NSError *error) {
    //
    //    }];
    
}


#pragma mark - 批量下载并缓存
/**
 *  批量下载并缓存图片
 */
-(void)batchDownloadImageAndCache{
    
    //    [YXLaunchAd downLoadImageAndCacheWithURLArray:@[[NSURL URLWithString:imageURL1],[NSURL URLWithString:imageURL2],[NSURL URLWithString:imageURL3],[NSURL URLWithString:imageURL4],[NSURL URLWithString:imageURL5]] completed:^(NSArray * _Nonnull completedArray) {
    //
    //        /** 打印批量下载缓存结果 */
    //
    //        //url:图片的url字符串,
    //        //result:0表示该图片下载失败,1表示该图片下载并缓存完成或本地缓存中已有该图片
    //    }];
}

/**
 *  批量下载并缓存视频
 */
-(void)batchDownloadVideoAndCache{
    
    //    [YXLaunchAd downLoadVideoAndCacheWithURLArray:@[[NSURL URLWithString:videoURL1],[NSURL URLWithString:videoURL2],[NSURL URLWithString:videoURL3]] completed:^(NSArray * _Nonnull completedArray) {
    //
    //        /** 打印批量下载缓存结果 */
    //
    //        //url:视频的url字符串,
    //        //result:0表示该视频下载失败,1表示该视频下载并缓存完成或本地缓存中已有该视频
    //
    //    }];
    
}

#pragma mark - subViews
-(NSArray<UIView *> *)launchAdSubViews_alreadyView{
    
    CGFloat y = XH_IPHONEX ? 46:22;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, y, 60, 30)];
    label.text  = @"已预载";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
    
}

-(NSArray<UIView *> *)launchAdSubViews{
    
    CGFloat y = XH_IPHONEX ? 54 : 30;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-170, y, 60, 30)];
    label.text  = @"subViews";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    return [NSArray arrayWithObject:label];
}

#pragma mark - 手动移除广告Action
/**
 手动移除广告
 
 @param animated 是否需要动画
 */
+(void)removeAndAnimated:(BOOL)animated
{
    [YXLaunchAd removeAndAnimated:animated];
}
#pragma mark - YXLaunchAd delegate - 倒计时回调
/**
 *  倒计时回调
 *
 *  @param launchAd YXLaunchAd
 *  @param duration 倒计时时间
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd customSkipView:(UIView *)customSkipView duration:(NSInteger)duration{
    cuttentTime = duration;
    if (duration > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customSkipDuration:)]) {
            [self.delegate customSkipDuration:duration];
        }
    }
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - YXLaunchAd delegate - 其他
/**
 广告点击事件回调
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    //     if(openModel==nil) return;
    NSString * x =  [NSString stringWithFormat:@"%f",clickPoint.x ];
    NSString * y =  [NSString stringWithFormat:@"%f",clickPoint.y ];
    
    NSString *widthStr = [NSString stringWithFormat:@"%.0f",_frame.size.width];
    NSString *heightStr = [NSString stringWithFormat:@"%.0f",_frame.size.height];
 
    if(!_resultDict){
        return;
    }
    // 1.跳转链接
    NSString *urlStr = _resultDict[@"click_url"]; 
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedAdUrl:)]) {
        [self.delegate didClickedAdUrl:urlStr];
    }
    NSString * click_position = [NSString stringWithFormat:@"%@",_resultDict[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (_resultDict[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"width"]]];
        }
        if (_resultDict[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_HEIGHT__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
    }
    // 2.上报服务器
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        // 上报服务器
        NSArray *viewS = _resultDict[@"click_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            if ([click_position isEqualToString:@"1"]) {
                
                if (_resultDict[@"width"]) {
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"width"]]];
                }
                if (_resultDict[@"height"]) {
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_HEIGHT__" withString:[NSString stringWithFormat:@"%@",_resultDict[@"height"]]];
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
    }
}

#pragma mark 落地页返回
- (void)backClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAdShowReturn)]) {
        [self.delegate didAdShowReturn];
    }
}

#pragma mark s2s展示完成
/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  YXLaunchAd
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData{
    
    [self groupNotify];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadAd)]) {
        [self.delegate didLoadAd];
    }
}

/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd YXLaunchAd
 *  @param pathURL  视频保存在本地的path
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL{
    
}

/**
 *  视频下载进度回调
 */
-(void)YXLaunchAd:(YXLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current{
    
}
/**
 移除视图
 */
- (void)remove
{
    if (self.customSkipView) [self.customSkipView removeFromSuperview];
    if (self.skipButton)[self.skipButton removeFromSuperview];
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
        self.bottomView = nil;
    }
    if (self.yxADView) {
        [self.yxADView removeFromSuperview];
        self.yxADView = nil;
    }
}
/**
 *  广告显示完成
 */
-(void)YXLaunchAdShowFinish:(YXLaunchAd *)launchAd{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LaunchShowFinish)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self remove];
            
            [self.delegate LaunchShowFinish];
        });
        
    }
}
- (void)YXLaunchAdShowFailed
{
    launchTimeOut = YES;
    
    NSError *errors = [NSError errorWithDomain:@"" code:7423 userInfo:@{@"NSLocalizedDescription":@"请求超时"}];
    
    
    [self failedError:errors];
}
-(void)skipBtnClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lunchADSkipButtonClick)]) {
        [self.delegate lunchADSkipButtonClick];
    }
}
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
