//
//  WXMiniAppViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/8.
//  Copyright © 2019 YX. All rights reserved.
//

#import "WXMiniAppViewController.h"
#import "Network.h"
#import "NetTool.h"
#import "NSObject+SF_MJParse.h"
#import "WXMiniAppModel.h"
#import "WXMiniAppViewCell.h"
#import "YXLaunchAdConst.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"
#import "NSString+SFAES.h"

@interface WXMiniAppViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WXMiniAppModel *model;

@end

@implementation WXMiniAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信任务";
    self.view.backgroundColor = HColor(255, 102, 26, 1);
    // Do any additional setup after loading the view.
    [self getNetWorkData];
    [self.view addSubview:self.tableView];
}
- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.backgroundColor = HColor(255, 102, 26, 1);
        _tableView.dataSource = self;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
//        _tableView.separatorColor = HColor(224, 224, 224, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [self tableViewHeaderView];
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/WXMiniAppViewCell" bundle:nil] forCellReuseIdentifier:@"WXMiniAppViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXMiniAppViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXMiniAppViewCellID" forIndexPath:indexPath];
    WXMiniAppModelData *model = self.model.data[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    cell.titleLabel.text = model.name;
    cell.descLabel.text = model.Desc;
    cell.contentLabel.text = [NSString stringWithFormat:@"+%.0f%@",model.price,model.exdw];
    cell.backView.layer.masksToBounds = YES;
    cell.backView.layer.cornerRadius = 0;
    cell.lineView.hidden = NO;
    if (indexPath.row==0) {
        if (@available(iOS 11.0, *)) {
            cell.backView.layer.cornerRadius = 8;
            cell.backView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        }
    }
    if (indexPath.row==self.model.data.count-1) {
        if (@available(iOS 11.0, *)) {
            cell.backView.layer.cornerRadius = 8;
            cell.backView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        }
        cell.lineView.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WXMiniAppModelData *model = self.model.data[indexPath.row];
    NSString * miniPath = [NSString stringWithFormat:@"%@",model.jumpurl];
    miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *miniProgramOriginId = [NSString stringWithFormat:@"%@",model.miniProgramId];
    
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = miniProgramOriginId;  //拉起的小程序的username
    launchMiniProgramReq.path = miniPath;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    
    BOOL installWe = [WXApi isWXAppInstalled];
    if (installWe) {
        [WXApi sendReq:launchMiniProgramReq];
    }else{
        NSLog(@"未安装微信");
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT(110);
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setDictionary:@{
//                          @"type":@"",//类型 0=公众号 1=小程序 不传默认返回全部
//                          @"status":@"",//类型 0=签到任务 1=普通任务 2=分享任务（也叫高额任务） 不传该字段返回全部
                          @"cid":self.cid,//渠道标识 幂动广告提供
                          @"cuid":self.cuid,//合作方用户id
                          @"deviceid":[NetTool getIDFA],//用户设备码(安卓=IMEI,IOS=IDFA,小程序=传openid)
                          @"osversion":[NetTool getOS],//操作系统版本
                          @"phonemodel":[NetTool gettelModel],//手机型号
                          @"time":[NetTool getTimeLocal],//时间戳
                          @"pageSize":@"",//分頁大小（默認 30）
                          @"pageNo":@"",//第幾頁（默認 1
                          @"userIP":[NetTool getDeviceIPAdress],//用户ip
                          @"bundleid":[NetTool getPackageName],//bundleID
                          }];
    NSString *keyCode = [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@%@",dict[@"cid"],dict[@"cuid"],dict[@"deviceid"],dict[@"osversion"],dict[@"phonemodel"],dict[@"time"],self.key];
    keyCode = [keyCode sf_MD5EncryptString];
    [dict setObject:keyCode forKey:@"sign"];
    NSString *urlStr = [NetTool urlStrWithDict:dict UrlStr:@"https://ad.midongtech.com/api/ads/minilist"];
    [Network getJSONDataWithURL:urlStr parameters:nil success:^(id json) {
        self.model = [WXMiniAppModel SF_MJParse:json];
        if (self.model.code == 1) {
            if (self.model.data.count>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        } else {
            NSLog(@"接口返回错误 error message = %@",self.model.msg);
        }
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败 error = %@",error);
    }];
}

@end
