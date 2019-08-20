//
//  TaskActivityViewController.m
//  TestAdA
//
//  Created by lurich on 2019/8/6.
//  Copyright © 2019 YX. All rights reserved.
//

#import "TaskActivityViewController.h"
#import "YXLaunchAdConst.h"
#import "TaskImageViewCell.h"
#import "TaskLabelViewCell.h"
#import "TaskActicityViewCell.h"
#import "TaskTableViewCell.h"
#import "SFTaskWebViewController.h"
#import "NSString+SFAES.h"
#import "NetTool.h"
#import "Network.h"
#import "SFInformationViewController.h"
#import "YXMotivationVideoManager.h"
#import "WXMiniAppViewController.h"
#import "GetTaskModel.h"
#import "YXLoading.h"
#import "MoneyDetailViewController.h"
#import "CouponDetailViewController.h"
#import "DiscountNumberViewController.h"
#import "SFAlertView.h"
#import "NSString+SFAES.h"
#import "UILabel+SFAdd.h"

#define TASK_THEME_COLOR  HColor(179, 29, 41, 1)
#define SOLT_KEY @"!@#_123_sda_12!_qwe_%!2_"
@interface TaskActivityViewController ()<UITableViewDelegate,UITableViewDataSource,YXMotivationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) YXMotivationVideoManager * motivationVideo;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) GetTaskModel *model;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, copy) NSString *taskID;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, assign) BOOL isVerify;

@end

@implementation TaskActivityViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getTaskNetWork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isVerify = NO;
    self.view.backgroundColor = TASK_THEME_COLOR;
    [[NSUserDefaults standardUserDefaults] setObject:self.channelID forKey:@"channel"];
    [[NSUserDefaults standardUserDefaults] setObject:self.vuid forKey:@"vuid"];
    // Do any additional setup after loading the view.
    [self createHeaderView];
    [self.view addSubview:self.tableView];
//    self.navigationController.navigationBar.backItem
}

- (void)createHeaderView{
    CGFloat navbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navStarBarHeight;
    if (self.navigationController) {
        if (self.navigationController.navigationBar.translucent) {
            navStarBarHeight = navbarHeight+44;
            if (self.navigationController.navigationBar.hidden) {
            }
        } else {
            if (self.navigationController.navigationBar.hidden) {
                navStarBarHeight = navbarHeight+44;
            } else {
                navStarBarHeight = 0;
            }
        }
    } else {
        navStarBarHeight = navbarHeight+44;
    }
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, navStarBarHeight, SF_ScreenW, HEIGHT(226))];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SF_ScreenW, HEIGHT(178))];
    headerImage.image = [UIImage imageNamed:@"XibAndPng.bundle/taskImage1"];
    [self.headerView addSubview:headerImage];
    UIView *headerBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT(178), SF_ScreenW, HEIGHT(48))];
    headerBottomView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:headerBottomView];
    NSArray *titleArray = @[@"活动介绍",@"金币任务",@"兑换示例",@"乘车示例"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *headerTab = [UIButton buttonWithType:UIButtonTypeCustom];
        headerTab.frame = CGRectMake(i*SF_ScreenW/4.0, 0, SF_ScreenW/4.0, HEIGHT(48));
        [headerTab setTitle:titleArray[i] forState:UIControlStateNormal];
        [headerTab setTitleColor:HColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [headerTab setTitleColor:HColor(193, 38, 41, 1) forState:UIControlStateSelected];
        headerTab.titleLabel.font = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightBold];
        headerTab.tag = 100+i;
        [headerTab addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerBottomView addSubview:headerTab];
        headerTab.selected = NO;
        if (i==0) {
            self.lastBtn = headerTab;
            headerTab.selected = YES;
        }
    }
    [self.view addSubview:self.headerView];
}
- (void)taskBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 200:
        {
            MoneyDetailViewController *vc = [MoneyDetailViewController new];
            vc.channelID = self.channelID;
            vc.vuid = self.vuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 201:
        {
            CouponDetailViewController *vc = [CouponDetailViewController new];
            vc.channelID = self.channelID;
            vc.vuid = self.vuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 202:
        {
            DiscountNumberViewController *vc = [DiscountNumberViewController new];
            vc.channelID = self.channelID;
            vc.vuid = self.vuid;
            vc.count = self.model.data.asset.use_count;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 203:
        {
            NSString *message;
            if (self.model.data.asset.balance<self.model.data.rate) {
                message = [NSString stringWithFormat:@"当前%ld金币，%ld金币可兑换一张乘车券，去做任务赚金币吧！",(long)self.model.data.asset.balance,(long)self.model.data.rate];
            } else {
                message = [NSString stringWithFormat:@"当前金币可以兑换%ld张一元乘车券，是否全部兑换？",self.model.data.asset.balance/self.model.data.rate];
            }
            SFAlertView *alert=[[SFAlertView alloc] initWithTitle:@"提示" message:message cancelBtnTitle:@"否" otherBtnTitle:@"是" clickIndexBlock:^(NSInteger clickIndex) {
                if (clickIndex==0) {
                    if (self.model.data.asset.balance<self.model.data.rate) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    } else {
                        [self goNetWorkExchangeCoupon];
//                        [self showAlertImageView];
                    }
                }
            }];
            //alert.dontDissmiss=YES;
            //设置动画类型(默认是缩放)
            //_alert.animationStyle=SFASAnimationTopShake;
            [alert showSFAlertView];
        }
            break;
            
        default:
            break;
    }
}
- (void)headerBtnClick:(UIButton *)sender{
    CGFloat section0Height = CGRectGetHeight([self.tableView rectForSection:0]);
    CGFloat section1Height = CGRectGetHeight([self.tableView rectForSection:1]);
    CGFloat section2Height = CGRectGetHeight([self.tableView rectForSection:2]);
    CGFloat section3Height = CGRectGetHeight([self.tableView rectForSection:3]);
    switch (sender.tag) {
        case 100:
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 101:
            [self.tableView setContentOffset:CGPointMake(0, (section0Height+section1Height+1)) animated:YES];
            break;
        case 102:
            [self.tableView setContentOffset:CGPointMake(0, (section0Height+section1Height+section2Height+1)) animated:YES];
            break;
        case 103:
            [self.tableView setContentOffset:CGPointMake(0, (section0Height+section1Height+section2Height+section3Height+1)) animated:YES];
            break;
            
        default:
            break;
    }
    self.lastBtn.selected = NO;
    sender.selected = YES;
    self.lastBtn = sender;
}
- (void)goNetWorkExchangeCoupon{
    self.channelID = self.channelID?self.channelID:@"";
    self.vuid = self.vuid?self.vuid:@"";
    NSString *timeStr = [NetTool getTimeLocal];
    NSString *signStr = [[NSString stringWithFormat:@"%@%@%@%@",self.channelID,self.vuid,timeStr,SOLT_KEY] sf_MD5EncryptString];
    NSDictionary *parameterDict = @{
                                    @"deviceType":@"1",
                                    @"osType":@"2",
                                    @"osVersion":[NetTool getOS],
                                    @"vendor":@"apple",
                                    @"brand":@"apple",
                                    @"model":[NetTool gettelModel],
                                    @"imei":@"",
                                    @"androidId":@"",
                                    @"idfa":[NetTool getIDFA],
                                    @"connectionType":@([NetTool getNetTyepe]),
                                    @"operateType":@([NetTool getYunYingShang]),
                                    };
    [Network postJSONDataWithURL:[NSString stringWithFormat:@"%@/user/exchangeVoucher?channel=%@&vuid=%@&ts=%@&sign=%@",TASK_SEVERIN,self.channelID,self.vuid,timeStr,signStr] parameters:parameterDict success:^(id json) {
        NSString *code = [NSString stringWithFormat:@"%@",json[@"code"]];
        if ([code isEqualToString:@"200"]) {
//            NSString *data = [NSString stringWithFormat:@"%@",json[@"data"]];
            [self showAlertImageView];
        } else {
            NSLog(@"接口请求失败 error = %@",json[@"msg"]);
        }
    } fail:^(NSError *error) {
        NSLog(@"网络错误 error = %@",error);
    }];
}
- (void)goLookCoupon{
    [self dismissAlertWindow];
    CouponDetailViewController *vc = [CouponDetailViewController new];
    vc.channelID = self.channelID;
    vc.vuid = self.vuid;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dismissAlertWindow{
    [_alertWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _alertWindow.rootViewController = nil;
    [_alertWindow resignKeyWindow];
    [_alertWindow removeFromSuperview];
    _alertWindow = nil;
}
- (void)showAlertImageView{
    _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertWindow.windowLevel=UIWindowLevelAlert;
    [_alertWindow becomeKeyWindow];
    [_alertWindow makeKeyAndVisible];
    
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertWindow)]];
    [_alertWindow addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XibAndPng.bundle/alertbeijing"]];
    imageView.userInteractionEnabled = YES;
    imageView.bounds = CGRectMake(0, 0, 214, 161);
    imageView.center = backView.center;
    [backView addSubview:imageView];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, CGRectGetWidth(imageView.frame), 24)];
    name.text = @"恭喜";
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = HColor(255, 255, 255, 1);
    name.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
    [imageView addSubview:name];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame)+10, CGRectGetWidth(imageView.frame), 18)];
    desc.text = [NSString stringWithFormat:@"获得%ld张一元乘车券",self.model.data.asset.balance/self.model.data.rate];
    desc.textAlignment = NSTextAlignmentCenter;
    desc.textColor = HColor(255, 255, 255, 1);
    desc.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [imageView addSubview:desc];
    UIView *labelBackView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(imageView.frame)-135)/2.0, CGRectGetMaxY(desc.frame)+8, 135, 17)];
    labelBackView.backgroundColor=HColor(254, 253, 251, 0.6);
    [imageView addSubview:labelBackView];
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(labelBackView.frame), CGRectGetHeight(labelBackView.frame))];
    tips.text = [NSString stringWithFormat:@"您已拥有%ld张一元乘车券",self.model.data.asset.voucher_num+self.model.data.asset.balance/self.model.data.rate];
    tips.textAlignment = NSTextAlignmentCenter;
    tips.textColor = HColor(40, 39, 39, 1);
    tips.font = [UIFont systemFontOfSize:11 weight:UIFontWeightLight];
    [labelBackView addSubview:tips];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"XibAndPng.bundle/alertBtn"] forState:UIControlStateNormal];
    button.frame = CGRectMake((CGRectGetWidth(imageView.frame)-132)/2.0, CGRectGetHeight(imageView.frame)-60, 132, 44);
    [button addTarget:self action:@selector(goLookCoupon) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [imageView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [imageView.layer setValue:@(1.2) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.09 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [imageView.layer setValue:@(.9) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.02 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [imageView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SF_ScreenW, SF_ScreenH-CGRectGetMaxY(self.headerView.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = TASK_THEME_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tag = 999;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/TaskImageViewCell" bundle:nil] forCellReuseIdentifier:@"TaskImageViewCellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/TaskLabelViewCell" bundle:nil] forCellReuseIdentifier:@"TaskLabelViewCellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"XibAndPng.bundle/TaskActicityViewCell" bundle:nil] forCellReuseIdentifier:@"TaskActicityViewCellID"];
    }
    return _tableView;
}
- (UIView *)cellTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-30, HEIGHT(110))];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, HEIGHT(25), headerView.bounds.size.width-20, HEIGHT(20))];
    title.text = @"金币任务";
    title.font = [UIFont systemFontOfSize:HFont(18) weight:UIFontWeightBold];
    title.textColor = HColor(193, 38, 41, 1);
    [headerView addSubview:title];
    NSArray *descArray = @[@"总金币",@"乘车劵",@"优惠次数",@"去兑换"];
    NSArray *titleArray = @[@(self.model.data.asset.balance),@(self.model.data.asset.voucher_num),@(self.model.data.asset.use_count),@(0)];
    for (int i=0; i<descArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*headerView.bounds.size.width/4, HEIGHT(55), headerView.bounds.size.width/4, HEIGHT(30));
        if (i!=3) {
            [button setTitle:[NSString stringWithFormat:@"%@",titleArray[i]] forState:UIControlStateNormal];
        } else {
            [button setImage:[UIImage imageNamed:@"XibAndPng.bundle/duihuan"] forState:UIControlStateNormal];
        }
        [button setTitleColor:HColor(193, 38, 41, 1) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:HFont(23) weight:UIFontWeightMedium];
        button.tag = 200+i;
        [button addTarget:self action:@selector(taskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(i*headerView.bounds.size.width/4, CGRectGetMaxY(button.frame), headerView.bounds.size.width/4, HEIGHT(15))];
        desc.text = descArray[i];
        desc.textAlignment = NSTextAlignmentCenter;
        desc.font = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightRegular];
        desc.textColor = HColor(193, 38, 41, 1);
        [headerView addSubview:desc];
    }
    return headerView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==999) {
        return 5;
    } else {
        tableView.tableHeaderView = [self cellTableHeaderView];
        return self.model.data.data.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==999) {
        return 1;
    } else {
        GetTaskTypeModelData *typeModel = self.model.data.data[section];
        return typeModel.data.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==999) {
        switch (indexPath.section) {
            case 0:
            {
                TaskLabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskLabelViewCellID" forIndexPath:indexPath];
                if (self.model.data.announcement) {
                    cell.showCenterLabel.text = self.model.data.announcement;
                    cell.showCenterLabel.lineSpace = 2;
                    cell.showCenterLabel.characterSpace = 1;
                    cell.showCenterLabel.firstLineHeadIndent = cell.showCenterLabel.font.pointSize*2+2;
                    self.model.data.announcementHeight = [cell.showCenterLabel getLableRectWithMaxWidth:SF_ScreenW-40].height;
                }
                return cell;
            }
                break;
            case 1:
            {
                TaskImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskImageViewCellID" forIndexPath:indexPath];
                cell.showCenterImage.image = [UIImage imageNamed:@"XibAndPng.bundle/taskImage2"];
                return cell;
            }
                break;
            case 2:
            {
                TaskActicityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskActicityViewCellID" forIndexPath:indexPath];
                cell.activityTable.delegate = self;
                cell.activityTable.dataSource = self;
                [cell.activityTable reloadData];
                return cell;
            }
                break;
            case 3:
            {
                TaskImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskImageViewCellID" forIndexPath:indexPath];
                cell.showCenterImage.image = [UIImage imageNamed:@"XibAndPng.bundle/taskImage3"];
                return cell;
            }
                break;
            case 4:
            {
                TaskImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskImageViewCellID" forIndexPath:indexPath];
                cell.showCenterImage.image = [UIImage imageNamed:@"XibAndPng.bundle/taskImage4"];
                return cell;
            }
                break;
            default:
            {
                TaskImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskImageViewCellID" forIndexPath:indexPath];
                return cell;
            }
                break;
        }
    } else {
        TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCellID"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XibAndPng.bundle/TaskTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.goDoneBtn.tag = indexPath.section*10+10+indexPath.row;
        [cell.goDoneBtn addTarget:self action:@selector(goDoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        GetTaskTypeModelData *typeModel = self.model.data.data[indexPath.section];
        GetTaskDataModel *dataModel = typeModel.data[indexPath.row];
        cell.nameLabel.text = dataModel.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"+%@金币",dataModel.reward];
        cell.descLabel.text = dataModel.Desc;
        if (dataModel.max_completion_num == 1) {
            cell.countLabel.hidden = YES;
        } else {
            if (dataModel.infinite == 1) {
                cell.countLabel.text = @"不限次数";
            } else {
                cell.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)dataModel.completion_num,(long)dataModel.max_completion_num];
                if (dataModel.completion_num==0 && dataModel.max_completion_num!=0) {
                    cell.countLabel.text = [NSString stringWithFormat:@"每天限%ld次",(long)dataModel.max_completion_num];
                }
                if (dataModel.completion_num>=dataModel.max_completion_num && dataModel.max_completion_num!=0) {
                    cell.goDoneBtn.selected = YES;
                } else {
                    cell.goDoneBtn.selected = NO;
                }
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==999) {
        
    } else {
        
    }
}
- (void)goDoneBtnClick:(UIButton *)sender{
    NSInteger row = sender.tag%10;
    NSInteger section = sender.tag/10-1;
//    NSLog(@"section = %ld row = %ld",(long)section,(long)row);
    GetTaskTypeModelData *typeModel = self.model.data.data[section];
    GetTaskDataModel *dataModel = typeModel.data[row];
    switch (dataModel.execute_way) {//1=H5;2=SDK;3=站内
        case 1:
        {
            if (dataModel.url) {
                SFTaskWebViewController *webVc = [[SFTaskWebViewController alloc] init];
                webVc.urlStr = dataModel.url;
                [self.navigationController pushViewController:webVc animated:YES];
            } else {
                [YXLoading showStatus:@"暂无链接跳转"];
            }
        }
        break;
        case 2:
        {
            if ([dataModel.sdk_code isEqualToString:@"toutiao"]) {
                self.motivationVideo = [YXMotivationVideoManager new];
                self.motivationVideo.delegate = self;
                self.motivationVideo.showAdController = self;
                self.motivationVideo.mediaId = dataModel.media_id;
                self.taskID = [NSString stringWithFormat:@"%ld",(long)dataModel.ID];
                [self.motivationVideo loadVideoPlacement];
                [YXLoading showWithStatus:@"加载视频中"];
            } else if ([dataModel.sdk_code isEqualToString:@"midong"]) {
                WXMiniAppViewController *wxMini = [WXMiniAppViewController new];
                wxMini.cid = dataModel.app_id;
                wxMini.cuid = [NSString stringWithFormat:@"%@_%@",self.channelID,self.vuid];
                wxMini.key = dataModel.secret;
                [self.navigationController pushViewController:wxMini animated:YES];
            } else if ([dataModel.sdk_code isEqualToString:@"xianwan"]) {
                SFTaskWebViewController *webVc = [[SFTaskWebViewController alloc] init];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
                [dict setDictionary:@{
                                      @"ptype":@"1",
                                      @"deviceid":[NetTool getIDFA],
                                      @"appid":dataModel.app_id,
                                      @"appsign":[NSString stringWithFormat:@"%@_%@",self.channelID,self.vuid],
                                      }];
                NSString *keyCode = [NSString stringWithFormat:@"%@%@%@%@%@",dict[@"appid"],dict[@"deviceid"],dict[@"ptype"],dict[@"appsign"],dataModel.secret];
                keyCode = [keyCode sf_MD5EncryptString];
                [dict setObject:keyCode forKey:@"keycode"];
                NSString *urlStr = [NetTool urlStrWithDict:dict UrlStr:@"https://h5.51xianwan.com/try/iOS/try_list_ios.aspx"];
                webVc.urlStr = urlStr;
                [self.navigationController pushViewController:webVc animated:YES];
            }
        }
            break;
        case 3:
        {
            SFInformationViewController *infoVC = [SFInformationViewController new];
            infoVC.mLocationId = dataModel.location_id;
            infoVC.title = @"任务资讯";
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==999) {
        switch (indexPath.section) {
            case 0:
                return self.model.data.announcementHeight+40;
                break;
            case 1:
                return HEIGHT(223);
                break;
            case 2:
            {
                NSInteger count = 0;
                for (GetTaskTypeModelData *model in self.model.data.data) {
                    for (GetTaskDataModel *descModel in model.data) {
                        CGSize maximumLabelSize = CGSizeMake(SF_ScreenW-122, MAXFLOAT);//labelsize的最大值
                        CGRect expectRect = [descModel.Desc boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil];
                        if (expectRect.size.height>20) {
                            count = count + HEIGHT(95);
                            descModel.DescHeight = HEIGHT(95);
                        } else {
                            count = count + HEIGHT(75);
                            descModel.DescHeight = HEIGHT(75);
                        }
                    }
                }
                return HEIGHT(110)+HEIGHT(40)*self.model.data.data.count+count+35;
            }
                break;
            case 3:
                return HEIGHT(306);
                break;
            case 4:
                return HEIGHT(781);
                break;
                
            default:
                return 0;
                break;
        }
    } else {
        GetTaskTypeModelData *typeModel = self.model.data.data[indexPath.section];
        GetTaskDataModel *dataModel = typeModel.data[indexPath.row];
        return dataModel.DescHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag==999) {
        return [UIView new];
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT(40))];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, headerView.bounds.size.width-20, 1)];
        lineView.backgroundColor = HColor(247, 248, 249, 1);
        [headerView addSubview:lineView];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.bounds.size.width-20, HEIGHT(40))];
        GetTaskTypeModelData *dataModel = self.model.data.data[section];
        titleLabel.text = dataModel.name;
        titleLabel.textColor = HColor(161, 161, 161, 1);
        titleLabel.font = [UIFont systemFontOfSize:HFont(16) weight:UIFontWeightMedium];
        [headerView addSubview:titleLabel];
        return headerView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView.tag==999) {
        return [UIView new];
    } else {
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag==999) {
        return CGFLOAT_MIN;
    } else {
        return HEIGHT(40);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView.tag==999) {
        return CGFLOAT_MIN;
    } else {
        return CGFLOAT_MIN;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tableView = (UITableView *)scrollView;
    if (tableView.tag == 999) {
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat section0Height = CGRectGetHeight([tableView rectForSection:0]);
        CGFloat section1Height = CGRectGetHeight([tableView rectForSection:1]);
        CGFloat section2Height = CGRectGetHeight([tableView rectForSection:2]);
        CGFloat section3Height = CGRectGetHeight([tableView rectForSection:3]);
        if (offset>=(section0Height+section1Height+section2Height+section3Height)) {
            self.lastBtn.selected = NO;
            UIButton *sender = [self.headerView viewWithTag:103];
            sender.selected = YES;
            self.lastBtn = sender;
        } else if (offset>=(section0Height+section1Height+section2Height)) {
            self.lastBtn.selected = NO;
            UIButton *sender = [self.headerView viewWithTag:102];
            sender.selected = YES;
            self.lastBtn = sender;
        } else if (offset>=(section0Height+section1Height)) {
            self.lastBtn.selected = NO;
            UIButton *sender = [self.headerView viewWithTag:101];
            sender.selected = YES;
            self.lastBtn = sender;
        } else {
            self.lastBtn.selected = NO;
            UIButton *sender = [self.headerView viewWithTag:100];
            sender.selected = YES;
            self.lastBtn = sender;
        }
    }
}
#pragma mark - 激励视频delegate
/**
 adValid 激励视频广告-视频-加载成功
 @param adValid 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
- (void)rewardedVideoDidLoad:(BOOL)adValid{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"激励视频广告-视频-加载成功");
        [YXLoading dissmissProgress];
        self.isVerify = NO;
    });
}

/**
 adValid 广告位即将展示
 */
- (void)rewardedVideoWillVisible{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"广告位即将展示");
        [YXLoading dissmissProgress];
    });
}

/**
 adValid 广告位已经展示
 */
- (void)rewardedVideoDidVisible{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"广告位已经展示");
    });
}

/**
 adValid 激励视频广告即将关闭
 */
- (void)rewardedVideoWillClose{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"激励视频广告即将关闭");
    });
}

/**
 adValid 激励视频广告已经关闭
 */
- (void)rewardedVideoDidClose{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"激励视频广告已经关闭");
        if (self.isVerify) {
            [self updateVideoTaskNetWork];
        }
    });
}

/**
 adValid 激励视频广告点击下载
 
 @param adValid 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
- (void)rewardedVideoDidClick:(BOOL)adValid{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"激励视频广告点击下载");
    });
}

/**
 adValid 激励视频广告素材加载失败
 @param error 错误对象
 */
- (void)rewardedVideoDidFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"激励视频广告素材加载失败");
        self.isVerify = NO;
        [YXLoading showStatus:@"激励视频广告素材加载失败"];
    });
}

/**
 adValid 激励视频广告播放完成
 
 @param adValid 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
 */
- (void)rewardedVideoDidPlayFinish:(BOOL)adValid{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"激励视频广告播放完成");
    });
}

/**
 服务器校验后的结果,异步 adValid publisher 终端返回 20000
 @param verify 有效性验证结果
 */
- (void)rewardedVideoServerRewardDidSucceedVerify:(BOOL)verify{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *message = [NSString stringWithFormat:@"验证结果有效性->%d",verify];
//        NSLog(@"%@",message);
        [YXLoading dissmissProgress];
        if (verify) {
            self.isVerify = verify;
        }
    });
}

/**
 adValid publisher 终端返回非 20000
 @param error 错误对象
 */
- (void)rewardedVideoServerRewardDidFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"%@",[NSString stringWithFormat:@"终端返回错误->%@",error]);
        [YXLoading dissmissProgress];
    });
}

- (void)getTaskNetWork{
    [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/task/getTasks?channel=%@&vuid=%@",TASK_SEVERIN,self.channelID?self.channelID:@"",self.vuid?self.vuid:@""] parameters:nil success:^(id json) {
        self.model = [GetTaskModel SF_MJParse:json];
        if (self.model.code == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
        } else {
            NSLog(@"接口请求失败 error = %@",self.model.msg);
        }
    } fail:^(NSError *error) {
        NSLog(@"网络错误 error = %@",error);
    }];
}
- (void)updateVideoTaskNetWork{
    NSDictionary *parameterDict = @{
                                    @"deviceType":@"1",
                                    @"osType":@"2",
                                    @"osVersion":[NetTool getOS],
                                    @"vendor":@"apple",
                                    @"brand":@"apple",
                                    @"model":[NetTool gettelModel],
                                    @"imei":@"",
                                    @"androidId":@"",
                                    @"idfa":[NetTool getIDFA],
                                    @"connectionType":@([NetTool getNetTyepe]),
                                    @"operateType":@([NetTool getYunYingShang]),
                                    };
    NSDictionary *dict = @{
                           @"taskId":self.taskID?self.taskID:@"",
                           @"channel":self.channelID?self.channelID:@"",
                           @"vuid":self.vuid?self.vuid:@"",
                           @"orderId":[NSString stringWithFormat:@"%@%@",[NetTool getIDFA],[NetTool getTimeLocal]],
                           @"deviceInfo":parameterDict,
                           };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonBase64Str = [YXGTMBase64 stringByEncodingData:jsonData];
    NSString *signStr = [[NSString stringWithFormat:@"%@%@",jsonBase64Str,SOLT_KEY] sf_MD5EncryptString];
    if (signStr.length>=32) {
        signStr = [signStr substringWithRange:NSMakeRange(16, 16)];
    }
    [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/task/completed?info=%@&sign=%@",TASK_SEVERIN,jsonBase64Str?jsonBase64Str:@"",signStr?signStr:@""] parameters:nil success:^(id json) {
        NSString *code = [NSString stringWithFormat:@"%@",json[@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSString *data = [NSString stringWithFormat:@"%@",json[@"data"]];
            [YXLoading showMiddleStatus:data];
        } else {
            NSLog(@"接口请求失败 error = %@",json[@"msg"]);
        }
    } fail:^(NSError *error) {
        NSLog(@"网络错误 error = %@",error);
    }];
}

@end
