//
//  BaseViewController.m
//  museum
//
//  Created by 小富 on 2017/11/8.
//  Copyright © 2017年 xiaofu. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.tabBarController) {
        self.tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    } else {
        self.tabBarHeight = 0;
    }
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    if (StatusRect.size.height == 40) {
        StatusRect = CGRectMake(0, 0, StatusRect.size.width, 20);
    }
    self.statusBarHeight = StatusRect.size.height;
    self.navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    self.navigationAndStatuHeight = self.statusBarHeight + self.navigationBarHeight;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
}
//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)setType:(NavigationType)type{
    _type = type;
    //如果自定义返回按钮。请打开
    if (self.navigationController.viewControllers.count>1) {
        [self addLeftBackButton];
    }
    if (type == NavigationTypeBlack) {
        self.navBarBgAlpha = @"1.0";
        // 设置导航栏标题和返回按钮颜色
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        //返回按钮颜色
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    } else if (type == NavigationTypeWhite) {
        self.navBarBgAlpha = @"1.0";
        // 设置导航栏标题和返回按钮颜色
        self.navigationController.navigationBar.barTintColor = THEME_COLOR;
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        //返回按钮颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navBarBgAlpha = @"0.0";
        // 设置导航栏标题和返回按钮颜色
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        //返回按钮颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}
- (UIWindow *)window
{
    return [UIApplication sharedApplication].delegate.window;
}

- (void)addLeftBackButton
{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右偏移10 point
    [settingButton setFrame:CGRectMake(-15.0, 0.0, 44.0, 44.0)];
    [settingButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == NavigationTypeBlack) {
        [settingButton setImage:[UIImage imageNamed:@"fanhui_hui"] forState:UIControlStateNormal];
    } else {
        [settingButton setImage:[UIImage imageNamed:@"fanhui_bai"] forState:UIControlStateNormal];
    }
    
    //修改方法
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [view addSubview:settingButton];
    view.userInteractionEnabled = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)backAction
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
