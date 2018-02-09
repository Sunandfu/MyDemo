//
//  WKJSToOCViewController.m
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/3/25.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "WKJSToOCViewController.h"
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WeakScriptMessageDelegate.h"


@interface WKJSToOCViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>{
    
    WKWebView *_myWebView;
}

@end

@implementation WKJSToOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 调用js根据视图大小来缩放页面
    NSString *jScript = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:wkUScript];
    
    
    _myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    _myWebView.UIDelegate = self;
    _myWebView.navigationDelegate = self;
    [self.view addSubview:_myWebView];
    
    
    [[_myWebView configuration].userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"callbackHandler"];
    /*下面这种方式会循环引用造成内存泄露，所以用上面这种创建了一个中间对象
    [[_myWebView configuration].userContentController addScriptMessageHandler:self name:@"callbackHandler"];
    */
    
    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"wkjsindex"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
}


#pragma mark- WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
    //如果需要回调，直接调用OC调用JS的方法
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    _myWebView.UIDelegate = nil;
    _myWebView.navigationDelegate = nil;
    [_myWebView loadHTMLString:@"" baseURL:nil];
    [_myWebView stopLoading];
    _myWebView = nil;
    [[_myWebView configuration].userContentController removeScriptMessageHandlerForName:@"callbackHandler"];

    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSLog(@"我被释放了");
}

@end
