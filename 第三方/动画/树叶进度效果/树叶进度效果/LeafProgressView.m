//
//  LeafProgressView.m
//  树叶进度效果
//
//  Created by PengXiaodong on 16/1/27.
//  Copyright © 2016年 Tomy. All rights reserved.
//

#import "LeafProgressView.h"

@interface LeafProgressView ()
@property (nonatomic, strong) UIImageView *flowerView;
@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) UIImageView *progressBGImageView;
@property (nonatomic, strong) UILabel *textLabel;
@end
@implementation LeafProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //创建背景
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, frame.size.width, frame.size.height)];
        bgImageView.image = [[UIImage imageNamed:@"bg"] stretchableImageWithLeftCapWidth:124/2.0 topCapHeight:35/2.0];
        [self addSubview:bgImageView];
        
        self.flowerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 32, 2, 30, 30)];
        _flowerView.image = [[UIImage imageNamed:@"flower"] stretchableImageWithLeftCapWidth:126/2.0 topCapHeight:119.0/2.0];
        self.flowerView.backgroundColor = [UIColor orangeColor];
        self.flowerView.layer.cornerRadius = 15;
        [self addSubview:_flowerView];
        
        self.progressBGImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 6.0, frame.size.width - 8 - 30, 24)];
        _progressBGImageView.contentMode = UIViewContentModeLeft;
        _progressBGImageView.backgroundColor = [UIColor clearColor];
        _progressBGImageView.clipsToBounds = YES;
        [self addSubview:_progressBGImageView];
        
        self.progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 6.0, 0, 24)];
        _progressImageView.image = [[UIImage imageNamed:@"progress"] stretchableImageWithLeftCapWidth:86/2.0 topCapHeight:24/2.0];
        _progressImageView.contentMode = UIViewContentModeLeft;
        _progressImageView.clipsToBounds = YES;
        [self addSubview:_progressImageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:_flowerView.frame];
        _textLabel.text = @"100\%";
        _textLabel.textColor = [UIColor orangeColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:11];
        _textLabel.hidden = YES;
        [self addSubview:_textLabel];
    }
    return self;
}


- (void)startLoading{
    //花瓣转动
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotateAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotateAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(_flowerView.layer.transform, M_PI, 0, 0, 1)];
    rotateAnimation.cumulative = YES;
    rotateAnimation.duration = 0.5;
    rotateAnimation.repeatCount = MAXFLOAT;
    
    [self.flowerView.layer addAnimation:rotateAnimation forKey:@"flowerAnimation"];
}

- (void)stopLoading{
    [_flowerView.layer removeAllAnimations];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0;
    scaleAnimation.duration = 0.5;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [self.flowerView.layer addAnimation:scaleAnimation forKey:nil];
    
    _textLabel.hidden = NO;
    scaleAnimation.fromValue = @0;
    scaleAnimation.toValue = @1;
    [_textLabel.layer addAnimation:scaleAnimation forKey:nil];
}

- (void)setProgress:(CGFloat)rate{
    //树叶效果
    CALayer *leafLayer = [CALayer layer];
    leafLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"leaf"].CGImage);
    leafLayer.bounds = CGRectMake(0, 0, 10, 10);
    leafLayer.position = CGPointMake(_progressBGImageView.frame.origin.x + _progressBGImageView.frame.size.width, 8);
    [self.progressBGImageView.layer addSublayer:leafLayer];
    
    //开始树叶的动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *p1 = [NSValue valueWithCGPoint:leafLayer.position];
    NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(_progressBGImageView.frame.origin.x + _progressBGImageView.frame.size.width*3/4.0 + arc4random()%(int)(_progressBGImageView.frame.size.width/4.0), _progressBGImageView.frame.origin.y + arc4random()%(int)_progressBGImageView.frame.size.height)];
    NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(_progressBGImageView.frame.origin.x + _progressBGImageView.frame.size.width/2.0 + arc4random()%(int)(_progressBGImageView.frame.size.width/4.0), _progressBGImageView.frame.origin.y + arc4random()%(int)_progressBGImageView.frame.size.height)];
    NSValue *p4 = [NSValue valueWithCGPoint:CGPointMake(_progressBGImageView.frame.origin.x + _progressBGImageView.frame.size.width/4.0 + arc4random()%(int)(_progressBGImageView.frame.size.width/4.0), _progressBGImageView.frame.origin.y + arc4random()%(int)_progressBGImageView.frame.size.height)];
    NSValue *p5 = [NSValue valueWithCGPoint:CGPointMake(_progressBGImageView.frame.origin.x+5, _progressBGImageView.frame.origin.y + arc4random()%(int)_progressBGImageView.frame.size.height)];
    keyAnimation.values = @[p1, p2, p3, p4, p5];
    
    CABasicAnimation *roateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    roateAnimation.fromValue = @0;
    roateAnimation.toValue = @(M_PI/18.0 * (arc4random()%(36*6) ));
    
    CAAnimationGroup  *group = [CAAnimationGroup animation];
    group.animations = @[roateAnimation, keyAnimation];
    group.duration = 3;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [group setValue:leafLayer forKey:@"leafLayer"];
    
    [leafLayer addAnimation:group forKey:nil];
    
    self.progressImageView.frame = CGRectMake(_progressImageView.frame.origin.x, _progressImageView.frame.origin.y, _progressBGImageView.frame.size.width * rate, _progressImageView.frame.size.height);
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CALayer *layer = [anim valueForKey:@"leafLayer"];
    [layer removeFromSuperlayer];
}
@end















