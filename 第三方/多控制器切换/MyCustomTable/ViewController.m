//
//  ViewController.m
//  MyTableProject
//
//  Created by 小富 on 16/4/1.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "ViewController.h"
#import "MySlideTabBarView.h"
#import "TableViewRefresh.h"

@interface ViewController ()<MySliderTabBarDataSourceDelegate,MySliderTabBarDelegate>{
    NSArray *_typeArray;
    UITableView *_currentTableView;
}

@property (nonatomic, strong)MySlideTabBarView *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sliderView = [[MySlideTabBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.sliderView];
    _typeArray = @[@"推荐",@"热门",@"默认",@"最新"];
    _currentTableView = self.sliderView.currentTableView;
    self.sliderView.dataSourceDelegate = self;
    self.sliderView.delegate = self;
}
- (NSArray *)headerTitleArray{
    return _typeArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"myCustomTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSInteger i = tableView.tag;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_typeArray[i]];
    return cell;
}
- (void)headerTitleClick:(int)index{
    _currentTableView = self.sliderView.currentTableView;
}
- (void)TableViewHeaderRefresh:(UITableView *)tableView{
    _currentTableView = tableView;
    [_currentTableView headerEndRefreshing];
}
- (void)TableViewFooterRefresh:(UITableView *)tableView{
    _currentTableView = tableView;
    [_currentTableView footerEndRefreshing];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
