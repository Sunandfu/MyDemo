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
    NSString *url = @"http://unet.ucweb.com/ucbrowser/ulcall?st_name=JSSDK&appkey=f11f7cb5d16fa0969d670c1eccc6053d&ch=llios1&bid=997&pkg=com.ucweb.iphone.lowversion&fr=ios&fromULcall=1&ucLink=uclink%3A%2F%2Fwww.uc.cn%2Ff11f7cb5d16fa0969d670c1eccc6053d%3Fsrc_pkg%3Dllios1%26src_ch%3Dllios1%26action%3Dopen_url%26src_scene%3Dpullup%26url%3Dext%253Ainfo_flow_open_channel%253Ach_id%253D100%2526insert_item_ids%253D15266524790584323791%2526type%253Dmultiple%2526from%253D6101";
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
