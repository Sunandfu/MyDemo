//
//  SFVc8Controller.m
//  SFScrollPageView
//
//  Created by jasnig on 16/5/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFVc8Controller.h"
#import "SFScrollPageView.h"
#import "SFTestViewController.h"

@interface SFVc8Controller ()<SFScrollPageViewDelegate>

@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (weak, nonatomic) SFScrollPageView *scrollPageView;

@end

@implementation SFVc8Controller


- (IBAction)changeBtnOnClick:(UIBarButtonItem *)sender {
    // 切换选中的下标
    [self.scrollPageView setSelectedIndex:5 animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    self.titles = @[@"新闻头条",
                    @"国际要闻",
                    @"体育",
                    @"中国足球",
                    @"汽车",
                    @"囧途旅游",
                    @"幽默搞笑",
                    @"视频",
                    @"无厘头",
                    @"美女图片",
                    @"今日房价",
                    @"头像",
                    ];
    // 初始化
    SFScrollPageView *scrollPageView = [[SFScrollPageView alloc] initWithFrame:CGRectMake(0, SF_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - SF_StatusBarAndNavigationBarHeight) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    self.scrollPageView = scrollPageView;
    
    // 设置默认下标
    [self.scrollPageView setSelectedIndex:2 animated:NO];
    [self.view addSubview:self.scrollPageView];
}


- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}


- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [[SFTestViewController alloc] init];
    }
    
    
    if (index%2==0) {
        childVc.view.backgroundColor = [UIColor blueColor];
    } else {
        childVc.view.backgroundColor = [UIColor greenColor];
        
    }
    
    return childVc;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---将要消失",index);
    
}


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    NSLog(@"%ld ---已经消失",index);
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}
@end
