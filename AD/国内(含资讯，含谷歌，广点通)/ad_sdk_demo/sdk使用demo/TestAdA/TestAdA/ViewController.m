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

#import "YXLaunchScreenViewController.h"
#import "YXIconViewController.h"
#import "YXInterstitialViewController.h"
#import "YXScrollerBannerViewController.h"

#import "YXMotivationVideoViewController.h"
#import <YXLaunchAds/YXLaunchAds.h>
#import "HalfViewController.h"
#import "TableHalfViewController.h"

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
    self.dataArr = @[@"轮播",@"信息流样式",@"横幅样式",@"开屏启动页样式",@"半屏开屏启动页样式",@"icon样式",@"插屏样式",@"激励视频",@"tableView半屏单频道资讯接入",@"tableView半屏全频道资讯接入",@"scrollView半屏单频道资讯接入",@"scrollView半屏全频道资讯接入",@"全屏资讯接入"];
    
    [self.view addSubview:self.tableView];
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
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[YXScrollerBannerViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[YXFeedAdViewController new] animated:YES];
            break;
         
        case 2:
            [self.navigationController pushViewController:[YXBannerViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[YXLaunchScreenViewController new] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[YXHalfLaunchScreenViewController new] animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:[YXIconViewController new] animated:YES];
            break;
        case 6:
            [self.navigationController pushViewController:[YXInterstitialViewController new] animated:YES];
            break;
        case 7:
            [self.navigationController pushViewController:[YXMotivationVideoViewController new] animated:YES];
            break;
        case 8:
        {
            TableHalfViewController *infoVC = [TableHalfViewController new];
            infoVC.isShowAll = NO;
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
            break;
        case 9:
        {
            TableHalfViewController *infoVC = [TableHalfViewController new];
            infoVC.isShowAll = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
            break;
        case 10:
        {
            HalfViewController *infoVC = [HalfViewController new];
            infoVC.isShowAll = NO;
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
            break;
        case 11:
        {
            HalfViewController *infoVC = [HalfViewController new];
            infoVC.isShowAll = YES;
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
            break;
        case 12:
        {
            SFInformationViewController *infoVC = [SFInformationViewController new];
            infoVC.mediaId = @"4";
            infoVC.mLocationId = @"3";
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }
            break;
        default:
            [self.navigationController pushViewController:[YXMotivationVideoViewController new] animated:YES];
            break;
            
            
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
