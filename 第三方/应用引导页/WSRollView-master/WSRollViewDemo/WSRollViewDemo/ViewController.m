//
//  ViewController.m
//  WSRollImageView
//
//  Created by iMac on 16/11/29.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"

#import "WSRollView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WSRollView *wsRoll = [[WSRollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    wsRoll.backgroundColor = [UIColor whiteColor];
    wsRoll.timeInterval = 0.01; //移动一次需要的时间
    wsRoll.rollSpace = 0.5; //每次移动的像素距离
    wsRoll.image = [UIImage imageNamed:@"111.jpg"];//本地图片
//    wsRoll.rollImageURL = @"http://jiangsu.china.com.cn/uploadfile/2016/0122/1453449251090847.jpg"; //网络图片地址
    [wsRoll startRoll]; //开始滚动
    [self.view addSubview:wsRoll];
    
    
    
    
    [self _creatUserAndPasswordTextField];
    
    
}


- (void)_creatUserAndPasswordTextField {
    
    
    
    //账号
    UITextField *userTextField = [[UITextField alloc]initWithFrame:CGRectMake(65, 100, kScreenWidth-65, 35)];
    userTextField.placeholder = @"请输入手机号";
    userTextField.textColor = [UIColor lightGrayColor];
    [userTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    userTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:userTextField];
    //加线
    [self addLineToTextField:userTextField];
    
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(45, CGRectGetMinY(userTextField.frame)+9, 17, 17)];
    userImage.image = [UIImage imageNamed:@"user"];
    [self.view addSubview:userImage];
    
    
    
    //密码
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(65, CGRectGetMaxY(userTextField.frame)+10, kScreenWidth-65, 35)];
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.textColor = [UIColor lightGrayColor];
    [passwordTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passwordTextField];
    //加线
    [self addLineToTextField:passwordTextField];
    UIImageView *passwordImage = [[UIImageView alloc]initWithFrame:CGRectMake(45, CGRectGetMinY(passwordTextField.frame)+9, 17, 17)];
    passwordImage.image = [UIImage imageNamed:@"pass"];
    [self.view addSubview:passwordImage];
    
    
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(20, CGRectGetMaxY(passwordTextField.frame)+20, kScreenWidth-40, 35);
    loginBtn.layer.cornerRadius = 5;
    loginBtn.backgroundColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:224/255.0 alpha:.5];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(kScreenWidth - 20 - 110 , CGRectGetMaxY(loginBtn.frame)+10, 50, 17);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    //下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:registerBtn.titleLabel.text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:224/255.0 alpha:1] range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    [registerBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    //找回密码
    UIButton *findPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findPasswordBtn.frame = CGRectMake(kScreenWidth - 20 - 60 , CGRectGetMaxY(loginBtn.frame)+10, 60, 17);
    [findPasswordBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
    findPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:findPasswordBtn];
    [findPasswordBtn addTarget:self action:@selector(findPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:findPasswordBtn.titleLabel.text];
    NSRange strRange1 = {0,[str1 length]};
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:59/255.0 green:175/255.0 blue:224/255.0 alpha:1] range:strRange1];
    [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [findPasswordBtn setAttributedTitle:str1 forState:UIControlStateNormal];
    
}


//给textField加上下边线
- (void)addLineToTextField:(UITextField *)textField {
    
    //加线
    UIView* topLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(textField.frame), kScreenWidth, 1)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    topLine.alpha = .3;
    [self.view addSubview:topLine];
    
    UIView* underLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textField.frame), kScreenWidth, 1)];
    underLine.backgroundColor = [UIColor lightGrayColor];
    underLine.alpha = .3;
    [self.view addSubview:underLine];
    
}


- (void)loginAction {
    //登录
    
}

- (void)registerAction {
    //注册
    
}

- (void)findPasswordAction {
    //找回密码
    
}


@end
