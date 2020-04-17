//
//  TestViewController.m
//  TestAdA
//
//  Created by lurich on 2019/6/21.
//  Copyright © 2019 YX. All rights reserved.
//

#import "TestViewController.h"
#import "Network.h"
#import <SafariServices/SafariServices.h>
#import "YXWebViewController.h"

@interface TestViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIButton *iconBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100 , 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"通用链接测试" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bannerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:iconBtn];
}
- (void)bannerBtnClicked:(UIButton*)button{
    NSString *url = @"https://newios.reader.qq.com/uniteqqreader://nativepage/client/readepage?bid=20496369&cid=2&source_name=feed_ioslanhai1&source_id=ioslh1&source_type=0";
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"跳转成功");
            } else {
                YXWebViewController *VC = [[YXWebViewController alloc] init];
                VC.URLString = url;
                //此处不要直接取keyWindow
                [self presentViewController:VC animated:NO completion:nil];
            }
        }];
    }
}
@end
