//
//  MoreViewController.m
//  UIPageViewController
//
//  Created by Boss Lin on 16/5/24.
//  Copyright © 2016年 zhigong123. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@property (nonatomic, strong) UIWebView *myWebView;



@end

@implementation MoreViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.myWebView loadHTMLString:_dataObject baseURL:nil];
    [self.view addSubview:self.myWebView];
    
//    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//    view.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:view];
}




#pragma mark - lazy load

- (UIWebView *)myWebView {
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    }
    return _myWebView;
}


@end
