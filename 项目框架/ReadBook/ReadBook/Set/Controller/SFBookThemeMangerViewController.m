//
//  SFBookSourceMangerViewController.m
//  ReadBook
//
//  Created by lurich on 2020/11/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBookThemeMangerViewController.h"
#import "SFBookThemeDetailViewController.h"

@interface SFBookThemeMangerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation SFBookThemeMangerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //在读取的时候首先去文件中读取为NSData类对象，然后通过NSJSONSerialization类将其转化为foundation对象
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookThemePath];
    self.dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
    [self.tableView reloadData];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"重置默认" style:UIBarButtonItemStyleDone target:self action:@selector(resetDefaultSet)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidLoad {
    self.title = @"主题管理";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}
- (void)resetDefaultSet{
    [[NSFileManager defaultManager] removeItemAtPath:DCBookThemePath error:nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SFReadTheme" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //首先判断能否转化为一个json数据，如果能，接下来先把foundation对象转化为NSData类型，然后写入文件
    if ([NSJSONSerialization isValidJSONObject:list]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:list options:1 error:nil];
        [jsonData writeToFile:DCBookThemePath atomically:YES];
        NSLog(@"主题存储成功：%@",DCBookThemePath);
        
        NSData *defaultJsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookThemePath];
        self.dataArray = [NSJSONSerialization JSONObjectWithData:defaultJsonData options:1 error:nil];
        [self.tableView reloadData];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.tableView.tableFooterView = [self tableViewFooterView];
}

- (UIView *)tableViewFooterView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 70)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-100, 10, 200, 50)];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [button setTitle:@"添加新主题" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addBookSourceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    return headerView;
}
- (void)addBookSourceBtnClick:(UIButton *)sender{
    SFBookThemeDetailViewController *detailVC = [SFBookThemeDetailViewController new];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [self tableViewFooterView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFBookSourceMangerViewControllerCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SFBookSourceMangerViewControllerCell"];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    if (![dict[@"isCustom"] isEqualToString:@"1"]) {
        cell.detailTextLabel.text = @"需要管理密码";
    } else {
        cell.detailTextLabel.text = @"可编辑、删除";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (![dict[@"isCustom"] isEqualToString:@"1"]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"⚠️⚠️⚠️" message:@"此为默认主题，请谨慎操作！" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入管理员密码";
            NSLog(@"输入的内容：%@",textField.text);
        }];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = [alertVC.textFields firstObject];
            NSLog(@"确定：%@",textField.text);
            if ([textField.text isEqualToString:dict[@"isCustom"]]) {
                SFBookThemeDetailViewController *detailVC = [SFBookThemeDetailViewController new];
                detailVC.dict = dict;
                [self.navigationController pushViewController:detailVC animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"密码错误"];
            }
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        // @"可编辑";
        SFBookThemeDetailViewController *detailVC = [SFBookThemeDetailViewController new];
        detailVC.dict = dict;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    if ([dict[@"isCustom"] isEqualToString:@"1"]) {
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除该主题" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self.dataArray removeObject:dict];
            [self.tableView reloadData];
            NSArray *tmpArr = [NSArray arrayWithArray:self.dataArray];
            if ([NSJSONSerialization isValidJSONObject:tmpArr]) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpArr options:1 error:nil];
                [jsonData writeToFile:DCBookThemePath atomically:YES];
                NSLog(@"主题存储成功：%@",DCBookThemePath);
            }
        }];
        return @[action];
    } else {
        return nil;
    }
}

@end
