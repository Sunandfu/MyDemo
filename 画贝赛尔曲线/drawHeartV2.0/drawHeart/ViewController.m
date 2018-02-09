//
//  ViewController.m
//  drawHeart
//
//  Created by 阿城 on 15/10/8.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "ViewController.h"
#import "heartView.h"

@interface ViewController ()
@property(nonatomic ,weak) heartView *heart;
@end

@implementation ViewController
- (IBAction)slider:(UISlider *)sender {
    _heart.value = sender.value;
    [_heart setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    heartView *heart = [[heartView alloc]initWithFrame:CGRectMake(50, 100, 200, 300)];
    heart.backgroundColor = [UIColor clearColor];
    [self.view addSubview:heart];
    _heart = heart;
    
//    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
