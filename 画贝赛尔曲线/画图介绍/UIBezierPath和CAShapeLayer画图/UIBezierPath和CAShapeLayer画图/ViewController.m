//
//  ViewController.m
//  UIBezierPath和CAShapeLayer画图
//
//  Created by long on 16/2/17.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ViewController.h"

#define LanPangZiDuration 0.5

typedef NS_OPTIONS(NSInteger, AnimationType){
    AnimationTypeNone = 0,
    AnimationTypeOne,
    AnimationTypeTwo,
    AnimationTypeThree,
};

@interface ViewController ()
{
    CGPoint _centerPosition;
    AnimationType _animationType;
}

@property (weak, nonatomic) IBOutlet UIView *displayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _centerPosition = CGPointMake(self.displayView.bounds.size.width/2, self.displayView.bounds.size.height/2);
}

#pragma mark - 实心矩形
- (IBAction)btnSolidRectangle_Click:(id)sender
{
    [self clearDisplayView];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.position = _centerPosition;
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.displayView.layer addSublayer:layer];
    
    [self addAnimation:layer duration:0.2];
}

#pragma mark - 空心矩形
- (IBAction)btnHollowRectangle_Click:(id)sender
{
    [self clearDisplayView];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(130, 10, 100, 80)];
    layer.path = path.CGPath;
    //填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //边框颜色
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.displayView.layer addSublayer:layer];
    
    [self addAnimation:layer duration:0.2];
}

#pragma mark - 三种圆形
- (IBAction)btnCircle_Click:(id)sender
{
    [self clearDisplayView];
    
    //这个画出来是一个圆形
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 10, 100, 100) cornerRadius:50];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor purpleColor].CGColor;
    [self.displayView.layer addSublayer:layer];
    
    //这个画出来是一个圆角，四个直角的图形
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(120, 10, 100, 100) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(50, 100)];
    layer1.path = path1.CGPath;
    layer1.fillColor = [UIColor clearColor].CGColor;
    layer1.strokeColor = [UIColor orangeColor].CGColor;
    [self.displayView.layer addSublayer:layer1];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    /*
     param: ArcCenter 圆心  radius 半径 startAngle/endAngle 开始结束角度 clockwise 是否闭合曲线
     角度问题见该项目目录的图
     */
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(280, 60) radius:50 startAngle:0 endAngle:M_PI clockwise:NO];
    [path2 addLineToPoint:CGPointMake(330, 60)];
    layer2.path = path2.CGPath;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = [UIColor blueColor].CGColor;
    [self.displayView.layer addSublayer:layer2];
    
    [self addAnimation:layer duration:0.2];
    [self addAnimation:layer1 duration:0.2];
    [self addAnimation:layer2 duration:0.2];
}

#pragma mark - 单控制点曲线
- (IBAction)btnBezierCurve1_Click:(id)sender
{
    [self clearDisplayView];
    
    //贝塞尔曲线的画法是由起点、终点、控制点三个参数来画的，为了解释清楚这个点，我写了几行代码来解释它
    CGPoint startPoint   = CGPointMake(50, 100);
    CGPoint endPoint     = CGPointMake(300, 100);
    CGPoint controlPoint = CGPointMake(175, 10);
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(startPoint.x, startPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [CALayer layer];
    layer3.frame = CGRectMake(controlPoint.x, controlPoint.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    [path moveToPoint:startPoint];
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.displayView.layer addSublayer:layer];
    [self.displayView.layer addSublayer:layer1];
    [self.displayView.layer addSublayer:layer2];
    [self.displayView.layer addSublayer:layer3];
    
    [self addAnimation:layer duration:0.2];
}

#pragma mark - 双控制点曲线
- (IBAction)btnBezierCurve2_Click:(id)sender
{
    [self clearDisplayView];
    
    //贝塞尔曲线的画法是由起点、终点、控制点三个参数来画的，为了解释清楚这个点，我写了几行代码来解释它
    CGPoint startPoint   = CGPointMake(50, 70);
    CGPoint endPoint     = CGPointMake(300, 70);
    CGPoint controlPoint1 = CGPointMake(112.5, 10);
    CGPoint controlPoint2 = CGPointMake(237.5, 130);
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(startPoint.x, startPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer3 = [CALayer layer];
    layer3.frame = CGRectMake(controlPoint1.x, controlPoint1.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    CALayer *layer4 = [CALayer layer];
    layer4.frame = CGRectMake(controlPoint2.x, controlPoint2.y, 5, 5);
    layer4.backgroundColor = [UIColor redColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.displayView.layer addSublayer:layer];
    [self.displayView.layer addSublayer:layer1];
    [self.displayView.layer addSublayer:layer2];
    [self.displayView.layer addSublayer:layer3];
    [self.displayView.layer addSublayer:layer4];
    
    [self addAnimation:layer duration:0.2];
}

#pragma mark - 曲面
- (IBAction)btnBezierSurface_Click:(id)sender
{
    [self clearDisplayView];
    
    CGSize size = self.displayView.frame.size;
    CGFloat startHeight = size.height * 0.2;
    CGFloat endHeight = size.height * 0.4;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, startHeight)];
    [path addLineToPoint:CGPointMake(0, endHeight)];
    [path addLineToPoint:CGPointMake(size.width, endHeight)];
    [path addLineToPoint:CGPointMake(size.width, startHeight)];
    [path addQuadCurveToPoint:CGPointMake(0, startHeight) controlPoint:CGPointMake(size.width/2, 0)];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.strokeColor = [UIColor purpleColor].CGColor;
    
    [self.displayView.layer addSublayer:layer];
    
    [self addAnimation:layer duration:0.2];
}

#pragma mark - 绘名字
- (IBAction)drawMyName:(id)sender
{
    [self clearDisplayView];
    
    CGFloat startX = self.view.frame.size.width * 1/4;
    CGFloat startY = 170;
    
    CAShapeLayer *nameLayer = [CAShapeLayer layer];
    UIBezierPath *namePath = [UIBezierPath bezierPath];
    
    //龙
    [namePath moveToPoint:CGPointMake(startX+10, startY+50)];
    [namePath addLineToPoint:CGPointMake(startX+130, startY+47)];
    
    [namePath moveToPoint:CGPointMake(startX+70, startY)];
    [namePath addQuadCurveToPoint:CGPointMake(startX, startY+150) controlPoint:CGPointMake(startX+60, startY+120)];
    
    [namePath moveToPoint:CGPointMake(startX+75, startY+55)];
    [namePath addLineToPoint:CGPointMake(startX+75, startY+130)];
    [namePath addQuadCurveToPoint:CGPointMake(startX+95, startY+150) controlPoint:CGPointMake(startX+75, startY+150)];
    [namePath addLineToPoint:CGPointMake(startX+135, startY+150)];
    [namePath addQuadCurveToPoint:CGPointMake(startX+140, startY+145) controlPoint:CGPointMake(startX+140, startY+150)];
    [namePath addLineToPoint:CGPointMake(startX+140, startY+135)];
    
    [namePath moveToPoint:CGPointMake(startX+120, startY+90)];
    [namePath addQuadCurveToPoint:CGPointMake(startX+50, startY+140) controlPoint:CGPointMake(startX+110, startY+110)];
    
    [namePath moveToPoint:CGPointMake(startX+110, startY+15)];
    [namePath addQuadCurveToPoint:CGPointMake(startX+120, startY+25) controlPoint:CGPointMake(startX+115, startY+18)];
    
    nameLayer.path = namePath.CGPath;
    nameLayer.fillColor = [UIColor whiteColor].CGColor;
    nameLayer.strokeColor = [UIColor blackColor].CGColor;
    nameLayer.lineWidth = 5;
    
    [self.displayView.layer addSublayer:nameLayer];
    [self addAnimation:nameLayer duration:0.4];
}

#pragma mark - 绘哆啦A梦
- (IBAction)btnDuoLaAMeng_Click:(id)sender
{
    [self clearDisplayView];
    
    CGFloat arcCenterX = self.view.frame.size.width/2;
    CGFloat arcCenterY = 80;
    CGFloat delay = LanPangZiDuration;
    
    //头
    CAShapeLayer *headLayer = [CAShapeLayer layer];
    UIBezierPath *headPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.view.frame.size.width/2-80, 0, 160, 160) cornerRadius:80];
    [self setLayer:headLayer path:headPath delay:delay*0];
    
    //脸
    CAShapeLayer *faceLayer = [CAShapeLayer layer];
    UIBezierPath *facePath = [UIBezierPath bezierPath];
    [facePath moveToPoint:CGPointMake(arcCenterX-80*sqrt(2.0)/2, arcCenterY+80*sqrt(2.0)/2)];
    [facePath addCurveToPoint:CGPointMake(arcCenterX-30, arcCenterY-20) controlPoint1:CGPointMake(arcCenterX-80, arcCenterY+25) controlPoint2:CGPointMake(arcCenterX-80, arcCenterY-20)];
    [facePath addLineToPoint:CGPointMake(arcCenterX+30, arcCenterY-20)];
    [facePath addCurveToPoint:CGPointMake(arcCenterX+80*sqrt(2.0)/2, arcCenterY+80*sqrt(2.0)/2) controlPoint1:CGPointMake(arcCenterX+80, arcCenterY-20) controlPoint2:CGPointMake(arcCenterX+80, arcCenterY+25)];
    [facePath addQuadCurveToPoint:CGPointMake(arcCenterX-80*sqrt(2.0)/2, arcCenterY+80*sqrt(2.0)/2) controlPoint:CGPointMake(arcCenterX, arcCenterY+105)];
    [self setLayer:faceLayer path:facePath delay:delay*1];
    
    //左眼
    CAShapeLayer *leftEyeLayer = [CAShapeLayer layer];
    UIBezierPath *leftEyePath = [UIBezierPath bezierPath];
    [leftEyePath moveToPoint:CGPointMake(arcCenterX-30, arcCenterY-25)];
    [leftEyePath addQuadCurveToPoint:CGPointMake(arcCenterX-15, arcCenterY-45) controlPoint:CGPointMake(arcCenterX-30, arcCenterY-45)];
    [leftEyePath addQuadCurveToPoint:CGPointMake(arcCenterX, arcCenterY-25) controlPoint:CGPointMake(arcCenterX, arcCenterY-45)];
    [leftEyePath addQuadCurveToPoint:CGPointMake(arcCenterX-15, arcCenterY-5) controlPoint:CGPointMake(arcCenterX, arcCenterY-5)];
    [leftEyePath addQuadCurveToPoint:CGPointMake(arcCenterX-30, arcCenterY-25) controlPoint:CGPointMake(arcCenterX-30, arcCenterY-5)];
    [self setLayer:leftEyeLayer path:leftEyePath delay:delay*2];
    //左眼珠
    CAShapeLayer *leftEyeBallLayer = [CAShapeLayer layer];
    UIBezierPath *leftEyeBallPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX-5, arcCenterY-30) radius:2.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:leftEyeBallLayer path:leftEyeBallPath delay:delay*3];
    
    //右眼
    CAShapeLayer *rightEyeLayer = [CAShapeLayer layer];
    UIBezierPath *rightEyePath = [UIBezierPath bezierPath];
    [rightEyePath moveToPoint:CGPointMake(arcCenterX, arcCenterY-25)];
    [rightEyePath addQuadCurveToPoint:CGPointMake(arcCenterX+15, arcCenterY-45) controlPoint:CGPointMake(arcCenterX, arcCenterY-45)];
    [rightEyePath addQuadCurveToPoint:CGPointMake(arcCenterX+30, arcCenterY-25) controlPoint:CGPointMake(arcCenterX+30, arcCenterY-45)];
    [rightEyePath addQuadCurveToPoint:CGPointMake(arcCenterX+15, arcCenterY-5) controlPoint:CGPointMake(arcCenterX+30, arcCenterY-5)];
    [rightEyePath addQuadCurveToPoint:CGPointMake(arcCenterX, arcCenterY-25) controlPoint:CGPointMake(arcCenterX, arcCenterY-5)];
    [self setLayer:rightEyeLayer path:rightEyePath delay:delay*4];
    //右眼珠
    CAShapeLayer *rightEyeBallLayer = [CAShapeLayer layer];
    UIBezierPath *rightEyeBallPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX+5, arcCenterY-30) radius:2.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:rightEyeBallLayer path:rightEyeBallPath delay:delay*5];
    
    //鼻子
    CAShapeLayer *noseLayer  = [CAShapeLayer layer];
    UIBezierPath *nosePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX, arcCenterY) radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:noseLayer path:nosePath delay:delay*6];
    //鼻子光晕
    CAShapeLayer *noseHaloLayer = [CAShapeLayer layer];
    UIBezierPath *noseHaloPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX-4, arcCenterY-5) radius:2.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:noseHaloLayer path:noseHaloPath delay:delay*7];
    
    //嘴巴
    CAShapeLayer *mouthLayer = [CAShapeLayer layer];
    UIBezierPath *mouthPath = [UIBezierPath bezierPath];
    [mouthPath moveToPoint:CGPointMake(arcCenterX-60, arcCenterY+25)];
    [mouthPath addQuadCurveToPoint:CGPointMake(arcCenterX+60, arcCenterY+25) controlPoint:CGPointMake(arcCenterX, arcCenterY+90)];
    [self setLayer:mouthLayer path:mouthPath delay:delay*8];
    CAShapeLayer *mouthLayer1 = [CAShapeLayer layer];
    UIBezierPath *mouthPath1 = [UIBezierPath bezierPath];
    [mouthPath1 moveToPoint:CGPointMake(arcCenterX, arcCenterY+10)];
    [mouthPath1 addLineToPoint:CGPointMake(arcCenterX, arcCenterY+55)];
    [self setLayer:mouthLayer1 path:mouthPath1 delay:delay*9];
    
    //胡子
    [self addBeardFromPoint:CGPointMake(arcCenterX-58, arcCenterY-5) toPoint:CGPointMake(arcCenterX-15, arcCenterY+10) delay:delay*10];
    [self addBeardFromPoint:CGPointMake(arcCenterX-68, arcCenterY+15) toPoint:CGPointMake(arcCenterX-15, arcCenterY+20) delay:delay*11];
    [self addBeardFromPoint:CGPointMake(arcCenterX-61, arcCenterY+45) toPoint:CGPointMake(arcCenterX-15, arcCenterY+30) delay:delay*12];
    [self addBeardFromPoint:CGPointMake(arcCenterX+58, arcCenterY-5) toPoint:CGPointMake(arcCenterX+15, arcCenterY+10) delay:delay*13];
    [self addBeardFromPoint:CGPointMake(arcCenterX+68, arcCenterY+15) toPoint:CGPointMake(arcCenterX+15, arcCenterY+20) delay:delay*14];
    [self addBeardFromPoint:CGPointMake(arcCenterX+61, arcCenterY+45) toPoint:CGPointMake(arcCenterX+15, arcCenterY+30) delay:delay*15];
    //左手
    CAShapeLayer *leftHandLayer = [CAShapeLayer layer];
    UIBezierPath *leftHandPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX-95, arcCenterY+110) radius:20 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:leftHandLayer path:leftHandPath delay:delay*16];
    //左胳膊
    CGFloat distanceXToArcCenter = 80*cos(M_PI_2*4/9);
    CGFloat distanceYToArcCenter = 80*sin(M_PI_2*4/9);
    CAShapeLayer *leftArmLayer = [CAShapeLayer layer];
    UIBezierPath *leftArmPath = [UIBezierPath bezierPath];
    [leftArmPath moveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter, arcCenterY+distanceYToArcCenter)];
    [leftArmPath addLineToPoint:CGPointMake(arcCenterX-95, arcCenterY+90)];
    [leftArmPath addQuadCurveToPoint:CGPointMake(arcCenterX-75, arcCenterY+110) controlPoint:CGPointMake(arcCenterX-92, arcCenterY+107)];
    [leftArmPath addLineToPoint:CGPointMake(arcCenterX-distanceXToArcCenter+1.5, arcCenterY+95)];
    [self setLayer:leftArmLayer path:leftArmPath delay:delay*17];
    
    //围巾
    CAShapeLayer *mufflerLayer = [CAShapeLayer layer];
    UIBezierPath *mufflerPath = [UIBezierPath bezierPath];
    [mufflerPath moveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter, arcCenterY+distanceYToArcCenter)];
    [mufflerPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter, arcCenterY+distanceYToArcCenter) controlPoint:CGPointMake(arcCenterX, arcCenterY+109)];
    [mufflerPath addLineToPoint:CGPointMake(arcCenterX+distanceXToArcCenter+2, arcCenterY+distanceYToArcCenter+7)];
    [mufflerPath addQuadCurveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter-4, arcCenterY+distanceYToArcCenter+5) controlPoint:CGPointMake(arcCenterX, arcCenterY+115)];
    [mufflerPath addLineToPoint:CGPointMake(arcCenterX-distanceXToArcCenter, arcCenterY+distanceYToArcCenter)];
    [self setLayer:mufflerLayer path:mufflerPath delay:delay*18];
    //身体
    CAShapeLayer *bodyLayer = [CAShapeLayer layer];
    UIBezierPath *bodyPath = [UIBezierPath bezierPath];
    [bodyPath moveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter, arcCenterY+distanceYToArcCenter+7)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter+5, arcCenterY+150) controlPoint:CGPointMake(arcCenterX-distanceXToArcCenter+2, arcCenterY+140)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter+3, arcCenterY+170) controlPoint:CGPointMake(arcCenterX-distanceXToArcCenter, arcCenterY+160)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX-8, arcCenterY+170) controlPoint:CGPointMake(arcCenterX-(distanceXToArcCenter+5)/2, arcCenterY+175)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX+8, arcCenterY+170) controlPoint:CGPointMake(arcCenterX, arcCenterY+155)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter-3, arcCenterY+170) controlPoint:CGPointMake(arcCenterX+(distanceXToArcCenter+5)/2, arcCenterY+175)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter-5, arcCenterY+150) controlPoint:CGPointMake(arcCenterX+distanceXToArcCenter-2, arcCenterY+160)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter, arcCenterY+distanceYToArcCenter+8) controlPoint:CGPointMake(arcCenterX+distanceXToArcCenter-2, arcCenterY+140)];
    [bodyPath addQuadCurveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter, arcCenterY+distanceYToArcCenter+7) controlPoint:CGPointMake(arcCenterX, arcCenterY+115)];
    [self setLayer:bodyLayer path:bodyPath delay:delay*19];
    //左脚
    CAShapeLayer *leftFootLayer = [CAShapeLayer layer];
    UIBezierPath *leftFootPath = [UIBezierPath bezierPath];
    [leftFootPath moveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter+3, arcCenterY+170)];
    [leftFootPath addQuadCurveToPoint:CGPointMake(arcCenterX-distanceXToArcCenter+3, arcCenterY+195) controlPoint:CGPointMake(arcCenterX-distanceXToArcCenter-20, arcCenterY+185)];
    [leftFootPath addQuadCurveToPoint:CGPointMake(arcCenterX-13, arcCenterY+195) controlPoint:CGPointMake(arcCenterX-(distanceXToArcCenter+10)/2, arcCenterY+200)];
    [leftFootPath addQuadCurveToPoint:CGPointMake(arcCenterX-10, arcCenterY+170) controlPoint:CGPointMake(arcCenterX+8, arcCenterY+187)];
    [self setLayer:leftFootLayer path:leftFootPath delay:delay*20];
    //右脚
    CAShapeLayer *rightFootLayer = [CAShapeLayer layer];
    UIBezierPath *rightFootPath = [UIBezierPath bezierPath];
    [rightFootPath moveToPoint:CGPointMake(arcCenterX+10, arcCenterY+170)];
    [rightFootPath addQuadCurveToPoint:CGPointMake(arcCenterX+15, arcCenterY+195) controlPoint:CGPointMake(arcCenterX-12, arcCenterY+185)];
    [rightFootPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter-5, arcCenterY+195) controlPoint:CGPointMake(arcCenterX+(distanceXToArcCenter+20)/2, arcCenterY+200)];
    [rightFootPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter-3, arcCenterY+170) controlPoint:CGPointMake(arcCenterX+distanceXToArcCenter+18, arcCenterY+185)];
    [self setLayer:rightFootLayer path:rightFootPath delay:delay*21];
    //肚子
    CAShapeLayer *bellyLayer = [CAShapeLayer layer];
    UIBezierPath *bellyPath = [UIBezierPath bezierPath];
    [bellyPath moveToPoint:CGPointMake(arcCenterX-30, arcCenterY+80)];
    [bellyPath addCurveToPoint:CGPointMake(arcCenterX-30, arcCenterY+150) controlPoint1:CGPointMake(arcCenterX-65, arcCenterY+95) controlPoint2:CGPointMake(arcCenterX-60, arcCenterY+140)];
    [bellyPath addQuadCurveToPoint:CGPointMake(arcCenterX+30, arcCenterY+150) controlPoint:CGPointMake(arcCenterX, arcCenterY+160)];
    [bellyPath addCurveToPoint:CGPointMake(arcCenterX+30, arcCenterY+80) controlPoint1:CGPointMake(arcCenterX+60, arcCenterY+140) controlPoint2:CGPointMake(arcCenterX+65, arcCenterY+95)];
    [bellyPath addQuadCurveToPoint:CGPointMake(arcCenterX-30, arcCenterY+80) controlPoint:CGPointMake(arcCenterX, arcCenterY+92)];
    [self setLayer:bellyLayer path:bellyPath delay:delay*22];
    //铃铛
    CAShapeLayer *bellLayer = [CAShapeLayer layer];
    UIBezierPath *bellPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX, arcCenterY+97) radius:15 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:bellLayer path:bellPath delay:delay*23];
    //铃铛上的线
    CAShapeLayer *bellLineLayer = [CAShapeLayer layer];
    UIBezierPath *BellLinePath = [UIBezierPath bezierPath];
    [BellLinePath moveToPoint:CGPointMake(arcCenterX-(sqrt(pow(15.0, 2)-pow(5.0, 2))), arcCenterY+92)];
    [BellLinePath addLineToPoint:CGPointMake(arcCenterX+(sqrt(pow(15.0, 2)-pow(5.0, 2))), arcCenterY+92)];
    [BellLinePath moveToPoint:CGPointMake(arcCenterX+(sqrt(pow(15.0, 2)-pow(2.0, 2))), arcCenterY+95)];
    [BellLinePath addLineToPoint:CGPointMake(arcCenterX-(sqrt(pow(15.0, 2)-pow(2.0, 2))), arcCenterY+95)];
    [self setLayer:bellLineLayer path:BellLinePath delay:delay*24];
    //铃铛上的小圆点
    CAShapeLayer *bellCirLayer = [CAShapeLayer layer];
    UIBezierPath *bellCirPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX, arcCenterY+102) radius:2.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [bellCirPath moveToPoint:CGPointMake(arcCenterX, arcCenterY+104.5)];
    [bellCirPath addLineToPoint:CGPointMake(arcCenterX, arcCenterY+112)];
    [self setLayer:bellCirLayer path:bellCirPath delay:delay*25];
    //口袋
    CAShapeLayer *bagLayer = [CAShapeLayer layer];
    UIBezierPath *bagPath = [UIBezierPath bezierPath];
    [bagPath moveToPoint:CGPointMake(arcCenterX-40, arcCenterY+112)];
    [bagPath addQuadCurveToPoint:CGPointMake(arcCenterX+40, arcCenterY+112) controlPoint:CGPointMake(arcCenterX, arcCenterY+120)];
    [bagPath addCurveToPoint:CGPointMake(arcCenterX-40, arcCenterY+112) controlPoint1:CGPointMake(arcCenterX+28, arcCenterY+160) controlPoint2:CGPointMake(arcCenterX-28, arcCenterY+160)];
    [self setLayer:bagLayer path:bagPath delay:delay*26];
    //右手
    CAShapeLayer *rightHandLayer = [CAShapeLayer layer];
    UIBezierPath *rightHandPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcCenterX+85*cos(27/180.0*M_PI), arcCenterY-85*sin(27/180.0*M_PI)) radius:20 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self setLayer:rightHandLayer path:rightHandPath delay:delay*27];
    //右胳膊
    CAShapeLayer *rightArmLayer = [CAShapeLayer layer];
    UIBezierPath *rightArmPath = [UIBezierPath bezierPath];
    [rightArmPath moveToPoint:CGPointMake(arcCenterX+80*cos(13/180.0*M_PI), arcCenterY-80*sin(13/180.0*M_PI))];
    [rightArmPath addQuadCurveToPoint:CGPointMake(arcCenterX+distanceXToArcCenter, arcCenterY+distanceYToArcCenter) controlPoint:CGPointMake(arcCenterX+80*cos(13/180.0*M_PI)+9, arcCenterY+20)];
    [rightArmPath addLineToPoint:CGPointMake(arcCenterX+distanceXToArcCenter, arcCenterY+distanceYToArcCenter+25)];
    [rightArmPath addQuadCurveToPoint:CGPointMake(arcCenterX+93*cos(15/180.0*M_PI), arcCenterY-93*sin(15/180.0*M_PI)) controlPoint:CGPointMake(arcCenterX+90*cos(13/180.0*M_PI)+15, arcCenterY+25)];
    [rightArmPath addQuadCurveToPoint:CGPointMake(arcCenterX+80*cos(13/180.0*M_PI), arcCenterY-80*sin(13/180.0*M_PI)) controlPoint:CGPointMake(arcCenterX+80*cos(13/180.0*M_PI)+5, arcCenterY-93*sin(15/180.0*M_PI)+5)];
    [self setLayer:rightArmLayer path:rightArmPath delay:delay*28];
    
    //上色
    [self setLayerColor:faceLayer color:[UIColor whiteColor] delay:delay*16];
    [self setLayerColor:leftEyeLayer color:[UIColor whiteColor] delay:delay*29];
    [self setLayerColor:rightEyeLayer color:[UIColor whiteColor] delay:delay*29];
    [self setLayerColor:leftEyeBallLayer color:[UIColor blackColor] delay:delay*29];
    [self setLayerColor:rightEyeBallLayer color:[UIColor blackColor] delay:delay*29];
    [self setLayerColor:noseLayer color:[UIColor redColor] delay:delay*29];
    [self setLayerColor:noseHaloLayer color:[UIColor whiteColor] delay:delay*29];
    [self setLayerColor:headLayer color:[UIColor colorWithRed:21/255.0 green:159/255.0 blue:237/255.0 alpha:1] delay:delay*29];
    [self setLayerColor:leftArmLayer color:[UIColor colorWithRed:21/255.0 green:159/255.0 blue:237/255.0 alpha:1] delay:delay*29];
    [self setLayerColor:leftHandLayer color:[UIColor whiteColor] delay:delay*29];
    [self setLayerColor:mufflerLayer color:[UIColor redColor] delay:delay*29];
    [self setLayerColor:bellyLayer color:[UIColor whiteColor] delay:delay*29];
    [self setLayerColor:bellLayer color:[UIColor yellowColor] delay:delay*29];
    [self setLayerColor:bodyLayer color:[UIColor colorWithRed:21/255.0 green:159/255.0 blue:237/255.0 alpha:1] delay:delay*29];
    [self setLayerColor:rightHandLayer color:[UIColor whiteColor] delay:delay*29];
    [self setLayerColor:rightArmLayer color:[UIColor colorWithRed:21/255.0 green:159/255.0 blue:237/255.0 alpha:1] delay:delay*29];
    
    [self performSelector:@selector(showHello) withObject:nil afterDelay:delay*29];
}

- (void)addBeardFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint delay:(CFTimeInterval)delay
{
    CAShapeLayer *beardLayer1 = [CAShapeLayer layer];
    UIBezierPath *beardPath1 = [UIBezierPath bezierPath];
    [beardPath1 moveToPoint:fromPoint];
    [beardPath1 addLineToPoint:toPoint];
    [self setLayer:beardLayer1 path:beardPath1 delay:delay];
}

- (void)setLayerColor:(CAShapeLayer *)layer color:(UIColor *)color delay:(CFTimeInterval)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        layer.fillColor = color.CGColor;
    });
}

- (void)setLayer:(CAShapeLayer *)layer path:(UIBezierPath *)path delay:(CFTimeInterval)delay
{
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.displayView.layer addSublayer:layer];
        [weakSelf addAnimation:layer duration:LanPangZiDuration];
    });
}

- (void)showHello
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+90, 0, 70, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:21/255.0 green:159/255.0 blue:237/255.0 alpha:1];
    label.text = @"Hello";
    label.font = [UIFont fontWithName:@"Chalkduster" size:20];
    [self.displayView addSubview:label];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = 0.5f;
    [label.layer addAnimation:animation forKey:nil];
}

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    _animationType = segment.selectedSegmentIndex;
}

- (void)addAnimation:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    switch (_animationType) {
        case AnimationTypeNone:
            break;
        
        case AnimationTypeOne:
            [self addAnimationOneOnLayer:layer duration:duration];
            break;
            
        case AnimationTypeTwo:
            [self addAnimationTwoOnLayer:layer duration:duration];
            break;
        
        case AnimationTypeThree:
            [self addAnimationThreeOnLayer:layer duration:duration];
            break;
        default:
            break;
    }
}

#pragma mark - 利用layer的 strokeEnd、strokeStart和lineWidth 属性添加CA动画
- (void)addAnimationOneOnLayer:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = duration;
    [layer addAnimation:animation forKey:nil];
}

- (void)addAnimationTwoOnLayer:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
//    layer.strokeStart = 0.5;
//    layer.strokeEnd = 0.5;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.fromValue = @(0.5);
    animation1.toValue = @(0);
    animation1.duration = duration;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.fromValue = @(0.5);
    animation2.toValue = @(1);
    animation2.duration = duration;
    
    [layer addAnimation:animation1 forKey:nil];
    [layer addAnimation:animation2 forKey:nil];
}

- (void)addAnimationThreeOnLayer:(CAShapeLayer *)layer duration:(CFTimeInterval)duration
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @(0);
    animation1.toValue = @(1);
    animation1.duration = duration;
    
    [layer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation2.fromValue = @(1);
    animation2.toValue = @(8);
    animation2.duration = duration;
    
    [layer addAnimation:animation1 forKey:nil];
    [layer addAnimation:animation2 forKey:nil];
}

- (void)clearDisplayView
{
    [self.displayView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
