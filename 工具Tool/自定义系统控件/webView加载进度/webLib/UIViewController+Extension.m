//
//  UIViewController+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/17.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "UIWebView+YBProgress.h"

@implementation UIViewController (Extension)

- (void)presentNegotiateWebViewWithURL:(NSString *)URL {
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewCon.view.bounds.size.width, 64)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [viewCon.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 20, 44, 44);
    [button setImage:[UIImage imageNamed:@"morenguanbi"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"anxiaguanbi"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewCon.view.bounds.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"用户协议";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewCon.view.bounds.size.width,viewCon.view.bounds.size.height-64)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [viewCon.view addSubview:webView];
    NSURL *url;
    if ([URL hasPrefix:@"http"]) {
        url = [NSURL URLWithString:URL];
    } else {
        url = [NSURL fileURLWithPath:URL];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self presentViewController:viewCon animated:YES completion:nil];
}
- (void)presentWebViewWithURL:(NSString *)URL Title:(NSString *)title{
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewCon.view.bounds.size.width, 64)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [viewCon.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 20, 44, 44);
    [button setImage:[UIImage imageNamed:@"morenguanbi"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"anxiaguanbi"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewCon.view.bounds.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewCon.view.bounds.size.width,viewCon.view.bounds.size.height-64)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [viewCon.view addSubview:webView];
    NSURL *url;
    if ([URL hasPrefix:@"http"]) {
        url = [NSURL URLWithString:URL];
    } else {
        url = [NSURL fileURLWithPath:URL];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self presentViewController:viewCon animated:YES completion:nil];
}
- (void)presentWebViewWithURL:(NSString *)URL {
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewCon.view.bounds.size.width, 64)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [viewCon.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 20, 44, 44);
    [button setImage:[UIImage imageNamed:@"morenguanbi"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"anxiaguanbi"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewCon.view.bounds.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewCon.view.bounds.size.width,viewCon.view.bounds.size.height-64)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = YES;
    [viewCon.view addSubview:webView];
    NSURL *url;
    if ([URL hasPrefix:@"http"]) {
        url = [NSURL URLWithString:URL];
    } else {
        url = [NSURL fileURLWithPath:URL];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self presentViewController:viewCon animated:YES completion:nil];
}
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pushWebViewWithURL:(NSString *)URL Title:(NSString *)title{
    UIViewController *viewCon = [[UIViewController alloc] init];
    viewCon.title = title;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewCon.view.bounds.size.width,viewCon.view.bounds.size.height-64)];
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    [viewCon.view addSubview:webView];
    NSURL *url;
    if ([URL hasPrefix:@"http"]) {
        url = [NSURL URLWithString:URL];
    } else {
        url = [NSURL fileURLWithPath:URL];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.navigationController pushViewController:viewCon animated:YES];
}
@end
