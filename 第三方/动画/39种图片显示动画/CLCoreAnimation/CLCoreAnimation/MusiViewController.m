//
//  MusiViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/21.
//  Copyright © 2016年 More. All rights reserved.
//

#import "MusiViewController.h"

@interface MusiViewController ()

@property (weak, nonatomic) IBOutlet UIView *Vc;




@end

@implementation MusiViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
}
-(void)makeUI{
    
    // 创建复制图层
    CAReplicatorLayer *repL =[CAReplicatorLayer layer];
    repL.frame =_Vc.bounds;
    repL.instanceColor =[UIColor redColor].CGColor;
    [_Vc.layer addSublayer:repL];
 
    
    CALayer *layer =[CALayer layer];
    layer.anchorPoint =CGPointMake(0.5, 1);
    layer.position =CGPointMake(15, _Vc.bounds.size.height);
    layer.bounds = CGRectMake(0, 0, 30, 150);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [repL addSublayer: layer];
    
    
    CABasicAnimation *anim =[CABasicAnimation animation];
    anim.duration =1.0;
    anim.keyPath =@"transform.scale.y";
    anim.toValue =@0.1;
    anim.repeatCount =MAXFLOAT;
    anim.autoreverses =YES;// 设置翻转
    [layer addAnimation:anim forKey:nil];
    
    // 进行平移
    repL.instanceTransform =CATransform3DMakeTranslation(45, 0, 0);
    repL.instanceCount =5;
    repL.instanceDelay  =0.3;
    repL.instanceColor = [UIColor greenColor].CGColor;
    repL.instanceGreenOffset = -0.3;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
