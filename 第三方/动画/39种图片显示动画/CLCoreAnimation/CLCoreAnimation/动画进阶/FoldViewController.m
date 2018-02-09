//
//  FoldViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//


/**
 
 图片折叠
 
 */

#import "FoldViewController.h"

@interface FoldViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topView;

@property (weak, nonatomic) IBOutlet UIImageView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *Vc;

// 图渐变图层
@property (nonatomic, weak) CAGradientLayer *gradientL;


@end

@implementation FoldViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
}
/**
 设置界面
 */
-(void)makeUI{
    
    _topView.layer.contentsRect =CGRectMake(0, 0, 1, 0.5);
    _topView.layer.anchorPoint =CGPointMake(0.5, 1);
    
    _bottomView.layer.contentsRect =CGRectMake(0, 0.5, 1, 0.5);
    _bottomView.layer.anchorPoint =CGPointMake(0.5, 0);
    
    
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_Vc addGestureRecognizer:pan];
    
    CAGradientLayer *gradientL  =[CAGradientLayer layer];
    
    gradientL.opacity =0;
    
    gradientL.frame =_bottomView.bounds;
    
    gradientL.colors=@[(id)[UIColor redColor].CGColor,(id)[UIColor purpleColor].CGColor];
    
    _gradientL =gradientL;

    [_bottomView.layer addSublayer:gradientL];
    
    
}
-(void)pan:(UIPanGestureRecognizer*)pan{
    
    CGPoint  cup =[pan locationInView:_Vc];
    
    CGFloat angle= -cup.y/200*M_PI;
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform.m34 =-1/500.0;
    
    _topView.layer.transform =CATransform3DRotate(transform, angle, 1, 0, 0);
    
    _gradientL.opacity =cup.y*1/200.0;
    
    // 加入弹簧效果
    
//    if (pan.state ==UIGestureRecognizerStateEnded) {
//        [UIView  animateWithDuration:1.0 delay:0.5 usingSpringWithDamping:0.2 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
