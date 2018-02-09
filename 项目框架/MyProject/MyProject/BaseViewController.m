//
//  BaseViewController.m
//  MyProject
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "BaseViewController.h"
#import "NetRequestManager.h"

#define RGBColor(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define kRightBtnColor     @"FFFFFF" //导航栏右侧按钮颜色
#define kLeftBtnTextColor  @"FFFFFF" //导航栏左侧按钮文字颜色
#define kBackgroundColor   @"333333" //通用View背景颜色
#define kNavBgColor   RGBColor(255*0.96,255*0.20,255*0.40)  //通用导航栏背景颜色

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = self.name;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self initViewBackgroundColor];
    [self initNavigationLeftButton:nil];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    //set NavigationBar 背景颜色&title 颜色 大小
    [self.navigationController.navigationBar setBarTintColor:kNavBgColor];
    NSDictionary *titleDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleDic];
    //使用图片当作导航栏标题
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appcoda-logo.png"]];
}

-(void)dealloc{
    
}

-(NSString *) getCurrentClassName{
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return className;
}
//试图即将出现
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
//    if (self.navigationController.viewControllers.count > 1) {
//        self.tabBarController.tabBar.hidden = YES;
//    }else {
//        self.tabBarController.tabBar.hidden = NO;
//    }
    self.modal = NO;
    [super viewWillAppear:animated];
}
//试图即将消失
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- common menthod
-(void)initViewBackgroundColor{
    self.view.backgroundColor = [UIColor colorWithHexString:kBackgroundColor];
}

-(float)tableViewMaxHeight{
    float viewHeight=[[UIScreen mainScreen] bounds].size.height;
    //44=navigation height , 20=status height.
    float maxHeight = viewHeight  - 44  - 20;
    return  maxHeight;
}

-(void)backButtonTouchEvents{
    if (self.modal)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonTouchEvents{
    
}

//left button
-(void)initNavigationLeftButton:(NSString*)_buttonImage{
    
    if (self.isModal) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchEvents)];
        
        UIImage *bgImage = [UIImage imageNamed:@"nav_back"];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:bgImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:bgImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsCompact];
        
        UIImage *buttonImage = [UIImage imageNamed:@"nav_back"];
        UIBarButtonItem *backButton;
        if (buttonImage) {
            backButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchEvents)];
        } else {
            backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTouchEvents)];
        }
        self.navigationItem.leftBarButtonItem = backButton;
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:kLeftBtnTextColor];
        
        
        
    }else{
        UIViewController *rootViewController = [self.navigationController.viewControllers firstObject];
        
        if ([rootViewController isKindOfClass:[self class]]) {
            //do nothing
            return;
        }
//        [self.navigationItem hidesBackButton];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 44);
        if (_buttonImage) {
            UIImage *backimg = [UIImage imageNamed:_buttonImage];
            [btn setImage:backimg forState:UIControlStateNormal];
            float leftEdge = (45-backimg.size.width)*0.5-10;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -leftEdge, 0, 0)];
            [btn setTitle:@"" forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"返回" forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(backButtonTouchEvents) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [btn setTitleColor:[UIColor colorWithHexString:kLeftBtnTextColor] forState:UIControlStateNormal];
        btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        btn.tintColor = [UIColor colorWithHexString:kLeftBtnTextColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -23;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:btn]];
    }
}

-(void)initNavigationRightButton:(NSString*)_btTitle btWidth:(float)_btWidth{
    if (self.navigationItem.rightBarButtonItem == nil){
        float btWidth = 60.0f;
        if (_btWidth > 0) {
            btWidth = _btWidth;
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [backBtn setBackgroundImage:[[UIImage imageNamed:@"nav_bar_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)] forState:UIControlStateNormal];
        [backBtn setTitle:_btTitle forState:UIControlStateNormal];
        
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [backBtn setTitleColor:[UIColor colorWithHexString:kRightBtnColor] forState:UIControlStateNormal];
        backBtn.titleLabel.shadowOffset = CGSizeMake(0, 1);
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -16;
        
        [backBtn addTarget:self action:@selector(rightButtonTouchEvents) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(0, 0, btWidth, 32);
        self.navRightItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backBtn]];
        self.navigationItem.rightBarButtonItems = self.navRightItems;
        self.rightButton = backBtn;
        
    }
}
//改变状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

@end
