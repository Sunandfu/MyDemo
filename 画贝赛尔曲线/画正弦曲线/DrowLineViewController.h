//
//  DrowLineViewController.h
//  423
//
//  Created by 小富 on 16/3/28.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrowLineViewController : UIViewController

+ (instancetype) sharedDrowLine;
/**********在.m文件中看画线示例代码＊＊＊＊＊＊＊＊
 
 正弦曲线示例代码
 设置全局变量{
 NSTimer *_timer;
 int xCV;
 CAShapeLayer *shapeLayer;
 }
 
 //初始化定时器
 - (void)viewDidLoad {
 [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
 _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
 
 }
 //画正弦曲线
 - (void)timeRun{
 [shapeLayer removeFromSuperlayer];
 xCV++;
 if (xCV == 100) {
     xCV = 0;
 }
 UIBezierPath *path = [UIBezierPath bezierPath];
 for (int i=0; i<5; i++) {
     int j = i*100 - xCV;
     //开始点
     [path moveToPoint:CGPointMake(j, 200)];
     //结束 点
     CGPoint beginPoint = CGPointMake(j+100, 200);
     //控制点 这点 控制 曲线的 曲度 形状
     CGPoint controlPoint = CGPointMake(j+40, 100);
     CGPoint controlPoint2 = CGPointMake(j+60, 300);
     
     [path addCurveToPoint:beginPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
 }
 
 shapeLayer = [CAShapeLayer layer];
 shapeLayer.strokeColor = [UIColor blueColor].CGColor;
 shapeLayer.fillColor = [UIColor clearColor].CGColor;
 shapeLayer.path = path.CGPath;
 [self.view.layer addSublayer:shapeLayer];
 }
 */

@end
