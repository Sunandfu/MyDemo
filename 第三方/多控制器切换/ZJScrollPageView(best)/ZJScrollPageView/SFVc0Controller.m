//
//  SFVc8Controller.m
//  SFScrollPageView
//
//  Created by ZeroJ on 16/7/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFVc0Controller.h"
#import "SFScrollPageView.h"
#import "SFPageController.h"
#import "UIView+SFFrame.h"
#import "SFCollectionController.h"
#import "SFTableViewController.h"
static CGFloat const segmentViewHeight = 44.0;
static CGFloat const headViewHeight = 200.0;

@interface SFVc0Controller ()<SFScrollPageViewDelegate, UIScrollViewDelegate, PageTableViewDelegate> {
    CGFloat _childOffsetY;
    //    CGFloat _currentOffsetY;
    
}
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)SFPageController<SFScrollPageViewChildVcDelegate> *currentChildVc;
@property(strong, nonatomic)UIView *containerView;
@property (strong, nonatomic) SFScrollSegmentView *segmentView;
@property (strong, nonatomic) SFContentView *contentView;
@property(strong, nonatomic)UIView *headView;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(assign, nonatomic)CGFloat currentOffsetY;

@end

@implementation SFVc0Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self commonSet];
    [self addSubviews];
    // 模拟信息加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.headView.bounds.size.width, self.headView.bounds.size.height)];
        [btn setBackgroundImage:[UIImage imageNamed:@"fruit"] forState:UIControlStateNormal];
        [self.headView addSubview:btn];
    });
    
}


- (void)commonSet {
    self.currentOffsetY = 0.0;
    _childOffsetY = -segmentViewHeight + SF_StatusBarAndNavigationBarHeight + headViewHeight;
}
- (void)addSubviews {
    [self.view addSubview:self.containerView];
    // 先添加contentView
    [self.containerView addSubview:self.contentView];
    // 这个scrollView是为了headView能够滑动
    [self.scrollView addSubview:self.headView];
    // 在添加headView
    [self.containerView addSubview:self.scrollView];
    // 在添加segmentView
    [self.containerView addSubview:self.segmentView];
}


#pragma scrollViewDelegate 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.currentOffsetY = scrollView.contentOffset.y;
    self.headView.sf_y = self.currentOffsetY;
    
    if (self.currentOffsetY < 0) {
        self.containerView.sf_y = -self.currentOffsetY;
        return;
    } else {
        self.containerView.sf_y = 0;
        
    }
    
    if (_currentChildVc.scrollView.contentOffset.y == self.currentOffsetY - segmentViewHeight + SF_StatusBarAndNavigationBarHeight + headViewHeight) {
        return;
    }
    
    [_currentChildVc.scrollView setContentOffset:CGPointMake(0, self.currentOffsetY - segmentViewHeight + SF_StatusBarAndNavigationBarHeight + headViewHeight)];
}

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
    _childOffsetY = scrollView.contentOffset.y;
    self.currentOffsetY = _childOffsetY + segmentViewHeight + SF_StatusBarAndNavigationBarHeight + headViewHeight;
    
    //    NSLog(@"%f", _currentOffsetY);
    
    if (self.currentOffsetY <= 0 ) {// 让headView停在navigationBar下面
        self.segmentView.sf_y = -_childOffsetY - segmentViewHeight;
        self.scrollView.sf_y = self.segmentView.sf_y - headViewHeight;
        
    }
    else if (self.currentOffsetY>=headViewHeight) {
        // 使滑块停在navigationBar下面
        self.scrollView.sf_y = SF_StatusBarAndNavigationBarHeight - headViewHeight;
        self.segmentView.sf_y = SF_StatusBarAndNavigationBarHeight;
        
    }
    
    else {
        // 这里是让滑块和headView随着上下滚动
        self.segmentView.sf_y = -_childOffsetY - segmentViewHeight;
        self.scrollView.sf_y = self.segmentView.sf_y - headViewHeight;
        // "递归"
        if (self.scrollView.contentOffset.y == self.currentOffsetY) {
            return;
        }
        [self.scrollView setContentOffset:CGPointMake(0, self.currentOffsetY)];
        
    }
    
    
}

- (void)setupScrollViewOffSetYWhenViewWillAppear:(UIScrollView *)scrollView {
    
    
    if (self.segmentView.sf_y<=SF_StatusBarAndNavigationBarHeight) {
        if (scrollView.contentOffset.y < -(SF_StatusBarAndNavigationBarHeight + segmentViewHeight)) {
            [scrollView setContentOffset:CGPointMake(0, -(SF_StatusBarAndNavigationBarHeight + segmentViewHeight))];
            
        } else {
            
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
        }
        
    } else {
        [scrollView setContentOffset:CGPointMake(0, -(CGRectGetMaxY(self.segmentView.frame)))];
        
    }
    _childOffsetY = scrollView.contentOffset.y;
    [scrollView setContentSize:CGSizeMake(0, MAX(scrollView.bounds.size.height - SF_StatusBarAndNavigationBarHeight - segmentViewHeight, scrollView.contentSize.height))];
    
    
    
}


#pragma SFScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    // 可以在这里为每个childVc设置title, 然后就可以在相应的childVc里面通过 viewDidLoad加载初始数据
    if (!childVc) {
        if (index%2==0) {
            childVc = [[SFTableViewController alloc] init];
            // 触发viewDidLoad
            childVc.view.backgroundColor = [UIColor blueColor];
        } else {
            childVc = [[SFCollectionController alloc] init];
            
            childVc.view.backgroundColor = [UIColor redColor];
            
        }
        
    }
    
    
    // 设置代理, 用于处理子控制器的滚动
    _currentChildVc = (SFPageController *)childVc;
    _currentChildVc.delegate = self;
    return childVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SFScrollSegmentView *)segmentView {
    if (_segmentView == nil) {
        SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
        style.showCover = YES;
        // 渐变
        style.gradualChangeTitleColor = YES;
        // 遮盖背景颜色
        style.coverBackgroundColor = [UIColor whiteColor];
        //标题一般状态颜色 --- 注意一定要使用RGB空间的颜色值
        style.normalTitleColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        //标题选中状态颜色 --- 注意一定要使用RGB空间的颜色值
        style.selectedTitleColor = [UIColor colorWithRed:235.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        
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
        
        // 注意: 一定要避免循环引用!!
        __weak typeof(self) weakSelf = self;
        SFScrollSegmentView *segment = [[SFScrollSegmentView alloc] initWithFrame:CGRectMake(0, SF_StatusBarAndNavigationBarHeight + headViewHeight, self.view.bounds.size.width, segmentViewHeight) segmentStyle:style delegate:self titles:self.titles titleDidClick:^(SFTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            
        }];
        segment.backgroundColor = [UIColor lightGrayColor];
        _segmentView = segment;
        
    }
    return _segmentView;
}

- (SFContentView *)contentView {
    if (_contentView == nil) {
        SFContentView *content = [[SFContentView alloc] initWithFrame:self.view.bounds segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headViewHeight)];
        
        _headView.backgroundColor = [UIColor greenColor];
    }
    
    return _headView;
}


@end

