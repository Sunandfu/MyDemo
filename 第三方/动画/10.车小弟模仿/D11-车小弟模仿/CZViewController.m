//
//  CZViewController.m
//  D11-车小弟模仿
//
//  Created by Vincent_Guo on 14-8-11.
//  Copyright (c) 2014年 vgios. All rights reserved.
//

#import "CZViewController.h"
#import "OBShapedButton.h"

@interface CZViewController ()
- (IBAction)centerBtnClick;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation CZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i = 0; i < 3; i++) {
        NSString *btnImage = [NSString stringWithFormat:@"circle%d",i + 1];
        
        OBShapedButton *btn = [OBShapedButton  buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(0, 0, 306, 306);
        [btn setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
        
        //[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:btn];
    }
}



- (IBAction)centerBtnClick {
    
    //CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
  
    CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    CABasicAnimation *rotation =  [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animation];
    scale.keyPath = @"transform.scale";
    
    if (self.imageView.alpha == 0) {//打开
        self.imageView.alpha = 1;
       opacity.values = @[@(0.2),@(0.8),@(1.0)];
//        opacity.fromValue = @(0);
//        opacity.toValue = @(1);
        
        rotation.fromValue = @(-M_PI_4);
        rotation.toValue = @(0);
        
        scale.values = @[@(0),@(1.2),@(1)];
        
    }else{//隐藏
        self.imageView.alpha = 0;
        opacity.values = @[@(1),@(0.8),@(0.2)];
       
        //opacity.fromValue = @(1);
        //opacity.toValue = (0);
       
        rotation.fromValue = @(0);
        rotation.toValue = @(-M_PI_4);
        
        scale.values = @[@(1),@(1.2),@(0)];
    }
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacity,rotation,scale];
    group.duration = 3;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.imageView.layer addAnimation:group forKey:nil];
}
@end
