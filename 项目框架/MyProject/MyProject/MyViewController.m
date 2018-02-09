//
//  MyViewController.m
//  MyProject
//
//  Created by 小富 on 16/4/8.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "MyViewController.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"
#import "NewsTableViewCell.h"
#import "ODRefreshControl.h"
#import "SDRefreshFooterView.h"
#import "FMDB.h"

@interface MyViewController () <UITableViewDelegate,UITableViewDataSource> {
    int pageNumber;
    ODRefreshControl *mRefreshControl;
    SDRefreshFooterView *_refreshFooter;
    FMDatabase *fmdb;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新闻";
    self.navigationItem.title = @"iOS头条";
    
    //创建数据库
    [self createSqlite];
    pageNumber = 0;
    //布局View
    [self setUpView];
    //数据处理
    [self dataAccess:pageNumber];
    mRefreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    
    [mRefreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}
- (void)createSqlite{
    //创建数据库
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingString:@"/MyFmdb.sqlite"];
    NSLog(@"%@",filePath);
    fmdb = [FMDatabase databaseWithPath:filePath];
    [fmdb open];
    [fmdb executeUpdate:@"create table if not exists t_MyFmdb (id integer primary key autoincrement,name text,data blob);"];
    
    //create table if not exists t_myfmdb (id integer primary key autoincrement, name text,data blob);
    //select * from t_myfmdb where name = ?
    // delete from t_myfmdb;
    //insert into t_myfmdb (name,data) values (?,?),
    
    //    NSString *sql = [NSString stringWithFormat:@"select * from t_MyFmdb where name = '%@' order by name desc limit 1;",@"lurich"];
    FMResultSet *result = [fmdb executeQuery:@"select * from t_MyFmdb where name = ?;",@"lurich"];
    //解析数据库
    // 从结果集里面往下找
    while ([result next]) {
        NSData *data = [result dataForColumn:@"data"];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if ([dict[@"status"] intValue] == 1) {
            NSDictionary *data = dict[@"data"];
            NSArray *dataArray = data[@"results"];
            for (NSDictionary *dic in dataArray) {
                NewsModel *model = [[NewsModel alloc] initWithDic:dic];
                [self.dataArr addObject:model];
            }
        }
    }
}
- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
-(void)dropViewDidBeginRefreshing:(ODRefreshControl*)refresh
{
    [self dataAccess:0];
}
- (void)refresh{
    pageNumber += 1;
    [self dataAccess:pageNumber];
}
#pragma mark - setUpView
- (void)setUpView{
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakSelf = self;
    
    // 上拉加载
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    _refreshFooter.beginRefreshingOperation = ^() {
            [weakSelf refresh];
            [weakRefreshFooter endRefreshing];
    };
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setRowHeight:80.0];
    }
    return _tableView;
}

#pragma mark DataAccess
- (void)dataAccess:(int)pageNum{
    NSString *url = @"http://cloud.bmob.cn/f8bb56aa119e68ee/news_list_2_0";
    NSDictionary *parmDic=[NSDictionary dictionaryWithObjectsAndKeys:@(10),@"limit",@(pageNum*10),@"skip", nil];
    //http://cloud.bmob.cn/f8bb56aa119e68ee/news_list_2_0?limit=20&skip=0
    [NetRequestManager GET:url parame:parmDic SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
        [fmdb executeUpdate:@"delete from t_MyFmdb;"];
        NSString *name = @"lurich";
        [fmdb executeUpdate:@"insert into t_MyFmdb (name,data) values (?,?)",name,reponseObject];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponseObject options:0 error:nil];
        NSLog(@"%@",dict);
        if ([dict[@"status"] intValue] == 1) {
            NSDictionary *data = dict[@"data"];
            NSArray *dataArray = data[@"results"];
            if (pageNum == 0) {
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dataArray) {
                NewsModel *model = [[NewsModel alloc] initWithDic:dic];
                [self.dataArr addObject:model];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [mRefreshControl endRefreshing];
            [self.tableView reloadData];
        });
        
        
    } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        [mRefreshControl endRefreshing];
        [GlobalUtil showCompleteOnController:self andTitle:@"请求失败"];
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    NewsModel *model=self.dataArr[indexPath.row];
    NewsDetailViewController *DetailVC=[[NewsDetailViewController alloc]init];
    [DetailVC setNavTitle:model.newsTitle];
    [DetailVC setUrlStr:model.newsLink];
    [self.navigationController pushViewController:DetailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    NewsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    [cell setData:self.dataArr[indexPath.row]];
    
    return cell;
}

@end
