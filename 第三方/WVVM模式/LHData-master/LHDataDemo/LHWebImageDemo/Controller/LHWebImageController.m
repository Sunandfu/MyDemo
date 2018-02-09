//
//  ViewController.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/6.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHWebImageController.h"
#import "Cell.h"
#import "LHData.h"

@interface LHWebImageController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LHWebImageController{
    UITableView* _tableview;
    NSMutableArray* _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"LHWebImageDemo";
    _dataSource = [NSMutableArray array];
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview registerNib:[UINib nibWithNibName:@"Cell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ImageUrl" ofType:@"plist"]];
    for (NSString* key in dic.allKeys) {
        [_dataSource addObject:dic[key]];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.headImage lh_setImageWithURL:_dataSource[indexPath.row] placeholderImage:nil progress:^(float updateProgress) {
        NSLog(@"%f",updateProgress);
        cell.progressLabel.text = [NSString stringWithFormat:@"下载了%d",(int)(updateProgress*100)];
    } complete:^(UIImage *image) {
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
