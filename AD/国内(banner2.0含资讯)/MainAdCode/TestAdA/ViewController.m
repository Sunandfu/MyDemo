//
//  ViewController.m
//  LunchAd
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "ViewController.h"
#import "YXHalfLaunchScreenViewController.h"

#import "YXBannerViewController.h"

#import "YXFeedAdRegisterView.h"
#import "YXFeedAdViewController.h"
#import "YXNativeExpressAdController.h"
#import "YXLaunchScreenViewController.h"
#import "YXIconViewController.h"
#import "YXInterstitialViewController.h"
#import "YXScrollerBannerViewController.h"

#import "YXMotivationVideoViewController.h"
#import "SFInformationViewController.h"
#import "HalfViewController.h"
#import "TableHalfViewController.h"
#import "GDTSDKConfig.h"
#import "TestViewController.h"
#import "GraspMaterialViewController.h"
#import "TaskActivityViewController.h"
#import "SFNativeExpressAdManager.h"

#define YX_IPHONEX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"ADDemo";
    self.dataArr = @[@"轮播广告",@"原生信息流广告",@"原生模板广告",@"横幅广告",@"全屏开屏启动页样式",@"半屏开屏启动页样式",@"icon样式",@"插屏样式",@"激励视频",@"tableView半屏单频道资讯接入",@"tableView半屏全频道资讯接入",@"scrollView半屏单频道资讯接入",@"scrollView半屏全频道资讯接入",@"全屏资讯接入",@"抓素材",@"活动任务",@"测试通用链接",@"测试模板广告"];
    
    [self.view addSubview:self.tableView];
    
    NSLog(@"版本号：%@",[GDTSDKConfig sdkVersion]);
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView * tableView = [UITableView new];
            tableView.frame = ({
                CGRect frame;
                CGFloat y = 0;
                if (YX_IPHONEX) {
                    y = 88;
                }
                frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - y);
                frame;
            });
            tableView.rowHeight = 60;
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
            tableView;
        });
    }
    return _tableView;
}
static NSString * cellID = @"CELL";
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *titleStr = self.dataArr[indexPath.row];
    if ([titleStr isEqualToString:@"轮播广告"]) {
        [self.navigationController pushViewController:[YXScrollerBannerViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"原生信息流广告"]) {
        [self.navigationController pushViewController:[YXFeedAdViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"原生模板广告"]) {
        [self.navigationController pushViewController:[YXNativeExpressAdController new] animated:YES];
    } else if ([titleStr isEqualToString:@"横幅广告"]) {
        [self.navigationController pushViewController:[YXBannerViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"全屏开屏启动页样式"]) {
        [self.navigationController pushViewController:[YXLaunchScreenViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"半屏开屏启动页样式"]) {
        [self.navigationController pushViewController:[YXHalfLaunchScreenViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"icon样式"]) {
        [self.navigationController pushViewController:[YXIconViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"插屏样式"]) {
        [self.navigationController pushViewController:[YXInterstitialViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"激励视频"]) {
        [self.navigationController pushViewController:[YXMotivationVideoViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"tableView半屏单频道资讯接入"]) {
        TableHalfViewController *infoVC = [TableHalfViewController new];
        infoVC.isShowAll = NO;
        [self.navigationController pushViewController:infoVC animated:YES];
    } else if ([titleStr isEqualToString:@"tableView半屏全频道资讯接入"]) {
        TableHalfViewController *infoVC = [TableHalfViewController new];
        infoVC.isShowAll = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    } else if ([titleStr isEqualToString:@"scrollView半屏单频道资讯接入"]) {
        HalfViewController *infoVC = [HalfViewController new];
        infoVC.isShowAll = NO;
        [self.navigationController pushViewController:infoVC animated:YES];
    } else if ([titleStr isEqualToString:@"scrollView半屏全频道资讯接入"]) {
        HalfViewController *infoVC = [HalfViewController new];
        infoVC.isShowAll = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    } else if ([titleStr isEqualToString:@"全屏资讯接入"]) {
        SFInformationViewController *infoVC = [SFInformationViewController new];
        infoVC.mLocationId = @"ystios";
        infoVC.showLine = YES;
        infoVC.title = @"资讯";
        [self.navigationController pushViewController:infoVC animated:YES];
    } else if ([titleStr isEqualToString:@"活动任务"]) {
        TaskActivityViewController *task = [TaskActivityViewController new];
        task.channelID = @"t-i";
        task.vuid = @"1";
        [self.navigationController pushViewController:task animated:YES];
    } else if ([titleStr isEqualToString:@"测试通用链接"]) {
        [self.navigationController pushViewController:[TestViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"抓素材"]) {
        [self.navigationController pushViewController:[GraspMaterialViewController new] animated:YES];
    } else if ([titleStr isEqualToString:@"测试模板广告"]) {
//        SFNativeExpressAdManager *manager = [[SFNativeExpressAdManager alloc] init];
//        manager.adSize = YXADSize690X388;
//        manager.mediaId = @"dev_ios_templet";
//        manager.adCount = 4;
//        manager.controller = self;
//        manager.delegate = self;
//        [manager loadNativeExpressFeedAd];
//        [self.navigationController pushViewController:manager animated:YES];
    } else if ([titleStr isEqualToString:@""]) {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}


@end
