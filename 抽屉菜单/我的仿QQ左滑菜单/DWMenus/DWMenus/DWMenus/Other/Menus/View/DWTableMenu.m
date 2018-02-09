//
//  DWTableMenu.m
//  DWMenu
//
//  Created by Dwang on 16/4/26.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//



/***********************QQ:739814184********************/

/***********************欢迎各位添加讨论********************/


#import "DWTableMenu.h"
#import "DWModel.h"
#import "DWViewController.h"

@interface DWTableMenu ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *menus;

@end

@implementation DWTableMenu

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    self.dataSource = self;
    
    self.delegate = self;
    
}


#pragma mark - 懒加载数据
- (NSArray *) leftMenus {
    
    if (!_menus) {
        _menus = [DWModel menuModel];
    }
    return _menus;
}

#pragma mark ---delegate
- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftMenus.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    DWModel *menus = self.leftMenus[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //点击cell没有选中效果
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    cell.textLabel.text = menus.text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //点击时有效果，返回时选中效果消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DWModel *menus = self.leftMenus[indexPath.row];
    NSDictionary *dicy = @{@"model":menus,@"indexPath":indexPath};
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:dicy];
    
}

@end
