//
//  SFGroupManageViewController.m
//  ReadBook
//
//  Created by lurich on 2020/11/9.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFGroupManageViewController.h"
#import "SFBookSave.h"

@interface SFGroupManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSArray *dataArray;

@end

@implementation SFGroupManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分组管理";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    NSArray *groups = [SFBookSave selectBookGroups];
    self.dataArray = [NSArray arrayWithArray:groups];
    [self.tableView reloadData];
    if (groups.count<1) {
        SFBookGroupModel *group = [SFBookGroupModel new];
        group.name = @"书架(默认全部书籍，无法删除)";
        group.createTime = [SFTool getTimeLocal];
        group.other1 = @"";
        group.other2 = @"";
        group.other3 = 0.0;
        [SFBookSave insertBookGroup:group];
        [self groupLoadData];
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
    [button setTitle:@"添加分组" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addBookGroup:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    return headerView;
}
- (void)addBookGroup:(UIButton *)sender{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入分组名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入小说分组名称";
        NSLog(@"输入的内容：%@",textField.text);
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
        UITextField *textField = [alertVC.textFields firstObject];
        SFBookGroupModel *group = [SFBookGroupModel new];
        group.name = textField.text;
        group.createTime = [SFTool getTimeLocal];
        group.other1 = @"";
        group.other2 = @"";
        group.other3 = 0.0;
        [SFBookSave insertBookGroup:group];
        [self groupLoadData];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.tableFooterView = [self tableViewFooterView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFGroupManageViewControllerCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SFGroupManageViewControllerCell"];
    }
    SFBookGroupModel *book = self.dataArray[indexPath.row];
    cell.textLabel.text = book.name;
    NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:KeySelectGroup];
    if (book.ID == selectedIndex) {
        cell.backgroundColor = [UIColor orangeColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = @"当前选择";
    } else {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.detailTextLabel.text = @"";
        if (@available(iOS 13.0, *)) {
            cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
                if (isFollSys) {
                    if (traitCollection.userInterfaceStyle==UIUserInterfaceStyleDark) {
                        return [UIColor whiteColor];
                    } else {
                        return [UIColor blackColor];
                    }
                } else {
                    BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
                    if (isNignt) {
                        return [UIColor whiteColor];
                    } else {
                        return [UIColor blackColor];
                    }
                }
            }];
        } else {
            // Fallback on earlier versions
            BOOL isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
            if (isNignt) {
                cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor whiteColor];
            } else {
                cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor blackColor];
            }
        };
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFBookGroupModel *book = self.dataArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setInteger:book.ID forKey:KeySelectGroup];
    [self.tableView reloadData];
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return nil;
    }
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除该分组" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        SFBookGroupModel *group = self.dataArray[indexPath.row];
        NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:KeySelectGroup];
        if (group.ID == selectedIndex) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:KeySelectGroup];
        }
        BOOL isDelegate = [SFBookSave deleteBookGroup:group];
        if (isDelegate) {
            NSLog(@"删除成功 %d",isDelegate);
            [self groupLoadData];
        }
    }];
    return @[action];
}
- (void)groupLoadData{
    NSArray *groups = [SFBookSave selectBookGroups];
    self.dataArray = [NSArray arrayWithArray:groups];
    [self.tableView reloadData];
}

@end
