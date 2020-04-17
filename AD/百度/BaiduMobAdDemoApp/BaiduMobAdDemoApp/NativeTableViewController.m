//
//  ViewController.m
//  DemoNativeAd
//
//  Created by houshunwei on 15-6-9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "NativeTableViewController.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdDelegate.h"
#import "BaiduMobAdSDK/BaiduMobAdNative.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdObject.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeVideoView.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeWebView.h"
#import "XScreenConfig.h"

//type = normal
#define ADID_NORMAL @"2058621" //信息流
//type = video
#define ADID_VIDEO  @"2362914" //信息流-视频
//type = html
#define ADID_TYPE1  @"4393166" //组图
#define ADID_TYPE2  @"4393179" //图+底部文字
#define ADID_TYPE3  @"2403627" //轮播图文
#define ADID_TYPE4  @"4394006" //轮播图

@interface NativeTableViewController ()<BaiduMobAdNativeAdDelegate>
@property(nonatomic,retain)UITableView*mainTableView;
@property (nonatomic, retain) BaiduMobAdNative *native;
@property (nonatomic, retain) NSMutableArray *adViewArray;
@property (nonatomic, retain) NSArray *adsArray;

@end

@implementation NativeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置开发者自己处理View点击事件,只需要设置一次，不设置时，sdk内部采用默认方式处理
    [BaiduMobAdNativeAdView dealTapGesture:true];
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-100) style:UITableViewStylePlain] ;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    
    self.adViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.mainTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView = self.mainTableView;
    [self pressToLoadAd:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换样式" style:UIBarButtonItemStylePlain target:self action:@selector(pressToShowAdTypes)];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        self.native.delegate = nil;
        self.native = nil;
}

#pragma mark - 广告相关设置
//请求广告
- (IBAction)pressToLoadAd:(UIButton *)sender
{
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;

    if (!self.native)
    {
        self.native = [[BaiduMobAdNative alloc]init];
        self.native.delegate = self;
    }
    //请求原生广告
    [self.native requestNativeAds];
}

- (void) pressToShowAdTypes {
    UIAlertController *alc = [UIAlertController alertControllerWithTitle:@"选择要展示的样式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self)weakSelf = self;
    UIAlertAction *actNormal = [UIAlertAction actionWithTitle:@"普通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.toBeChangedApid = ADID_NORMAL;
        [strongSelf pressToLoadAd:nil];
    }];
    UIAlertAction *actVideo = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.toBeChangedApid = ADID_VIDEO;
        [strongSelf pressToLoadAd:nil];
    }];
    UIAlertAction *actType1 = [UIAlertAction actionWithTitle:@"组图模板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.toBeChangedApid = ADID_TYPE1;
        [strongSelf pressToLoadAd:nil];
    }];
    UIAlertAction *actType2 = [UIAlertAction actionWithTitle:@"图+底文模板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.toBeChangedApid = ADID_TYPE2;
        [strongSelf pressToLoadAd:nil];
    }];
    UIAlertAction *actType3 = [UIAlertAction actionWithTitle:@"轮播图文模板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.toBeChangedApid = ADID_TYPE3;
        [strongSelf pressToLoadAd:nil];
    }];
    UIAlertAction *actType4 = [UIAlertAction actionWithTitle:@"轮播图模板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.toBeChangedApid = ADID_TYPE4;
        [strongSelf pressToLoadAd:nil];
    }];
    UIAlertAction *actCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alc addAction:actNormal];
    [alc addAction:actVideo];
    [alc addAction:actType1];
    [alc addAction:actType2];
    [alc addAction:actType3];
    [alc addAction:actType4];
    [alc addAction:actCancel];
    
    [self presentViewController:alc animated:YES completion:nil];
}

//创建后获得的应用id
#warning - 上线前请换为自己的id
-(NSString*)publisherId
{
    return self.toBeChangedPublisherId;
}

//创建后获得的信息流广告位id
#warning - 上线前请换为自己的id
-(NSString*)apId
{
    return self.toBeChangedApid; //普通信息流, 3条
}

//广告返回成功
//成功返回广告字段，BaiduMobAdNativeAdObject array
- (void)nativeAdObjectsSuccessLoad:(NSArray*)nativeAds{

    self.adViewArray = [NSMutableArray array];
    self.adsArray = [nativeAds copy];
    for(int i = 0; i < [nativeAds count]; i++){
        BaiduMobAdNativeAdObject *object = [nativeAds objectAtIndex:i];
        BaiduMobAdNativeAdView *view = [self createNativeAdViewWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 351) object:object];
        
        //自己添加点击事件时，必须提前设置[BaiduMobAdNativeAdView dealTapGesture:true];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [view addGestureRecognizer:tapGesture];
        
        //传入用来展示广告详情页的viewcontroller (也可以不传)
        view.presentAdViewController = self;
        [self.adViewArray addObject:view];
        
        // 展现前检查是否过期，30分钟广告将过期，如果广告过期，请放弃展示并重新请求
        if ([object isExpired]) {
            continue;
        }
        
        //如果开启了多图模式，则可以在标准的BaiduMobAdNativeAdView上添加自定义多图
        if([object.morepics count]>0 ){
            NSLog(@"多图url array 为 %@",object.morepics);
            UIImageView *imageview = [[UIImageView alloc]init] ;
            [view addSubview:imageview];
        }
        
        __block NativeTableViewController *weakSelf = self;
        // 加载和显示广告内容
        [view loadAndDisplayNativeAdWithObject:object completion:^(NSArray *errors) {
            if (!errors) {
                // 确定视图显示在window上之后再调用trackImpression，不要太早调用
                //在tableview或scrollview中使用时尤其要注意
                [weakSelf.tableView reloadData];
            }
            
        }];
    }
    
}


-(void)tapGesture:(UIGestureRecognizer*)sender
{
    UIView *view = sender.view ;
    NSInteger index = [self.adViewArray indexOfObject:view];
    BaiduMobAdNativeAdObject *object = [self.adsArray objectAtIndex:index];
    if([view isKindOfClass:[BaiduMobAdNativeAdView class]]) {
        BaiduMobAdNativeAdView * adView = (BaiduMobAdNativeAdView *)view;
        if (object.materialType == VIDEO && [self locationInVideo:sender withView:view]) {
            //点击视频区域 播放视频
            [adView.videoView play];
        } else {
            [object handleClick:view];
        }
    } else {
        [object handleClick:view];
    }
}

//点击区域是否处在视频区域
- (BOOL)locationInVideo:(UIGestureRecognizer*)sender withView:(UIView*)view {
    BOOL inVideoView =  NO;
    if ([view isKindOfClass:[BaiduMobAdNativeAdView class]]) {
        BaiduMobAdNativeAdView *adView = (BaiduMobAdNativeAdView*)view;
        CGPoint point = [sender locationInView:adView.mainImageView];
        if (point.x >= 0 &&
            point.x <= adView.mainImageView.frame.size.width &&
            point.y >= 0 &&
            point.y <= adView.mainImageView.frame.size.height) {
            inVideoView = YES;
        }
    }
    return inVideoView;
}

//广告返回失败
-(void)nativeAdsFailLoad:(BaiduMobFailReason)reason
{
    NSLog(@"nativeAdsFailLoad,reason = %d",reason);
    self.adViewArray = [NSMutableArray array];
    [self.tableView reloadData];
}

//广告被点击，打开后续详情页面，如果为视频广告，可选择暂停视频
-(void)nativeAdClicked:(UIView *)nativeAdView
{
    if ([nativeAdView isKindOfClass:[BaiduMobAdNativeAdView class]]) {
        BaiduMobAdNativeAdView *bdAdView = (BaiduMobAdNativeAdView*) nativeAdView;
        if ([bdAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
            [(BaiduMobAdNativeVideoView *)bdAdView.videoView pause];
        }
    }
    NSLog(@"nativeAdClicked");
}

//广告详情页被关闭，如果为视频广告，可选择继续播放视频
-(void)didDismissLandingPage:(UIView *)nativeAdView
{
    if ([nativeAdView isKindOfClass:[BaiduMobAdNativeAdView class]]) {
        BaiduMobAdNativeAdView *bdAdView = (BaiduMobAdNativeAdView*) nativeAdView;
        if ([bdAdView.videoView isKindOfClass:[BaiduMobAdNativeVideoView class]]) {
            [(BaiduMobAdNativeVideoView *)(bdAdView.videoView) play];
        }
    }
    NSLog(@"didDismissLandingPage");
}

#pragma mark - adConfig
- (BaiduMobAdNativeAdView *)createNativeAdViewWithframe:(CGRect)frame object:(BaiduMobAdNativeAdObject *)object
{
    UILabel *brandLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 15, 212, 20)];
    brandLabel.font = [UIFont fontWithName:brandLabel.font.familyName size:15];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 60, 200, 10)];//(85, 60, 200, 10)
    titleLabel.font = [UIFont fontWithName:titleLabel.font.familyName size:12];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 40, 200, 10)];
    textLabel.font = [UIFont fontWithName:textLabel.font.familyName size:12];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 60, 60)];
    UIImageView *mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 300, 250)];
    UIImageView *baiduLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 310, 18, 18)];
    UIImageView *adLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(286, 318, 24, 12)];

    
    BaiduMobAdNativeAdView *nativeAdView;
    
    if (object.materialType == VIDEO) {
                BaiduMobAdNativeVideoView *videoView = [[BaiduMobAdNativeVideoView alloc]initWithFrame:CGRectMake(0, 80, 320, 180) andObject:object];
        
        mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 300, 180)];
        //在大图上添加播放按钮引导用户点击视频
        UIImage *image = [self imageResoureForName:@"play_big_image"];
        UIImageView *playImage = [[UIImageView alloc ]initWithImage:image];
        playImage.alpha = 0.85;
        playImage.frame = CGRectMake(86, 40, 120, 120);
        [mainImageView addSubview:playImage];
        
        
        nativeAdView = [[BaiduMobAdNativeAdView alloc] initWithFrame:frame
                                                            brandName:brandLabel
                                                                title:titleLabel
                                                                 text:textLabel
                                                                 icon:iconImageView
                                                            mainImage:mainImageView
                                                            videoView:videoView
                         ];
        nativeAdView.baiduLogoImageView = baiduLogoView;
        [nativeAdView addSubview:baiduLogoView];
        nativeAdView.adLogoImageView = adLogoView;
        [nativeAdView addSubview:adLogoView];
        
    } else if (object.materialType == NORMAL) {
        nativeAdView =  [[BaiduMobAdNativeAdView alloc]initWithFrame:frame
                                                            brandName:brandLabel
                                                                title:titleLabel
                                                                 text:textLabel
                                                                 icon:iconImageView
                                                            mainImage:mainImageView];
        nativeAdView.baiduLogoImageView = baiduLogoView;
        [nativeAdView addSubview:baiduLogoView];
        nativeAdView.adLogoImageView = adLogoView;
        [nativeAdView addSubview:adLogoView];
        
    } else if (object.materialType == HTML) {
#warning 信息流模版广告
#warning 模板广告内部已添加百度广告logo和熊掌，开发者无需添加
        BaiduMobAdNativeWebView *webview = [[BaiduMobAdNativeWebView alloc]initWithFrame:frame andObject:object];
        nativeAdView = [[BaiduMobAdNativeAdView alloc]initWithFrame:frame
                                                               webview:webview];
    }
    
    nativeAdView.backgroundColor = [UIColor whiteColor];
    return nativeAdView;
}

- (UIImage *)imageResoureForName:(NSString*)name
{
    NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"baidumobadsdk" ofType:@"bundle"];
    NSBundle* b=  [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageWithContentsOfFile: [b pathForResource:name ofType:@"png"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.adViewArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (self.adViewArray.count > indexPath.row)
    {
        BaiduMobAdNativeAdView *view = [self.adViewArray objectAtIndex:indexPath.row];
        view.tag = 0;
        [[cell viewWithTag:0] removeFromSuperview];
        [cell addSubview: view];
        [self sendVisibleImpressionAtIndexPath:indexPath];
    }
    return cell;
}

- (void)sendVisibleImpressionAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *visiblePath = [self.tableView indexPathsForVisibleRows];
    if ([visiblePath containsObject:indexPath]) {
        if ([self.adViewArray count]> indexPath.row) {
            // 确定视图显示在window上之后再调用trackImpression，不要太早调用
            //在tableview或scrollview中使用时尤其要注意
            BaiduMobAdNativeAdView *view = [self.adViewArray objectAtIndex:indexPath.row];
            //仍然支持旧版本的展现方法
//            [view trackImpression];
            BaiduMobAdNativeAdObject *object = [self.adsArray objectAtIndex:indexPath.row];
            [object trackImpression:view];
        }
    }
}

/**
 * 大图高度，仅用于信息流模版广告
 */
-(NSNumber*)baiduMobAdsHeight {
    return [NSNumber numberWithFloat:180];
}

/**
 * 大图宽度，仅用于信息流模版广告
 */
-(NSNumber*)baiduMobAdsWidth {
    return [NSNumber numberWithFloat:320];
}

- (BOOL)enableLocation {
    return YES;

}

- (void)dealloc {
    _native = nil;
    for (UIView *adview in _adViewArray) {
        [adview removeFromSuperview];
    }
    [_adViewArray removeAllObjects];
    _adViewArray = nil;
    _adsArray = nil;
}

@end
