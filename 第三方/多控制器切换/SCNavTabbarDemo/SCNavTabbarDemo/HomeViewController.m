//
//  HomeViewController.m
//  SCNavTabbarDemo
//
//  Created by 小富 on 16/5/3.
//  Copyright © 2016年 SCNavTabbarDemo. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *urlStr = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    urlStr.text = self.stringUrl;
    urlStr.center = self.view.center;
    urlStr.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:urlStr];
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
