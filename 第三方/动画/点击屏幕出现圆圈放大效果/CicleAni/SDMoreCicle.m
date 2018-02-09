//
//  SDMoreCicle.m
//
//  Created by LSD on 15/10/23.
//  Copyright (c) 2015年 Joky. All rights reserved.
//

#import "SDMoreCicle.h"

@implementation SDMoreCicle

+(instancetype)viewWithCicle:(CGRect)rect
{
    return [[self alloc]initWithFrame:rect];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}
-(void)createLayer:(NSSet *)touches
{
    //<1>获取点击屏幕的点的坐标
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //<2>创建层对象
    CALayer *waveLayer = [CALayer layer];
    
    //<3>设置层的显示位置及大小
    waveLayer.frame = CGRectMake(point.x - 1, point.y - 1,5,5);
    
    //<4>设置层的颜色
    waveLayer.borderColor = [UIColor colorWithRed:(arc4random() % 256 / 255.0) green:(arc4random() % 256 / 255.0) blue:(arc4random() % 256 / 255.0) alpha:1.0].CGColor;
    //<5>设置层的边框宽度
    waveLayer.borderWidth = 0.5;
    
    //<6>设置层的圆角效果
    waveLayer.cornerRadius = 2.5;
    
    //<7>圈的动画效果
    [self setAnimation:waveLayer];
    
    //<8>将Layer添加到当前层上
    [self.layer addSublayer:waveLayer];
}
- (void)setAnimation:(CALayer *)layer
{
    const int max =20;
    if (layer.transform.m11 < max)
    {
        [layer setTransform:CATransform3DScale(layer.transform, 1.1, 1.1, 1.0)];
        //_cmd 获取当前方法的名字
        [self performSelector:_cmd withObject:layer afterDelay:0.03];
    }
    else
    {
        [layer removeFromSuperlayer];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self createLayer:touches];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self createLayer:touches];
}


@end
