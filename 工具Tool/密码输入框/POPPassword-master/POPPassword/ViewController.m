//
//  ViewController.m
//  POPPassword
//
//  Created by Luoxusheng-imac on 16/10/19.
//  Copyright © 2016年 luoxusheng. All rights reserved.
//

#import "ViewController.h"

#import "PasswordAlertView.h"

#define BtnColor [UIColor colorWithRed:0.01f green:0.45f blue:0.88f alpha:1.00f]     //按钮的颜色  蓝色


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:BtnColor];
    [btn setTitle:@"弹出式密码框" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    

    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 200, 100)];
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:BtnColor];
    [btn1 setTitle:@"一体式密码框" forState:UIControlStateNormal];

    [self.view addSubview:btn1];


}

-(void)clickBtn{
    
    //弹出式密码框
    PasswordAlertView *passView = [[PasswordAlertView alloc]initSingleBtnView];
    passView.passWordTextConfirm =^(NSString *text){//点击确定按钮输出密码
        
        NSLog(@"%@",text);
        NSLog(@"点击了确定按钮");
    };
    [passView show];
}


-(void)clickBtn1{
    
    //一体式密码框
    PasswordAlertView *passView = [[PasswordAlertView alloc]initPasswordView];
    passView.passWordText =^(NSString *text){//实时监听输入的密码
        
        NSLog(@"%@",text);

    };
    [passView passwordShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
