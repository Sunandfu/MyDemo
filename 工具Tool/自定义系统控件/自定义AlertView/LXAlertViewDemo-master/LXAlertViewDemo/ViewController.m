//
//  ViewController.m
//  LXAlertViewDemo
//
//  Created by 刘鑫 on 16/4/15.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#import "ViewController.h"
#import "LXAlertView.h"

@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)myAlertClick:(id)sender {
   
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"自定义alertview,可以自动适应文字内容。" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击index====%ld",clickIndex);
    }];
    //alert.dontDissmiss=YES;
    //设置动画类型(默认是缩放)
    //_alert.animationStyle=LXASAnimationTopShake;
    [alert showLXAlertView];
    
}
- (IBAction)animation2:(id)sender {
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"自定义alertview,可以自动适应文字内容。" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击index====%ld",clickIndex);
    }];
    alert.animationStyle=LXASAnimationTopShake;
    [alert showLXAlertView];
}
- (IBAction)animation3:(id)sender {
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"自定义alertview,可以自动适应文字内容。" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"点击index====%ld",clickIndex);
    }];
    alert.animationStyle=LXASAnimationLeftShake;
    [alert showLXAlertView];
}

- (IBAction)systemAlertClick:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"系统的alert" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    /*
     //iOS 9.0 以后用这个
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统的alert" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"系统alert==取消");
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"系统alert==确定");
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
     */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"系统alert==%ld",buttonIndex);
}


@end
