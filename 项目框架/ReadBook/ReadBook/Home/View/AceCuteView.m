//
//  AceCuteView.m
//  LayerDemo1
//
//  Created by AceWei on 16/3/9.
//  Copyright © 2016年 AceWei. All rights reserved.
//

#import "AceCuteView.h"

@interface AceCuteView (){
    
    CGFloat r1; // backView
    CGFloat r2; // frontView
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
}


@property UIView *backView;
@property UIView *frontView;
@property UILabel *label;
@property CAShapeLayer *BezierLayer;

@end

@implementation AceCuteView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self addGesture];
        _BezierLayer = [CAShapeLayer layer];
        _BezierLayer.lineWidth = 1;
        _BezierLayer.fillColor = _bgColor.CGColor;
        [self.layer insertSublayer:_BezierLayer atIndex:0];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
        [self addGesture];
        _BezierLayer = [CAShapeLayer layer];
        _BezierLayer.lineWidth = 1;
        _BezierLayer.fillColor = _bgColor.CGColor;
        [self.layer insertSublayer:_BezierLayer atIndex:0];
    }
    return self;
}


-(void)setUp
{
    _bgColor = [UIColor redColor];
    CGFloat DefaultSize = CGRectGetHeight(self.frame);
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DefaultSize, DefaultSize)];
    _backView.backgroundColor = self.bgColor;
    _backView.layer.cornerRadius = CGRectGetHeight(_backView.frame)/2;
    _backView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:_backView];
    
    
    _frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), DefaultSize)];
    _frontView.backgroundColor = self.bgColor;
    _frontView.layer.cornerRadius = DefaultSize/2;
    [self addSubview:_frontView];
    
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), DefaultSize)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = DefaultSize/2;
    _label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
    
    _label.text = @"";
    if (_bubbleText.length>0) {
        _label.text = _bubbleText;
    }
    [self.frontView addSubview:_label];
}
- (void)setBubbleText:(NSString *)bubbleText{
    _bubbleText = bubbleText;
    if (_bubbleText.length>0) {
        _label.text = _bubbleText;
    }
}


-(void)addGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [_frontView addGestureRecognizer:pan];
}


- (void)doHandlePanAction:(UIPanGestureRecognizer *)paramSender
{
    CGPoint point = [paramSender translationInView:self];
    paramSender.view.center = CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    [paramSender setTranslation:CGPointMake(0, 0) inView:self];
    
    //粘度设置
    if (_viscosity == 0) {
        _viscosity = 50;
    }
    if (_viscosity < 30) {
        _viscosity = 30;
    }
    if (_viscosity > 90) {
        _viscosity = 90;
    }
    
    
    [self addBezierPathLayer:_BezierLayer];
    
    
    if (paramSender.state == UIGestureRecognizerStateBegan) {
        _backView.hidden = NO;
    }
    
    
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        if (centerDistance>_viscosity) {
            _BezierLayer.path = nil;
            _backView.hidden = YES;
        } else {
            _backView.hidden = NO;
        }
    }
    
    
    if (paramSender.state == UIGestureRecognizerStateEnded || paramSender.state ==UIGestureRecognizerStateCancelled || paramSender.state == UIGestureRecognizerStateFailed) {
        
        //距离50以内没问题
        if (centerDistance < _viscosity) {
            _BezierLayer.path = nil;
            _backView.hidden = YES;
            [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.2f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                paramSender.view.center = self->_backView.center;
            } completion:nil];
        } else {
            //距离50外
            [self removeFromSuperview];
        }
        
    }
    
}


-(void)addBezierPathLayer:(CAShapeLayer *)layer
{
    x1 = _backView.center.x;
    y1 = _backView.center.y;
    x2 = _frontView.center.x;
    y2 = _frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    
    
    
    CGFloat size = self.frame.size.height-centerDistance*0.2;
    _backView.frame = CGRectMake(0, 0, size, size);
    _backView.center = CGPointMake(x1, y1);
    _backView.layer.cornerRadius = CGRectGetWidth(_backView.frame)/2;
    
    
#if 1
    
    r1 = _backView.frame.size.height/2;
    r2 = _frontView.frame.size.height/2;
    
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    
    float m = 2;
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / m)*sinDigree, pointA.y + (centerDistance / m)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / m)*sinDigree, pointB.y + (centerDistance / m)*cosDigree);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    //B→C  D→A  需要贝赛尔曲线
    [path moveToPoint:pointA];
    [path addQuadCurveToPoint:pointD controlPoint:pointO];
    [path addLineToPoint:pointC];
    [path addQuadCurveToPoint:pointB controlPoint:pointP];
    [path moveToPoint:pointA];
    
    layer.path = path.CGPath;
    
#endif
}

@end
