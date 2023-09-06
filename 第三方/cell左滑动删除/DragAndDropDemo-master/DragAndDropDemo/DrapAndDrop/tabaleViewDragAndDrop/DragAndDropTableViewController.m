//
//  DragAndDropTableViewController.m
//  CardScrlDemo
//
//  Created by lotus on 2019/12/31.
//  Copyright © 2019 lotus. All rights reserved.
//

#import "DragAndDropTableViewController.h"
#import "DragAndDropTableViewController+Drag.h"
#import "DragAndDropTableViewController+Drop.h"


@interface DragAndDropTableViewController ()


@end

@implementation DragAndDropTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //初始化列表数据
    [self initDatas];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    //打开tableview的拖拽功能
    [self enableTableDragAndDrop];
}

- (void)enableTableDragAndDrop
{
    self.tableView.dragInteractionEnabled = YES;
    self.tableView.dragDelegate = self;
    self.tableView.dropDelegate = self;//如果只是本app内移动cell数据，这句代码可以注释掉
}

- (void)initDatas
{
    [self.dataManager setupDataSource];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dataManager numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *redView = [cell.contentView viewWithTag:0x11];
    if (!redView) {
        redView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tableView.frame) - 50, 0, 50, CGRectGetHeight(cell.contentView.bounds))];
        redView.backgroundColor = [UIColor redColor];
        redView.tag = 0x11;
        [cell.contentView addSubview:redView];
    }
    if ([self.dataManager numberOfRowsInSection:indexPath.section] > indexPath.row) {
        cell.textLabel.text = [self.dataManager cellDataForIndexPath:indexPath];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.dataManager moveFromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canMove = [[NSUserDefaults standardUserDefaults] boolForKey:@"canMove"];
    return canMove;
}


#pragma mark - getter
- (DragAndDropTableViewDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [[DragAndDropTableViewDataManager alloc] init];
    }

    return _dataManager;
}

@end
