//
//  SFVc4Controller.m
//  SFScrollPageView
//
//  Created by jasnig on 16/5/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFVc4Controller.h"
#import "SFScrollPageView.h"
#import "SFTestViewController.h"

@interface SFVc4Controller ()<SFScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;

@end

@implementation SFVc4Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
    //显示遮盖
    style.showCover = YES;
    // 缩放标题
    style.scaleTitle = YES;
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

    [self.view addSubview:scrollPageView];
}



- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}


- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [[SFTestViewController alloc] init];
    }
    
    
    return childVc;
}
@end
