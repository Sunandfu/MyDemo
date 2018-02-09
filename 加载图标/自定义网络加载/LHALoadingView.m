//
//  LHALoadingView.m
//  LHALoadingVC
//
//  Created by LiuHao on 16/5/3.
//  Copyright © 2016年 littleye. All rights reserved.
//

#import "LHALoadingView.h"
#import "ATLabel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation LHALoadingView{
    ATLabel *_atlable;
    UIView *_superView;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadingAnimation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadingAnimation];
    }
    return self;
}

- (void)loadingAnimation {
    _superView = [[UIView alloc] init];
    _superView.frame = CGRectMake(kScreenWidth/2 - (kScreenWidth*0.2), kScreenHeight/2 - (kScreenHeight/10), kScreenWidth*0.4, kScreenHeight/5);
//    _superView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
//    _superView.backgroundColor = [UIColor greenColor];
    [self addSubview:_superView];
    
    UIView *loadingView=[[UIView alloc] initWithFrame:CGRectMake(_superView.frame.size.width/2 - (_superView.frame.size.width*0.15), _superView.frame.size.height/2 - (_superView.frame.size.height*0.16), _superView.frame.size.width*0.3, _superView.frame.size.height*0.3 )];
    [_superView addSubview:loadingView];
//    view.backgroundColor = [UIColor grayColor];
    
    UIBezierPath *beizPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2) radius:loadingView.frame.size.height*0.7 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    CAShapeLayer *layer=[CAShapeLayer layer];
    layer.path = beizPath.CGPath;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.strokeColor=[UIColor redColor].CGColor;
    layer.lineWidth = 3.0f;
    layer.lineCap = kCALineCapRound;
    [loadingView.layer addSublayer:layer];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI*2);
    animation.duration = 0.5;
    animation.repeatCount = HUGE;
    animation.fillMode=kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [loadingView.layer addAnimation:animation forKey:@"animation"];
    
    _atlable = [[ATLabel alloc] initWithFrame:CGRectMake(10, _superView.frame.size.height - 20, _superView.frame.size.width - 10, _superView.frame.size.height*0.1)];
    _atlable.textColor = [UIColor blackColor];
    _atlable.adjustsFontSizeToFitWidth = YES;
//    _atlable.backgroundColor = [UIColor yellowColor];
//    _atlable.font = [UIFont systemFontOfSize:20];
//    _atlable.textAlignment = NSTextAlignmentCenter;
    [_atlable animateWithWords:@[@"正在加载中",@"正在加载中.",@"正在加载中. .",@"正在加载中. . ."]forDuration:0.3];
    [_superView addSubview:_atlable];
    
    
    
}

-(void)animationDidStart:(CAAnimation *)anim {
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}


@end
