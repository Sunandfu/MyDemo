//
//  TouchWindow.m
//  TouchIDDemo
//
//  Created by Ben on 16/3/11.
//  Copyright © 2016年 https://github.com/CoderBBen/YBTouchID.git. All rights reserved.
//

#import "TouchWindow.h"
#import <LocalAuthentication/LAContext.h>
#import "ViewController.h"

@interface TouchWindow ()

@property (nonatomic, strong) UIAlertAction *confirmAction;
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) LAContext *context;

@end

@implementation TouchWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [ViewController new];
    }
    
    return self;
}

- (void)show
{
    [self makeKeyAndVisible];
    self.hidden = NO;
    [self alertEvaluatePolicyWithTouchID];
}

- (void)dismiss
{
    [self resignKeyWindow];
    self.hidden = YES;
}

//successed,show animation
- (void)imageViewShowAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.rootViewController.view.alpha = 0;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:^(BOOL finished) {
            [self.rootViewController.view removeFromSuperview];
            [self dismiss];
        }];
    });
}

- (void)alertEvaluatePolicyWithTouchID
{
    [_alert dismissViewControllerAnimated:YES completion:nil];
    self.rootViewController = [ViewController new];
    _context = [LAContext new];
    NSError *error;
    //Whether the device support touch ID? ---if it's yes,support!Otherwise,the system version is lower than iOS8.
    if([_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        
        NSLog(@"Yeah,Support touch ID");
        
        //if return yes,whether your fingerprint correct.
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Please verif the existing fingerprint,enter the app" reply:^(BOOL success, NSError * _Nullable error) {
            if (success)
            {
                [self imageViewShowAnimation];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertViewWithEnterPassword:YES];
                });
                
                NSLog(@"fail");
            }
        }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertViewWithEnterPassword:YES];
        });
        
        NSLog(@"Sorry,The device doesn't support touch ID");
    }
    
}

//if it is not support touch ID,then input password
- (void)alertViewWithEnterPassword:(BOOL)isTrue
{
    if (isTrue)
    {
        _alert = [UIAlertController alertControllerWithTitle:@"ENTER THE PASSWORD" message:@"Please enter the password again" preferredStyle:UIAlertControllerStyleAlert];
    }
    else
    {
        _alert = [UIAlertController alertControllerWithTitle:@"PASSWORD FAIL" message:@"Please enter the password again" preferredStyle:UIAlertControllerStyleAlert];
    }
    
    
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"Back Touch" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_alert.textFields.firstObject];
        
        [self alertEvaluatePolicyWithTouchID];

    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_alert.textFields.firstObject];
        if ([_alert.textFields.firstObject.text isEqualToString:kUSERPASSWORD])
        {
            [self imageViewShowAnimation];
        }
        else
        {
            [self alertViewWithEnterPassword:NO];
        }
    }];
    
    confirmAction.enabled = NO;
    self.confirmAction = confirmAction;
    __weak typeof(self)weakSelf = self;
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(alertTextFieldChangeTextNotificationHandler:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [_alert addAction:backAction];
    [_alert addAction:confirmAction];
    
    [self.rootViewController presentViewController:_alert animated:YES completion:nil];
}

- (void)alertTextFieldChangeTextNotificationHandler:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    self.confirmAction.enabled = textField.text.length >= 4;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
