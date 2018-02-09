//
//  HaHaController.m
//  FPS
//
//  Created by iMac on 17/1/22.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "HaHaController.h"

@implementation HaHaController

-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.frame.size.width/2-100, 100, 200, 50);
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(hahaAAAAA) forControlEvents:UIControlEventTouchUpInside];
    

    
}

- (void)hahaAAAAA {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
