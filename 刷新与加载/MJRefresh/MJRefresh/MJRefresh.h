//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000

#import "UIScrollView+MJRefresh.h"
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"

#import "MJRefreshNormalHeader.h"
#import "MJRefreshGifHeader.h"

#import "MJRefreshBackNormalFooter.h"
#import "MJRefreshBackGifFooter.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshAutoGifFooter.h"
/*
 - (void)viewDidLoad {
 /*
 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊下拉刷新＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 //1.block刷新
 self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
 // 进入刷新状态后会自动调用这个block
 NSLog(@"正在刷新");
 [NSThread sleepForTimeInterval:3];
 [self.tableView.header endRefreshing];
 //    }];
 //2.调用方法刷新
 self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
 // 马上进入刷新状态
 [self.tableView.header beginRefreshing];
 //3.自定义刷新
 MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
 // 设置普通状态的动画图片
 [header setImages:@[@""] forState:MJRefreshStateIdle];
 // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
 [header setImages:@[@""] forState:MJRefreshStatePulling];
 // 设置正在刷新状态的动画图片
 [header setImages:@[@""] forState:MJRefreshStateRefreshing];
 // 设置header
 self.tableView.header = header;
 // 隐藏时间
 header.lastUpdatedTimeLabel.hidden = YES;
 // 隐藏状态
 header.stateLabel.hidden = YES;
 // 设置文字
 [header setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
 [header setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
 [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];
 // 设置字体
 header.stateLabel.font = [UIFont systemFontOfSize:15];
 header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
 
 // 设置颜色
 header.stateLabel.textColor = [UIColor redColor];
 header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
 
 //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊上拉加载＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
 //1.block块刷新
 self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
 // 进入刷新状态后会自动调用这个block
 NSLog(@"正在刷新");
 [NSThread sleepForTimeInterval:3];
 [self.tableView.footer endRefreshing];
 }];
 //2.调用方法刷新
 self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 //自动回弹的上拉加载
 self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 //3.自定义刷新
 // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
 MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 
 // 设置刷新图片
 [footer setImages:@[@""] forState:MJRefreshStateRefreshing];
 
 // 设置尾部
 self.tableView.footer = footer;
 // 隐藏刷新状态的文字
 footer.refreshingTitleHidden = YES;
 // 如果没有上面的方法，就用footer.stateLabel.hidden = YES;
 //当全部加载完毕时 变为没有更多数据的状态
 [footer noticeNoMoreData];
 // 设置文字
 [footer setTitle:@"Click or drag up to refresh" forState:MJRefreshStateIdle];
 [footer setTitle:@"Loading more ..." forState:MJRefreshStateRefreshing];
 [footer setTitle:@"No more data" forState:MJRefreshStateNoMoreData];
 
 // 设置字体
 footer.stateLabel.font = [UIFont systemFontOfSize:17];
 
 // 设置颜色
 footer.stateLabel.textColor = [UIColor blueColor];
 // 隐藏当前的上拉刷新控件
 self.tableView.footer.hidden = YES;
 
 ////////////////////自动回弹的上拉加载//////////////////////////
 
 MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 
 // 设置普通状态的动画图片
 [footer setImages:idleImages forState:MJRefreshStateIdle];
 // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
 [footer setImages:pullingImages forState:MJRefreshStatePulling];
 // 设置正在刷新状态的动画图片
 [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
 
 // 设置尾部
 self.tableView.footer = footer;

}
- (void)loadNewData{
    NSLog(@"下拉刷新");
    [NSThread sleepForTimeInterval:3];
    [self.tableView.header endRefreshing];
}
- (void)loadMoreData{
    NSLog(@"上拉加载");
    [NSThread sleepForTimeInterval:3];
    [self.tableView.footer endRefreshing];
}
 */