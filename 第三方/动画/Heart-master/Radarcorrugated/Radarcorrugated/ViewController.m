//
//  ViewController.m
//  Radarcorrugated
//
//  Created by yunxiang on 2017/8/29.
//  Copyright © 2017年 yunxiang. All rights reserved.
//

#import "ViewController.h"
#import "heartView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.width)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    
    heartView *radarView = [[heartView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150)/2,0, 150, 120)];
    radarView.backgroundColor = [UIColor clearColor];
    [radarView animate:YES];
    [backgroundView addSubview:radarView];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
