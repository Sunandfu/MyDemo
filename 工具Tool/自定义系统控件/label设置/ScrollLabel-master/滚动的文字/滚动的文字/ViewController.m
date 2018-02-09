//
//  ViewController.m
//  滚动的文字
//
//  Created by iMac on 16/9/21.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSScrollLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    WSScrollLabel *label1 = [[WSScrollLabel alloc]initWithFrame:CGRectMake(30, 50, 250, 30)];;
    label1.text = @"我是一个单纯的静止的文字";
    label1.textFont = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor whiteColor];
    label1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label1];
    
    
    WSScrollLabel *label2 = [[WSScrollLabel alloc]initWithFrame:CGRectMake(30, 120, 250, 30)];;
    label2.text = @"我是一个能动的文字，你他妈倒是东给我看看啊";
    label2.textFont = [UIFont systemFontOfSize:20];
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:label2];
    
    
}



@end
