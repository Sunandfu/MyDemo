//
//  ViewController.m
//  封装输入框demo
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "ViewController.h"
#import "WSTextField.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor greenColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0,@1];
    [self.view.layer addSublayer:gradientLayer];
    
    
    
    [self setUp];

    
}


-(void)setUp{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleLabel.center = CGPointMake(self.view.center.x, 150);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"WS";
    titleLabel.font = [UIFont systemFontOfSize:40.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    
    WSTextField *username = [[WSTextField alloc]initWithFrame:CGRectMake(30, kScreenHeight/2 + 50, kScreenWidth-60, 30)];
    username.ly_placeholder = @"Username";
    //改输入框placeholder的颜色
    username.placeholderSelectStateColor = [UIColor redColor];
    username.placeholderNormalStateColor = [UIColor cyanColor];
    [self.view addSubview:username];
    
    WSTextField *password = [[WSTextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(username.frame)+30, kScreenWidth-60, 30)];
    password.textField.secureTextEntry = YES;
    password.ly_placeholder = @"Password";
    [self.view addSubview:password];
 
}









@end
