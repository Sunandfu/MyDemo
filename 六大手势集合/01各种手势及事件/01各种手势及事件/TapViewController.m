//
//  TapViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "TapViewController.h"

@interface TapViewController ()

@end

@implementation TapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//重写添加手势的方法
- (void)addGesture {
    //创建一个点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //设置点击次数（点击几次之后才响应）默认是一次
    tap.numberOfTapsRequired = 1;
    //设置几个手指触发(默认是1)
    tap.numberOfTouchesRequired = 1;
    //给imageView添加手势
    [_imageView addGestureRecognizer:tap];
}

#pragma mark --点击
- (void)tap:(UITapGestureRecognizer *)tap {
    //获得触发手势的视图
    NSLog(@"%@", tap.view);
}

@end
