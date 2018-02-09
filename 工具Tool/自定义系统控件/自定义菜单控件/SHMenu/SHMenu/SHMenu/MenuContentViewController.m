//
//  MenuContentViewController.m
//  SHMenu
//
//  Created by 宋浩文的pro on 16/4/15.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "MenuContentViewController.h"

@interface MenuContentViewController ()

@property (nonatomic, strong) NSMutableArray *menuListArray;

@end

@implementation MenuContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.menuListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *id_cell = @"cell_menu";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id_cell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id_cell];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"menu_recharge"];
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"menu_personalCenter"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"menu_calculate"];
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:181/255.0 green:128/255.0 blue:67/255.0 alpha:1];
    
    cell.selectedBackgroundView = selectedBackgroundView;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.menuListArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(menuController:clickAtRow:)]) {
        [self.delegate menuController:self clickAtRow:indexPath.row];
    }
    
}

- (NSMutableArray *)menuListArray
{
    if (_menuListArray == nil) {
        
        _menuListArray = [NSMutableArray arrayWithArray:@[@"充值金币", @"个人中心", @"开始测算"]];
    }
    return _menuListArray;
}

@end
