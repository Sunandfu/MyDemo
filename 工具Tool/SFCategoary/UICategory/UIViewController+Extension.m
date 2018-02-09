//
//  UIViewController+Extension.m
//  XCFApp
//
//  Created by callmejoejoe on 16/4/17.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)presentWebViewWithURL:(NSString *)URL {
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewCon.view.bounds.size.width, 64)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [viewCon.view addSubview:view];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 20, 44, 44);
    [button setTitle:@"×" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:45];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewCon.view.bounds.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"新闻";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewCon.view.bounds.size.width,viewCon.view.bounds.size.height)];
    webView.backgroundColor = [UIColor whiteColor];
    [viewCon.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [webView loadRequest:request];
    [self presentViewController:viewCon animated:NO completion:nil];
}
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pushWebViewWithURL:(NSString *)URL {
    UIViewController *viewCon = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, viewCon.view.bounds.size.width,viewCon.view.bounds.size.height)];
    webView.backgroundColor = [UIColor whiteColor];
    [viewCon.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [webView loadRequest:request];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
