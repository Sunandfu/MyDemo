//
//  ViewController.m
//  01-模糊查询
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "Contact.h"
#import "ContactTool.h"

@interface ViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *contacts;
@end

@implementation ViewController
- (NSMutableArray *)contacts
{
    if (_contacts == nil) {
        // 从数据库读取数据
        _contacts = [NSMutableArray arrayWithArray:[ContactTool contacts]];
        
        if (_contacts == nil) {
            _contacts = [NSMutableArray array];
        }
    }
    return _contacts;
}

- (IBAction)insert:(id)sender {
    
    
    NSArray *nameArr = @[@"gogoing",@"duang",@"uzi",@"omg"];
    
    NSString *name = [NSString stringWithFormat:@"%@%d",nameArr[arc4random_uniform(4)],arc4random_uniform(200)];
    NSString *phone = [NSString stringWithFormat:@"%d",arc4random_uniform(10000)+10000];
    Contact *c = [Contact contactWithName:name phone:phone];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.contacts.count inSection:0];
    [self.contacts addObject:c];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 存储到数据库里面
    [ContactTool saveWithContact:c];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // 设置导航条的内容
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
    
}

// 以后想实现tableViewcell的上下排序拖动，就实现这个方法。
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    
//}

#warning 如果以后直接从本地数据库请求数据，就在这里写
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // o  select * from t_contact where name like '%searchText%' or phone like '%searchText%'
    // % 在stringWithFormat中有特殊意思
    // %% == %
    // 输入一个文字，进行模糊查询，查看下名字或者电话是否包含文字
    NSString *sql = [NSString stringWithFormat:@"select * from t_contact where name like '%%%@%%' or phone like '%%%@%%';",searchText,searchText];
   _contacts = (NSMutableArray *)[ContactTool contactWithSql:sql];
    [self.tableView reloadData];

}
#warning 如果以后要像服务器请求数据，就在这里写
// 点击键盘上的按钮就会调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 给服务器发送请求
    
    // 刷新表格
    
    NSLog(@"%s",__func__);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    Contact *c  = self.contacts[indexPath.row];
    cell.textLabel.text = c.name;
    cell.detailTextLabel.text = c.phone;
    return cell;
}

@end
