//
//  HistoryTableViewController.m
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/11/15.
//  Copyright © 2015年 DINGYONGGANG. All rights reserved.
//

#import "HistoryTableViewController.h"

@interface HistoryTableViewController (){
    NSArray *history;
}

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self getDataResource];
}

- (void)initNavigationBar{
    self.title = @"扫描记录";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(leftItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getDataResource{
    history = [[NSUserDefaults standardUserDefaults]objectForKey:@"history"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return history.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = history[indexPath.row];
    
    cell.textLabel.text = [dic valueForKey:@"value"];
    cell.detailTextLabel.text = [dic valueForKey:@"time"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.textLabel.text;
}

@end
