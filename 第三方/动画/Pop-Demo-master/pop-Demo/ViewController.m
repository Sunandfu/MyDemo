//
//  ViewController.m
//  pop-Demo
//
//  Created by kxrt_013 on 2017/4/11.
//  Copyright © 2017年 kxrt_013. All rights reserved.
//

#import "ViewController.h"
// 导入头文件
#import "POP.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layerView.backgroundColor = [UIColor cyanColor];
    self.layerView.layer.cornerRadius = 50;
    
    // 弹簧效果
    [self springAnimation];
    
    // 衰减效果
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [self.layerView addGestureRecognizer:pan];
    
    // 基本动画
//    [self basicAnimation];
    
    // 自定义属性动画
//    [self propertyAnimation];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.layerView.layer pop_removeAllAnimations];
//    [self springAnimation];
    
//    [self basicAnimation];
    
//     [self propertyAnimation];
}

#pragma mark ---- 弹簧效果 ----
- (void)springAnimation{
    // 1.初始化
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    // 2.设置初始值和变化后的值
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.f, 1.f)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(3.f, 3.f)];
    // 速度 可以设置的范围是0-20，默认为12.值越大速度越快，结束的越快
    anim.springSpeed = 2.f;
    // 振幅 可以设置的范围是0-20，默认为4。值越大振动的幅度越大
    anim.springBounciness = 10.f;
    // 拉力 拉力越大，动画的速度越快，结束的越快。 接下来的三个值一般不用设置，可以分别放开注释查看效果
//    anim.dynamicsTension = 250;
    // 摩擦力 摩擦力越大，动画的速度越慢，振动的幅度越小。
//    anim.dynamicsFriction = 100.0;
    // 质量 质量越大，动画的速度越慢，振动的幅度越大，结束的越慢
    anim.dynamicsMass = 10;
    anim.beginTime = CACurrentMediaTime() + 1.f;
    // 3.添加到view上
    [self.layerView.layer pop_addAnimation:anim forKey:@"ScaleXY"];
}


#pragma mark ---- 拖动事件(衰减效果) ----
- (void)pan:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    // 拖拽动作结束
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        // 1.初始化
        POPDecayAnimation *animtion = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        // 2.设置初始值
        // 这个例子中不需要设置初始值。注意：POPDecayAnimation只有fromValue，没有toValue
        // POPDecayAnimation设置duration也是没有意义的，因为POPDecayAnimation的动画持续时间，是由velocity(速度)和deceleration(衰减系数)决定的。
        // 衰减系数（越小贼衰减的越快）很少用到，可以不设置
        animtion.deceleration = 0.998;
        // 设置动画速度
        animtion.velocity = [NSValue valueWithCGPoint:velocity];
        // 3.添加到view上
        [recognizer.view.layer pop_addAnimation:animtion forKey:@"positionAnimation"];
    }
}


#pragma mark ---- 基本动画 ----
- (void)basicAnimation{
    // 1.初始化
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    // 2.设置初始值
    basic.fromValue = [UIColor blackColor];
    basic.toValue = [UIColor redColor];
    // 动画的时长
    basic.duration = 4.0;
    // 动画类型 系统预设的类型有以下5种：
    //    kCAMediaTimingFunctionLinear            线性,即匀速
    //    kCAMediaTimingFunctionEaseIn            先慢后快
    //    kCAMediaTimingFunctionEaseOut           先快后慢
    //    kCAMediaTimingFunctionEaseInEaseOut     先慢后快再慢
    //    kCAMediaTimingFunctionDefault           实际效果是动画中间比较快
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basic.beginTime = CACurrentMediaTime() + 1.f;
    // 3.添加到view上
    [self.layerView pop_addAnimation:basic forKey:@"colorAnimation"];
    
}

#pragma mark ---- 自定义属性动画 ----
- (void)propertyAnimation{
    
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"prop" initializer:^(POPMutableAnimatableProperty *prop) {
        
        // 告诉pop当前的属性值
        prop.readBlock = ^(id obj, CGFloat *values) {
          
        };
        // 修改变化后的属性值
        prop.writeBlock = ^(id obj, const CGFloat *values) {
            UILabel *label = (UILabel *)obj;
            label.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)values[0]/60,(int)values[0]%60,(int)(values[0]*100)%100];
        };
        // 动画变化的快慢，值越大block调用的次数越少
//        prop.threshold = 0.1;
    }];
    // 1.初始化
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    // 自定义属性
    anim.property = prop;
    // 2.设置初始值
    anim.fromValue = @(0);
    anim.toValue = @(3*60);
    // 动画的时长
    anim.duration = 3*60;
    anim.beginTime = CACurrentMediaTime() + 1.f;
    [self.countLabel pop_addAnimation:anim forKey:@"countAnimation"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
