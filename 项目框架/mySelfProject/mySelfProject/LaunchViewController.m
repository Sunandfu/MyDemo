//
//  LaunchViewController.m
//  mySelfProject
//
//  Created by 小富 on 16/3/14.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "LaunchViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "AppDelegate.h"
#import "RTutorialView.h"
#import <CoreLocation/CoreLocation.h>

@interface LaunchViewController ()<RTutorial,CLLocationManagerDelegate>

@property (nonatomic, strong) RTutorialView *tutorialView;
@property (nonatomic, strong) CLLocationManager *manger;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.manger respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.manger requestAlwaysAuthorization];
    }
    [self.manger startUpdatingLocation];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/studymark.txt"]])
    {
        [self initRootViewControllerWithTabbar];
    }
    else{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.view.backgroundColor = [UIColor clearColor];
        [self makeStudyPage];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)initRootViewControllerWithTabbar{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UIViewController *viewController1 = [HomeViewController new];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    
//    UIViewController *viewController2 = [LocationViewController new];
//    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
//    
//    UIViewController *viewController3 = [IncomeViewController new];
//    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    
    UIViewController *viewController4 = [MineViewController new];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    
    
    AppDelegate *appDele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDele.tabbarController = [[UITabBarController alloc] init];
    appDele.tabbarController.delegate = appDele;
    appDele.tabbarController.viewControllers = @[nav1, nav4];
    [appDele.tabbarController setSelectedViewController:nav1];
    appDele.window.rootViewController = appDele.tabbarController;
    
}
-(void)makeStudyPage
{
    if (self.tutorialView == nil) {
        self.tutorialView = [[RTutorialView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        [self.view addSubview:self.tutorialView];
        self.tutorialView.tutorialDelegate = self;
    }
//    [self.tutorialView setBackgroundImage:[UIImage imageNamed:@"learn1"]];
    [self.tutorialView setLearningImageNames:@[@"jiance_1",@"huxi_2",@"zixun_3",@"guanjia_4"]];
    
}
- (void)tutorialDidFinish:(RTutorialView *)tutorialView {
    
    
    NSLog(@"点击了");
    [[NSFileManager defaultManager]createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/studymark.txt"] contents:nil attributes:nil];
    
}
- (void)tutorialView:(RTutorialView *)tutorialView didPageToIndex:(NSUInteger)index {
    NSLog(@"点击了第%lu张启动页",index);
    if (index == 3) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(kMainScreenWidth/2-40, kMainScreenHeight-100, 80, 40);
        [button setTitle:@"启动应用" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.tutorialView addSubview:button];
    }
    
}
- (void)btnClick{
    [self initRootViewControllerWithTabbar];
    [[NSFileManager defaultManager]createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/studymark.txt"] contents:nil attributes:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 2.停止定位
//    [manager stopUpdatingLocation];
    
    CLGeocoder *geoder = [[CLGeocoder alloc] init];
    [geoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 如果有错误,或者解析出来的地址数量为0
        if (placemarks.count == 0 || error) return ;
        
        // 取出地标,就可以取出地址信息,以及CLLocation对象
        CLPlacemark *pm = [placemarks firstObject];
        
        if (pm.locality) {
            NSString *cityStr = pm.locality;
            [[NSUserDefaults standardUserDefaults] setObject:cityStr forKey:@"city"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSString *cityStr = pm.administrativeArea;
            [[NSUserDefaults standardUserDefaults] setObject:cityStr forKey:@"city"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
}
- (CLLocationManager *)manger{
    if (_manger == nil) {
        _manger = [[CLLocationManager alloc] init];
        _manger.delegate = self;
        _manger.distanceFilter = 10;
        _manger.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [_manger requestWhenInUseAuthorization];//⓵只在前台开启定位
//            [_manger requestAlwaysAuthorization];//⓶在后台也可定位
        }
        // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//            _manger.allowsBackgroundLocationUpdates = YES;
//        }
    }
    return _manger;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
