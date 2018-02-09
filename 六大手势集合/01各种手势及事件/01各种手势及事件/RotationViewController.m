//
//  RotationViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "RotationViewController.h"

@interface RotationViewController ()

@end

@implementation RotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//重写添加手势的方法
- (void)addGesture {
    //创建旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];

    //添加手势
    [_imageView addGestureRecognizer:rotation];
}

#pragma mark --旋转
- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    //初始化旋转量
    static CGFloat rotationCount;
    //当旋转结束的时候，修改旋转量
    if (rotation.state == UIGestureRecognizerStateEnded) {
        rotationCount += rotation.rotation;
    }
    //当正在旋转的时候(值改变的时候)
    if (rotation.state == UIGestureRecognizerStateChanged) {
        //设置旋转形变
        _imageView.transform = CGAffineTransformMakeRotation(rotation.rotation + rotationCount);
    }

}

@end
