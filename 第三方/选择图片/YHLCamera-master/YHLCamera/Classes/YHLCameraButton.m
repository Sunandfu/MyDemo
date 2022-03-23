//
//  YHLCameraButton.m
//  YHLCamera_Example
//
//  Created by che on 2018/7/5.
//  Copyright © 2018年 272789124@qq.com. All rights reserved.
//

#import "YHLCameraButton.h"

@implementation YHLCameraButton

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 4, 42, 42)];
    path.lineWidth=3;
    [[UIColor blackColor] set];
    [path stroke];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    path.lineWidth=5;
    [[UIColor lightGrayColor] set];
    [path stroke];
    
}

@end
