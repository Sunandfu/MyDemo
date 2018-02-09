//
//  ViewController.m
//  navigationBarAnimation
//
//  Created by lihongfeng on 16/1/22.
//  Copyright © 2016年 wanglei. All rights reserved.
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
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat scale;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.headerHeight = 260;
    [self.view addSubview:self.tableView];
    
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //添加背景view
    CGRect backView_frame = CGRectMake(0, -kStatusBarHeight, kScreenWith, kNavigationBarHeight+kStatusBarHeight);
    UIView *backView = [[UIView alloc] initWithFrame:backView_frame];
    UIColor *backColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.4 alpha:0];
    backView.backgroundColor = [backColor colorWithAlphaComponent:0.3];
    [self.navigationController.navigationBar addSubview:backView];
    self.backView = backView;
    self.backColor = backColor;
    //标题
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    //header
    CGRect bounds = CGRectMake(0, 0, kScreenWith, self.headerHeight);
    UIView *contentView = [[UIView alloc] initWithFrame:bounds];
    contentView.backgroundColor = [UIColor blackColor];
    //背景
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.bounds = bounds;
    headerImageView.center = contentView.center;
    headerImageView.image = [UIImage imageNamed:@"backImage.jpg"];
    contentView.layer.masksToBounds = YES;
    
    self.headerImageView = headerImageView;
    self.headerContentView = contentView;
    [self.headerContentView addSubview:self.headerImageView];
    self.headerContentView.layer.masksToBounds = YES;
    
    //信息内容
    CGRect icon_frame = CGRectMake(12, self.headerContentView.bounds.size.height-80-12, 80, 80);
    UIImageView *icon = [[UIImageView alloc] initWithFrame:icon_frame];
    icon.backgroundColor = [UIColor clearColor];
    icon.image = [UIImage imageNamed:@"icon.jpg"];
    icon.layer.cornerRadius = 80/2.0f;
    icon.layer.masksToBounds = YES;
    icon.layer.borderWidth = 1.0f;
    icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.headerContentView addSubview:icon];
    self.icon = icon;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(108, self.headerContentView.bounds.size.height-60-12, kScreenWith-108-12, 50)];
    label.text = @"这羡慕你们这些人, 年纪轻轻的就认识了才华横溢的我!";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    self.label = label;
    [self.headerContentView addSubview:self.label];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:bounds];
    [headerView addSubview:self.headerContentView];
    self.tableView.tableHeaderView = headerView;;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y + 40)/300.0f;
    self.backView.backgroundColor = [self.backColor colorWithAlphaComponent:alpha];
    
    if (offset_Y < -64) {
        //放大比例
        CGFloat add_topHeight = -(offset_Y+kNavigationBarHeight+kStatusBarHeight);
        self.scale = (self.headerHeight+add_topHeight)/self.headerHeight;
        //改变 frame
        CGRect contentView_frame = CGRectMake(0, -add_topHeight, kScreenWith, self.headerHeight+add_topHeight);
        self.headerContentView.frame = contentView_frame;
        CGRect imageView_frame = CGRectMake(-(kScreenWith*self.scale-kScreenWith)/2.0f,
                                            0,
                                            kScreenWith*self.scale,
                                            self.headerHeight+add_topHeight);
        self.headerImageView.frame = imageView_frame;
        
        CGRect icon_frame = CGRectMake(12, self.headerContentView.bounds.size.height-80-12, 80, 80);
        self.icon.frame = icon_frame;
        
        self.label.frame = CGRectMake(108, self.headerContentView.bounds.size.height-60-12, kScreenWith-108-12, 50);
        
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell %ld", (long)indexPath.row];
    
    return cell;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        
        CGRect tableView_frame = CGRectMake(0, -64, kScreenWith, kScreenHeight+kNavigationBarHeight+kStatusBarHeight);
        _tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    
    return _tableView;
}



@end
