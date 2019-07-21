//
//  SFVc6Controller.m
//  SFScrollPageView
//
//  Created by jasnig on 16/5/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFVc6Controller.h"
#import "SFScrollPageView.h"
#import "SFTestViewController.h"
@interface SFVc6Controller ()<SFScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController<SFScrollPageViewChildVcDelegate> *> *childVcs;
@property (weak, nonatomic) SFScrollSegmentView *segmentView;
@property (weak, nonatomic) SFContentView *contentView;
@end

@implementation SFVc6Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.childVcs = [self setupChildVc];
    // 初始化
    [self setupSegmentView];
    [self setupContentView];
    
}

- (void)setupSegmentView {
    SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
    style.showCover = YES;
    // 不要滚动标题, 每个标题将平分宽度
    style.scrollTitle = NO;
    
    // 渐变
    style.gradualChangeTitleColor = YES;
    // 遮盖背景颜色
    style.coverBackgroundColor = [UIColor whiteColor];
    //标题一般状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.normalTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    //标题选中状态颜色 --- 注意一定要使用RGB空间的颜色值
    style.selectedTitleColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    self.titles = @[@"国内新闻", @"新闻头条"];
    
    // 注意: 一定要避免循环引用!!
    __weak typeof(self) weakSelf = self;
    SFScrollSegmentView *segment = [[SFScrollSegmentView alloc] initWithFrame:CGRectMake(0, SF_StatusBarAndNavigationBarHeight, 160.0, 28.0) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(SFTitleView *titleView, NSInteger index) {
        
        [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
        
    }];
    // 自定义标题的样式
    segment.layer.cornerRadius = 14.0;
    segment.backgroundColor = [UIColor redColor];
    // 当然推荐直接设置背景图片的方式
//    segment.backgroundImage = [UIImage imageNamed:@"extraBtnBackgroundImage"];
    
    self.segmentView = segment;
    self.navigationItem.titleView = self.segmentView;
    
}

- (void)setupContentView {
    
    SFContentView *content = [[SFContentView alloc] initWithFrame:CGRectMake(0.0, SF_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - SF_StatusBarAndNavigationBarHeight) segmentView:self.segmentView parentViewController:self delegate:self];
    self.contentView = content;
    [self.view addSubview:self.contentView];
    
}

- (NSArray *)setupChildVc {
    
    SFTestViewController *vc1 = [SFTestViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    
    SFTestViewController *vc2 = [SFTestViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    
    NSArray *childVcs = [NSArray arrayWithObjects:vc2, vc1, nil];
    return childVcs;
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}




- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = self.childVcs[index];
    }
    
    return childVc;
}


-(CGRect)frameOfChildControllerForContainer:(UIView *)containerView {
    return  CGRectInset(containerView.bounds, 20, 20);
}
@end
