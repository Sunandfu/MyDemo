//
//  ViewController.m
//  WS-TodayWidget
//
//  Created by iMac on 16/10/14.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 100)];
    label.numberOfLines = 0;
    label.textColor = [UIColor blueColor];
    label.text = @"通知栏下拉,\n点击编辑,\n添加WSWidget即可看到通知中心的视图";
    [self.view addSubview:label];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
