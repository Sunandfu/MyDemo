//
//  ViewController.m
//  CicleAni
//
//  Created by JoKy_Li on 16/2/3.
//  Copyright © 2016年 Joky. All rights reserved.
//

#import "ViewController.h"
#import "SDMoreCicle.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:[SDMoreCicle viewWithCicle:self.view.frame]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
