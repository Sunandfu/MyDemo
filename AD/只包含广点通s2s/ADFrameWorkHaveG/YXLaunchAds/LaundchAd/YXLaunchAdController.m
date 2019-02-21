//
//  YXLaunchAdController.m
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import "YXLaunchAdController.h"
#import "YXLaunchAdConst.h"

@interface YXLaunchAdController ()

@end

@implementation YXLaunchAdController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(BOOL)shouldAutorotate{
    
    return NO;
}

-(BOOL)prefersHomeIndicatorAutoHidden{
    
    return YXLaunchAdPrefersHomeIndicatorAutoHidden;
}

@end
