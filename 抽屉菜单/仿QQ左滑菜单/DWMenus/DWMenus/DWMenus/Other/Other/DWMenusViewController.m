//
//  DWMenusViewController.m
//  DWMenu
//
//  Created by Dwang on 16/4/27.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import "DWMenusViewController.h"
#import "DWViewController.h"

@interface DWMenusViewController ()
@end

@implementation DWMenusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.selfblock(@"我的颜色是白色");
}

- (void)wodeyanse:(wodeblock)block{
    self.selfblock = block;
}

@end
