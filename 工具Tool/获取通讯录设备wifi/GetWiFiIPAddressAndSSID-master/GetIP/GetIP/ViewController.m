//
//  ViewController.m
//  GetIP
//
//  Created by iMac on 16/8/26.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "ViewController.h"
#import "WSGetWifi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    UILabel *SSID = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 300, 40)];
    NSLog(@"%@",[[WSGetWifi getSSIDInfo] description]);
    SSID.text = [NSString stringWithFormat:@"当前连接Wifi名称: %@",[WSGetWifi getSSIDInfo][@"SSID"]];
    SSID.textColor = [UIColor whiteColor];
    [self.view addSubview:SSID];
    
    
    UILabel *ip = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 300, 40)];
    ip.text = [NSString stringWithFormat:@"当前Wifi的IP地址: %@",[WSGetWifi getWiFiIPAddress]];
    ip.textColor = [UIColor whiteColor];
    NSLog(@"当前Wifi的IP地址:%@",[WSGetWifi getWiFiIPAddress]);
    [self.view addSubview:ip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
