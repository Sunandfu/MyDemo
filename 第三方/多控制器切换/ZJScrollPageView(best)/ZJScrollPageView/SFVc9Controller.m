//
//  SFVcController.m
//  SFScrollPageView
//
//  Created by ZeroJ on 16/8/31.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFVc9Controller.h"
#import "SFScrollPageView.h"
#import "SFPageTableViewController.h"
#import "SFPageCollectionViewController.h"
#import "MJRefresh/MJRefresh.h"
static CGFloat const segmentViewHeight = 44.0;
static CGFloat const headViewHeight = 200.0;

NSString *const SFParentTableViewDidLeaveFromTopNotification = @"SFParentTableViewDidLeaveFromTopNotification";


@interface SFCustomGestureTableView : UITableView

@end

@implementation SFCustomGestureTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
@end

@interface SFVc9Controller ()<SFScrollPageViewDelegate, SFPageViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) SFScrollSegmentView *segmentView;
@property (strong, nonatomic) SFContentView *contentView;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UIScrollView *childScrollView;
@property (strong, nonatomic) SFCustomGestureTableView *tableView;

@end

static NSString * const cellID = @"cellID";

@implementation SFVc9Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微博个人页面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakself = self;
    
    /// 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            typeof(weakself) strongSelf = weakself;
            [strongSelf.tableView.mj_header endRefreshing];
        });
    }];

}


#pragma SFScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        if (index%2==0) {
            childVc = [[SFPageTableViewController alloc] init];
            SFPageTableViewController *vc = (SFPageTableViewController *)childVc;
            vc.delegate = self;
        } else {
            childVc = [[SFPageCollectionViewController alloc] init];
            SFPageCollectionViewController *vc = (SFPageCollectionViewController *)childVc;
            vc.delegate = self;
            
        }
        
    }
    return childVc;
}


#pragma mark- SFPageViewControllerDelegate

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView {
    _childScrollView = scrollView;
    if (self.tableView.contentOffset.y < headViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }
    else {
        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
    
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childScrollView && _childScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0.0f, headViewHeight);
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < headViewHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SFParentTableViewDidLeaveFromTopNotification object:nil];

    }
}

#pragma mark- UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.contentView];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

#pragma mark- setter getter
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
        UILabel *label = [[UILabel alloc] initWithFrame:_headView.bounds];
        label.text = @"这是header~~~~~~~~~~~~~~";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
        [_headView addSubview:label];
        _headView.backgroundColor = [UIColor greenColor];
    }
    
    return _headView;
}

- (SFCustomGestureTableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0.0f, SF_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height);
        SFCustomGestureTableView *tableView = [[SFCustomGestureTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        // 设置tableView的headView
        tableView.tableHeaderView = self.headView;
        tableView.tableFooterView = [UIView new];
        // 设置cell行高为contentView的高度
        tableView.rowHeight = self.contentView.bounds.size.height;
        tableView.delegate = self;
        tableView.dataSource = self;
        // 设置tableView的sectionHeadHeight为segmentViewHeight
        tableView.sectionHeaderHeight = segmentViewHeight;
        tableView.showsVerticalScrollIndicator = false;
        _tableView = tableView;
    }
    
    return _tableView;
}

@end





