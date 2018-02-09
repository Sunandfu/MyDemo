//
//  InfoTableViewViewController.m
//  HBGuard
//
//  Created by 郝好杰 on 15/11/9.
//  Copyright © 2015年 YunXiang. All rights reserved.
//

#import "InfoTableViewViewController.h"

@interface InfoTableViewViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation InfoTableViewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBackgroundColor];
    
    //[self getTableViewData];
    [self createTableView];
    
    // Do any additional setup after loading the view.
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.channelString=@"推荐";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"title" object:nil];
}


//设置背景颜色
-(void)setViewBackgroundColor{
    if ([[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 4S"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage4"]];
    }else if ([[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 5"]||[[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 5S"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage5s"]];
    }else if ([[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 6"]||[[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 6S"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage6"]];
    }else if ([[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 6 Plus"]||[[Factory getCurrentDeviceModel] isEqualToString:@"iPhone 6S Plus"]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backImageplus"]];
    }
}


-(void)createTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-30) style:UITableViewStylePlain];
    
    //设置分割线居中
    [self.tableView setSeparatorInset: UIEdgeInsetsMake(0, 8, 0, 8)];
    self.tableView.delegate=self;
    //self.tableView.hidden = YES;
    self.tableView.dataSource=self;
//    [self.view addSubview:self.tableView];
    
    [Factory setExtraCellLineHidden:self.tableView];
}


- (void)getChannelStings {
    NSLog(@"调用");

}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];
        }
        cell.textLabel.text = @"试验一下";
        return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.channel);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"title" object:nil];
    //当View消时取消加载效果
    [GiFHUD dismiss];
}

@end
