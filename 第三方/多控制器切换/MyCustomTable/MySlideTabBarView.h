//
//  MySlideTabBarView.h
//
//  Created by 史岁富 on 15/11/18.
//  Copyright © 2015年 史岁富. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MJRefresh.h"
#import "NSString+additional.h"
#import "UIView+convenience.h"

@protocol MySliderTabBarDataSourceDelegate <NSObject>

- (NSArray *)headerTitleArray;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol MySliderTabBarDelegate <NSObject>
- (void)headerTitleClick:(int)index;
- (void)TableViewHeaderRefresh:(UITableView *)tableView ;
- (void)TableViewFooterRefresh:(UITableView *)tableView ;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface MySlideTabBarView : UIView
@property (nonatomic,strong) UIColor *selectColor;//选中时颜色
@property (nonatomic,strong) UIColor *unSelectColor;//未选中时颜色
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,weak) id dataSourceDelegate;
@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) UITableView *currentTableView;

- (void)reloadData:(int)index;

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation index:(int)index;

@end
