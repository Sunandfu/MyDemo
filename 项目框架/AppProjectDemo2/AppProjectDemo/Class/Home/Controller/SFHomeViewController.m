//
//  SFHomeViewController.m
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import "SFHomeViewController.h"
#import "SFDetailViewController.h"
#import "SFLoginViewController.h"

@interface SFHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SFHomeViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
//    [self.view addSubview:self.navigationBackView];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.type = NavigationTypeBlack;
}
- (UIView *)tableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, HEIGHT(50))];
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
    cell.textLabel.text = @"测试数据";
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
    if (indexPath.row % 2 == 0) {
        [self.navigationController pushViewController:[SFDetailViewController new] animated:YES];
    } else {
        [self.navigationController pushViewController:[SFLoginViewController new] animated:YES];
    }
    
}

@end
