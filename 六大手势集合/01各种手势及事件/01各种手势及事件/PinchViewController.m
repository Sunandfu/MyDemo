//
//  PinchViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "PinchViewController.h"

@interface PinchViewController ()

@end

@implementation PinchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//重写添加手势的方法
- (void)addGesture {
    //创建缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    //添加手势
    [_imageView addGestureRecognizer:pinch];
}

#pragma mark -- 缩放
- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    //初始化缩放比例
    static CGFloat scale = 1;
    //缩放结束的时候
    if (pinch.state == UIGestureRecognizerStateEnded) {
        scale *= pinch.scale;
    }
    //缩放的时候
    if (pinch.state == UIGestureRecognizerStateChanged) {
        //设置形变
        _imageView.transform = CGAffineTransformMakeScale(scale *pinch.scale, scale *pinch.scale);
    }
}

@end
