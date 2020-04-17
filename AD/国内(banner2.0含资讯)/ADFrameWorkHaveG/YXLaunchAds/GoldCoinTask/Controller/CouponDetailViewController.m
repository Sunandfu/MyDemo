//
//  CouponDetailViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "CouponDetailViewCell.h"
#import "CouponDetailModel.h"

@interface CouponDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CouponDetailModel *model;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可用优惠乘车劵";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self tableViewBottomView]];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self getNetWorkData];
}
- (UIView *)tableViewBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.view.bounds.size.width, 35)];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SF_ScreenW-40, 35)];
    desc.text = @"优惠券有效期一年，请尽快乘车使用";
    self.tipsLabel = desc;
    desc.textAlignment = NSTextAlignmentCenter;
    desc.textColor = HColor(102, 102, 102, 1);
    desc.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [bottomView addSubview:desc];
    return bottomView;
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    return headerView;
}
- (UIView *)tableViewFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    return footerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-35) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewFooterView];
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/CouponDetailViewCell" bundle:nil] forCellReuseIdentifier:@"CouponDetailViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.vouchers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponDetailViewCellID" forIndexPath:indexPath];
    CouponDetailModelVouchers *model = self.model.data.vouchers[indexPath.row];
    cell.leftLabel.text = [NSString stringWithFormat:@"%ld元",model.voucher_value];
    cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.voucher_name];
    cell.timeLabel.text = model.expire_time;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)getNetWorkData{
    __weak typeof(self) weakSelf = self;
    [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/user/getUserVoucherDetail?channel=%@&vuid=%@",TASK_SEVERIN,self.channelID?self.channelID:@"",self.vuid?self.vuid:@""] parameters:nil success:^(id json) {
        weakSelf.model = [CouponDetailModel SF_MJParse:json];
        if (weakSelf.model.code == 200) {
            weakSelf.tipsLabel.text = weakSelf.model.data.tips;
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"接口请求失败 message = %@",weakSelf.model.msg);
        }
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败 error=%@",error);
    }];
}

@end
