//
//  ViewController.m
//  FMDB
//
//  Created by 小富 on 16/4/12.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation ViewController
@synthesize fmdb;

- (IBAction)zengjia:(id)sender {
    BOOL flag = [fmdb executeUpdate:@"insert into t_MyFmdb (name,phone) values (?,?)",@"lurich",@"520"];
//    for (int i=0; i<40; i++) {
//        NSString *number = [NSString stringWithFormat:@"%d",arc4random_uniform(3)];
//        [fmdb executeUpdate:@"insert into t_MyFmdb (name,phone) values (?,?)",@"lurich",number];
//    }
    
    if (flag) {
        NSLog(@"成功增加数据");
    } else {
        NSLog(@"添加失败");
    }
}
- (IBAction)shanchu:(id)sender {
    BOOL flag = [fmdb executeUpdate:@"delete from t_MyFmdb;"];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"failure");
    }
}
- (IBAction)xiugai:(id)sender {
    BOOL flag = [fmdb executeUpdate:@"update t_MyFmdb set name = ? where phone = ?",@"abc",@"5"];
    if (flag) {
        NSLog(@"success");
    }else{
        NSLog(@"failure");
    }
}
- (IBAction)chazhao:(id)sender {
//    NSString *sql = [NSString stringWithFormat:@"select * from t_MyFmdb where phone = '%@' order by name desc limit 5;",@"1"];
//    FMResultSet *result = [fmdb executeQuery:sql];
    
    FMResultSet *result =  [fmdb executeQuery:@"select * from t_MyFmdb"];
    
    // 从结果集里面往下找
    while ([result next]) {
        NSString *name = [result stringForColumn:@"name"];
        NSString *phone = [result stringForColumn:@"phone"];
        NSLog(@"%@--%@",name,phone);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePath stringByAppendingString:@"/MyFmdb.sqlite"];
    NSLog(@"%@",filePath);
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    fmdb = db;
    BOOL flag = [db open];
    if (flag) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
    }
    
    BOOL new = [db executeUpdate:@"create table if not exists t_MyFmdb (id integer primary key autoincrement,name text,phone text);"];
    if (new) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
