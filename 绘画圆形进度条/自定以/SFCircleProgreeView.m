//
//  SFCircleProgreeView.m
//  scrollerViewDemo
//
//  Created by 史岁富 on 2018/9/7.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "SFCircleProgreeView.h"

@interface SFCircleProgreeView()

@property (nonatomic,strong) UIImageView  *backGroundIMGV;
@property (nonatomic,strong) UIView  *backView;
@property (nonatomic,assign) CGFloat progress;

@end

@implementation SFCircleProgreeView

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    self.backGroundIMGV.backgroundColor = backgroundImage == nil ?
    self.defaultBorderColor : [UIColor clearColor];
    self.backGroundIMGV.image = self.backgroundImage;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth = 10;
        self.defaultBorderColor = [UIColor redColor];
        self.defaultBackColor = [UIColor grayColor];
        self.animationDuration = 0.3;
        self.progress = 0.0;
        self.backGroundIMGV.frame = self.bounds;
        self.isHaveBackProgress = YES;
        self.backView = [[UIView alloc] initWithFrame:self.bounds];
        self.backView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self addSubview:self.backGroundIMGV];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backGroundIMGV.frame = self.bounds;
    [self DrowCirleWithProgress:self.progress Animation:NO];
}
- (void)DrowCirleWithProgress:(CGFloat)theProgress Animation:(BOOL)isAnimation{
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    CGFloat radius = ((self.bounds.size.width < self.bounds.size.height ?
                       self.bounds.size.width : self.bounds.size.height) / 2.0) - (self.borderWidth / 2) - 2;
    CGFloat startA = -M_PI / 2;
    CGFloat endA = -M_PI / 2 + M_PI * 2 * theProgress;
    
    if (self.isHaveBackProgress) {
        CAShapeLayer *backprogressLayer = [[CAShapeLayer alloc] init];
        backprogressLayer.frame = self.bounds;
        backprogressLayer.fillColor = [UIColor clearColor].CGColor;
        backprogressLayer.strokeColor = [UIColor blackColor].CGColor;
        backprogressLayer.opacity = 1.0;
        backprogressLayer.lineCap = kCALineCapRound;
        backprogressLayer.lineWidth = self.borderWidth;
        UIBezierPath *backtoPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        backprogressLayer.path = backtoPath.CGPath;
        self.backView.layer.mask = backprogressLayer;
        self.backView.backgroundColor = self.defaultBackColor;
    }
    
    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    progressLayer.frame = self.bounds;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor blackColor].CGColor;
    progressLayer.opacity = 1.0;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = self.borderWidth;
    UIBezierPath *toPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    if (isAnimation) {
        CGFloat fullEndA = (-M_PI / 2) + M_PI * 2 * 0.999;
        UIBezierPath *fullPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:fullEndA clockwise:YES];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(self.progress);
        animation.toValue = @(theProgress);
        animation.duration = self.animationDuration;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        [progressLayer addAnimation:animation forKey:nil];
        progressLayer.path = fullPath.CGPath;
    } else {
        progressLayer.path = toPath.CGPath;
    }
    self.backGroundIMGV.layer.mask = progressLayer;
    self.progress = theProgress;
}
- (UIImageView *)backGroundIMGV{
    if (!_backGroundIMGV) {
        _backGroundIMGV = [[UIImageView alloc] init];
        _backGroundIMGV.contentMode = UIViewContentModeScaleAspectFill;
        _backGroundIMGV.layer.masksToBounds = YES;
        _backGroundIMGV.backgroundColor = self.defaultBorderColor;
    }
    return _backGroundIMGV;
}
- (void)setIsHaveShadow:(BOOL)isHaveShadow{
    _isHaveShadow = isHaveShadow;
    if (isHaveShadow) {
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.8;
    } else {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0;
    }
}

@end
