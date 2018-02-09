//
//  ViewController.m
//  test
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import <sys/sysctl.h>
#import <mach/mach.h>

#import "ViewController.h"
#import "MSPadHorizonView.h"
#import "MyHorizonCell.h"
#import "YourHorizonCell.h"
#import "MyHorizonRefreshView.h"

@interface ViewController ()<MSPadHorizonViewDelegate, MSPadHorizonViewPullRefreshDelegate, UIAlertViewDelegate>{
    NSUInteger sectionCount, colCount;
}
@property (nonatomic, strong) MSPadHorizonView *myHorizonView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sectionCount = 2;
    colCount = 8;
    [self initHorizonView];
    [self initHorizonRefreshView];
}

- (void)initHorizonView{
    self.myHorizonView = [[MSPadHorizonView alloc]initWithFrame:CGRectMake(0, 150, self.view.width, 100) style:MSPadHorizonViewStylePlain];

    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    header.backgroundColor = [UIColor redColor];
    header.font = [UIFont systemFontOfSize:14];
    header.text = @"header";
    header.numberOfLines = 0;
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 100)];
    footer.backgroundColor = [UIColor redColor];
    footer.text = @"footer";
    footer.font = [UIFont systemFontOfSize:14];
    header.numberOfLines = 0;
    self.myHorizonView.headerView = header;
    self.myHorizonView.footerView = footer;
    self.myHorizonView.horizonDelegate = self;// 必要
    //self.myHorizonView.cellSpacing = 5.0; // cell 间距
    self.myHorizonView.pullRefreshDelegate = self;// 开启内置的左右拉刷新功能
    self.myHorizonView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];

    [self.view addSubview:self.myHorizonView];
}

- (void)initHorizonRefreshView{
    // 自定义拉动头尾view
    MyHorizonRefreshView *left = [[MyHorizonRefreshView alloc]initWithFrame:CGRectMake(0, 0, 60, 100)];
    left.isLeft = YES;
    MyHorizonRefreshView *right = [[MyHorizonRefreshView alloc]initWithFrame:left.frame];
    self.myHorizonView.refreshHeader = left;
    self.myHorizonView.refreshFooter = right;
}

#pragma mark --horizonview delegate
- (NSUInteger)numberOfSectionsInHorizonView:(MSPadHorizonView *)horizonView{
    return sectionCount;
}

- (NSUInteger)MSPadHorizonView:(MSPadHorizonView *)horizonView numberOfColsInSection:(NSUInteger)section{
    return colCount;
}

CGFloat getRandom(){
    NSInteger fff = arc4random() % 20;
    fff = 40 + (fff % 2 ? fff : -fff);
    return fff;
};

// cell的宽度
- (CGFloat)MSPadHorizonView:(MSPadHorizonView *)horizonView widthForIndexPath:(MPIndexPath *)indexPath{
    return indexPath.col % 2 ? 30 : 50;//indexPath.col + 30;
}
// 设置cell，cell是继承自MSPadHorizonCell的
- (MSPadHorizonCell*)MSPadHorizonView:(MSPadHorizonView *)horizonView cellForColAtIndexPath:(MPIndexPath *)indexPath{
    if (indexPath.col % 2) {
        MyHorizonCell *cell = [horizonView horizonReusableCellWithIdentifier:@"my"];// ========一定要调用的，重用========
        if (!cell) {
            cell = [[MyHorizonCell alloc]initWithReuseIdentifier:@"my"];// 初始化用标识
        }
        // 下面是让每个cell的显示不一样 利于展示效果
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
        cell.myLabel.text = [NSString stringWithFormat:@"%zd", indexPath.section];
        cell.myLabel.textColor = [UIColor orangeColor];
        cell.yourLabel.text = [NSString stringWithFormat:@"%zd", indexPath.col];
        cell.yourLabel.textColor = [UIColor blueColor];
        cell.myLabel.backgroundColor = [UIColor whiteColor];
        cell.yourLabel.backgroundColor = [UIColor yellowColor];
        return cell;
    }else{
        YourHorizonCell *cell = [horizonView horizonReusableCellWithIdentifier:nil];// 没有标识的话启用默认值
        if (!cell) {
            cell = [[YourHorizonCell alloc]initWithReuseIdentifier:nil];
        }
        cell.backgroundColor = [UIColor colorWithRed:0.2 green:1 blue:0.2 alpha:1];
        cell.myLabel.text = [NSString stringWithFormat:@"%zd", indexPath.col];
        cell.myLabel.textColor = [UIColor cyanColor];
        cell.myLabel.backgroundColor = [UIColor yellowColor];
        cell.cycleView.backgroundColor =  [UIColor cyanColor];
        return cell;
    }
}
// section header
- (CGFloat)MSPadHorizonView:(MSPadHorizonView *)horizonView widthForHeaderInSection:(NSUInteger)section{
    return 30;
}

- (UIView*)MSPadHorizonView:(MSPadHorizonView *)horizonView viewForHeaderInSection:(NSUInteger)section{
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, horizonView.height)];
    header.font = [UIFont systemFontOfSize:11];
    header.text = [NSString stringWithFormat:@"第%zd个标题头", section];
    header.numberOfLines = 0;
    header.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    return header;
}

// section footer
- (CGFloat)MSPadHorizonView:(MSPadHorizonView *)horizonView widthForFooterInSection:(NSUInteger)section{
    return 30;
}

- (UIView*)MSPadHorizonView:(MSPadHorizonView *)horizonView viewForFooterInSection:(NSUInteger)section{
    UILabel *footer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, horizonView.height)];
    footer.text = [NSString stringWithFormat:@"第%zd个标题尾", section];
    footer.numberOfLines = 0;
    footer.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    footer.font = [UIFont systemFontOfSize:11];
    return footer;
}

// cell点选事件
- (void)MSPadHorizonView:(MSPadHorizonView *)horizonView didSelectCell:(MSPadHorizonCell *)cell atIndexPath:(MPIndexPath *)indexPath{
    //[horizonView scrollToColAtIndexPath:[MPIndexPath indexPathWithSection:indexPath.section andCol:indexPath.col + 1] atScrollPosition:MSPadHorizonViewScrollPositionLeft animated:YES];
}

// 左右拉刷新回调
- (void)MSPadHorizonView:(MSPadHorizonView *)horizonView didRefresh:(MSPadHorizonRefreshDirection)direction{
    NSString *msg;
    if (direction == MSPadHorizonRefreshDirectTop) {
        // ...左拉事件
        msg = @"刷新完成";
    }else {
        // ...右拉
        msg = @"加载完成";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqualToString:@"刷新完成"]) {
        [self.myHorizonView finishRefresh]; // 模拟左拉刷新之后，数据没有变化，所以只结束左拉动作
    }else{
        sectionCount++;
        [self.myHorizonView reloadData]; // 模拟右拉刷新之后，数据变化，===这边即要结束刷新动作又要reload只调用reloadData即可===
    }
}

#pragma mark --scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double)usedMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

@end
