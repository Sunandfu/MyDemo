//
//  ViewController.m
//  JCKeyBoard
//
//  Created by QB on 16/4/26.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "ViewController.h"

#import "JCKeyBoardNum.h"
#import "UITextField+JCTextField.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) JCKeyBoardNum *NumKeyBoard;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 300, 50)];
    self.textField.delegate = self;
    self.textField.placeholder = @"请输入内容。。。";
    self.textField.clearsOnBeginEditing = YES;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
//    self.textField.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.textField];
    
    
}


#pragma mark====== UITextFieldDelegate 代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSLog(@"将要开始编辑了");
    
    self.NumKeyBoard = [JCKeyBoardNum allocNew];
    self.NumKeyBoard.normolNumber = YES;
    [self.NumKeyBoard show];
    textField.inputView = self.NumKeyBoard;
    __weak typeof(self) weakSelf = self;
    //点击键盘
    self.NumKeyBoard.completeBlock = ^(NSString *text,NSInteger tag) {
        
        switch (tag) {
            case 9:
                //点击完成按钮
                [weakSelf.NumKeyBoard dismiss];
                break;
            case 11:
                //点击删除按钮
                [weakSelf clickDeleteBtn];
                break;
            default:
                //点击数字键盘
                [weakSelf.textField changTextWithNSString:text];
                break;
        }
         
       
    };
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"开始编辑了");
}

- (void)clickDeleteBtn
{
    if (self.textField.text.length > 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.NumKeyBoard dismiss];
}


@end
