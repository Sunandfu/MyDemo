//
//  ViewController.m
//  SCNavTabbarDemo
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabbarDemo. All rights reserved.
//

#import "ViewController.h"
#import "SCNavTabBarController.h"
#import "HomeViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.titleArray = @[@"新闻",@"科技",@"自媒体",@"国际新闻",@"政治",@"四川省",@"天府之国",@"娱乐八卦",@"体育",@"新闻",@"科技",@"自媒体",@"国际新闻",@"政治",@"四川省",@"天府之国",@"娱乐八卦",@"体育"];
    self.viewControllerArray = [NSMutableArray array];
    for (int i=0; i<self.titleArray.count; i++) {
        HomeViewController *oneVC = [[HomeViewController alloc] init];
        oneVC.title = self.titleArray[i];
        oneVC.stringUrl = [NSString stringWithFormat:@"第%d个视图",i];
        oneVC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        [self.viewControllerArray addObject:oneVC];
    }
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = self.viewControllerArray;
    navTabBarController.showArrowButton = YES;
    [navTabBarController addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
