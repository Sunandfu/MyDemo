//
//  ZMAddressBookViewController.m
//  ZMAddressBook
//
//  Created by ZengZhiming on 2017/4/1.
//  Copyright © 2017年 菜鸟基地. All rights reserved.
//

#import "ZMAddressBookViewController.h"
#import "ZMAddressBookManager.h"
#import "ZMEditPersonView.h"

@interface ZMAddressBookViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;       //!< TableView.

@property (nonatomic, strong) ZMEditPersonView *editView;   //!< 编辑View.

@property (nonatomic, strong) NSMutableArray<ZMPersonModel *> *dataSourceArray; //!< 数据源.

@end

@implementation ZMAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 初始化View
    [self initView];
    
    // 获取数据源
    [self getDataSource];
}


/** 初始化View */
- (void)initView
{
    // 设置标题
    self.title = @"自定义通讯录";
    
    // 设置添加按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddButtonAction:)];
    
    // 初始化数据源数组
    _dataSourceArray = [NSMutableArray array];
    
    // 初始化编辑View
    _editView = [[ZMEditPersonView alloc] init];

    // 初始化TableView
    [self initTableView];
}


/** 初始化TableView */
- (void)initTableView
{
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:MAIN_SCREEN_FRAME style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;;
}

/** 获取数据源 */
- (void)getDataSource
{
    [[ZMAddressBookManager getInstance] getAddressBookWithSort:SortByFirstName completionBlock:^(int code, NSArray<ZMPersonModel *> *personArray, NSString *msg) {
        [_dataSourceArray removeAllObjects];
        [_dataSourceArray addObjectsFromArray:personArray];
        [_tableView reloadData];
    }];
}

/** 添加按钮点击响应 */
- (void)onAddButtonAction:(UIBarButtonItem *)action
{
    [_editView showView:nil submitBlock:^(int code, ZMPersonModel *personModel) {
        if (code == 1 && [[ZMAddressBookManager getInstance] addPerson:personModel]) {
            [self getDataSource];
        }
    }];
}


#pragma mark - UITableViewDataSource实现方法

/** Section中Cell数量 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _dataSourceArray.count;
}

static NSString *CellIdentifier = @"UITableViewCell";

/** 设置Cell视图 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取Cell
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!tableCell) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // 获取数据
    ZMPersonModel *personModel = _dataSourceArray[indexPath.row];
    if (!personModel.lastName) personModel.lastName = @"";
    if (!personModel.firstName) personModel.firstName = @"";
    NSString *name = [personModel.lastName stringByAppendingString:personModel.firstName];
    NSString *phone = [personModel.phones firstObject].content;
    UIImage *headImage = personModel.headImage ? personModel.headImage : [UIImage imageNamed:@"person_head"];
    
    // 设置Cell数据
    tableCell.textLabel.text = name;
    tableCell.detailTextLabel.text = phone;
    tableCell.imageView.image = headImage;
    
    return tableCell;
}

/** 添加侧滑删除 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除联系人
    if ([[ZMAddressBookManager getInstance] removePerson:_dataSourceArray[indexPath.row]]) {
        [self getDataSource];
    }
}


#pragma mark - UITableViewDelegate实现方法

/** 设置Cell高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


/** 点击Cell响应 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 编辑
    [_editView showView:_dataSourceArray[indexPath.row] submitBlock:^(int code, ZMPersonModel *personModel) {
        if (code == 1 && [[ZMAddressBookManager getInstance] updatePerson:personModel]) {
            [self getDataSource];
        }
    }];
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
