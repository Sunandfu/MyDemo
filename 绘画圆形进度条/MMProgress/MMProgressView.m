//
//  MMProgressView.m
//  MMprogressView
//
//  Created by imac on 16/4/25.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "MMProgressView.h"

@interface MMProgressView()
@property(nonatomic,strong)CAShapeLayer*trackLayer;
@property(nonatomic,strong)UIBezierPath*trackPath;

@property(nonatomic,strong)CAShapeLayer*progressLayer;
@property(nonatomic,strong)UIBezierPath*progressPath;

@property(nonatomic,assign)CGFloat trackLayerWidth;
@property(nonatomic,assign)CGFloat progressLayerWidth;

@property(nonatomic,strong)CAGradientLayer*gradientLayer;

@end
@implementation MMProgressView

+ (instancetype )progressViewWithFrame:(CGRect )frame percent:(CGFloat )percent{
    MMProgressView *progress = [[self alloc]initWithFrame:frame];
    progress.percent = percent;
    return progress;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.trackLayer = [CAShapeLayer new];
        self.trackLayer.fillColor = nil;
        self.trackLayer.lineCap = kCALineCapRound;
        self.trackLayer.strokeColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:self.trackLayer];

        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];
        _gradientLayer.locations = @[@(0.0f),@(0.3f),@(0.6f),@(1.0f)];
        _gradientLayer.startPoint   = CGPointMake(0.0f, 0.0f);
        _gradientLayer.endPoint     = CGPointMake(1.0f, 1.0f);
        _gradientLayer.frame        = self.bounds;
//        [_gradientLayer setMask:_trackLayer];
//        [self.layer addSublayer:_gradientLayer];
        
        self.progressLayer = [CAShapeLayer new];
        self.progressLayer.fillColor = nil;
        self.progressLayer.strokeColor =[UIColor whiteColor].CGColor;
        self.progressLayer.lineCap = kCALineCapButt;
        [self.layer addSublayer:self.progressLayer];
        
        _progressWidth = 5;
        _trackLayerWidth = _progressWidth -1;
        _progressLayerWidth = _progressWidth + 1;
        

    }
    return self;
}

- (void)setTrack{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x-self.frame.origin.x,self.center.y-self.frame.origin.y) radius:(self.bounds.size.width - _trackLayerWidth)*0.5 startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    self.trackLayer.path = _trackPath.CGPath;
    self.trackLayer.lineWidth = _trackLayerWidth;
}

- (void)setProgress{
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x-self.frame.origin.x,self.center.y-self.frame.origin.y) radius:(self.bounds.size.width - _progressLayerWidth + (_progressLayerWidth - _trackLayerWidth))*0.5 startAngle:-M_PI_2 endAngle:2*M_PI*_percent-M_PI_2 clockwise:YES];
    self.progressLayer.path = _progressPath.CGPath;
    self.progressLayer.lineWidth = _progressLayerWidth;

}

-(void)setTrackColor:(UIColor *)trackColor{
    self.trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor{
    self.progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgressWidth:(CGFloat)progressWidth{
    _trackLayerWidth = progressWidth - 1;
    _progressLayerWidth = progressWidth + 1;
}

-(void)setPercent:(CGFloat)percent{
    _percent = percent;
    [self setProgress];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setTrack];
    [self setProgress];
}



@end
