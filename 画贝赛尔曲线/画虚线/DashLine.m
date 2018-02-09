//
//  DashLine.m
//  DemoForTest
//
//  Created by 云镶网络科技公司 on 2016/11/29.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "DashLine.h"

@implementation DashLine

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, _color.CGColor);
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 1);
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, width/2.0, 0);
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, width/2.0, height);
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {2,2};
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

@end
