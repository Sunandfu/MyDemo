//
//  TableHalfViewController.m
//  TestAdA
//
//  Created by lurich on 2019/5/7.
//  Copyright © 2019 YX. All rights reserved.
//

#import "TableHalfViewController.h"
#import "YXFeedAdTableViewCell.h"
#import <YXLaunchAds/YXLaunchAds.h>

//竖屏幕宽高
#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//IPhoneX IPhoneXS 的逻辑分辨率相同
#define IPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)

//IPhoneXR IPhoneXSMax 的逻辑分辨率相同
#define IPhoneXR CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size)

//导航栏
#define StatusBarHeight ((IPhoneX || IPhoneXR) ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight ((IPhoneX || IPhoneXR) ? 88.f : 64.f)
#define TabbarHeight ((IPhoneX || IPhoneXR) ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight ((IPhoneX || IPhoneXR) ? (34.f) : (0.f))

@interface SFTableView : UITableView

@end

@implementation SFTableView

/// 返回YES同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end

@interface TableHalfViewController () <UIScrollViewDelegate,SFHalfPageControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SFTableView *tableView;
@property (nonatomic, strong) SFHalfPageViewController *webVC;

@property (nonatomic,assign) BOOL canScroll;

@end

@implementation TableHalfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.canScroll = YES;
    // Do any additional setup after loading the view.
    [self addChildViewController:self.webVC];
    [self.view addSubview:self.tableView];
    
    //添加请求数据的 HUD 开始请求推荐数据
    [self.webVC refreshNewsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:LEAVETOPNOTIFITION object:nil];
    
}
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.webVC.vcCanScroll = NO;
}
- (SFHalfPageViewController *)webVC{
    if (_webVC == nil) {
        _webVC = [[SFHalfPageViewController alloc] init];
        _webVC.mediaId = @"4";
        _webVC.mLocationId = @"3";
        _webVC.vcCanScroll = NO;
        _webVC.halfDelegate = self;
        _webVC.isShowAllChannels = self.isShowAll;
    }
    return _webVC;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = 300 - StatusBarAndNavigationBarHeight;
    if (offset >= bottomCellOffset) {
        self.tableView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.webVC.vcCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
//    if (self.tableView) {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:0]]; NSLog(@"cell=%@***%@",NSStringFromCGRect(cell.contentView.bounds),NSStringFromCGSize(self.tableView.contentSize));
//    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}
- (UIView *)tableViewHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    UILabel *label = [[UILabel alloc] initWithFrame:headView.bounds];
    label.text = @"这是header~~~~~~~~~~~~~~";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [headView addSubview:label];
    headView.backgroundColor = [UIColor greenColor];
    return headView;
}

- (SFTableView *)tableView{
    if(!_tableView){
        _tableView = [[SFTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = self.view.bounds.size.height;
        _tableView.tableHeaderView = [self tableViewHeaderView];
        [_tableView registerNib:[UINib nibWithNibName:@"YXFeedAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFeedAdTableViewCell"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXFeedAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXFeedAdTableViewCell" forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.webVC.view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    cell.costomView = self.webVC.view;
    return cell;
}
#pragma mark - SFPageViewControllerDelegate
- (void)newsDataRefreshSuccess{
    NSLog(@"数据加载成功");
}
- (void)newsDataRefreshFail:(NSError *)error{
    NSLog(@"数据加载失败，error = %@",error);
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}

@end

