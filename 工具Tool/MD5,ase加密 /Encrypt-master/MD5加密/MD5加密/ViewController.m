//
//  ViewController.m
//  MD5
//
//  Created by iMac on 16/7/8.
//  Copyright © 2016年 Sinfotek. All rights reserved.
//

/*
 使用注意事项:
 1. 在build phases中的GTMBase64.m需要设置 -fno-objc-arc
 2. 在#import "NSString+Base64.m”文件中导入   #import <Foundation/Foundation.h>
 3.在#import "GTMBase64.m”文件中添加          #import <CommonCrypto/CommonCrypto.h>
 */

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "CusMD5.h"
#import "GTMBase64.h"
#import "AESCrypt.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    UITextField *textF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    textF = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, kScreenWidth-60, 30)];
    textF.borderStyle = UITextBorderStyleRoundedRect;
    textF.placeholder = @"需要加密字符串";
    [self.view addSubview:textF];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 150, kScreenWidth-100, 30);
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"加密与解密" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    for (NSInteger i = 0; i < 5; i++) {
        
        if (i==0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200+35*i, kScreenWidth, 20)];
            label.font = [UIFont systemFontOfSize:13];
            label.tag = i+100;
            [self.view addSubview:label];
        }
        if (i == 1 || i == 2) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 230+35*i, kScreenWidth-10, 20)];
            label.font = [UIFont systemFontOfSize:14];
            label.tag = i+100;
            [self.view addSubview:label];
        }
        if (i == 3 || i == 4) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 260+35*i, kScreenWidth-10, 20)];
            label.font = [UIFont systemFontOfSize:14];
            label.tag = i+100;
            [self.view addSubview:label];
        }
    }
    
    
}

- (void)btnAction {
    //要加密的字符串
    NSString *strForEn = textF.text;
    UILabel *label0 = (UILabel *)[self.view viewWithTag:100];
    UILabel *label1 = (UILabel *)[self.view viewWithTag:101];
    UILabel *label2 = (UILabel *)[self.view viewWithTag:102];
    UILabel *label3 = (UILabel *)[self.view viewWithTag:103];
    UILabel *label4 = (UILabel *)[self.view viewWithTag:104];
    
    if ([textF.text isEqualToString:@""]) {
        return;
    }
    
    
    //md5加密
    NSString *strEnRes = [CusMD5 md5String:strForEn];
    label0.text = [NSString stringWithFormat:@"md5加密：%@",strEnRes];
    
    
    
    
    //base64加密
    NSData *dataEn = [strForEn dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataEnRes = [GTMBase64 encodeData:dataEn];
    //把加密结果转成string
    NSString *base64EnRes = [[NSString alloc] initWithData:dataEnRes encoding:NSUTF8StringEncoding];
    label1.text = [NSString stringWithFormat:@"base64加密：%@",base64EnRes];
    
    //base64解密
    NSData *resDeBase64 = [GTMBase64 decodeData:dataEnRes];
    NSString *strDeBase64 = [[NSString alloc] initWithData:resDeBase64 encoding:NSUTF8StringEncoding];
    label2.text =  [NSString stringWithFormat:@"base64解密：%@",strDeBase64];
    
    
    //aes 加密
    NSString *strAESEnRes = [AESCrypt encrypt:strForEn password:@"secret"];
    label3.text = [NSString stringWithFormat:@"aes加密：%@",strAESEnRes];
    
    //aes 解密
    NSString *strAESDeRes = [AESCrypt decrypt:strAESEnRes password:@"secret"];
    label4.text = [NSString stringWithFormat:@"aes解密：%@",strAESDeRes];
    
}

@end
