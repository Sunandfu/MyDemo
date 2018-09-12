//
//  ViewController.m
//  AjenShiftyTextField
//
//  Created by Ajen on 2018/8/13.
//  Copyright © 2018年 Ajen. All rights reserved.
//

#import "ViewController.h"
#import "AjenShiftyInputView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    AjenShiftyInputView * inputView = [[AjenShiftyInputView alloc] initWithFrame:CGRectMake(50, 100, 270, 40)];
    
    //以下属性均可不设置
    
    inputView.backgroundColor = [UIColor whiteColor];
    
    //icon
    inputView.iconImage = [UIImage imageNamed:@"账户"];
    //占位文字
    inputView.placeholder = @"请输入";
    //光标颜色
    inputView.cursorColor = [UIColor grayColor];
    //是否显示清除按钮
    inputView.isShowClearButton = YES;
    //边框颜色
    inputView.borderLineColor = [UIColor grayColor];
    //是否显示最大字数
    inputView.isShowWordCount = YES;
    //最大字数
    inputView.maxWordNumber = 20;
    
    [self.view addSubview:inputView];
    
    
    inputView.beginEditBlock = ^(AjenShiftyInputView *inputView, NSString *text) {
        NSLog(@"%@",text);
    };
    inputView.finishDoneBlock = ^(AjenShiftyInputView *inputView, NSString *text) {
        NSLog(@"%@",text);
    };
    inputView.changeBlock = ^(AjenShiftyInputView *inputView, NSString *text) {
        NSLog(@"%@",text);
    };
    
}



@end
