//
//  SFDetailViewController.m
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/29.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "SFDetailViewController.h"

@interface SFDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *navigationBackView;

@end

@implementation SFDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.navigationAndStatuHeight)];
    navigationView.backgroundColor = THEME_COLOR;
    navigationView.alpha = 0.0;
    [self.view addSubview:navigationView];
    self.navigationBackView = navigationView;
}
- (void)viewWillAppear:(BOOL)animated{
    self.type = NavigationTypeClean;
    [super viewWillAppear:animated];
}
- (UIView *)tableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, HEIGHT(100))];
    headerView.backgroundColor = [UIColor greenColor];
    return headerView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tableHeaderView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = [UIColor lightGrayColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据%ld",indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, HEIGHT(30))];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DEVICE_WIDTH-40, headerView.kaf_height)];
    headerLabel.text = @"tableView-section-header";
    headerLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
    headerLabel.textColor = THEME_COLOR;
    [headerView addSubview:headerLabel];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT(30);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset<0) {
        self.navigationBackView.alpha = 0.0;
    } else if (offset<self.navigationAndStatuHeight) {
        self.navigationBackView.alpha = offset/self.navigationAndStatuHeight;
    } else {
        self.navigationBackView.alpha = 1.0;
    }
}

@end
