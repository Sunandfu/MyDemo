//
//  CpuChannelViewController.m
//  XAdSDKDevSample
//
//  Created by LiYan on 2016/12/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "CpuChannelViewController.h"
#import "BaiduMobAdSDK/BaiduMobCpuInfoManager.h"
#import "BaiduMobAdSDK/BaiduMobAdCommonConfig.h"
#import "XScreenConfig.h"

@interface CpuChannelViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource, UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIButton *channelSelectButton;
@property (retain, nonatomic) IBOutlet UIButton *channelShowButton;
@property (retain, nonatomic) IBOutlet UIPickerView *channelSelectPickerView;

@property (nonatomic, retain) NSDictionary *channelDictionary; //选择频道

@property (nonatomic, copy) NSString *currentSelectedChannelString; //当前选定的频道

@property (nonatomic, strong) UIWebView   *webView; //展示内容联盟用的webview

@end

@implementation CpuChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeWebView)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.channelSelectButton addTarget:self action:@selector(pressChannelSelectButton) forControlEvents:UIControlEventTouchUpInside];
    [self.channelShowButton addTarget:self action:@selector(pressChannelShowButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.channelSelectPickerView.hidden = YES;

    //仅适用于频道样式, 不适用于block样式
    self.channelDictionary = @{
                               @"cpuChannelEntertainment" : CPU_CHANNEL_ENTERTAINMENT,  //娱乐
                               @"cpuChannelSports"        : CPU_CHANNEL_SPORTS,         //体育
                               @"cpuChannelPicture"       : CPU_CHANNEL_PICTURE,        //图片
                               @"cpuChannelMobilePhone"   : CPU_CHANNEL_MOBILE,         //手机
                               @"cpuChannelFinance"       : CPU_CHANNEL_FINANCE,        //财经
                               @"cpuChannelAutoMotive"    : CPU_CHANNEL_CAR,            //汽车
                               @"cpuChannelHouse"         : CPU_CHANNEL_HOUSE,          //房产
                               @"cpuChannelFashion"       : CPU_CHANNEL_FASHION,        //时尚
                               @"cpuChannelShopping"      : CPU_CHANNEL_SHOPPING,       //购物
                               @"cpuChannelMilitary"      : CPU_CHANNEL_MILITARY,       //军事
                               @"cpuChannelTech"          : CPU_CHANNEL_TECH,           //科技
                               @"cpuChannelHealth"        : CPU_CHANNEL_HEALTH,         //健康
                               @"cpuChannelHotspot"       : CPU_CHANNEL_HOTSPOT,        //热点
                               @"cpuChannelRecommend"     : CPU_CHANNEL_RECOMMEND,      //推荐
                               @"cpuChannelBeauty"        : CPU_CHANNEL_BEAUTY,         //美女
                               @"cpuChannelAmuse"         : CPU_CHANNEL_AMUSE,          //搞笑
                               @"cpuChannelAgg"           : CPU_CHANNEL_AGG,            //聚合
                               @"cpuChannelVideo"         : CPU_CHANNEL_VIDEO,          //视频
                               @"cpuChannelWoman"         : CPU_CHANNEL_WOMEN,          //女人
                               @"cpuChannelLife"          : CPU_CHANNEL_LIFE,           //生活
                               @"cpuChannelCulture"       : CPU_CHANNEL_CULTURE         //文化
                               };
    
    self.channelSelectPickerView.dataSource = self;
    self.channelSelectPickerView.delegate = self;
    
    [self.channelSelectPickerView reloadAllComponents];
}

- (void) pressChannelSelectButton {
    self.channelSelectPickerView.hidden = !self.channelSelectPickerView.hidden;
}

- (void) pressChannelShowButton {
    if (self.currentSelectedChannelString) {
        [self loadCpuStyleChannelWithChannelId:self.currentSelectedChannelString];
    }
}

#pragma mark - pickerview

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 21;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.channelDictionary allKeys] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.channelSelectPickerView.hidden = YES;
    NSString *currentChannelTitle = [[self.channelDictionary allKeys] objectAtIndex:row];
    [self.channelSelectButton setTitle:currentChannelTitle forState:UIControlStateNormal];
    self.currentSelectedChannelString = [self.channelDictionary objectForKey:currentChannelTitle];
}

#pragma mark - show ad
- (void)loadCpuStyleChannelWithChannelId:(NSString *)channelId {
    NSString *urlStr = [[BaiduMobCpuInfoManager shared] getCpuInfoUrlWithChannelId:channelId
                                                                             appId:@"d77e414"];
    if (urlStr) {
        NSURL  *url = [NSURL URLWithString:urlStr];
        [self.webView loadRequest:[NSMutableURLRequest requestWithURL:url]];
        [self.view addSubview:self.webView];
    }
}

- (void) closeWebView {
    [self.webView removeFromSuperview];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

#pragma mark - getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
        if(ISIPHONEX) {
            _webView.frame = CGRectMake(0, 84, self.view.bounds.size.width, self.view.bounds.size.height);
        }
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _webView;
}


@end
