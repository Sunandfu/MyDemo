//
//  MainViewController.m
//  WMDemo
//
//  Created by jiacy on 2017/6/6.
//  Copyright © 2017年 bytedance. All rights reserved.
//

#import "WMDMainViewController.h"

#import "WMDActionCellDefine.h"
#import "WMDActionCellView.h"
#import "WMDBannerViewController.h"
#import "WMDFeedViewController.h"
#import "WMDInterstitialViewController.h"
#import "WMDNativeViewController.h"
#import "WMDSplashViewController.h"
#import "WMDSlotViewModel.h"
#import "WMDRewardedVideoAdViewController.h"
#import "WMDRewardVideoCusEventVC.h"
#import "WMDNativeBannerViewController.h"
#import "WMDNativeInterstitialViewController.h"
#import "WMDFullscreenViewController.h"

@interface WMDMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<WMDActionModel *> *items;
@end

@implementation WMDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Menu";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    Class plainActionCellClass = [WMDActionCellView class];
    [self.tableView registerClass:plainActionCellClass forCellReuseIdentifier:NSStringFromClass(plainActionCellClass)];
    
    WMDActionModel *item1 = [WMDActionModel plainTitleActionModel:@"Feed" action:^{
        WMDFeedViewController *vc = [WMDFeedViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546238";
        vc.viewModel = viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];

    WMDActionModel *item2 = [WMDActionModel plainTitleActionModel:@"Native" action:^{
        WMDNativeViewController *vc = [WMDNativeViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546910";
        vc.viewModel = viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *itemNativeBanner = [WMDActionModel plainTitleActionModel:@"Native Banner" action:^{
        WMDNativeBannerViewController *vc = [WMDNativeBannerViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546687";
        vc.viewModel = viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *itemNativeInterstitial = [WMDActionModel plainTitleActionModel:@"Native Interstitial" action:^{
        WMDNativeInterstitialViewController *vc = [WMDNativeInterstitialViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546829";
        vc.viewModel = viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *fullscreenItem = [WMDActionModel plainTitleActionModel:@"全屏视频" action:^{
        WMDFullscreenViewController *vc = [WMDFullscreenViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546299";
        vc.viewModel = viewModel;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *item3 = [WMDActionModel plainTitleActionModel:@"Banner" action:^{
        WMDBannerViewController *vc = [WMDBannerViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546859";
        vc.viewModel = viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *item4 = [WMDActionModel plainTitleActionModel:@"插屏广告" action:^{
        WMDInterstitialViewController *vc = [WMDInterstitialViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546957";
        vc.viewModel = viewModel;
        vc.view.backgroundColor = [UIColor whiteColor];
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *item5 = [WMDActionModel plainTitleActionModel:@"开屏广告" action:^{
        WMDSplashViewController *vc = [WMDSplashViewController new];
        vc.view.backgroundColor = [UIColor whiteColor];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"800546808";
        vc.viewModel = viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    WMDActionModel *item6 = [WMDActionModel plainTitleActionModel:@"激励视频" action:^{
        WMDRewardedVideoAdViewController *vc = [WMDRewardedVideoAdViewController new];
        WMDSlotViewModel *viewModel = [WMDSlotViewModel new];
        viewModel.slotID = @"900546421";
        vc.viewModel = viewModel;
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    WMDActionModel *item7 = [WMDActionModel plainTitleActionModel:@"激励视频（CustomEventAdapter）" action:^{
        WMDRewardVideoCusEventVC *vc = [WMDRewardVideoCusEventVC new];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.items = @[item1, item2, itemNativeBanner, itemNativeInterstitial, fullscreenItem, item3, item4, item5, item6, item7];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.items.count) {
        return [UITableViewCell new];
    }
    WMDActionModel *model = self.items[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMDActionCellView" forIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(WMDActionCellConfig)]) {
        [(id<WMDActionCellConfig>)cell configWithModel:model];
    } else {
        cell = [UITableViewCell new];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.items.count) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell<WMDCommandProtocol> *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(WMDCommandProtocol)]) {
        [cell execute];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
