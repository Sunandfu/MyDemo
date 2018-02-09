//
//  ViewController.m
//  CYNavigationDemo
//
//  Created by 张春雨 on 2017/5/5.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "CYNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgation];
}


#pragma mark - 设置导航栏
- (void)setNavgation{
    self.navigationbar = [self standardNavigationbar];
    self.navigationbar.backgroundColor = [UIColor whiteColor];
    [self.navigationbar customNavigationLabelColor:[UIColor blackColor]];
    self.navigationbar.title.text = @"首页";
    [self.navigationbar.rightBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [self.navigationbar.rightBtn addTarget:self action:@selector(next) forControlEvents:
     UIControlEventTouchUpInside];
}

- (void)next{
    ViewController2 *vc = [[ViewController2 alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
