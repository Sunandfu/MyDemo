//
//  ViewController.m
//  test
//
//  Created by suyushen on 16/4/28.
//  Copyright © 2016年 lbh. All rights reserved.
//

#import "ViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface ViewController () <NJKWebViewProgressDelegate,UIWebViewDelegate>
{
    NJKWebViewProgress * _progressxy;
    NJKWebViewProgressView *_progressView;
    UIWebView *_webView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"load" style:UIBarButtonItemStylePlain target:self action:@selector(load)];
    
    //测试webView
    [self setWebView];
   
}
- (void)setWebView
{
    _progressxy = [[NJKWebViewProgress alloc]init];
    _progressxy.webViewProxyDelegate = self;
    _progressxy.progressDelegate = self;
    
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _webView.delegate = _progressxy;
    [self load];
   
    
    _progressView = [[NJKWebViewProgressView alloc]init];
    _progressView.frame = CGRectMake(0, 64, self.view.frame.size.width, 2);
    [self.view addSubview:_progressView];
    [_progressView setProgress:0 animated:NO];
    
}
- (void)load
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

@end
