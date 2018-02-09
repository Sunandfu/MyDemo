//
//  NewsDetailViewController.m
//  MyProject
//
//  Created by 小富 on 16/4/25.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NetRequestManager.h"

@interface NewsDetailViewController () <UIWebViewDelegate>

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([NetRequestManager sharedNetworking].networkStats == StatusNotReachable) {
        UILabel *label = [Factory createLabelWithTitle:@"无网络连接" frame:CGRectMake(0, 0, 160, 50)];
        label.center = self.view.center;
        label.font = [UIFont boldSystemFontOfSize:20];
        [self.view addSubview:label];
    } else {
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlStr]]];
        [self.view addSubview:web];
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
