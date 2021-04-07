//
//  LBToAppStore.m
//  LBToAppStore
//
//  Created by gold on 16/5/3.
//  Copyright © 2016年 Bison. All rights reserved.
//

#import "LBToAppStore.h"

@implementation LBToAppStore


- (void)showGotoAppStore:(UIViewController *)VC{
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里的天数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger udtheDays = [[userDefaults objectForKey:@"theDays"] integerValue];
    //userDefaults里的版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] floatValue];
    //userDefaults里用户上次的选项
    int udUserChoose = [[userDefaults objectForKey:@"userOptChoose"] intValue];
    //时间戳的天数
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSInteger daySeconds = 24 * 60 * 60;
    NSInteger theDays = interval / daySeconds;
    
    //版本升级之后的处理,全部规则清空,开始弹窗
    if (udAppVersion && appVersion>udAppVersion) {
        [userDefaults removeObjectForKey:@"theDays"];
        [userDefaults removeObjectForKey:@"appVersion"];
        [userDefaults removeObjectForKey:@"userOptChoose"];
        [self alertUserCommentView:VC];
    }
    //1,从来没弹出过的
    //2,用户选择😭残忍拒绝后，7天之后再弹出
    //3,用户选择😭残忍拒绝的30天后，才会弹出
    else if (!udUserChoose ||
             (udUserChoose==1 && theDays-udtheDays>7) ||
             (udUserChoose==3 && theDays-udtheDays>30))
    {
        [self alertUserCommentView:VC];
        
    }

}

- (void)showAlwaysGotoAppStore:(UIViewController *)VC{
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里的天数
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //userDefaults里的版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] floatValue];
    
    //版本升级之后的处理,全部规则清空,开始弹窗
    if (udAppVersion && appVersion>udAppVersion) {
        [userDefaults removeObjectForKey:@"theDays"];
        [userDefaults removeObjectForKey:@"appVersion"];
        [userDefaults removeObjectForKey:@"userOptChoose"];
        [self alertUserCommentView:VC];
    } else {
        [self alertUserCommentView:VC];
    }
}

-(void)alertUserCommentView:(UIViewController *)VC{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //当前时间戳的天数
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    NSInteger theDays = interval / daySeconds;
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] floatValue];
    //userDefaults里版本号
    float udAppVersion = [[userDefaults objectForKey:@"appVersion"] floatValue];
    
    //当前版本比userDefaults里版本号高
    if (appVersion>udAppVersion || ![userDefaults objectForKey:@"appVersion"]) {
        [userDefaults setObject:[NSString stringWithFormat:@"%f",appVersion] forKey:@"appVersion"];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"致书友们的一封信" message:@"如果感觉不错，请给我五星好评哦！有了您的支持才能让作者有动力更新！当然您也可以直接反馈问题给到我！" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"😭残忍拒绝" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"userOptChoose"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)theDays] forKey:@"theDays"];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"😄好评赞赏" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"userOptChoose"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)theDays] forKey:@"theDays"];
        NSString *appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1514732986"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:nil];
        
    }];
    
    UIAlertAction *showAction = [UIAlertAction actionWithTitle:@"😓我要吐槽" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"userOptChoose"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)theDays] forKey:@"theDays"];
        NSString *appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1514732986"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:nil];
    }];
    
    //请允许授权访问您的相册为你挑选你想显示的图片
    [alertController addAction:refuseAction];
    [alertController addAction:okAction];
    [alertController addAction:showAction];
    
    NSLog(@"%@",[userDefaults objectForKey:@"appVersion"]);
    NSLog(@"%@",[userDefaults objectForKey:@"userOptChoose"]);
    NSLog(@"%@",[userDefaults objectForKey:@"theDays"]);
    
    [VC presentViewController:alertController animated:YES completion:nil];
}

@end
