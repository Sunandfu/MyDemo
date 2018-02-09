//
//  OCToJSViewController.m
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/1/21.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "OCToJSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSObject.h"

@interface OCToJSViewController()

@end

@implementation OCToJSViewController{
    
    UIWebView *_myWebView;
    
    JSContext *_context;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];

    
    UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 250, 45)];
    [buttonOne setTitle:@"调用js：标题变红" forState:UIControlStateNormal];
    buttonOne.backgroundColor = [UIColor redColor];
    [buttonOne addTarget:self action:@selector(buttonOneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];
    
    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(10, 120, 250, 45)];
    [buttonTwo setTitle:@"调用js：标题变黑" forState:UIControlStateNormal];
    buttonTwo.backgroundColor = [UIColor redColor];
    [buttonTwo addTarget:self action:@selector(buttonTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTwo];
}

#pragma mark - Click Methon

- (void)buttonOneClick:(UIButton *)sender{
    
    if (_context) {
        NSString *jsString=@"redHeader(\"red\")"; //准备执行的js代码
        JSValue *value = [_context evaluateScript:jsString];//通过oc方法调用js的alert
        NSLog(@"%@",value.toString);
    }
}

- (void)buttonTwoClick:(UIButton *)sender{
    
    NSString *string = [_myWebView stringByEvaluatingJavaScriptFromString:@"redHeader(\"black\")"];
    //NSString *string = [_myWebView stringByEvaluatingJavaScriptFromString:@"hello()"];
    NSLog(@"%@",string);
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];

    if ([self.title isEqualToString:@""]||!self.title) {
        NSString *navigationTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (![navigationTitle isEqualToString:@""]) {
            [self setTitle:navigationTitle];
        }
    }
    
    JSObject *object = [[JSObject alloc] init];
    
    //此处把js方法注入。使js可以调用oc方法。  为了测试，先把js方法注入，然后再使用oc调用js方法
    _context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"Toyun"] = object;
    _context.exception = nil;
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    
    return YES;
}


#pragma mark JSObjcDelegate

- (void)dealloc{
    
    _myWebView.delegate = nil;
    [_myWebView loadHTMLString:@"" baseURL:nil];
    [_myWebView stopLoading];
    _myWebView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSLog(@"我被释放了");
}

@end
