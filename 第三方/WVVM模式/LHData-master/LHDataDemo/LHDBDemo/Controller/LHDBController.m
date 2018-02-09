//
//  LHDBController.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHDBController.h"
#import "LHData.h"
#import "Teacher.h"
#import "LHDBCell.h"

@interface LHDBController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic)  UITableView* tableView;
@property (nonatomic)  NSMutableArray* dataSource;

@property (nonatomic,strong) NSMutableArray* imageURLArray;

@end

@implementation LHDBController

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-150) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"LHDBCell" bundle:nil] forCellReuseIdentifier:@"lhdbcell"];
    }
    return _tableView;
}

- (NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray*)imageURLArray
{
    if (!_imageURLArray) {
        _imageURLArray = [NSMutableArray array];
    }
    return _imageURLArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"LHDBDemo";
//    self.view.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self createTable];
    [self loadUI];
    [self loadDataFromDB];
    [self prepareData];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)loadDataFromDB
{
    if (self.dataSource.count>0) {
        [self.dataSource removeAllObjects];
    }
    [LHDBPath instanceManagerWith:DEFAULT_PATH];
    NSArray* array = [self selectDataWithPredicate:nil];
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
    if (self.tableView.contentSize.height>self.tableView.frame.size.height) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.frame.size.height) animated:YES];
    }
}

- (void)prepareData
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ImageUrl" ofType:@"plist"]] options:NSJSONWritingPrettyPrinted error:nil];
    if (!data) {
        return;
    }
    NSDictionary* dataDic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (dataDic.count<=0) {
        return;
    }
    for (NSString* key in dataDic.allKeys) {
            [self.imageURLArray addObject:dataDic[key]];
    }
    if (self.dataSource.count>0) return;
    for (int i=0; i<4; i++) {
        Teacher* teacher = [[Teacher alloc] init];
        teacher.name = [NSString stringWithFormat:@"godL%d",i];
        teacher.imageUrl = self.imageURLArray[arc4random_uniform((u_int32_t)self.imageURLArray.count)];
        teacher.age = 10+i;
        [self.dataSource addObject:teacher];
    }
}

- (void)loadUI
{
    NSArray* titleArray = @[@"增",@"删",@"改",@"查"];
    for (int i=0; i<4; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5+(i*60+5), self.view.frame.size.height-100, 60, 60);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)btnAction:(UIButton*)btn
{
    [LHDBPath instanceManagerWith:DEFAULT_PATH];
    switch (btn.tag-10) {
        case 0:
        {
            Teacher* teacher = [[Teacher alloc] init];
            teacher.name = [NSString stringWithFormat:@"godL%d",arc4random_uniform((u_int32_t)100)];
            teacher.age = arc4random_uniform((u_int32_t)100);
            //因为公司token随时失效 ，所以图片不能使用
            teacher.imageUrl = self.imageURLArray[arc4random_uniform((u_int32_t)self.imageURLArray.count)];
            [self insertDataWithModel:teacher];
            [self loadDataFromDB];
        }
            break;
            
        case 1:
        {
            [self deleteDataWithPredicate:nil];
            [self loadDataFromDB];
        }
            break;
            
        case 2:
        {
            Teacher* teacher = [self.dataSource lastObject];
            if (teacher) {
                LHPredicate* predicate = [LHPredicate predicateWithFormat:@"name = '%@'",teacher.name];
                [self updateDataWithModel:self.dataSource[arc4random_uniform((u_int32_t)self.dataSource.count)] predicate:predicate];
                [self loadDataFromDB];
            }
        }
            break;
            
        default:
        {
            NSArray* select = [self selectDataWithPredicate:nil];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"查询结果" message:[NSString stringWithFormat:@"数据库中有%ld个Teacher对象",select.count] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
            break;
    }
}

#pragma mark- LHDB
//建表
- (void)createTable
{
    [Teacher createTable];
}

//数据插入
- (void)insertDataWithDic:(NSDictionary*)dic
{
    [Teacher saveWithDic:dic];
}

- (void)insertDataWithModel:(id)model
{
    [model save];
}

//数据更新
- (void)updateDataWithDic:(NSDictionary*)dic predicate:(LHPredicate*)predicate
{
    [Teacher updateWithDic:dic predicate:predicate];
}

- (void)updateDataWithModel:(id)model predicate:(LHPredicate*)predicate
{
    [model updateWithPredicate:predicate];
}

//数据删除
- (void)deleteDataWithPredicate:(LHPredicate*)predicate
{
    [Teacher deleteWithPredicate:predicate];
}

//数据查询
- (NSArray*)selectDataWithPredicate:(LHPredicate*)predicate
{
    return [Teacher selectWithPredicate:predicate];
}

#pragma mark- UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHDBCell* cell = [tableView dequeueReusableCellWithIdentifier:@"lhdbcell" forIndexPath:indexPath];
    Teacher* teacher = self.dataSource[indexPath.row];

    [cell.headImage lh_setImageWithURL:teacher.imageUrl];
    cell.nameLabel.text = [NSString stringWithFormat:@"姓名是:%@",teacher.name];
    cell.ageLabel.text = [NSString stringWithFormat:@"年龄是:%ld",(long)teacher.age];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
