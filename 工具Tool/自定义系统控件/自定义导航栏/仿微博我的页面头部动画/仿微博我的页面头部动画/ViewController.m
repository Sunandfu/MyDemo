//
//  ViewController.m
//  仿微博我的页面头部动画
//
//  Created by 小富 on 16/8/17.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "ViewController.h"

#define kScreenWith [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

const CGFloat kNavigationBarHeight = 44;
const CGFloat kStatusBarHeight = 20;

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation ViewController

- (void)settingNavigationBar{
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //添加背景view
    CGRect backView_frame = CGRectMake(0, -kStatusBarHeight, kScreenWith, kNavigationBarHeight+kStatusBarHeight);
    UIView *backView = [[UIView alloc] initWithFrame:backView_frame];
    UIColor *backColor = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:0];
    backView.backgroundColor = [backColor colorWithAlphaComponent:0];
    [self.navigationController.navigationBar addSubview:backView];
    self.backView = backView;
    self.backColor = backColor;
    //标题
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerHeight = 210;
    //header
    CGRect bounds = CGRectMake(0, 0, kScreenWith, self.headerHeight);
    //背景
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, kScreenWith, self.headerHeight+64*2)];
    headerImageView.image = [UIImage imageNamed:@"backImage.jpg"];
    [self.view addSubview:headerImageView];
    self.headerImageView = headerImageView;
    
    [self settingNavigationBar];
    [self.view addSubview:self.tableView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:bounds];
    contentView.backgroundColor = [UIColor clearColor];
    
    CGFloat userImgWidth = 60;
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentView.bounds.size.width/2-userImgWidth/2, contentView.bounds.size.height-60-userImgWidth, userImgWidth, userImgWidth)];
    userImageView.image = [UIImage imageNamed:@"userHeaderImg.jpg"];
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = userImgWidth/2;
    [contentView addSubview:userImageView];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, contentView.bounds.size.height-55, contentView.bounds.size.width, 20)];
    detailLabel.text = @"这个人很懒，什么也没有留下";
    detailLabel.font = [UIFont systemFontOfSize:14.0f];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor whiteColor];
    [contentView addSubview:detailLabel];
    self.tableView.tableHeaderView = contentView;
    self.headerContentView = contentView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = -scrollView.contentOffset.y;
    CGFloat alpha = (-offset_Y)/self.headerHeight;
    self.backView.backgroundColor = [self.backColor colorWithAlphaComponent:alpha];
    //改变 frame
    CGRect contentView_frame = CGRectMake(0, 0, kScreenWith, self.headerHeight+offset_Y);
    self.headerContentView.frame = contentView_frame;
    CGRect imageView_frame;
    if (offset_Y>128) {
        imageView_frame = CGRectMake(0,
                                     (offset_Y/2-64)*2,
                                     kScreenWith,
                                     self.headerHeight+64*2);
    } else {
        imageView_frame = CGRectMake(0,
                                     offset_Y/2-64,
                                     kScreenWith,
                                     self.headerHeight+64*2);
    }
    NSLog(@"%f,%f",offset_Y,contentView_frame.size.height);
    self.headerImageView.frame = imageView_frame;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"cell %ld", (long)indexPath.row];
    
    return cell;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        
        CGRect tableView_frame = CGRectMake(0, 0, kScreenWith, kScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    
    return _tableView;
}



@end
