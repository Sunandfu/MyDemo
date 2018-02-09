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
    
    NSString *sql = [NSString stringWithFormat:@"select * from t_MyFmdb where name = '%@' order by name desc limit 1;",@"lurich"];
    FMResultSet *result = [fmdb executeQuery:sql];
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
    //ecgPath = "http://img.yun-xiang.net/hbguard/ecg/1459495432422_fail.ecg";
    ListModel *model = self.dataArray[indexPath.row];
    NSString *string = model.ecgPath;
    if (string.length>37) {
        self.BleName = [string substringFromIndex:37];
    } else {
        self.BleName = [string substringFromIndex:7];
    }
    
    [self DownloadTextFile:indexPath];
}

- (void)getData:(NSString *)string{
    [NetRequestManager manager].requestTime = 30;
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
-(void)DownloadTextFile:(NSIndexPath *)indexpath
{
    if (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).count>0) {
        NSString *imageDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        imageDir = [imageDir stringByAppendingString:@"/FTPFilesnew"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imageDir error:nil];
        NSLog(@"文件删除成功");
    }
    
    
    NSLog(@"self.BleName:%@",self.BleName);
    LxFTPRequest *downLoad = [LxFTPRequest downloadRequest];
    NSString *urlFtp = [NSString stringWithFormat:@"%@hbguard/ecg/%@",FTP_SCHEME_HOST,self.BleName];
    
    NSLog(@"urlFtp:%@",urlFtp);
    downLoad.serverURL = [NSURL URLWithString:urlFtp];
    NSString *string = [NSString stringWithFormat:@"FTPFilesnew"];
    downLoad.localFileURL = [[NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject ]] URLByAppendingPathComponent:string];
    NSLog(@"urlFtp:%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]);
    downLoad.username = FTPUSERNAME;
    downLoad.password = FTPPASSWORD;
    downLoad.progressAction = ^(NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
//        NSLog(@"totalSize = %ld, finishedSize = %ld, finishedPercent = %f", totalSize, finishedSize, finishedPercent);
        NSLog(@"%.0f％",finishedPercent);
    };
    __weak typeof(self) weakSelf = self;
    downLoad.successAction = ^(Class resultClass, id result) {
        NSLog(@"resultClass = %@, result = %@", resultClass, result);
        NSString *FileName1 =  [result stringByAppendingPathComponent:self.BleName];
        NSLog(@"%@",FileName1);
        NSLog(@"文件下载完毕");
    
        [weakSelf onFileSelected:FileName1 andStr:string];
    };
    downLoad.failAction = ^(CFStreamErrorDomain domain, NSInteger error,NSString*errorDescription) {
        
        NSLog(@"domain = %ld, error = %ld, errorDescription = %@" , domain, error,errorDescription);
    };
    [downLoad start];
}
-(void)onFileSelected:(NSString *)url andStr:(NSString *)strPath
{
    // Reset the file type. A new file has been selected
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * localFilePath = [[NSURL fileURLWithPath:[ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject ]] URLByAppendingPathComponent:strPath].absoluteString.stringByDeletingScheme ;
    BOOL ret = [fileManager fileExistsAtPath:localFilePath];
    NSLog(@"%@",ret == 0 ?@"文件不存在":@"文件存在");
    
    url = localFilePath;
    
    
    // Save the URL in DFU helper
    NSLog(@"url:%@",url);
    ViewController *viewcon = [[ViewController alloc] init];
    viewcon.filePath = url;
    [self presentViewController:viewcon animated:NO completion:nil];
}
/*
 - (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
 NSLog(@"删除");
 }];
 UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"添加" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
 NSLog(@"添加");
 }];
 action1.backgroundColor = [UIColor blueColor];
 UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
 NSLog(@"修改");
 }];
 action2.backgroundColor = [UIColor greenColor];
 return @[action,action1,action2];
 }
 */
@end
