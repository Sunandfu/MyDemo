//
//  PasswordAlertView.h
//  MobileClient
//
//  Created by Luoxusheng-imac on 16/6/22.
//  Copyright © 2016年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordAlertView : UIView

@property(nonatomic,copy)void (^passWordText)(NSString *text);
@property(nonatomic,copy)void (^passWordTextConfirm)(NSString *text);
@property (nonatomic,strong) UITextField *inputTextField;//密码输入框

//***********密码框1*****************//
-(instancetype)initPasswordView;//初始化 密码弹窗

-(void)passwordShow;//显示


//***********密码框2*****************//

-(instancetype)initSingleBtnView;//单选按钮密码框

-(void)show;



@end
