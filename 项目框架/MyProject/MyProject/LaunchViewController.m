//
//  HomeViewController.m
//  MyProject
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 SSF. All rights reserved.
//

#import "LaunchViewController.h"
#import "RTutorialView.h"
#import "HomeViewController.h"
//#import "LocationViewController.h"
//#import "IncomeViewController.h"
#import "MyViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import "SSFTabBarViewController.h"
#import "JDSideMenu.h"
#import "LeftViewController.h"

#define OtherPic @"http://hiphotos.baidu.com/wisegame/pic/item/52adcbef76094b3638be5162a3cc7cd98d109d15.jpg"    //广告图片
//系统tabbar控制器 抽屉控制器不好使
#define isCustomTabbar 0  //是否是自定义Tabbar （1 是 ＊ 0 不是）
#define screeenWidth [UIScreen mainScreen].bounds.size.width
#define screeenHeight [UIScreen mainScreen].bounds.size.height
#define TIME 0
@interface LaunchViewController ()<RTutorial,CLLocationManagerDelegate>{
    int period;
    UIButton *button;
    UIButton *starBtn;
}

@property (nonatomic, strong) RTutorialView *tutorialView;
@property (nonatomic, strong) NSArray *learnArray;
@property (nonatomic, strong) CLLocationManager *manger;

@end

@implementation LaunchViewController

- (NSArray *)learnArray{
    if (_learnArray == nil) {
        _learnArray = @[@"jiance_1",@"huxi_2",@"zixun_3",@"guanjia_4"];//添加引导页
    }
    return _learnArray;
}
#pragma mark 自定义tabbar
-(void)initRootViewControllerWithTabbar{
    SSFTabBarViewController *tabBarVC = [SSFTabBarViewController shareTabBarVC];
    //添加控制器
    [tabBarVC setupChildViewController:[HomeViewController new] title:@"首页" imageName:@"HomePage" selectedimageName:@"HomePage-clicked"];
    [tabBarVC setupChildViewController:[MyViewController new] title:@"我的" imageName:@"zixun" selectedimageName:@"zixun-click"];
    
    LeftViewController *menuController = [[LeftViewController alloc] init];
    
    JDSideMenu *sideMenu = [[JDSideMenu alloc] initWithContentController:tabBarVC menuController:menuController];
    [sideMenu setBackgroundImage:[UIImage imageNamed:@"bg"]];
    UINavigationController *leftNaVC = [[UINavigationController alloc] initWithRootViewController:sideMenu];
    leftNaVC.navigationBarHidden = YES;
    
    AppDelegate *appDele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDele.tabbarController = tabBarVC;
    appDele.tabbarController.delegate = appDele;
    appDele.window.rootViewController = leftNaVC;
    
}
#pragma mark 系统默认tabbar
-(void)initRootViewControllerWithUITabbarcontroller{
    HomeViewController *home = [[HomeViewController alloc] init];
    home.tabBarItem.title = @"游戏";
    home.tabBarItem.image = [UIImage imageNamed:@"HomePage"];
    home.tabBarItem.selectedImage = [UIImage imageNamed:@"HomePage-clicked"];
    UINavigationController *homeVC = [[UINavigationController alloc] initWithRootViewController:home];
    MyViewController *my = [[MyViewController alloc] init];
    my.tabBarItem.title = @"新闻";
    my.tabBarItem.image = [UIImage imageNamed:@"zixun"];
    my.tabBarItem.selectedImage = [UIImage imageNamed:@"zixun-click"];
    UINavigationController *myVC = [[UINavigationController alloc] initWithRootViewController:my];
    
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    [tabbar addChildViewController:homeVC];
    [tabbar addChildViewController:myVC];
    tabbar.tabBar.tintColor = RedColor;
    AppDelegate *appDele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDele.window.rootViewController = tabbar;
}
#pragma mark 定位
- (CLLocationManager *)manger{
    if (_manger == nil) {
        _manger = [[CLLocationManager alloc] init];
        _manger.delegate = self;
        _manger.distanceFilter = 10;//经过10米重新定位
        _manger.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _manger;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    //反地理编码
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        // 如果有错误,或者解析出来的地址数量为0
        if (placemarks.count == 0 || error) return ;
        
        // 取出地标,就可以取出地址信息,以及CLLocation对象
        CLPlacemark *pm = [placemarks firstObject];
        HBUserDefaults *hbuser = [HBUserDefaults sharedInstance];
        if (pm.locality) {
            hbuser.cityName = pm.locality;
        } else {
            hbuser.cityName = pm.administrativeArea;
        }
        NSLog(@"%@",pm.name);
    }];
}
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.manger respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.manger requestAlwaysAuthorization];
    }
    [self.manger startUpdatingLocation];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/firstStar.txt"]])
    {
        period = TIME;
        [self addGuanggaoImage];
        [self dishiqi];
    }
    else{
        [self prefersStatusBarHidden];
        self.view.backgroundColor = [UIColor clearColor];
        [self makeStudyPage];
    }

}
#pragma mark 添加启动页广告页面
- (void)addGuanggaoImage{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screeenWidth, screeenHeight)];
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:OtherPic] placeholderImage:[UIImage imageNamed:@"Default"]];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screeenWidth-85, 20, 70, 30);
    [button setTitle:@"剩余5秒" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:imageView];
    [self.view addSubview:button];
    [self shakeToShow:imageView];
}
#pragma mark 图片放大效果
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [NSThread sleepForTimeInterval:0.4];
    animation.duration = 4.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}
#pragma mark 倒计时动画
- (void)dishiqi{//设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.2 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        if (period<=0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCustomTabbar) {
                    [self initRootViewControllerWithTabbar];
                } else {
                    [self initRootViewControllerWithUITabbarcontroller];
                }
                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"剩余%d秒",period] forState:UIControlStateNormal];
                NSLog(@"%@",button.titleLabel.text);
            });
            period--;
        }
    });
    dispatch_resume(_timer);
}
- (void)btnClick:(UIButton *)sender{
    period = TIME;
    [self dishiqi];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    //停止定位
    [self.manger stopUpdatingLocation];
}
#pragma mark 引导页背景
-(void)makeStudyPage
{
    if (self.tutorialView == nil) {
        self.tutorialView = [[RTutorialView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.tutorialView];
        self.tutorialView.tutorialDelegate = self;
    }
    [self.tutorialView setBackgroundImage:[UIImage imageNamed:@"learn_bg"]];
    [self.tutorialView setLearningImageNames:self.learnArray];
    
}
#pragma mark 引导页结束
- (void)tutorialDidFinish:(RTutorialView *)tutorialView {
    NSLog(@"引导页结束");
    if (isCustomTabbar) {
        [self initRootViewControllerWithTabbar];
    } else {
        [self initRootViewControllerWithUITabbarcontroller];
    }
    [[NSFileManager defaultManager]createFileAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/firstStar.txt"] contents:nil attributes:nil];
    
}
#pragma mark 点击引导页
- (void)tutorialView:(RTutorialView *)tutorialView didPageToIndex:(NSUInteger)index {
    NSLog(@"点击了第%lu张引导页",index);
}

- (BOOL)prefersStatusBarHidden{
    return YES;
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
