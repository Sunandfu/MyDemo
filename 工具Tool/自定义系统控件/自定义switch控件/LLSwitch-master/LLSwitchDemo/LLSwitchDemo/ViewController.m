//
//  ViewController.m
//  LLSwitchDemo
//
//  Created by admin on 16/5/17.
//  Copyright © 2016年 LiLei. All rights reserved.
//

#import "ViewController.h"
#import "LLSwitch.h"

@interface ViewController () <LLSwitchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LLSwitch *llSwitch = [[LLSwitch alloc] initWithFrame:CGRectMake(100, 100, 120, 60)];
    llSwitch.onColor = [UIColor greenColor];    // switch is open color    开关打开的颜色
    llSwitch.offColor = [UIColor redColor];    // switch is close color    开关关闭的颜色
    llSwitch.faceColor = [UIColor blackColor];    // switch face color    圆脸的颜色
    llSwitch.animationDuration = 1.2f;    // switch open or close animation time    开关的动画时间
    [self.view addSubview:llSwitch];
    llSwitch.delegate = self;
}

-(void)didTapLLSwitch:(LLSwitch *)llSwitch {
    NSLog(@"start");
}

- (void)animationDidStopForLLSwitch:(LLSwitch *)llSwitch {
    NSLog(@"stop");
}

@end
