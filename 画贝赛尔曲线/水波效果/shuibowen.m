//
//  shuibowen.m
//  wuxiangundongview
//
//  Created by 小富 on 16/5/4.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "shuibowen.h"

@interface shuibowen()

@property (nonatomic ,assign)CGFloat t;

@end

@implementation shuibowen

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //wave
    CGPoint zero = CGPointMake(0, self.bounds.size.height * (1-0.3));
    UIBezierPath *wave = [UIBezierPath bezierPath];
    [wave moveToPoint:zero];
    for (int i = 0; i < self.bounds.size.width; i++) {
        CGPoint p = relativeCoor(zero, i, self.num*sin(M_PI /50 *i + _t ) );
        [wave addLineToPoint:p];
    }
    [wave addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [self.colorName set];
    [wave fill];
}
-(void)didMoveToSuperview{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(change) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)change{
    _t += M_PI * self.beishu;
    if (_t == M_PI * 2) {
        _t = 0;
    }
    [self setNeedsDisplay];
}

CGPoint relativeCoor(CGPoint point, CGFloat x ,CGFloat y){
    return CGPointMake(point.x + x, point.y + y);
}
@end
