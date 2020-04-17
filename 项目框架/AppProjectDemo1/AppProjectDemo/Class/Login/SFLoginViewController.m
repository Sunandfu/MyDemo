//
//  SFLoginViewController.m
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "SFLoginViewController.h"

@interface SFLoginViewController ()

@end

@implementation SFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"登陆";
//    self.view.backgroundColor = [UIColor yellowColor];
}
- (void)viewWillAppear:(BOOL)animated{
    self.type = NavigationTypeWhite;
    [super viewWillAppear:animated];
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
