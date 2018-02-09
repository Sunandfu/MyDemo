//
//  ViewController.m
//  photo
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

#define screeenWidth [UIScreen mainScreen].bounds.size.width
#define screeenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController (){
    int period;
    UIButton *button;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    period = 5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screeenWidth, screeenHeight)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"Default"];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screeenWidth-85, 20, 70, 30);
    [button setTitle:@"剩余5秒" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:imageView];
    [self.view addSubview:button];
    [self shakeToShow:imageView];
    [self dishiqi];
}
//图片放大效果
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
- (void)dishiqi{//设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.2 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        if (period<=0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NextViewController *text = [[NextViewController alloc] init];
                [self presentViewController:text animated:NO completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"剩余%d秒",period] forState:UIControlStateNormal];
                NSLog(@"%@",button.titleLabel.text);
            });
            period--;
        }
    });
    dispatch_resume(_timer);
}
- (void)btnClick:(UIButton *)sender{
    period = 0;
    [self dishiqi];
}
- (void)showView{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
