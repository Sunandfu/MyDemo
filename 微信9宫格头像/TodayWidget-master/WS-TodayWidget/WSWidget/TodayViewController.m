//
//  TodayViewController.m
//  water
//
//  Created by iMac on 17/5/17.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "AFNetworking.h"
#import "NewsCell.h"

#import "Masonry.h"


#define stsystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]

#define cellHeight 85


@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *dynamicTableView;

@end

@implementation TodayViewController {
    
    NewsCell *dynamicCell;
    
    AFHTTPSessionManager *manager;
    
    NSMutableArray *modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.preferredContentSize = CGSizeMake(self.view.frame.size.width, cellHeight+30);//显示大小
    
    manager = [AFHTTPSessionManager manager];
    
    [self requestNet];
    
    
    UIButton *footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    footBtn.layer.cornerRadius = 5;
    [footBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:.3]];
    [self.view addSubview:footBtn];
    [footBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-12.5);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@25);
    }];
    
    
    [self setPreferredContentSize:CGSizeMake(self.view.frame.size.width, cellHeight*4+ 50)];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (stsystemVersion < 10.0) {
//        
//        if (modelArray.count > 4) {
//            CGFloat height = 4 * cellHeight ;
//            [self setPreferredContentSize:CGSizeMake(0, height+ 50)];
//        }
//        else {
//            CGFloat height = modelArray.count * cellHeight ;
//            height         = height > cellHeight ? height : cellHeight;
//            [self setPreferredContentSize:CGSizeMake(0, height+ 50)];
//        }
//    }
//}


//第一次进来请求
- (void)requestNet {
    
    //文章列表
    NSString *articleURL = @"http://wangyi.butterfly.mopaasapp.com/news/api?type=war&page=1&limit=10";
    [manager GET:articleURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self creatTableView];//创建tableView
        
        NSArray *articleArray = responseObject[@"list"];
        modelArray = [NSMutableArray array];
        for (NSDictionary *dic in articleArray) {
            
            NewsModel *model = [[NewsModel alloc]init];
            
            model.cellTitle = dic[@"title"];//单元格上的主标题
            model.imageUrl = dic[@"imgurl"];
            model.newsID = dic[@"id"];
            model.time = dic[@"time"];
            [modelArray addObject:model];
            
        }
        
        if (modelArray.count > 4) {
            CGFloat height = 4 * cellHeight ;
            [self setPreferredContentSize:CGSizeMake(0, height+ 50)];
        }
        else {
            CGFloat height = modelArray.count * cellHeight ;
            height         = height > cellHeight ? height : cellHeight;
            [self setPreferredContentSize:CGSizeMake(0, height+ 50)];
        }
        [self.dynamicTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    
}

- (void)creatTableView {
    
    _dynamicTableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _dynamicTableView.dataSource  = self;
    _dynamicTableView.delegate = self;
    _dynamicTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_dynamicTableView];
    
    [_dynamicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"dynamicCell";
    dynamicCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (dynamicCell == nil) {
        
        dynamicCell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    dynamicCell.model = modelArray[indexPath.row];//传model   MVC
    
    return dynamicCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsModel *model = [modelArray objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"iOSWidgetApp://action=openNewsID=%@",model.newsID];
    
    [self.extensionContext openURL:[NSURL URLWithString:string] completionHandler:nil];
}

- (void)moreAction {
    [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=openAPP"] completionHandler:nil];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    completionHandler(NCUpdateResultNewData);
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
