//
//  LongPressViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "LongPressViewController.h"

@interface LongPressViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LongPressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//重写添加视图的方法
- (void)addGesture {
    //创建长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //设置时长
    longPress.minimumPressDuration = 2;

    longPress.delegate = self;
    //给imageView添加手势
    [_imageView addGestureRecognizer:longPress];
}

#pragma mark --长按
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    NSLog(@"-----------");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
