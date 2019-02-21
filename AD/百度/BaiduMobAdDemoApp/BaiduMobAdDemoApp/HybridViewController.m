//
//  HybridViewController.m
//  XAdSDKDevSample
//
//  Created by lishan04 on 17/04/2018.
//  Copyright © 2018 Baidu. All rights reserved.
//

#import "HybridViewController.h"
#import <WebKit/WebKit.h>
#import "BaiduMobAdSDK/BaiduMobAdHybridAdManager.h"
@interface HybridViewController ()<WKNavigationDelegate, BaiduMobAdHybridAdManagerDelegate>
@property (nonatomic, retain) BaiduMobAdHybridAdManager *manager;
@property (nonatomic, retain) WKWebView *wkWebView;

@end

@implementation HybridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NSClassFromString(@"WKWebView")) {
        [self useWKWebView];
    }
}

- (void)useWKWebView {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:
                             [NSURL URLWithString:@"https://mobads.baidu.com/ads/indexlpios.html"]];
    self.manager = [[BaiduMobAdHybridAdManager alloc]init];
    self.manager.publisherId = @"ccb60059";
    self.manager.delegate = self;
    
    WKWebView *webView = [[[WKWebView alloc]initWithFrame:self.view.bounds] autorelease];
    webView.navigationDelegate = self;
    [webView loadRequest:request];
    
    //重要，把wkwebview传给BaiduMobAdHybridAdManager进行注册
    [self.manager injectJavaScriptBridgeForWKWebView:webView];
    [self.view addSubview:webView];
    self.wkWebView = webView;
}

//重要，在wkwebview回调时通知BaiduMobAdHybridAdManager
// if use wkwebview, call - (BOOL)webView:(WKWebView *)webView shouldStartLoadForNavigationAction:(WKNavigationAction *)navigationAction
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //当shouldStartLoadForNavigationAction返回no时,表示BaiduMobAdHybridAdManager可处理这次回调，调用decisionHandler(WKNavigationActionPolicyCancel);
    BOOL shouldLoad  = [self.manager webView:webView shouldStartLoadForNavigationAction:navigationAction];
    if (!shouldLoad) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.manager.delegate = nil;
    self.manager = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didAdClicked {
    NSLog(@"didadclicked");
}

- (void)didAdImpressed {
    NSLog(@"didAdImpressed");

}

- (void)failedDisplayAd {

}


@end
