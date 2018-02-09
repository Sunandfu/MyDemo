//
//  GroupViewController.m
//  CLCoreAnimation
//
//  Created by 优聚投 on 16/6/20.
//  Copyright © 2016年 More. All rights reserved.
//

#import "GroupViewController.h"


@interface GroupViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     self.title =@"动画组";
    
}

- (IBAction)startAnimation:(id)sender {
    
    //[self groupAnimation];
    
    [self demo2];
}

-(void)groupAnimation{
    CAAnimationGroup *group =[CAAnimationGroup animation];
    CABasicAnimation *anim =[CABasicAnimation animationWithKeyPath:@"position"];
    anim.fromValue =[NSValue valueWithCGPoint:CGPointMake(0, 200)];
    anim.toValue =[NSValue valueWithCGPoint:CGPointMake(WIDTH, 200)];
    anim.repeatCount =2;
    anim.duration =3.0;
    
    CABasicAnimation *scale =[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue =@0.5;
    scale.repeatCount =1;
    scale.duration =2.0;
    
    
    CABasicAnimation *transform =[CABasicAnimation animationWithKeyPath:@"transform"];
    transform.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2+M_PI_4, 1, 1, 0)];
    transform.repeatCount =1;
    transform.duration =2.0;
    
    group.animations =@[anim,scale,transform];
    
    [_imageV.layer addAnimation:group forKey:nil];
    
}
-(void)demo2{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @0.5;
    
    CABasicAnimation *rotation = [CABasicAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.toValue = @(arc4random_uniform(M_PI));
    
    CABasicAnimation *position = [CABasicAnimation animation];
    position.keyPath = @"position";
    position.toValue = [NSValue valueWithCGPoint:CGPointMake(arc4random_uniform(200), arc4random_uniform(200))];
    
    group.animations = @[scale,rotation,position];
    
    [_imageV.layer addAnimation:group forKey:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
