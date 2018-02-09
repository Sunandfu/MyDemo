//
//  ViewController.m
//  Tan_SwipeCellBlock
//
//  Created by PX_Mac on 16/3/30.
//  Copyright © 2016年 PX_Mac. All rights reserved.

//  自定义UITableViewCell左滑多菜单功能，使用Block进行回调

#import "ViewController.h"
#import "MemberModel.h"
#import "TanTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablView;
@property (nonatomic, strong) NSMutableArray *dataArr; //模型数据集

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化数据
    self.dataArr = [NSMutableArray arrayWithArray:[self getMemberData]];
    
    //初始化tableView
    self.tablView.dataSource = self;
    self.tablView.rowHeight = 60.f;
}

//模型数据
- (NSArray *)getMemberData{
    NSArray *nameArray = @[@"徐子陵",@"寇仲",@"跋锋寒",@"侯希白",@"石之轩",@"杨虚彦",@"宁道奇",@"雷九指",@"宋缺"];
    NSArray *emailArrray = @[@"ziling@sina.com",@"kouzhong@qq.com",@"fenghan@163.com",@"xibai@sohu.com",@"zhixuan@yahoo.com",@"xuyan@hotmail.com",@"daoqi@gmail.com",@"jiuzhi@126.com",@"songque@aliyun.com"];
   
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (int i=0; i<100; i++) {
        NSString *name = [NSString stringWithFormat:@"%@",nameArray[arc4random_uniform((int)nameArray.count)]];
        NSString *email = [NSString stringWithFormat:@"%@",emailArrray[arc4random_uniform((int)emailArrray.count)]];
        NSString *phone = [NSString stringWithFormat:@"1385120%d",arc4random_uniform(8999)+1000];
        MemberModel *model = [MemberModel memberWithID:1+i displayname:name email:email phone:phone];
        [mutableArr addObject:model];
    }
    
    
    NSArray *arr = [NSArray arrayWithArray:mutableArr];
    return arr;
}

#pragma mark - 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TanTableViewCell *cell = [TanTableViewCell cellWithTableView:tableView];
    
    MemberModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell setData:model]; //设置数据
    
    __weak typeof(self) tempSelf = self;
    __weak typeof(cell) tempCell = cell;
    //设置删除cell回调block
    cell.deleteMember = ^{
        NSIndexPath *tempIndex = [tempSelf.tablView indexPathForCell:tempCell];
        [tempSelf.dataArr removeObject:tempCell.model];
        [tempSelf.tablView deleteRowsAtIndexPaths:@[tempIndex] withRowAnimation:UITableViewRowAnimationLeft];
    };
    
    //设置当cell左滑时，关闭其他cell的左滑
    cell.closeOtherCellSwipe = ^{
        for (TanTableViewCell *item in tempSelf.tablView.visibleCells) {
            if (item != tempCell) [item closeLeftSwipe];
        }
    };
    
    return cell;
}

//刷新数据
- (IBAction)refreshData:(UIButton *)sender{
    [self.dataArr removeAllObjects]; //先清空数据
    self.dataArr = [NSMutableArray arrayWithArray:[self getMemberData]];
    [self.tablView reloadData]; //重载数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com