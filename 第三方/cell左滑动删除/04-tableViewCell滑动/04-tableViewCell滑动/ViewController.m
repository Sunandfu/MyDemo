//
//  ViewController.m
//  04-tableViewCell滑动
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *cover;

@end

@implementation ViewController

- (UIView *)cover
{
    if (_cover == nil) {
        
        UIView *cover = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
       
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.8;
        cover.userInteractionEnabled = NO;
        [self.view.window addSubview:cover];
        _cover = cover;
    }
    return _cover;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"删除");
    }];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"添加");
    }];
    action1.backgroundColor = [UIColor blueColor];
    return @[action,action1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"row--%ld",indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.cover;
}

//// 实现这个方法，就有删除按钮
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"删除111");
//}
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row>0) {
//        return UITableViewCellEditingStyleDelete;
//    } else {
//        return UITableViewCellEditingStyleNone;
//    }
//}

@end
