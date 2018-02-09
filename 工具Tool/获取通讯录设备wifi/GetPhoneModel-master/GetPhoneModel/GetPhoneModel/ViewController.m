//
//  ViewController.m
//  GetPhoneModel
//
//  Created by iMac on 16/7/8.
//  Copyright © 2016年 Sinfotek. All rights reserved.
//

#import "ViewController.h"
#import "WSGetPhoneTypeController.h"



#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *phoneModelStr = [WSGetPhoneTypeController getPhoneModel];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, kScreenWidth-40, 20)];
    label.text = [NSString stringWithFormat:@"此设备是：%@",phoneModelStr];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
