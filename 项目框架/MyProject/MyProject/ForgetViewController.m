//
//  ForgetViewController.m
//  CYloginSystem
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
{
    UIButton *imageButton;
    UIButton *hideButton;
    UIButton *submitButton;
    UIButton *undoButton;
    NSInteger _s,_ss;
    NSInteger a;
    int p;
    int setTime;
}
@property(nonatomic,strong)UILabel *timeLabel;
//计时器用来刷新时间
@property(nonatomic,strong)NSTimer *runTimer;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [self creatTimer];
    p = 2;
    if (self.sumTime) {
        setTime = [self.sumTime intValue];
    } else {
        setTime = 30;
    }
    [super viewDidLoad];
    NSInteger width = (self.view.bounds.size.width)/4;
    NSInteger height = self.view.bounds.size.height;
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width*1.25-30, height-114, width+120, 50)];
    
    self.timeLabel.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.timeLabel];
    
    // Do any additional setup after loading the view.
    [self playGame];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playGame{
    // 1. 先将原来的v移除
    UIView *view = [self.view viewWithTag:987];
    [view removeFromSuperview];
    a++;
    if (a %5 == 0) {
        p ++;
    }
    NSInteger height=kScreenHeight/p;
    NSInteger width=kScreenWidth/p;
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height*p-100)];
    v.tag = 987;
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    v.backgroundColor = [UIColor whiteColor];
    
    int s = arc4random()%(p*p);
    CGFloat hue = ( arc4random() % 128 / 256.0 )+0.5;
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    for (int i = 0; i < p*p; i++) {
        imageButton = [[UIButton alloc]initWithFrame:CGRectMake(width*(i/p+0.025), ((height*0.83) *(i%p)), width*0.95, height*0.8)];
        if (i == s ) {
            imageButton.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:(0.5+0.01*a)];
            [imageButton addTarget:self action:@selector(playGame) forControlEvents:UIControlEventTouchDown];
        }else{ 
            imageButton.backgroundColor = [ UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        }
        [v addSubview:imageButton];
    }
    [self.view addSubview:v];
}

- (void)creatTimer{
    [self.runTimer setFireDate:[NSDate distantPast]];
    self.runTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    

//    [self.runTimer setFireDate:[NSDate distantFuture]];
}

- (void)timerAction{
        if (++_s>=setTime) {
            _s=0;
            NSString *str = [NSString stringWithFormat:@"您一共找出来了%ld张图片",a-1];
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"恭喜" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            p = 2;
            [aler show];
            [self.runTimer setFireDate:[NSDate distantFuture]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    self.timeLabel.text=[NSString stringWithFormat:@"剩余时间%02zd",setTime-_s];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)clickOnButton:(UIButton *)imageButton{
    
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.runTimer invalidate];
}


@end
