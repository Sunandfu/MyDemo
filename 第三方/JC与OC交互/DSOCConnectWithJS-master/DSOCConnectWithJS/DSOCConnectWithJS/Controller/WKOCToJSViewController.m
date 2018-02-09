//
//  WKOCToJSViewController.m
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/3/25.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "WKOCToJSViewController.h"
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WKOCToJSViewController ()<WKUIDelegate,WKNavigationDelegate>{
    
    WKWebView *_myWebView;
}

@end

@implementation WKOCToJSViewController

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

    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"wkindex"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
    
    
    UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 250, 50)];
    [buttonOne setTitle:@"调用js：标题变红" forState:UIControlStateNormal];
    buttonOne.backgroundColor = [UIColor redColor];
    [buttonOne addTarget:self action:@selector(buttonOneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];
}

#pragma mark - Click Methon

-(void)buttonOneClick:(UIButton *)sender{
   
    [_myWebView evaluateJavaScript:@"redHeader(\"red\")" completionHandler:^(id _Nullable string, NSError * _Nullable error) {
        
        //js返回值
        NSLog(@"%@",string);
    }];
    
    
    /* 调用js的alert是在WKUIDelegate的runJavaScriptAlertPanelWithMessage方法里实现的。
       还有confirm、prompt这两种js方法也是有对应的代理方法的
    [_myWebView evaluateJavaScript:@"hello()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",response);
    }];
    */
}


#pragma mark WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);   //js的alert框的message
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
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSLog(@"我被释放了");
}

@end
