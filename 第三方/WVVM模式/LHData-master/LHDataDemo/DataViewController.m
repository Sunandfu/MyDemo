//
//  DataViewController.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "DataViewController.h"
#import "LHDBController.h"
#import "LHWebImageController.h"
#import "LHHTTPRequestController.h"
#import "LHModelController.h"
#import "LHCacheController.h"
@interface DataViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* tableView;

@end

@implementation DataViewController{
    NSArray* dataSource;
}


- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"LHDataDemo";
    dataSource = @[@"LHDBDemo",@"LHHTTPRequestDemo",@"LHWebImageDemo",@"LHModelDemo",@"LHCacheDemo"];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = dataSource[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            LHDBController* vc = [[LHDBController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            LHHTTPRequestController* vc = [[LHHTTPRequestController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            LHWebImageController* vc = [[LHWebImageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            LHModelController* vc = [[LHModelController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        
        default:
        {
            LHCacheController* vc = [[LHCacheController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
