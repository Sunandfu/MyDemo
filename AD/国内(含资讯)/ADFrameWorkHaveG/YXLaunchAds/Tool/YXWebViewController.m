//
//  WebViewController.m
//  YXLaunchAdExample
//
//  Created by zhuxiaohui on 16/9/8.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/YXLaunchAd
//  广告详情页

#import "YXWebViewController.h"
#import <WebKit/WebKit.h>
#import "YXLaunchAd.h"
#import "Network.h"

API_AVAILABLE(ios(8.0))
@interface YXWebViewController ()
{
    UIWebView * webview;
    NSInteger lengthOfTime;
}
@property(nonatomic,strong)WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation YXWebViewController

-(void)dealloc
{
    /**
     如果你设置了APP从后台恢复时也显示广告,
     当用户停留在广告详情页时,APP从后台恢复时,你不想再次显示启动广告,
     请在广告详情控制器销毁时,发下面通知,告诉YXLaunchAd,广告详情页面已显示完
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdDetailPageShowFinishNotification object:nil];
    
    if (@available(iOS 8.0, *)) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }else{
        [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
//    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat navbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navStarBarHeight;
    if (self.navigationController) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_leftback"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_close"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
        self.navigationItem.leftBarButtonItems = @[backBtn,closeBtn];
        
        if (self.navigationController.navigationBar.translucent) {
            navStarBarHeight = navbarHeight+44;
        } else {
            if (self.navigationController.navigationBar.hidden) {
                [self addCustomNavigationWithNavbarHeight:navbarHeight];
                navStarBarHeight = navbarHeight+44;
            } else {
                navStarBarHeight = 0;
            }
        }
    } else {
        [self addCustomNavigationWithNavbarHeight:navbarHeight];
        navStarBarHeight = navbarHeight+44;
    }
    if (@available(iOS 8.0, *)) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navStarBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-navStarBarHeight)];
        
        self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:self.webView];
        
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        if(!self.URLString) return;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(self.URLString)]];
        [self.webView loadRequest:request];
    } else {
        webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, navStarBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-navStarBarHeight)];
        webview.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:webview];
        
        [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        if(!self.URLString) return;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(self.URLString)]];
        [webview loadRequest:request];
    }
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, navStarBarHeight-2, self.view.bounds.size.width, 2)];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = [UIColor blackColor];
    [self.view addSubview:self.progressView];
}
- (void)addCustomNavigationWithNavbarHeight:(CGFloat)navbarHeight{
    UIView *navVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, navbarHeight + 44)];
    navVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navVIew];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    NSString *lang;
    NSString *close;
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        lang = @"返回";
        close = @"关闭";
    }else{//非中文
        lang = @"back";
        close = @"close";
    }
    
    UIImage *leftimage = [UIImage imageNamed:@"XibAndPng.bundle/sf_leftback"];
    [button setImage:leftimage forState:UIControlStateNormal];
    
    button.frame = CGRectMake(20,navbarHeight, 30, 44);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [navVIew addSubview:button];
    
    
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.backgroundColor =[UIColor whiteColor];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonBack.titleLabel.font = [UIFont systemFontOfSize:15];
    UIImage *closeimage = [UIImage imageNamed:@"XibAndPng.bundle/sf_close"];
    [buttonBack setImage:closeimage forState:UIControlStateNormal];
    
    buttonBack.frame = CGRectMake(60,navbarHeight, 30, 44);
    [buttonBack addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    
    [navVIew addSubview:buttonBack];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     如果你设置了APP从后台恢复时也显示广告,
     当用户停留在广告详情页时,APP从后台恢复时,你不想再次显示启动广告,
     请在广告详情控制器将要显示时,发下面通知,告诉YXLaunchAd,广告详情页面将要显示
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdDetailPageWillShowNotification object:nil];
    if (!self.show) {
        lengthOfTime = [[NSDate date] timeIntervalSince1970];
        return;
    }
    
    if (nil!=[YXAdSDKManager defaultManager].webCustomView) {
        NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:[YXAdSDKManager defaultManager].webCustomView];
        UIView *redView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        redView.autoresizesSubviews =YES;
        for (UIView *view in redView.subviews) {
            view.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin   |
            UIViewAutoresizingFlexibleWidth        |
            UIViewAutoresizingFlexibleRightMargin  |
            UIViewAutoresizingFlexibleTopMargin    |
            UIViewAutoresizingFlexibleHeight       |
            UIViewAutoresizingFlexibleBottomMargin ;
        }
        redView.frame = CGRectMake(SF_ScreenW-redView.bounds.size.width-10, SF_ScreenH-SF_TabbarHeight-redView.bounds.size.height-10, redView.bounds.size.width, redView.bounds.size.height);
        redView.tag = 998;
        redView.layer.masksToBounds = YES;
        redView.layer.cornerRadius = (redView.bounds.size.height<redView.bounds.size.width?redView.bounds.size.height:redView.bounds.size.width)/2.0;
        redView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewClick)];
        [redView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:redView];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.progressView removeFromSuperview];
    if (!self.show) {
        NSTimeInterval tmpDisTime = [[NSDate date] timeIntervalSince1970];
        lengthOfTime = tmpDisTime - lengthOfTime;
        [Network newsStatisticsWithType:4 NewsID:self.newsIdStr CatID:self.catIdStr lengthOfTime:lengthOfTime];
        return;
    }
    UIView *redView = [[UIApplication sharedApplication].keyWindow viewWithTag:998];
    [redView removeFromSuperview];
}
- (void)customViewClick{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customWebViewClicked)]) {
        [self.delegate customWebViewClicked];
    }
}
-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
- (void)backToHome
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)backAction
{
    if (@available(iOS 8.0, *)) {
        if([_webView canGoBack]) {
            [_webView goBack];
        } else {
            [self backToHome];
        }
    } else{
        [self backToHome];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.progressView setProgress:progress animated:YES];
        if(progress == 1.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.progressView setProgress:0.0 animated:NO];
            });
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
