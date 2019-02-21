//
//  MainTableViewController.m
//  APIExampleApp
//
//  Created by lishan04 on 15-5-14.
//
//

#import "MainTableViewController.h"
#import "BaiduMobAdFirstViewController.h"
#import "BaiduMobAdNormalInterstitialViewController.h"
#import "BaiduMobAdPrerollViewController.h"
#import "NativeTableViewController.h"
#import "NativeLoopViewController.h"
#import "InterstitialExampleViewController.h"
#import "CpuChannelViewController.h"
#import "BaiduMobAdPrerollNativeViewController.h"
#import "NativeVideoTableViewController.h"
#import "HybridViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"横幅广告20:3";
            break;
        case 1:
            cell.textLabel.text = @"非原生视频贴片";
            break;
        case 2:
            cell.textLabel.text = @"原生视频贴片";
            break;
        case 3:
            cell.textLabel.text = @"插屏广告";
            break;
        case 4:
            cell.textLabel.text = @"信息流";
            break;
        case 5:
            cell.textLabel.text = @"信息流视频";
            break;
        case 6:
            cell.textLabel.text = @"信息流焦点图(使用示例)";
            break;
        case 7:
            cell.textLabel.text = @"插屏章节切换(使用示例)";
            break;
        case 8:
            cell.textLabel.text = @"内容联盟样式";
            break;
        case 9:
            cell.textLabel.text = @"横幅广告3:2";
            break;
        case 10:
            cell.textLabel.text = @"横幅广告7:3";
            break;
        case 11:
            cell.textLabel.text = @"横幅广告2:1";
            break;
        case 12:
            cell.textLabel.text = @"jssdk";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *detailViewController = nil;
    switch (indexPath.row) {
        case 0:
            detailViewController = [[[BaiduMobAdFirstViewController alloc]init]autorelease];
            [((BaiduMobAdFirstViewController *)detailViewController) startAdViewWithHeightScale:0.15 adUnitTag:kBannerSize_20_3];
            break;
        case 1:
            detailViewController = [[[BaiduMobAdPrerollViewController alloc]init]autorelease];
            break;
        case 2:
            detailViewController = [[[BaiduMobAdPrerollNativeViewController alloc]init]autorelease];
            break;
        case 3:
            detailViewController = [[[BaiduMobAdNormalInterstitialViewController alloc]init]autorelease];
            break;
        case 4:
            detailViewController = [[[NativeTableViewController alloc]init]autorelease];
            ((NativeTableViewController *)detailViewController).toBeChangedApid=@"2058621";
            ((NativeTableViewController *)detailViewController).toBeChangedPublisherId=@"ccb60059";
            break;
        case 5:
            detailViewController = [[[NativeVideoTableViewController alloc]init]autorelease];
            break;
        case 6:
            detailViewController = [[[NativeLoopViewController alloc]init]autorelease];
            break;
        case 7:
            detailViewController = [[[InterstitialExampleViewController alloc]init]autorelease];
            break;
        case 8:
            detailViewController = [[[CpuChannelViewController alloc]init]autorelease];
            break;
        case 9:
            detailViewController = [[[BaiduMobAdFirstViewController alloc]init]autorelease];
            [((BaiduMobAdFirstViewController *)detailViewController) startAdViewWithHeightScale:0.66 adUnitTag:kBannerSize_3_2];
            break;
        case 10:
            detailViewController = [[[BaiduMobAdFirstViewController alloc]init]autorelease];
            [((BaiduMobAdFirstViewController *)detailViewController) startAdViewWithHeightScale:0.43 adUnitTag:kBannerSize_7_3];
            break;
        case 11:
            detailViewController = [[[BaiduMobAdFirstViewController alloc]init]autorelease];
            [((BaiduMobAdFirstViewController *)detailViewController) startAdViewWithHeightScale:0.50 adUnitTag:kBannerSize_2_1];
            break;
        case 12:
            detailViewController = [[[HybridViewController alloc]init]autorelease];
            break;
        default:
            break;
    }

    if (detailViewController) {
        [self.navigationController pushViewController:detailViewController animated:NO];
    }
}

@end
