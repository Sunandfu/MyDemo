//
//  LHHTTPRequestController.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHHTTPRequestController.h"
#import "LHData.h"
#import "MBProgressHUD.h"
#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface LHHTTPRequestController ()

@end

@implementation LHHTTPRequestController{
    LHNetWorkReachability* reachability;
    UILabel* netLabel;
    LHHTTPRequestManager* manger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //监测网络
    [self networkReachability];
    [self request];
    // Do any additional setup after loading the view.
}

- (void)networkReachability
{
    reachability = [LHNetWorkReachability manager];
    netLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    netLabel.textAlignment  = NSTextAlignmentCenter;
    netLabel.center = self.view.center;
    [self.view addSubview:netLabel];
    netLabel.backgroundColor = [UIColor redColor];
    [self loadNetWork];
    WEAKSELF;
    [reachability addReachabilityDidChanged:^(LHNetWorkStatus status) {
        [weakSelf loadNetWork];
        [[MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES] setLabelText:@"网络状态发生变化"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    }];
    [reachability StartMonitoring];
}

- (void)request
{
    manger = [LHHTTPRequestManager shareInstance];
    //需要请求对象和请求进度
   [manger GET:@"your url" progress:^(LHProgressLong currentBytes, LHProgressLong alreadyReceiveBytes, LHProgressLong totalBytes) {
        
    } receiveData:^(NSData *data, LHHTTPRequest *request) {
        
    } complete:^(NSData *resultData, NSString *urlString) {
        
    }];
    //直接的GET请求
    [manger GET:@"your url" success:^(id response) {
        
    } fail:^(NSError *error) {
        
    }];
    //POST
    [manger POST:@"your url" parameters:@"your postbody" success:^(id response) {
        
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
    //阻塞下载到指定路径
    [manger downloadToFilePathWithURL:@"your url" filePath:@"your filepath"];
    //非阻塞下载到指定路径 回调进度
    [manger downloadToFilePathWithURL:@"your url" filePath:@"your filepath" progress:^(LHProgressLong currentBytes, LHProgressLong alreadyReceiveBytes, LHProgressLong totalBytes) {
        
    }];
}



- (void)loadNetWork
{
    switch (reachability.netWorkStatus) {
        case LHNetworkStatusNotReachable:
            netLabel.text = [NSString stringWithFormat:@"当前无网络"];
            break;
            
        case LHNetworkStatusReachableViaWWAN:
            netLabel.text = [NSString stringWithFormat:@"当前是蜂窝网络"];
            break;
            
        case LHNetworkStatusReachableViaWiFi:
            netLabel.text = [NSString stringWithFormat:@"当前是WIFI网络"];
        default:
            break;
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
