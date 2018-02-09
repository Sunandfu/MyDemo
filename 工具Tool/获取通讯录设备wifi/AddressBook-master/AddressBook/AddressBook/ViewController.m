//
//  ViewController.m
//  AddressBook
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "ViewController.h"
#import "WSAddressBook.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *dataSource;//数据源
@property (nonatomic, strong) NSString *mobileString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"获取联系人";
    
    //获取没有经过排序的联系人模型
    [WSAddressBook getOriginalAddressBook:^(NSArray<WSPersonModel *> *addressBookArray) {

        _dataSource = addressBookArray;
        [self.tableView reloadData];
        
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    
    
}


#pragma mark - TableViewDatasouce/TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    WSPersonModel *model = _dataSource[indexPath.row];
    cell.textLabel.text = model.name;
    
    for (NSInteger i = 0; i < model.mobileArray.count; i++) {
        if (i == 0) {
            _mobileString = [model.mobileArray objectAtIndex:0];
        }
        else {
            _mobileString = [_mobileString stringByAppendingFormat:@"和%@",model.mobileArray[i]];
        }
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"姓名:%@ 电话:%@",model.name,_mobileString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSPersonModel *people = _dataSource[indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:people.name
                                                    message:[NSString stringWithFormat:@"号码:%@",people.mobileArray]
                                                   delegate:nil
                                          cancelButtonTitle:@"知道啦"
                                          otherButtonTitles:nil];
    [alert show];
}






@end
