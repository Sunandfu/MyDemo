//
//  YXFeedNativeBannerViewControllerDemo.m
//  TestAdA
//
//  Created by shuai on 2018/11/13.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedNativeBannerViewControllerDemo.h"
#import <YXLaunchAds/YXFeedAdManager.h>
#import <YXLaunchAds/YXFeedAdData.h>

#import "YXNewPagedFlowView.h"
#import "YXPGIndexBannerSubiew.h"

#define Width [UIScreen mainScreen].bounds.size.width

static  NSString * feedMediaID = @"pt_ios_native";

@interface YXFeedNativeBannerViewControllerDemo ()<YXFeedAdManagerDelegate,YXNewPagedFlowViewDelegate, YXNewPagedFlowViewDataSource>
{
    YXFeedAdManager *feedManager;
    BOOL isAdLoadSuccess;
}

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  指示label
 */
@property (nonatomic, strong) UILabel *indicateLabel;

@property (nonatomic,strong) YXNewPagedFlowView *pageFlowView;

@property (nonatomic,strong) UIView *yxFeedView;

@property (nonatomic,strong) UIImageView *adImageView;

@property (nonatomic,strong) YXFeedAdData *adData;

@end

@implementation YXFeedNativeBannerViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    isAdLoadSuccess = NO;
    for (int index = 0; index < 2; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [self.imageArray addObject:image];
    }
    
    [self setupUI];
    
    [self loadFeedAds:self.yxFeedView];
    
    
    // Do any additional setup after loading the view.
}

-(UIView *)yxFeedView
{
    if (!_yxFeedView) {
        _yxFeedView = ({
            UIView * view = [UIView new];
            view.frame = ({
                CGRect frame;
                frame = CGRectMake(0, 0, Width, Width * 9 / 16);
                frame;
            });
            view.userInteractionEnabled = YES;
            [_yxFeedView addSubview:self.adImageView];
            view;
        });
    }
    return _yxFeedView;
}
-(UIImageView *)adImageView
{
    if (!_adImageView) {
        _adImageView = ({
            UIImageView * imageView = [UIImageView new];
            imageView.frame = ({
                CGRect frame;
                frame = CGRectMake(0, 0, _yxFeedView.bounds.size.width, _yxFeedView.bounds.size.height);
                frame;
            });
            imageView;
        });
    }
    return _adImageView;
}

- (void)initScrollerView
{
    //初始化pageControl
 
}

- (void)loadFeedAds:(UIView*)view
{
    feedManager = [YXFeedAdManager new];
    feedManager.adSize = YXADSize690X388;
    feedManager.mediaId = feedMediaID;
    
    feedManager.controller = self;
    feedManager.delegate = self;
    [feedManager loadFeedAd];
}
- (void)initadViewWithData:(YXFeedAdData *)data
{
    [self setImage:self.adImageView WithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:nil];
}

- (void)setImage:(UIImageView*)imageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    NSURLSession *shareSessin = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [shareSessin dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }];
    [dataTask resume];
}
#pragma mark ad delegate
- (void)didLoadFeedAd:(YXFeedAdData *)data
{
    NSLog(@"feed请求成功");
    self.adData = data;
    isAdLoadSuccess = YES;
    [_pageFlowView reloadData];
}
-(void)didFailedLoadFeedAd:(NSError *)error
{
    NSLog(@"%@",error);
}
-(void)didClickedFeedAd
{
    NSLog(@"点击");
}
- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _pageFlowView = [[YXNewPagedFlowView alloc] initWithFrame:CGRectMake(0, 100, Width, Width * 9 / 16)];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0;
    _pageFlowView.isCarousel = YES;
    _pageFlowView.orientation = YXNewPagedFlowViewOrientationVertical;
    _pageFlowView.isOpenAutoScroll = YES;
    
    //初始化pageControl
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 32, Width, 8)];
//    _pageFlowView.pageControl = pageControl;
//    [_pageFlowView addSubview:pageControl];
    
    [_pageFlowView reloadData];
//
    [self.view addSubview:_pageFlowView];
    
    //添加到主view上
    [self.view addSubview:self.indicateLabel];
    
}


#pragma mark YXNewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(YXNewPagedFlowView *)flowView {
    return CGSizeMake(Width , (Width ) * 9 / 16);
//    return CGSizeMake(Width - 60, (Width - 60) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
    
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(YXNewPagedFlowView *)flowView {
    
    if (self) {
        NSLog(@"ViewController 滚动到了第%ld页",(long)pageNumber);
    }
    
}

#pragma mark YXNewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(YXNewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (YXPGIndexBannerSubiew *)flowView:(YXNewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    YXPGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[YXPGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    bannerView.mainImageView.image = self.imageArray[index];
    
    if (isAdLoadSuccess && index == 0) {
        //在这里下载网络图片
        [self setImage:bannerView.mainImageView WithURL:[NSURL URLWithString:self.adData.imageUrl] placeholderImage:self.imageArray[index]];
        [feedManager registerAdViewForInteraction:bannerView];
    }
    return bannerView;
}


#pragma mark --懒加载

- (UILabel *)indicateLabel {
    
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, Width, 16)];
        _indicateLabel.textColor = [UIColor blueColor];
        _indicateLabel.font = [UIFont systemFontOfSize:16.0];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"指示Label";
    }
    
    return _indicateLabel;
}
@end
