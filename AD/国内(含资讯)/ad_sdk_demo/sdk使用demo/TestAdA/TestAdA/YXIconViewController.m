//
//  YXIconViewController.m
//  LunchAd
//
//  Created by shuai on 2018/10/8.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXIconViewController.h"
#import <YXLaunchAds/YXLaunchAds.h>
#import "WXApi.h"

static  NSString * iconMediaID = @"beta_ios_icon";

@interface YXIconViewController ()<YXIconAdManagerDelegate>

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) YXIconAdManager *iconAd;
@property (nonatomic, strong) YXIconAdManager *iconAdArray;

@end

@implementation YXIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"IconAd";
    UIButton *iconBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, [UIScreen mainScreen].bounds.size.width - 100 , 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"IconADTest" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(iconBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:iconBtn];
    
    //多Icon样式
    self.iconAdArray = [[YXIconAdManager alloc]initWithFrame:CGRectMake(100, 300, 40, 40)];
    self.iconAdArray.mediaIdArray = @[@"tongx_ios_dwicon",@"tongx_ios_wlicon",@"tongx_ios_syicon"];
    self.iconAdArray.popType = YXPopupMenuDirectionRight;
    self.iconAdArray.adType = YXIconType;
    self.iconAdArray.delegate = self;
    self.iconAdArray.titleFont = [UIFont systemFontOfSize:12];
    self.iconAdArray.itemWidth = 60;
    self.iconAdArray.itemHeight = 80;
    self.iconAdArray.contentMode = UIViewContentModeScaleAspectFill;
    self.iconAdArray.menuGroundColor = [UIColor orangeColor];
    [self.iconAdArray loadIconAd];
    self.customView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 300, 80, 80)];
    self.customView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.customView];
    //    NSString * str = NSStringFromClass([self class]);
    
    //    [HMTAgentSDK postAction:str];
    // Do any additional setup after loading the view from its nib.
}
- (void)iconBtnClicked:(UIButton*)sender
{
    if (self.iconAd) {
        [self.iconAd removeFromSuperview];
        self.iconAd = nil;
    }
    //单Icon样式
    self.iconAd = [[YXIconAdManager alloc]initWithFrame:CGRectMake(100, 300, 40, 40)];
    self.iconAd.mediaId = iconMediaID;
    self.iconAd.adType = YXIconType;
    self.iconAd.delegate = self;
    [self.iconAd loadIconAd];
    NSLog(@"Icon请求");
}

- (void)didLoadIconAd:(UIView *)adView
{
    NSLog(@"Icon广告请求成功");
    if (self.iconAd) {
        adView.center = self.view.center;
        [self.view addSubview:self.iconAd];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        adView.userInteractionEnabled = YES;
        [self.iconAd addGestureRecognizer:pan];
    } else {
        //多icon 此时可点击展示
    }
}



- (void)didClickedIconAd
{
    NSLog(@"Icon广告点击");
}


- (void)didFailedLoadIconAd:(NSError *)error
{
    NSLog(@"Icon广告请求失败");
}

-(void)handlePan:(UIPanGestureRecognizer *)rec{
    
    
    CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
    //    CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
    
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point=[rec translationInView:[UIApplication sharedApplication].keyWindow];
    //    NSLog(@"%f,%f",point.x,point.y);
    
    CGFloat centerX = rec.view.center.x+point.x;
    CGFloat centerY = rec.view.center.y+point.y;
    
    CGFloat viewHalfH = rec.view.frame.size.height/2;
    CGFloat viewhalfW = rec.view.frame.size.width/2;
    //    CGRect tabbar = [self.tabBarController.tabBar frame];
    //确定特殊的centerY
    if (centerY - viewHalfH < 0 ) {
        centerY = viewHalfH;
    }
    //    if (centerY + viewHalfH > KHeight - tabbar.size.height) {
    //        centerY = KHeight - viewHalfH - tabbar.size.height;
    //    }
    
    //确定特殊的centerX
    if (centerX - viewhalfW < 0){
        centerX = viewhalfW;
    }
    if (centerX + viewhalfW > KWidth){
        centerX = KWidth - viewhalfW;
    }
    
    rec.view.center=CGPointMake(centerX, centerY);
    
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t = touches.anyObject;
    CGPoint p = [t locationInView: self.view];
    
    if (CGRectContainsPoint(self.customView.frame, p)) {
        [self.iconAdArray showCustomPopupMenuWithPoint:p];
    }
}

@end
