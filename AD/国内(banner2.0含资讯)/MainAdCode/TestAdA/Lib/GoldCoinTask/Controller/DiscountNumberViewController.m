//
//  Discount DiscountNumberViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import "DiscountNumberViewController.h"
#import "CouponCountViewCell.h"
#import "DiscountNumberModel.h"

@interface DiscountNumberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) DiscountNumberModel *model;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DiscountNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex = 1;
    self.title = @"累计优惠乘车次数";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
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

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 135)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 115)];
    imageView.image = [UIImage imageNamed:@"XibAndPng.bundle/jbsrmxHbi"];
    [headerView addSubview:imageView];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, CGRectGetWidth(imageView.frame), 25)];
    name.text = @"累计优惠次数";
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = HColor(255, 255, 255, 1);
    name.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [imageView addSubview:name];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(imageView.frame), 55)];
    desc.text = [NSString stringWithFormat:@"%ld",self.count];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.textColor = HColor(255, 255, 255, 1);
    desc.font = [UIFont systemFontOfSize:43 weight:UIFontWeightBold];
    [imageView addSubview:desc];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 0;
//        _tableView.estimatedSectionHeaderHeight = 0;
//        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = HColor(229, 229, 229, 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/CouponCountViewCell" bundle:nil] forCellReuseIdentifier:@"CouponCountViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCountViewCellID" forIndexPath:indexPath];
    DiscountNumberModelRecords *dataModel = self.dataArray[indexPath.row];
    cell.nameLabel.text = dataModel.voucher_desc;
    cell.descLabel.text = [NSString stringWithFormat:@"%ld元%@",(long)dataModel.voucher_value,dataModel.voucher_name];
    cell.timeLabel.text = dataModel.use_time;
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
    [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/user/getDiscountDetail?channel=%@&vuid=%@&page_index=%ld",TASK_SEVERIN,self.channelID?self.channelID:@"",self.vuid?self.vuid:@"",page] parameters:nil success:^(id json) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            weakSelf.model = [DiscountNumberModel SF_MJParse:json];
            if (weakSelf.model.code == 200) {
                if (page == 1) {
                    [weakSelf.dataArray removeAllObjects];
                }
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
