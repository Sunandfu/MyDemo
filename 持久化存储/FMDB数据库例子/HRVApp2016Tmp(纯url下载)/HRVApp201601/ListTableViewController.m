//
//  ListTableViewController.m
//  HRVApp201601
//
//  Created by 小富 on 16/4/12.
//  Copyright © 2016年 betterlife. All rights reserved.
//

#import "ListTableViewController.h"
#import "NetRequestManager.h"
#import "LxFTPRequest.h"
#import "ListModel.h"
#import "ListTableViewCell.h"
#import "ViewController.h"
#import "FMDB.h"

#define FTP_SCHEME_HOST @"ftp://139.196.50.85/"
#define FTPUSERNAME @"admftp"
#define FTPPASSWORD @"12ab!@"
@interface ListTableViewController () <UITableViewDelegate,UITableViewDataSource>{
    FMDatabase *fmdb;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UITableView *tableView;
@property (copy,nonatomic)NSString *BlePath;
@property (copy,nonatomic)NSString *BleName;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dict in dic[@"rows"]) {
            ListModel *model = [[ListModel alloc] init];
            [model dictionary:dict];
            [self.dataArray addObject:model];
        }
        NSLog(@"%@",dic);
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIDatePicker *date = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 60)];
    date.datePickerMode = UIDatePickerModeDate;
    [date addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:date];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height-80) style:UITableViewStylePlain];
    self.tableView.rowHeight = 155;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
- (void)dateChange:(UIDatePicker *)datePick{
    NSLog(@"%@",datePick.date);
    NSString *date = [NSString stringWithFormat:@"%@",datePick.date];
    NSString *string = [date substringToIndex:10];
    [self getData:string];
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:nil options:nil]firstObject];
    }
    ListModel *model = self.dataArray[indexPath.row];
    cell.checktime.text = model.checktime;
    cell.ecgPath.text = model.ecgPath;
    cell.osVersion.text = model.osVersion;
    cell.userId.text = model.userId;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSString *ecgPath = @"http://img.yun-xiang.net/hbguard/ecg/1459495432422_fail.ecg";
    ListModel *model = self.dataArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@",model.ecgPath];
    NSString *fileName = [NSString stringWithFormat:@"myFile.ecg"];
    NSLog(@"%@ ***** %@",fileName,url);
    NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
    if (path) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    [NetRequestManager downloadWithUrl:url saveToPath:path progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        //封装方法里已经回到主线程，所有这里不用再调主线程了
        NSString *jindu = [NSString stringWithFormat:@"进度==%.2f",1.0 * bytesProgress/totalBytesProgress];
        NSLog(@"---------%@",jindu);
    } success:^(id response) {
        NSLog(@"下载完成---------%@",response);
        ViewController *view = [[ViewController alloc] init];
        view.filePath = response;
        [self presentViewController:view animated:NO completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"下载失败---------%@",error);
    }];
}
#pragma mark 网络请求数据
- (void)getData:(NSString *)string{
    [NetRequestManager sharedNetworking].requestTime = 30;
    //http://jkjia.yun-xiang.net/Bluetooth/getAllFailEcgs?checktime=2016-04-01
    NSString *url = @"http://jkjia.yun-xiang.net/Bluetooth/getAllFailEcgs";
    NSDictionary *dic = @{@"checktime":string};
    [NetRequestManager GET:url parame:dic SUccess:^(AFHTTPRequestOperation *operation, id reponseObject) {
        NSString *date = [NSString stringWithFormat:@"%@",[NSDate date]];
        NSString *strDate = [date substringToIndex:10];
        if ([strDate isEqualToString:string]) {
            [fmdb executeUpdate:@"delete from t_MyFmdb;"];
            NSString *name = @"lurich";
            [fmdb executeUpdate:@"insert into t_MyFmdb (name,data) values (?,?)",name,reponseObject];
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:reponseObject options:1 error:nil];
        NSLog(@"%@",dic);
        if (self.dataArray.count>0) {
            [self.dataArray removeAllObjects];
        }
        for (NSDictionary *dict in dic[@"rows"]) {
            ListModel *model = [[ListModel alloc] init];
            [model dictionary:dict];
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failed:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
