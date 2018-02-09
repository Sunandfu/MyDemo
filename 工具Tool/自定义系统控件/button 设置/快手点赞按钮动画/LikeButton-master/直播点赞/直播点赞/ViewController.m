//
//  ViewController.m
//  直播点赞
//
//  Created by iMac on 16/9/13.
//  Copyright © 2016年 waterLC. All rights reserved.
//

#import "ViewController.h"
#import "LikeButton.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    LikeButton *btn = [[LikeButton alloc]initWithFrame:CGRectMake(kScreenWidth-20-50, kScreenHeight-20-50, 50, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_high"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)likeAction:(LikeButton *)btn {
    NSLog(@"点击了按钮");
    [btn wsShowInView:self.view];
}


@end
