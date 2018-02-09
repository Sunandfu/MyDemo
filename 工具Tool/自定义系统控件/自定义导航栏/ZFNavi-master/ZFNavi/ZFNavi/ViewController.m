//
//  ViewController.m
//  ZFNavi
//
//  Created by renzifeng on 15/9/10.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#define kWindowHeight 205.0f
#import "ViewController.h"
#import "CoolNavi.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CoolNavi *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 给导航条的背景图片传递一个空图片的UIImage对象
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 隐藏底部阴影条，传递一个空图片的UIImage对象
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CoolNavi *headerView = [[CoolNavi alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kWindowHeight)backGroudImage:@"background" headerImageURL:@"http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4f263b0fc3adbb6fd52663334.jpg" title:@"哈哈!" subTitle:@"个性签名, 啦啦啦!"];
    self.headerView = headerView;
    headerView.scrollView = self.tableView;
    headerView.imgActionBlock = ^(){
        NSLog(@"headerImageAction");
    };
    [self.view addSubview:headerView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + kWindowHeight)/2;
    NSLog(@"%f ",yOffset);
    if (yOffset < -kWindowHeight) {
        CGRect rect = self.headerView.backImageView.frame;
        rect.origin.y = -0.5*kWindowHeight;
        rect.size.height =  -yOffset+kWindowHeight-100;
        rect.origin.x = xOffset;
        rect.size.width = self.view.frame.size.width + fabs(xOffset)*2;
        //修改背景的frame
        self.headerView.backImageView.frame = rect;
        self.headerView.height = -yOffset;
    }else {
        self.headerView.height = kWindowHeight;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier  = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"test %ld",(long)indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
