//
//  AuthcodeView.h
//  423
//
//  Created by 小富 on 16/3/29.
//  Copyright © 2016年 yunxiang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

@end
/*
 #pragma mark 输入框代理，点击return 按钮
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
     //判断输入的是否为验证图片中显示的验证码
     if ([[_input.text uppercaseString] isEqualToString:[authCodeView.authCodeStr uppercaseString]])
         {
             //正确弹出警告款提示正确
             UIAlertController *alview = [UIAlertController alertControllerWithTitle:@"恭喜您 ^o^" message:@"验证成功" preferredStyle:UIAlertControllerStyleAlert];
             //iOS9.0之后新增功能
             [alview addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             //清空输入框内容，收回键盘
             _input.text = @"";
             [_input resignFirstResponder];
             }]];
             [self presentViewController:alview animated:YES completion:nil];
         } else {
             //验证不匹配，验证码和输入框抖动
             CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
             anim.repeatCount = 3;
             anim.values = @[@-20,@20,@-20];
             [anim setDuration:0.1];
             [_input.layer addAnimation:anim forKey:nil];
             //手机震动效果 调用系统 <AudioToolbox/AudioToolbox.h>
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     }
 
 return YES;
 }
 */