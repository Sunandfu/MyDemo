//
//  ViewController.m
//  QQBtn
//
//  Created by MacBook on 15/6/25.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "ViewController.h"
#import "QQButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    QQButton *btn = [[QQButton alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    [self.view addSubview:btn];
    [btn setUp];
    btn.backgroundColor = [UIColor greenColor];
    btn.samllCircleView.backgroundColor = [UIColor blueColor];
}

@end
