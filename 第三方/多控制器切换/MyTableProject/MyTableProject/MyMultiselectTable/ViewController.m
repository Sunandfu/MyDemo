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
#import "NetRequestManager.h"

@interface ViewController ()<MySliderTabBarDataSourceDelegate,MySliderTabBarDelegate>{
    NSArray *_typeArray;
    UITableView *_currentTableView;//当前选中的tableview
    int _currentIndex;//当前选中的编号
    TableViewRefresh *_refreshTools;
}

@property (nonatomic, strong)MySlideTabBarView *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    self.sliderView = [[MySlideTabBarView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [self.view addSubview:self.sliderView];
    _typeArray = @[@"推荐",@"热门",@"默认",@"最新"];
    _refreshTools = [[TableViewRefresh alloc]initWithCount:(int)_typeArray.count];
    _currentTableView = self.sliderView.currentTableView;
    self.sliderView.dataSourceDelegate = self;
    self.sliderView.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSupplyGoodsInStore:0 pages:[_refreshTools.pageNumberArray[0] intValue]];
}
- (NSArray *)headerTitleArray{
    return _typeArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%@",_refreshTools.tableViewsDataArray);
    int count = (int)[_refreshTools.tableViewsDataArray[tableView.tag] count];
    return count;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_refreshTools.tableViewsDataArray[tableView.tag][indexPath.row]];
    return cell;
}
- (void)headerTitleClick:(int)index{
    _currentTableView = self.sliderView.currentTableView;
    _currentIndex = index;
    NSLog(@"第 %d 个 Title is clicked",index);
    NSMutableArray *dataArray = _refreshTools.tableViewsDataArray[index];
    if (dataArray.count>0) {
        NSLog(@"有商品，隐藏'暂无商品'背景图");
    } else {
        NSLog(@"无商品，显示'暂无商品'背景图");
    }
    [self getSupplyGoodsInStore:index pages:[_refreshTools.pageNumberArray[index] intValue]];
}
- (void)TableViewHeaderRefresh:(UITableView *)tableView{
    int index = (int)tableView.tag;
    [_refreshTools resetPageNumberWithIndex:index];
    [self getSupplyGoodsInStore:index pages:[_refreshTools.pageNumberArray[index] intValue]];
    NSLog(@"第 %d 个 tableView 下拉刷新",(int)tableView.tag);
}
- (void)TableViewFooterRefresh:(UITableView *)tableView{
    int index = (int)tableView.tag;
    [_refreshTools addPageNumberWithIndex:index];
    [self getSupplyGoodsInStore:index pages:[_refreshTools.pageNumberArray[index] intValue]];
    NSLog(@"第 %d 个 tableView 上拉加载",(int)tableView.tag);
    
}
//网络请求
- (void)getSupplyGoodsInStore:(int)index pages:(int)page{
    [NetRequestManager manager].requestTime = 30.0f;
    [NetRequestManager POST:@"http://www.baidu.com" parame:nil SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponseObject options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        if (!dict) {
            NSLog(@"数据接收成功，开始解析数据");
            for (int i=0; i<10; i++) {
                NSString *dataStr = [NSString stringWithFormat:@"第%d个tableview 数据%d",index,i];
                [dataArray addObject:dataStr];
            }
            [_refreshTools setDataWithData:dataArray Index:index];
            [self.sliderView reloadData:index];
        } else {
            NSLog(@"数据接收失败");
            [_refreshTools subPageNumberWithIndex:index];
        }
        [self.sliderView.currentTableView headerEndRefreshing];
        [self.sliderView.currentTableView footerEndRefreshing];
    } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.sliderView.currentTableView headerEndRefreshing];
        [self.sliderView.currentTableView footerEndRefreshing];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
