//
//  PanViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PanViewController.h"

@interface PanViewController ()

@end

@implementation PanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//重写添加手势的方法
- (void)addGesture {
    //创建移动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //添加手势
    [_imageView addGestureRecognizer:pan];
}

#pragma mark --移动
- (void)pan:(UIPanGestureRecognizer *)pan {
    //起始位置
    static CGPoint startPiont;
    //当刚开始移动的时候
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPiont = _imageView.center;
    }
    //计算偏移量
    CGPoint tempPoint = [pan translationInView:self.view];
    //设置图片的位置
    _imageView.center = CGPointMake(startPiont.x + tempPoint.x, startPiont.y + tempPoint.y);
}


@end
