//
//  MainControllerViewController.m
//  iOS-Echarts
//
//  Created by Pluto-Y on 15/10/2.
//  Copyright © 2015年 pluto-y. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *kNavigationBar;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}


#pragma mark -custom functions
/**
 *  初始化
 */
-(void)initAll {
    _kNavigationBar.backgroundColor = [UIColor orangeColor];
    _kNavigationBar.translucent = NO;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com