//
//  SFHalfPageViewController.m
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import "XMHalfPageViewController.h"
#import "FeedMessageTableViewCellOne.h"
#import "FeedMessageTableViewCellTwo.h"
#import "Network.h"
#import "NetTool.h"
#import "YXReachability.h"
#import "MJRefresh.h"
#import "YXWebViewController.h"
#import "SFInformationViewController.h"
#import "UIView+SFFrame.h"
#import "SFScrollPageView.h"
#import "SFPageTableViewController.h"
#import "YXLaunchConfiguration.h"

@interface XMHalfPageViewController ()<SFScrollPageViewDelegate, SFPageTableControllerDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL isShow;
    BOOL isLeftRight;
}

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) SFScrollSegmentView *segmentView;
@property (strong, nonatomic) SFContentView *contentView;
@property (nonatomic, strong) UILabel *showHeaderLabel;

@end

@implementation XMHalfPageViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.showLine = NO;
        isShow = NO;
        self.scrollLineColor = [UIColor colorWithRed:56/255.0 green:119/255.0 blue:208/255.0 alpha:1.0];
        self.showDemarcationLine = YES;
        self.scrollDemarcationLineColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        self.scrollLineHeight = 1;
        self.titleMargin = 24;
        self.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        self.titleBigScale = 1.2;
        self.normalTitleColor = [UIColor colorWithRed:130/255.0 green:138/255.0 blue:148/255.0 alpha:1.0];
        self.selectedTitleColor = [UIColor colorWithRed:56/255.0 green:119/255.0 blue:208/255.0 alpha:1.0];
        self.headerViewHeight = 44;
        self.titleArray = [NSMutableArray arrayWithCapacity:0];
        self.backGroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSuccess) name:@"getDataSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail) name:@"getDataFail" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerViewHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.segmentView];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        if (self.navigationController) {
            _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-SF_StatusBarAndNavigationBarHeight);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = self.view.bounds.size.height;
        _tableView.scrollEnabled = NO;
        
        UIView *footerView = [[UIView alloc] initWithFrame:_tableView.bounds];
        footerView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 311)];
        imageView.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_pic"];
        imageView.center = footerView.center;
        [footerView addSubview:imageView];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}
- (void)refreshNewsData{
    if (self.mediaId==nil || self.mLocationId==nil) {
        NSLog(@"请正确传入媒体位与广告位");
        return;
    }
    UIView *view = [self.view viewWithTag:98765];
    if (view) {
        [view removeFromSuperview];
    }
    if ([NetTool getNetTyepe] == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-SF_StatusBarAndNavigationBarHeight)];
        footerView.tag = 98765;
        footerView.backgroundColor = [UIColor whiteColor];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.bounds.size.width, 30)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"当前网络不可用，请检查你的网络设置";
        label1.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [footerView addSubview:label1];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 311)];
        imageView.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_pic"];
        imageView.center = footerView.center;
        [footerView addSubview:imageView];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, footerView.bounds.size.height-30, footerView.bounds.size.width, 30)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"点击页面进行刷新";
        label2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [footerView addSubview:label2];
        [footerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewClick)]];
        [self.view addSubview:footerView];
    } else {
        __weak typeof(self) weakSelf = self;
        [self.titleArray removeAllObjects];
        [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/social/getYdFeedCatIds?userId=%@&mLocationId=%@",TASK_SEVERIN,self.mediaId,self.mLocationId] parameters:nil success:^(id json) {
            if ([json isKindOfClass:[NSArray class]]) {
                if (weakSelf.isShowAllChannels) {
                    weakSelf.titleArray = [NSMutableArray arrayWithArray:json];
                } else {
                    [weakSelf.titleArray addObject:[json firstObject]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.tableView) {
                        [weakSelf.tableView removeFromSuperview];
                        weakSelf.tableView = nil;
                        [weakSelf.segmentView removeFromSuperview];
                        weakSelf.segmentView = nil;
                    }
                    [weakSelf.view addSubview:weakSelf.tableView];
                });
            }
        } fail:^(NSError *error) {
            NSLog(@"error = %@",error);
        }];
    }
}
- (void)backViewClick{
    [self refreshNewsData];
}

#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"democeshiID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"democeshiID"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView = nil;
    [cell.contentView addSubview:self.contentView];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self tableViewHeaderView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerViewHeight;
}

//- (void)dealloc{
//    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
//}


#pragma mark- setter getter
- (SFScrollSegmentView *)segmentView {
    if (_segmentView == nil && self.titleArray.count>0) {
        SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
        // 缩放标题
        style.scaleTitle = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.showLine = self.showLine;
        style.scrollLineColor = self.scrollLineColor;
        style.scrollLineHeight = self.scrollLineHeight;
        style.scrollDemarcationLineColor = self.scrollDemarcationLineColor;
        style.showDemarcationLine = self.showDemarcationLine;
        style.titleMargin = self.titleMargin;
        style.titleFont = self.titleFont;
        style.titleBigScale = self.titleBigScale;
        style.normalTitleColor = self.normalTitleColor;
        style.selectedTitleColor = self.selectedTitleColor;
        style.backGroundColor = self.backGroundColor;
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in self.titleArray) {
            [titles addObject:dict[@"ydCatName"]];
        }
        // 注意: 一定要避免循环引用!!
        __weak typeof(self) weakSelf = self;
        SFScrollSegmentView *segment = [[SFScrollSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.headerViewHeight) segmentStyle:style delegate:self titles:titles titleDidClick:^(SFTitleView *titleView, NSInteger index) {
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:YES];
            weakSelf.showHeaderLabel.text = [NSString stringWithFormat:@"%@资讯",weakSelf.titleArray[index][@"ydCatName"]];
        }];
        segment.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
#pragma SFScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titleArray.count;
}
- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    if (!childVc) {
        NSDictionary *dict = self.titleArray[index];
        childVc = [[SFPageTableViewController alloc] init];
        SFPageTableViewController *newChildVc = (SFPageTableViewController *)childVc;
        newChildVc.pageDelegate = self;
        newChildVc.title = dict[@"ydCatName"];
        newChildVc.titleArray = self.titleArray;
        newChildVc.mLocationId = self.mLocationId;
        newChildVc.segmentHeight = self.headerViewHeight;
        newChildVc.isInfo = NO;
    }
    return childVc;
}
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //    NSLog(@"%ld ---已经出现",index);
    NSDictionary *titleDict = self.titleArray[index];
    NSString *ydCatIdStr = titleDict[@"ydCatId"];
    [Network newsStatisticsWithType:1 NewsID:@"" CatID:ydCatIdStr lengthOfTime:0];
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //    NSLog(@"%ld ---将要消失",index);
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    //    NSLog(@"%ld ---已经消失",index);
    
}
- (void)getDataSuccess{
    if (self.halfDelegate && [self.halfDelegate respondsToSelector:@selector(newsDataRefreshSuccess)]) {
        [self.halfDelegate newsDataRefreshSuccess];
    }
}
- (void)getDataFail{
    if (self.halfDelegate && [self.halfDelegate respondsToSelector:@selector(newsDataRefreshFail:)]) {
        NSError *errors = [NSError errorWithDomain:@"网络请求失败" code:500 userInfo:nil];
        [self.halfDelegate newsDataRefreshFail:errors];
    }
}
-(void)dealloc{
    //    NSLog(@"视图销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

