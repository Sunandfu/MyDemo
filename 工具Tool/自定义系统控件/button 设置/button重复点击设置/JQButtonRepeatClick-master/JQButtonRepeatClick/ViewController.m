//
//  ViewController.m
//  JQButtonRepeatClick
//
//  Created by 韩俊强 on 2016/12/20.
//  Copyright © 2016年 HaRi. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+JQ.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // test
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    testBtn.frame = CGRectMake(100, 100, [UIScreen mainScreen].bounds.size.width-200, [UIScreen mainScreen].bounds.size.height/3);
    
    testBtn.backgroundColor = [UIColor greenColor];
    [testBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [testBtn setTitle:@"测试" forState:UIControlStateNormal];
    
    [testBtn addTarget:self action:@selector(goToTestAction:) forControlEvents:UIControlEventTouchUpInside];
    // 设置几秒内忽略重复点击
    testBtn.JQ_acceptEventInterval = 1;
    
    [self.view addSubview:testBtn];

}

- (void)goToTestAction:(UIButton*)sender
{
    NSLog(@"Hello world！");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
