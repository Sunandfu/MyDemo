//
//  RootViewController.m
//  01各种手势及事件
//
//  Created by 升旭 刘 on 16/4/14.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //
    [self createView];

    [self addGesture];

}

//重写创建视图的方法
- (void)createView {
    //button的标题数组
    NSArray *buttonTitleArray = @[@"Touch", @"Tap", @"LongPress", @"Swipe", @"Pan", @"Rotation", @"Pinch"];

    //循环创建button
    for (NSInteger i = 0; i < buttonTitleArray.count; i++) {
        UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2, 100 + i * 75, 200, 60)];
        //设置背景颜色
        tempButton.backgroundColor = [UIColor blackColor];
        //设置标题颜色
        [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置标题
        [tempButton setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        //添加单击事件
        [tempButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //添加到当前控制器上
        [self.view addSubview:tempButton];
    }

}

#pragma mark --单击事件
- (void)btnClick:(UIButton *)button {
    //获取当前点击的title值 拼接的 类名字
    NSString *classNameStr = [NSString stringWithFormat:@"%@ViewController", button.titleLabel.text];
    //通过类名字的字符串反射得到这个类的类型
    Class aClass = NSClassFromString(classNameStr);
    //创建这个类型的对象
    UIViewController *vc = [[aClass alloc] init];
    //设置每个页面的导航上的title
    vc.navigationItem.title = button.titleLabel.text;
    //实现跳转
    [self.navigationController pushViewController:vc animated:YES];
}



@end
