//
//  SFChooseAppLogoViewController.m
//  ReadBook
//
//  Created by lurich on 2020/12/23.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFChooseAppLogoViewController.h"
#import "BaiduMobStatForSDK.h"
#import "SFTaskWebViewController.h"

@interface SFChooseAppLogoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SFChooseAppLogoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *selectedIconName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAppLogoName];
    [[BaiduMobStatForSDK defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",selectedIconName] withAppId:@"718527995f"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *selectedIconName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAppLogoName];
    [[BaiduMobStatForSDK defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",selectedIconName] withAppId:@"718527995f"];
}
- (void)viewDidLoad {
    self.title = @"更改APP图标";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"操作教程" style:UIBarButtonItemStyleDone target:self action:@selector(makingBookSourceTutorial)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.tableView.tableHeaderView = [self tableViewHeaderView];
    self.tableView.tableFooterView = [self tableViewFooterView];
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MIN)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return headerView;
}
- (UIView *)tableViewFooterView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *tipDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 30)];
    tipDetail.text = [NSString stringWithFormat:@"以上图标均为书友提供，如有侵权，请联系我删除！"];
    tipDetail.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    tipDetail.textColor = [SFTool colorWithHexString:@"#999999"];
    tipDetail.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:tipDetail];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewFooterView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"SFChooseAppLogoViewControllerCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Set up the cell.
    NSString *iconName = [NSString stringWithFormat:@"appLogo%ld",indexPath.section];
    cell.imageView.image = [UIImage imageNamed:iconName];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.textLabel.text = [NSString stringWithFormat:@"图标%ld",indexPath.section+1];
    NSString *selectedIconName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAppLogoName];
    if ([iconName isEqualToString:selectedIconName]) {
        cell.detailTextLabel.text = @"当前使用";
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *iconName = [NSString stringWithFormat:@"appLogo%ld",indexPath.section];
    [[NSUserDefaults standardUserDefaults] setObject:iconName forKey:KeyAppLogoName];
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        //不支持动态更换icon
        return;
    }
    if ([iconName isEqualToString:@""] || !iconName) {
        iconName = nil;
    }
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        } else {
        }
    }];
    [self.tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)makingBookSourceTutorial{
    [[BaiduMobStatForSDK defaultStat] logEvent:@"lookBookMakeClick" eventLabel:@"查看更换APP图标" withAppId:@"718527995f"];
    SFTaskWebViewController *taskVC = [[SFTaskWebViewController alloc] init];
    taskVC.URLString = @"https://shimo.im/docs/DJ66rYhVhgd6JXtw";
    [self.navigationController pushViewController:taskVC animated:YES];
}

@end
