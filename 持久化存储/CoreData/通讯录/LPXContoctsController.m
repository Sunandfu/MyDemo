//
//  ViewController.m
//  通讯录
//
//  Created by 卢鹏肖 on 16/4/20.
//  Copyright © 2016年 卢鹏肖. All rights reserved.
//

#import "LPXContoctsController.h"

#import "LPXEditController.h"

@interface LPXContoctsController () <NSFetchedResultsControllerDelegate,UISearchBarDelegate>

/**
 *  查询结果控制器
 */
@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;

@end

@implementation LPXContoctsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    
    // 添加一个searBar
    self.navigationItem.titleView = searchBar;
    
    
    
    NSLog(@"%@",    [NSHomeDirectory() stringByAppendingString:@"/Documents"] );
}


// sb连线走的方法
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //取出目标控制器
    LPXEditController *enitVC =segue.destinationViewController;
    //取出目标控制器对于的IndexPath
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    ContactsEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //赋值
    if (entity.entity != nil) {
        
        enitVC.entity = entity;
    }
}

#pragma mark -- tableView代理和数据源方法

/**
 *  组
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

/**
 *  行
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> aSection = self.fetchedResultsController.sections[section];
    return aSection.numberOfObjects;
}

/**
 *  数据
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"LPXContoctsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //取出数据
    ContactsEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = entity.name;
    cell.detailTextLabel.text = entity.phoneNum;
    
    return cell;
}

/**
 *  头部的文字
 */
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.fetchedResultsController.sectionIndexTitles[section];
}

/**
 *  侧滑出删除
 */
- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/// 点击删除后触发
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取出数据
    ContactsEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //删除对象
    [[LPXCoreDataManager sharedInstance].managedObjectContext deleteObject:entity];
    //保存
    [entity save];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sectionIndexTitles;
}

#pragma mark -- fetchedResultsController代理
/**
 *  数据库文本发生改变了调用
 */
- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"改变了");
    //数据源的分组数
    NSInteger dataSourceSectionCount = self.fetchedResultsController.sections.count;
    //tableView的分组数
    NSInteger tableViewSectionCount = self.tableView.numberOfSections;
    //分组数改变的标示
    BOOL sectionCountChg = dataSourceSectionCount != tableViewSectionCount;
    
    //新增一条数据
    if (type == NSFetchedResultsChangeInsert) {
        if (sectionCountChg) {
            //等于yes新增一组
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
        }
        else {
            //新增一行
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    else if (type == NSFetchedResultsChangeDelete) {
        //删除一条数据
        if (sectionCountChg) {
            //删除一组
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
        }
        else {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    else if (type == NSFetchedResultsChangeUpdate) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if (type == NSFetchedResultsChangeMove) {
        //移动行不会刷新数据
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        //刷新单行
        [self.tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark -- UISearchBarDelegate代理

/**
 *  点击开始编辑
 */
- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"点击开始编辑");
    //显示取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

/**
 *   编辑完成
 */
- (BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"编辑完成");
    // 隐藏取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

/**
 *  取消按钮
 */
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //情况文本
    searchBar.text = nil;
    //文本改变
    [self searchBar:searchBar textDidChange:searchBar.text];
    //结束编辑
    [searchBar endEditing:YES];
}

// 文办发生了改变
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
    //转成小写
    searchText = searchText.lowercaseString;

    //谓词查找
    NSFetchRequest *request = self.fetchedResultsController.fetchRequest;
    //如果文本为空全部显示,不为空按搜索词查询
    if (searchText.length) {
        //创建谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS %@ || self.namePinYin CONTAINS %@ || self.phoneNum CONTAINS %@",searchText,searchText,searchText];
        //请求谓词
        request.predicate = predicate;
    }
    else {
        // 没有谓词查出全部
        request.predicate = nil;
    }
    // 执行查询
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
}


#pragma mark -- 懒加载
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[ContactsEntity entityName]];
        // 拼音字母比较
        NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"namePinYin" ascending:YES];
        NSSortDescriptor *sortPhoneNum = [NSSortDescriptor sortDescriptorWithKey:@"phoneNum" ascending:YES];
        
        // 给请求排序
        request.sortDescriptors = @[sortName,sortPhoneNum];
        
        /**
          * 查询的请求
          * 查询的上下文
          * 分组依据的字段
          * 缓存名字
         */
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[LPXCoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
        // 设置代理
        _fetchedResultsController.delegate = self;
        //执行查询
        NSError *error;
        [_fetchedResultsController performFetch:&error];
        if (error != nil) {
            NSLog(@"执行查询有误%@",error);
        }
        
        for (ContactsEntity *entity in _fetchedResultsController.fetchedObjects) {
            NSLog(@"名字%@",entity.name);
        }
    }
    
    return _fetchedResultsController;
}



@end
