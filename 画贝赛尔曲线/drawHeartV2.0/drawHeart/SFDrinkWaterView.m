//
//  heartView.m
//  drawHeart
//
//  Created by 阿城 on 15/10/8.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "SFDrinkWaterView.h"

@interface SFDrinkWaterView ()

@property (nonatomic ,assign)CGFloat t;

@end

@implementation SFDrinkWaterView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width * 2/3, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width * 1/3, self.bounds.size.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    [path addClip];
    [path setLineWidth:2];
    [path setLineCapStyle:kCGLineCapRound];

    [path stroke];
    
    //wave
    CGPoint zero = CGPointMake(0, self.bounds.size.height * (1.1-_value));
    UIBezierPath *wave = [UIBezierPath bezierPath];
    [wave moveToPoint:zero];
    for (int i = 0; i < self.bounds.size.width; i++) {
        CGPoint p = SFRelativeCoor(zero, i, 5*sin(M_PI /50 *i + _t ) );
        [wave addLineToPoint:p];
    }
    [wave addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [[UIColor redColor]set];
    [wave fill];
    
}

-(void)didMoveToSuperview{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(change) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)change{
    _t += M_PI * 0.04;
    if (_t == M_PI * 2) {
        _t = 0;
    }
    [self setNeedsDisplay];
}

CGPoint SFRelativeCoor(CGPoint point, CGFloat x ,CGFloat y){
    return CGPointMake(point.x + x, point.y + y);
}

@end
