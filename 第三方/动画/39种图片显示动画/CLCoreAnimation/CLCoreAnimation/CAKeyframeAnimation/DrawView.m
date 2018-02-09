//
//  DrawView.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()

@property(nonatomic,strong)UIBezierPath *path;



@end

@implementation DrawView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    
    CGPoint cup =[touch locationInView: self];
    
    UIBezierPath *path =[UIBezierPath bezierPath];
    
    _path =path;
    
    [_path moveToPoint:cup];
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    
    CGPoint cup = [touch locationInView:self];
    
    [_path addLineToPoint:cup];
    
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CAKeyframeAnimation *anim =[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    anim.delegate =self;
    
    anim.path =_path.CGPath;
    
    anim.duration = 2.0;
    
    anim.repeatCount = 1;
    
    [[[self.subviews firstObject]layer] addAnimation:anim forKey:nil];
    
}
/**
 动画代理
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)fla
{
    
    if (fla ==YES) {
        [_path  removeAllPoints];
    }
    NSLog(@"动画完成");
}

- (void)drawRect:(CGRect)rect {

    [_path stroke];
}

@end
