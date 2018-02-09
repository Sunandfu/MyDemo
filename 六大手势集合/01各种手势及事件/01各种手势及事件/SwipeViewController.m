//
//  SwipeViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "SwipeViewController.h"

@interface SwipeViewController ()

@end

@implementation SwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//重写添加手势的方法
- (void)addGesture {
    //添加滑动手势
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swip:)];
    //设置滑动方向
    swip.direction = UISwipeGestureRecognizerDirectionRight;
//    UISwipeGestureRecognizerDirectionRight
//    UISwipeGestureRecognizerDirectionLeft
//    UISwipeGestureRecognizerDirectionUp
//    UISwipeGestureRecognizerDirectionDown
    //添加手势
    [_imageView addGestureRecognizer:swip];
}

#pragma -- mark 滑动
- (void)swip:(UISwipeGestureRecognizer *)swip{
    NSLog(@"--------------------");
}

@end
