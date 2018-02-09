//
//  BaseViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "BaseViewController.h"

#define COLOR_VALUE arc4random() % 255 / 255.0
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:COLOR_VALUE green:COLOR_VALUE blue:COLOR_VALUE alpha:1];

    [self createView];

    [self addGesture];
}

//添加手势
- (void)addGesture {

}

//创建视图
- (void)createView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 200, 200, 200)];
    _imageView.image = [UIImage imageNamed:@"01.JPG"];
    //设置支持事件交互
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
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
