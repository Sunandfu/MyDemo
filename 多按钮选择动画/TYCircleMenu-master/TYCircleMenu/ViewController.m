//
//  ViewController.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "ViewController.h"
#import "TYCircleCell.h"
#import "TYCircleMenu.h"

@interface ViewController ()<TYCircleMenuDelegate>

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main.jpg"]];

    self.items = @[@"test_0",@"test_1",@"test_2",@"test_3",
                   @"test_4",@"test_5",@"test_6",@"test_7",
                   @"test_8",@"test_9",@"test_10",@"test_11"];
    /*  init method:
     *  radious:菜单大小（高 == 宽）
     *  itemOffset:首项的偏移距离
     */
    TYCircleMenu *menu = [[TYCircleMenu alloc]initWithRadious:240 itemOffset:0 imageArray:self.items titleArray:self.items menuDelegate:self];
    /* 以下设置为可选，不设置的时候，默认visibleNum = 4, isDismissWhenSelected = NO */
//    menu.visibleNum = 3; //当前可见菜单数
//    menu.isDismissWhenSelected = YES; //点击菜单项，隐藏菜单
    [self.view addSubview:menu];

}


- (void)selectMenuAtIndex:(NSInteger)index {
    NSLog(@"选中:%zd",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com