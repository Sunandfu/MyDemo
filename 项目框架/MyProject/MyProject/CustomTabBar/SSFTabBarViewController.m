//
//  HomeViewController.m
//  自定义tabbar
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 SSF. All rights reserved.
//

#import "SSFTabBarViewController.h"
#import "SSFTabBar.h"


@interface SSFTabBarViewController ()<SSFTabBarDelegate>

//自定义TabBar
@property (nonatomic,weak) SSFTabBar *customTabBar;

@end

static SSFTabBarViewController *tabbar = nil;
@implementation SSFTabBarViewController

+ (instancetype)shareTabBarVC{
    static dispatch_once_t once = 0;
    _dispatch_once(&once, ^{
        tabbar = [[SSFTabBarViewController alloc] init];
    });
    return tabbar;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化Tabbar
    [self setupTabbar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView *chid in self.tabBar.subviews) {
        if ([chid isKindOfClass:[UIControl class]]) {
            [chid removeFromSuperview];
        }
    }
}
//初始化Tabbar
- (void)setupTabbar{
    SSFTabBar *customTabBar = [[SSFTabBar alloc] init];
    customTabBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}
- (void)tabBar:(SSFTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to{
    NSLog(@"%d===%d",from,to);
    self.selectedIndex = to;
}
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedimageName:(NSString *)selectedImageName{
    childVc.title = title;
    //加载tabbar图片
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nvc];
    //添加按钮
    [self.customTabBar addTabBarItem:childVc.tabBarItem];
}
@end
