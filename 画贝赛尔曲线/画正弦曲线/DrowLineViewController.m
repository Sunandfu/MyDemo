//
//  DrowLineViewController.m
//  423
//
//  Created by 小富 on 16/3/28.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "DrowLineViewController.h"

@interface DrowLineViewController ()

@end

@implementation DrowLineViewController

+ (instancetype)sharedDrowLine{
    static DrowLineViewController *drow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        drow = [[self alloc] init];
    });
    return drow;
}
//根据一个矩形画曲线
- (void)drowRectangle{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 70, 50, 50)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor blueColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
//根据矩形框的内切圆画曲线
- (void)drowNeiqieyuan{
    CGRect rect = CGRectMake(250, 70, 50, 50);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
//根据矩形画带圆角的曲线
- (void)drowYuanjiaojuxing{
    CGRect rect = CGRectMake(170, 70, 50, 50);
    CGFloat ra = 5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:ra];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor cyanColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
//在矩形中，可以针对四角中的某个角加圆角
/**
 corners:枚举值，可以选择某个角
 UIRectCornerTopLeft      左上
 UIRectCornerTopRight     右上
 UIRectCornerBottomLeft   左下
 UIRectCornerBottomRight  右下
 */
- (void)drowMouyigejiao{
    CGRect rect = CGRectMake(20, 250, 80, 50);
    //选择那几个角 是圆角， 没有选择的那么就是 直角
    //UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft|UIRectCornerBottomRight
    UIRectCorner rectcorner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft;
    //圆角大小
    CGSize radii = CGSizeMake(5, 5);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectcorner cornerRadii:radii];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
//以某个中心点画弧线
/*
 center:弧线中心点的坐标
 
 radius:弧线所在圆的半径
 
 startAngle:弧线开始的角度值
 
 endAngle:弧线结束的角度值
 
 clockwise:是否顺时针画弧线
 + (UIBezierPath*)bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
 */
- (void)drowHuxian{
    CGPoint piont = CGPointMake(120, 90);
    CGFloat ra = 20.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:piont radius:ra startAngle:0 endAngle:22 * M_PI  clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor purpleColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
//画二元曲线，一般和moveToPoint配合使用

/*
参数：
endPoint:曲线的终点
controlPoint:画曲线的基准点
-(void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint
*/
- (void)drowEryuanquxian{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //开始 点
    CGPoint beginPoint = CGPointMake(20, 150);
    //控制点 这点 控制 曲线的 曲度 形状
    CGPoint controlPoint = CGPointMake(60, 100);
    //结束点
    [path moveToPoint:CGPointMake(100, 150)];
    
    [path addQuadCurveToPoint:beginPoint controlPoint:controlPoint];
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor purpleColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
//以三个点画一段曲线，一般和moveToPoint配合使用
/*
参数：

endPoint:曲线的终点

controlPoint1:画曲线的第一个基准点

controlPoint2:画曲线的第二个基准点
-(void)addCurveToPoint:(CGPoint)endPoin tcontrolPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
*/
- (void)drowSanyuanquxian{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //开始 点
    CGPoint beginPoint = CGPointMake(150, 150);
    //控制点 这点 控制 曲线的 曲度 形状
    CGPoint controlPoint = CGPointMake(180, 100);
    CGPoint controlPoint2 = CGPointMake(263, 200);
    //结束点
    [path moveToPoint:CGPointMake(300, 150)];
    
    [path addCurveToPoint:beginPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}




@end
