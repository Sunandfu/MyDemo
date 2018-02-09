//
//  JSToOCViewController.m
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/1/21.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "JSToOCViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSObject.h"


@interface JSToOCViewController()<UIWebViewDelegate>

@end

@implementation JSToOCViewController{
    
    UIWebView *_myWebView;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    
    //本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"jsindex"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
    
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
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"Toyun"] = object;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType //这个方法是网页中的每一个请求都会被触发的
{
    
    return YES;
}


- (void)dealloc{
    
    NSLog(@"我被释放了");
}

@end
