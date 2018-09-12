//
//  VVWaterWaveView.m
//  WaveView
//
//  Created by 卫兵 on 16/8/30.
//  Copyright © 2016年 GeekBean Technology Co., Ltd. All rights reserved.
//

/*
 
 正弦曲线可表示为y=Asin(ωx+φ)+k
 A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
 (ωx+φ)——相位，反映变量y所处的状态。
 φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
 k——偏距，反映在坐标系上则为图像的上移或下移。
 ω——角速度， 控制正弦周期(单位角度内震动的次数)。
 
 */

#import "VVWaterWaveView.h"

@interface VVWaterWaveView () {
    CGFloat _riseFallCountAngle;
    CGFloat _unit;
    BOOL _increase;
    CGFloat _variable;
}

@property (nonatomic, assign) BOOL waveing;

@property (nonatomic, weak) CADisplayLink *waveDisplaylink;

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *waveLayerArray;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *waveLayerPathArray;

@property (nonatomic, assign, readonly) CGFloat unit;
@property (nonatomic, assign, readonly) CGFloat riseFallCountAngle;
/** 第一个点开始的Y位置 */
@property (nonatomic, assign) CGFloat startPointY;
/** 波浪起伏的速度，其实就是滚动的速度， */
@property (nonatomic, assign) CGFloat waveGrowth;
/** 偏移量，实际是waveGrowth一直相加的结果 对应φ值 */
@property (nonatomic, assign) CGFloat offset;

@end

@implementation VVWaterWaveView

#pragma mark - LifeCycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES;
    self.amplitude = 10.0;
    self.percent = 0.5;
    self.waveGrowth = 4.0;
    self.offset = 0.0;
    _variable = 0.0;
}

#pragma mark - DataSource

#pragma mark - Delegate

#pragma mark - Event Method

- (void)animateWave {
    self.offset += self.waveGrowth;
    
    if (_increase) {
        _variable += 0.01;
    } else{
        _variable -= 0.01;
    }
    if (_variable <= 0.0) {
        _increase = YES;
    }
    if (_variable >= 1.0) {
        _increase = NO;
    }
}

#pragma mark - Public Method

- (void)reset {
    [self stopWave];
}

- (void)startWave {
    if (self.waveing == YES) {
        return;
    }
    self.waveing = YES;
    [self waveDisplaylink];
}

- (void)stopWave {
    if (self.waveing == NO) {
        return;
    }
    self.waveing = NO;
    [self.waveDisplaylink invalidate];
    self.waveDisplaylink = nil;
}

#pragma mark - Property Method

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _riseFallCountAngle = 0;
    self.percent = self.percent;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    self.startPointY = self.frame.size.height * (1.0 - self.percent);
}

- (CGFloat)riseFallCountAngle {
    if (_riseFallCountAngle <= 0) {
        // 1.00是波谷数
        _riseFallCountAngle = 1.00 * M_PI / self.frame.size.width;
    }
    return _riseFallCountAngle;
}

- (CGFloat)unit {
    if (_unit <= 0) {
        _unit = M_PI / self.frame.size.width;
    }
    return _unit;
}

- (void)setWaveLayerColorArray:(NSArray<UIColor *> *)waveLayerColorArray {
    _waveLayerColorArray = waveLayerColorArray;
    if (waveLayerColorArray.count >= self.waveLayerArray.count) {
        for (NSInteger index = 0; index < waveLayerColorArray.count; index++) {
            if (index < self.waveLayerArray.count) {
                self.waveLayerArray[index].fillColor = waveLayerColorArray[index].CGColor;
            } {
                CAShapeLayer *waveLayer = [CAShapeLayer layer];
                [self.waveLayerArray addObject:waveLayer];
                [self.layer addSublayer:waveLayer];
                waveLayer.fillColor = waveLayerColorArray[index].CGColor;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [self.waveLayerPathArray addObject:path];
            }
        }
    } else {
        NSInteger layerCount = self.waveLayerArray.count;
        for (NSInteger index = 0; index < layerCount; index++) {
            if (index < waveLayerColorArray.count) {
                self.waveLayerArray[index].fillColor = waveLayerColorArray[index].CGColor;
            } {
                [self.waveLayerArray[index] removeFromSuperlayer];
                [self.waveLayerPathArray removeLastObject];
            }
        }
    }
}

- (NSMutableArray<CAShapeLayer *> *)waveLayerArray {
    if (_waveLayerArray == nil) {
        _waveLayerArray = [NSMutableArray array];
    }
    return _waveLayerArray;
}

- (NSMutableArray<UIBezierPath *> *)waveLayerPathArray {
    if (_waveLayerPathArray == nil) {
        _waveLayerPathArray = [NSMutableArray array];
    }
    return _waveLayerPathArray;
}

- (CADisplayLink *)waveDisplaylink {
    if (_waveDisplaylink == nil) {
        CADisplayLink *waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getLayerPath)];
        _waveDisplaylink = waveDisplaylink;
        [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _waveDisplaylink;
}

#pragma mark - Private Method

-(void)getLayerPath {
    [self animateWave];
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    for (NSInteger layerIndex = 0; layerIndex < self.waveLayerArray.count; layerIndex++) {
        CGFloat amplitude = (self.amplitude + (5 + layerIndex) * _variable);
        UIBezierPath *path = self.waveLayerPathArray[layerIndex];
        [path removeAllPoints];
        CGFloat y = self.startPointY;
        [path moveToPoint:CGPointMake(0, y)];
        for (CGFloat x = 0.0; x <= viewWidth; x++) {
            // 正弦波浪公式
            y = amplitude * sin(x * self.riseFallCountAngle + (self.offset + 200 * layerIndex) * self.unit) + self.startPointY;
            CGPoint currentPoint = CGPointMake(x, y);
            [path addLineToPoint:currentPoint];
        }
        [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
        [path addLineToPoint:CGPointMake(0.0, viewHeight)];
        [path closePath];
        self.waveLayerArray[layerIndex].path = path.CGPath;
    }
}

@end
