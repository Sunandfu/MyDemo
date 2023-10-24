//
//  RootTableViewController.m
//  DragAndDropDemo
//
//  Created by lotus on 2020/1/2.
//  Copyright © 2020 lotus. All rights reserved.
//

#import "RootTableViewController.h"

#define CLASS_NAME @"className"
#define TITLE      @"title"

@interface RootTableViewController ()

@property (nonatomic, strong) NSArray <NSDictionary *>* listDatas;
@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDatas];
    [self setupViews];
}

- (void)initDatas
{
    self.listDatas = @[@{CLASS_NAME: @"DragAndDropTableViewController", TITLE: @"tableView DragAndDrop"},
                       @{CLASS_NAME: @"TextViewDragAndDropViewController", TITLE: @"TextView TextField DragAndDrop"},
                       @{CLASS_NAME: @"DragAndDropViewController", TITLE: @"自定义控件DragAndDrop"},];
}

- (void)setupViews
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    if (indexPath.row < self.listDatas.count) {
        cell.textLabel.text = self.listDatas[indexPath.row][TITLE];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *vcInfoDic = self.listDatas[indexPath.row];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:vcInfoDic[CLASS_NAME]];
    vc.title = vcInfoDic[TITLE];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
