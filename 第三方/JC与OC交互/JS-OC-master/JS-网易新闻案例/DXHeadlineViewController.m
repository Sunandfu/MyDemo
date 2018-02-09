//
//  DXHeadlineViewController.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXHeadlineViewController.h"
#import "UIImageView+WebCache.h"
#import "DXHTTPManager.h"
#import "DXHeadline.h"
#import "DXDetailController.h"
#import "MJExtension.h"
#import "DXHeadlineTool.h"

@interface DXHeadlineViewController ()

@property (nonatomic,strong) NSArray *headline;

@end

@implementation DXHeadlineViewController

- (void)setHeadline:(NSArray *)headline {
    _headline = headline;
    
    // 重新加载tableview
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"头条新闻";

    self.tableView.rowHeight = 70;
    
    // 控制器拿到新闻头条地址,调用方法加载数据
    [self setUpData];

}

- (void)setUpData {
    self.headline = nil;

    [DXHeadlineTool headlineWithSuccessBlock:^(NSArray *array) {
         self.headline = array;
    } errorBlock:^(NSError *error) {
        NSLog(@"连接出错 %@", error);

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.headline.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headline" ];

    DXHeadline *model = self.headline[indexPath.row];
    
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.digest;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"loading"]];

    return cell;
}

#pragma mark - 跳转之前执行的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSUInteger selecetedRow = self.tableView.indexPathForSelectedRow.row;

    DXDetailController *newsDeatailVc = segue.destinationViewController;

    newsDeatailVc.headline = self.headline[selecetedRow];

}



@end
