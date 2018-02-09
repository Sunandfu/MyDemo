//
//  MainViewController.m
//  DropDownMenuList
//
//  Created by 王会洲 on 16/5/13.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MainViewController.h"
#import "DropDownMenuList.h"

@interface MainViewController ()<DropDownMenuListDelegate,DropDownMenuListDataSouce>

@property (nonatomic, strong) UITableView * myTableView;


@property (nonatomic, strong) NSMutableArray *sortArr1;
@property (nonatomic, strong) NSMutableArray *sortArr2;
@property (nonatomic, strong) NSMutableArray *sortArr3;


@property (nonatomic, strong) DropDownMenuList * dropMenu;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    self.dropMenu = [DropDownMenuList show:CGPointMake(0, 64) andHeight:44];
    self.dropMenu.delegate = self;
    self.dropMenu.dataSource = self;
    [self.view addSubview:self.dropMenu];
    
}
-(NSMutableArray *)sortArr1 {
    if (_sortArr1 == nil) {
        _sortArr1 = [NSMutableArray arrayWithCapacity:0];
        [_sortArr1 addObject:@"不限"];
        [_sortArr1 addObject:@"1公里"];
        [_sortArr1 addObject:@"2公里"];
        [_sortArr1 addObject:@"3-5公里"];
        [_sortArr1 addObject:@"6-10公里"];
        [_sortArr1 addObject:@"10公里以上"];
    }
    return _sortArr1;
}
-(NSMutableArray *)sortArr2 {
    if (_sortArr2 == nil) {
        _sortArr2 = [NSMutableArray arrayWithCapacity:0];
        [_sortArr2 addObject:@"不限"];
        [_sortArr2 addObject:@"1天"];
        [_sortArr2 addObject:@"2天"];
        [_sortArr2 addObject:@"3天"];
        [_sortArr2 addObject:@"4天"];
        [_sortArr2 addObject:@"5天"];
        [_sortArr2 addObject:@"6天"];
        [_sortArr2 addObject:@"7天"];
    }
    return _sortArr2;
}
-(NSMutableArray *)sortArr3 {
    if (_sortArr3 == nil) {
        _sortArr3 = [NSMutableArray arrayWithCapacity:0];
        [_sortArr3 addObject:@"不限"];
        [_sortArr3 addObject:@"1-5元"];
        [_sortArr3 addObject:@"6-10元"];
        [_sortArr3 addObject:@"11-20元"];
        [_sortArr3 addObject:@"21-50元"];
        [_sortArr3 addObject:@"50元以上"];
    }
    return _sortArr3;
}




-(void)menu:(DropDownMenuList *)segment didSelectTitleAtColumn:(NSInteger)column{
    NSLog(@"didSelectTitleAtColumn------%ld",column);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dropMenu rightNowDismis];
}

-(NSMutableArray *)menuNumberOfRowInColumn {
    return @[@"每周公里数",@"每周出勤数",@"每日契约金"].mutableCopy;
}

-(NSInteger)menu:(DropDownMenuList *)menu numberOfRowsInColum:(NSInteger)column {
    NSLog(@"numberOfRowsInColum==%ld",column);
    if (column == 0) {
        return self.sortArr1.count;
    } else if (column == 1) {
        return self.sortArr2.count;
    } else {
        return self.sortArr3.count;
    }
}

-(NSString *)menu:(DropDownMenuList *)menu titleForRowAtIndexPath:(HZIndexPath *)indexPath {
    NSLog(@"titleForRowAtIndexPath==%ld",indexPath.row);
    if (indexPath.column == 0) {
        return self.sortArr1[indexPath.row];
    } else if (indexPath.column == 1) {
        return self.sortArr2[indexPath.row];
    } else {
        return self.sortArr3[indexPath.row];
    }
}
-(void)menu:(DropDownMenuList *)segment didSelectRowAtIndexPath:(HZIndexPath *)indexPath {
    NSLog(@"------%ld----->>>%ld",indexPath.column,indexPath.row);
}







@end
