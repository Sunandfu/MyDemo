//
//  TouchViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "TouchViewController.h"

@interface TouchViewController () {
    CGPoint _imageStartPoint; //图片起始位置
    CGPoint _touchStartPoint; //touch起始位置
}

@end



@implementation TouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//开始点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //保存图片的起始位置
    _imageStartPoint = _imageView.center;
    //获取当前的touch
    UITouch *touch = touches.anyObject;
    //获得当前touch的位置
    _touchStartPoint = [touch locationInView:self.view];

    NSLog(@"%@", NSStringFromCGPoint(_touchStartPoint));
}

//移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //得到当前的touch
    UITouch *touch = touches.anyObject;
    //得到当前touch的位置
    CGPoint tempPoint = [touch locationInView:self.view];
    //计算偏移量
    CGFloat x = tempPoint.x - _touchStartPoint.x;
    CGFloat y = tempPoint.y - _touchStartPoint.y;
    //设置图片的center
    _imageView.center = CGPointMake(_imageStartPoint.x + x, _imageStartPoint.y + y);
}


@end
