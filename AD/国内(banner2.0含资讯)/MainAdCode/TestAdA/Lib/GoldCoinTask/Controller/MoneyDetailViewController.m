//
//  MoneyDetailViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import "MoneyDetailViewController.h"
#import "MoneyDetailViewCell.h"
#import "MoneyDetailModel.h"

@interface MoneyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MoneyDetailModel *model;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.title= @"金币收入明细";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self tableViewBottomView]];
    __weak typeof(self) weakSelf = self;
    /// 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf getNetWorkDataWithPageIndex:weakSelf.pageIndex];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    /// 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex += 1;
        [weakSelf getNetWorkDataWithPageIndex:weakSelf.pageIndex];
    }];
//    footer.labelLeftInset = 20;
//    footer.automaticallyRefresh = NO;
//    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}
- (UIView *)tableViewBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-35, self.view.bounds.size.width, 35)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SF_ScreenW-40, 35)];
    desc.text = @"系统只保留最近3天的收入明细";
    self.tipsLabel = desc;
    desc.textAlignment = NSTextAlignmentCenter;
    desc.textColor = HColor(102, 102, 102, 1);
    desc.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [bottomView addSubview:desc];
    return bottomView;
}
- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 135)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 115)];
    imageView.image = [UIImage imageNamed:@"XibAndPng.bundle/jbsrmxHbi"];
    [headerView addSubview:imageView];
    CGFloat viewWidth = self.view.bounds.size.width/2.0-10;
    NSArray *nameArray = @[@"今日金币",@"总金币"];
    NSArray *priceArray;
    if (self.model) {
        priceArray = @[@(self.model.data.income_today),@(self.model.data.income_all)];
    } else {
        priceArray = @[@(0),@(0)];
    }
    for (int i=0; i<nameArray.count; i++) {
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(i*viewWidth, 25, viewWidth, 30)];
        name.text = nameArray[i];
        name.textAlignment = NSTextAlignmentCenter;
        name.textColor = HColor(255, 255, 255, 1);
        name.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        [imageView addSubview:name];
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(i*viewWidth, 60, viewWidth, 30)];
        desc.text = [NSString stringWithFormat:@"%@",priceArray[i]];
        desc.textAlignment = NSTextAlignmentCenter;
        desc.textColor = HColor(255, 255, 255, 1);
        desc.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
        [imageView addSubview:desc];
    }
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-35) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorColor = HColor(229, 229, 229, 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/MoneyDetailViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyDetailViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.pageIndex==1) {
        tableView.tableHeaderView = [self tableViewHeaderView];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyDetailViewCellID" forIndexPath:indexPath];
    MoneyDetailModelRecords *dataModel = self.dataArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.icon] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    cell.titleLabel.text = dataModel.Desc;
    cell.priceLabel.text = [NSString stringWithFormat:@"+%ld金币",(long)dataModel.num];
    cell.timeLabel.text = dataModel.time;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 43)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, SF_ScreenW-40, 17)];
    desc.text = @"明细";
    desc.textColor = HColor(27, 27, 27, 1);
    desc.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [headerView addSubview:desc];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)getNetWorkDataWithPageIndex:(NSInteger)page{
    __weak typeof(self) weakSelf = self;
    [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/user/getUserBalanceDetail?channel=%@&vuid=%@&page_index=%ld",TASK_SEVERIN,self.channelID?self.channelID:@"",self.vuid?self.vuid:@"",(long)page] parameters:nil success:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.model = [MoneyDetailModel SF_MJParse:json];
        if (weakSelf.model.code == 200) {
            if (page == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            weakSelf.tipsLabel.text = weakSelf.model.data.tips;
            [weakSelf.dataArray addObjectsFromArray:weakSelf.model.data.records];
            if (weakSelf.model.data.has_more==1) {
                [weakSelf.tableView.mj_footer endRefreshing];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"接口请求失败 message = %@",weakSelf.model.msg);
        }
    } fail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSLog(@"网络请求失败 error=%@",error);
    }];
}

@end
