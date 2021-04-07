//
//  SFLocalAuthViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/22.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFLocalAuthViewController.h"
#import "AppDelegate.h"
#import "YZAuthID.h"

@interface SFLocalAuthViewController ()

@end

@implementation SFLocalAuthViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startAuth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+80, self.view.bounds.size.width-60, 20)];
    titleLabel.font = [UIFont systemFontOfSize:22.0];
    titleLabel.textColor = [SFTool colorWithHexString:@"333333"];
    titleLabel.text = @"请验证身份以正常使用";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-50, CGRectGetMaxY(titleLabel.frame)+50, 100, 100)];
    UIImage *image = [UIImage imageNamed:[SFSafeAreaInsets shareInstance].safeAreaInsets.top>20?@"auth_face":@"auth_finger"];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UIButton *authButton = [[UIButton alloc] initWithFrame:CGRectMake(50, self.view.bounds.size.height/2.0+60, self.view.bounds.size.width-100, 50)];
    [authButton setTitle:@"开始验证" forState:UIControlStateNormal];
    authButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    authButton.backgroundColor = [UIColor orangeColor];
    authButton.layer.cornerRadius = 6;
    [authButton addTarget:self action:@selector(startAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authButton];
}

- (void)startAuth
{
    YZAuthID *authID = [YZAuthID sharedInstance];
    
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            [SVProgressHUD showErrorWithStatus:@"对不起，当前设备不支持指纹/面容ID"];
        } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
//            [SVProgressHUD showErrorWithStatus:@"指纹/面容ID不正确，认证失败"];
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            [SVProgressHUD showErrorWithStatus:@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码"];
        } else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            [self enter];
        }
        
    }];
    
    
}

- (void)enter
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:@"LastAuthTimeKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:0.4 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.authVc = nil;
    }];
}

@end
