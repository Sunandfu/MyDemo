//
//  MyNavigationController.m
//  HundredSchoolStudents
//
//  Created by 薛泽军 on 15/6/30.
//  Copyright (c) 2015年 薛泽军. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.backgroundColor=[UIColor clearColor];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:0.39f green:0.80f blue:0.70f alpha:1.00f]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"未标题-3"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor,[UIColor whiteColor],UITextAttributeTextShadowColor, nil]];
    self.navigationBar.translucent=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
