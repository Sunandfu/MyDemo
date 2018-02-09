//
//  HomeViewController.m
//  MyProject
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "HomeViewController.h"
#import "SSFTabBarViewController.h"
#import "NextViewController.h"
#import "RootViewController.h"
#import "HomeTableViewCell.h"
#import "ForgetViewController.h"
#import "CLMainViewController.h"
#import "BreakerViewController.h"
#import "PokeMoleViewController.h"

@interface HomeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [NetRequestManager startMonitoring];
    //    [self aotuNetworkIsOpen];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"游戏";
    
    if ([HBUserDefaults sharedInstance].cityName.length>0) {
        NSString *placeStr = [[HBUserDefaults sharedInstance].cityName substringToIndex:2];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:placeStr style:UIBarButtonItemStylePlain target:self action:@selector(cityButtonTouchEvents)];
        backButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    self.dataArray = @[@"猜你心中所想",@"连连看",@"眼力识别",@"2048",@"打砖块",@"打地鼠"];
    self.tableView.rowHeight = 44;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row == 0) {
        NextViewController *next = [[NextViewController alloc] init];
        next.pushID = @"gameFirst";
        next.name = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    } else if (indexPath.row == 1) {
        RootViewController *next = [[RootViewController alloc] init];
        next.name = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    } else if (indexPath.row == 2) {
        ForgetViewController *next = [[ForgetViewController alloc] init];
        next.name = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    } else if (indexPath.row == 3) {
        CLMainViewController *next = [[CLMainViewController alloc] init];
        next.name = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    } else if (indexPath.row == 4) {
        BreakerViewController *next = [[BreakerViewController alloc] init];
        next.name = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:next animated:YES];
    } else if (indexPath.row == 5) {
        PokeMoleViewController *next = [[PokeMoleViewController alloc] init];
        next.name = self.dataArray[indexPath.row];
        [self presentViewController:next animated:YES completion:nil];
    }
    self.hidesBottomBarWhenPushed = NO;
}
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTableCellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:0]firstObject];;
    }
    cell.myTableCell.text = self.dataArray[indexPath.row];
    return cell;
}
- (void)aotuNetworkIsOpen{
    [self performSelector:@selector(aotuNetworkIsOpen) withObject:nil afterDelay:1];
    NSLog(@"网络状态->%@",[NetRequestManager sharedNetworking].name);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (void)touchesBegan{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
    /*
     @property(nonatomic,copy) NSDate *fireDate; // 设置本地推送的时间
     @property(nonatomic,copy) NSTimeZone *timeZone; // 时区
     
     @property(nonatomic) NSCalendarUnit repeatInterval;     // 重复多少个单元发出一次
     @property(nonatomic,copy) NSCalendar *repeatCalendar;   // 设置日期
     
     @property(nonatomic,copy) CLRegion *region NS_AVAILABLE_IOS(8_0);  // 比如某一个区域的时候发出通知
     @property(nonatomic,assign) BOOL regionTriggersOnce NS_AVAILABLE_IOS(8_0); // 进入区域是否重复
     
     @property(nonatomic,copy) NSString *alertBody;      消息的内容
     @property(nonatomic) BOOL hasAction;                是否显示alertAction的文字(默认是YES)
     @property(nonatomic,copy) NSString *alertAction;    设置锁屏状态下,显示的一个文字
     @property(nonatomic,copy) NSString *alertLaunchImage;   启动图片
     
     @property(nonatomic,copy) NSString *soundName;      UILocalNotificationDefaultSoundName
     
     @property(nonatomic) NSInteger applicationIconBadgeNumber;  应用图标右上角的提醒数字
     
     // user info
     @property(nonatomic,copy) NSDictionary *userInfo;
     */
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 1.1.设置什么时间弹出
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    // 1.2.设置弹出的内容
    localNote.alertBody = @"吃饭了吗?";
    
    // 1.3.设置锁屏状态下,显示的一个文字
    localNote.alertAction = @"快点打开";
    
    // 1.4.显示启动图片
    localNote.alertLaunchImage = @"HomePage";
    
    // 1.5.是否显示alertAction的文字(默认是YES)
    localNote.hasAction = YES;
    
    // 1.6.设置音效
    localNote.soundName = UILocalNotificationDefaultSoundName;
    
    // 1.7.应用图标右上角的提醒数字
    localNote.applicationIconBadgeNumber = 1;
    
    // 1.8.设置UserInfo来传递信息
    localNote.userInfo = @{@"alertBody" : localNote.alertBody, @"applicationIconBadgeNumber" : @(localNote.applicationIconBadgeNumber)};
    
    // 2.调度通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cityButtonTouchEvents{
    NSLog(@"%s",__func__);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
//改变状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}
*/
@end
