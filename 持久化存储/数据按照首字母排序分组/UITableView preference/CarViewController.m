//
//  CarViewController.m
//  UITableView preference
//
//  Created by 史岁富 on 2018/9/13.
//  Copyright © 2018年 shenliping. All rights reserved.
//

#import "CarViewController.h"
#import "EaseChineseToPinyin.h"
#import "NSObject+YYModel.h"
#import "PlistModel.h"

@interface CarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;//初始数据源
@property (strong, nonatomic) NSMutableArray *sectionHeaderArray;//sectionHeader数组
@property (strong, nonatomic) NSMutableArray *sortArray;//整理好的数据源

@end

@implementation CarViewController

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"汽车列表";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshItem)];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    [self.view addSubview:self.tableView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self sort_searchList];
    });
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)deleteItem{
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}
- (void)refreshItem{
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    [self sort_searchList];
}

- (void)sort_searchList{
    [self.sectionHeaderArray removeAllObjects];
    [self.sortArray removeAllObjects];
    [self.dataArray removeAllObjects];
    
    NSString *filepath=[[NSBundle mainBundle] pathForResource:@"SFCarList" ofType:@"plist"];//添加我们需要的文件全称
    //获取此路径下的我们需要的数据（NSArray,NSDictionary,NSString...）
    NSMutableArray *rootArray = [NSMutableArray arrayWithContentsOfFile:filepath];//注意，如果想添加新的数据，需要NSMutable类型的
    for (NSDictionary *dcit in rootArray) {
        PlistModel *dataModel = [PlistModel modelWithJSON:dcit];
        [self.dataArray addObject:dataModel];
    }
    // 获取A~Z的排序
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionHeaderArray addObjectsFromArray:[indexedCollation sectionTitles]];
    
    NSMutableArray *sortarray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.sectionHeaderArray.count; i++) {
        NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
        [sortarray addObject:sectionArray];
    }
    
    for (PlistModel *model in self.dataArray) {
        NSString *fitst = [EaseChineseToPinyin pinyinFromChineseString:model.name];
        NSInteger index = [indexedCollation sectionForObject:[fitst substringFromIndex:0] collationStringSelector:@selector(uppercaseString)];
        [sortarray[index] addObject:model];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortarray count]; i++) {
        NSArray *modelArray = [sortarray objectAtIndex:i];
        NSArray *array = [modelArray sortedArrayUsingComparator:^NSComparisonResult(PlistModel *obj1, PlistModel *obj2) {
            NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.name];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.name];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortarray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    //去掉空的section
    for (NSInteger i = [sortarray count] - 1; i >= 0; i--) {
        NSArray *array = [sortarray objectAtIndex:i];
        if ([array count] == 0) {
            [sortarray removeObjectAtIndex:i];
            [self.sectionHeaderArray removeObjectAtIndex:i];
        }
    }
    
    [self.sortArray addObjectsFromArray:sortarray];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (NSMutableArray *)sectionHeaderArray{
    if (_sectionHeaderArray == nil) {
        _sectionHeaderArray = [[NSMutableArray alloc] init];
    }
    return _sectionHeaderArray;
}

- (NSMutableArray *)sortArray{
    if (_sortArray == nil) {
        _sortArray = [[NSMutableArray alloc] init];
    }
    return _sortArray;
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sortArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sortArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    PlistModel *model = [self.sortArray[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    NSBundle *newPath = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logoImage.bundle"]];
    cell.imageView.image = [UIImage imageNamed:model.logo inBundle:newPath compatibleWithTraitCollection:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionHeaderArray objectAtIndex:(section)]];
    [contentView addSubview:label];
    return contentView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionHeaderArray;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.sortArray[indexPath.section] removeObjectAtIndex:indexPath.row];
    //去掉空的section
    for (NSInteger i = [self.sortArray count] - 1; i >= 0; i--) {
        NSArray *array = [self.sortArray objectAtIndex:i];
        if ([array count] == 0) {
            [self.sortArray removeObjectAtIndex:i];
            [self.sectionHeaderArray removeObjectAtIndex:i];
        }
    }
    //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
