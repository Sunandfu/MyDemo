//
//  ViewController.m
//  AuthCode验证码
//
//  Created by iMac on 16/9/19.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSAuthCode.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController {
    WSAuthCode *wsCode;
    UITextField *textF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    

    
    wsCode = [[WSAuthCode alloc]initWithFrame:CGRectMake(50, 100, kScreenWidth-200, 40)];
    [self.view addSubview:wsCode];

    
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadBtn.frame = CGRectMake(kScreenWidth-150+20, 100, 100, 40);
    reloadBtn.layer.cornerRadius = 5;
    reloadBtn.backgroundColor = [UIColor greenColor];
    [reloadBtn setTitle:@"刷新验证码" forState:UIControlStateNormal];
    [self.view addSubview:reloadBtn];
    [reloadBtn addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    textF = [[UITextField alloc]initWithFrame:CGRectMake(20, 170, kScreenWidth-40, 30)];
    textF.borderStyle = UITextBorderStyleRoundedRect;
    textF.placeholder = @"输入验证码";
    [self.view addSubview:textF];
    
    
    UIButton *yanzhengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhengBtn.frame = CGRectMake(20, 220, kScreenWidth-40, 40);
    yanzhengBtn.layer.cornerRadius = 5;
    yanzhengBtn.backgroundColor = [UIColor greenColor];
    [yanzhengBtn setTitle:@"验证" forState:UIControlStateNormal];
    [self.view addSubview:yanzhengBtn];
    [yanzhengBtn addTarget:self action:@selector(yanzhengAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)reloadAction {
    [wsCode reloadAuthCodeView];
}


- (void)yanzhengAction {
    
    BOOL isOk = [wsCode startAuthWithString:textF.text];
    

    
    if (isOk) {
        
        //这里面写验证正确之后的动作.
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"匹配正确" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:2];

        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"验证码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:2];


        //这里面写验证失败之后的动作.
        [wsCode reloadAuthCodeView];
    }

    
}

@end
