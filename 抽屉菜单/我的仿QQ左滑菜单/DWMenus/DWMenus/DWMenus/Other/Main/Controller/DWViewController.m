//
//  ViewController.m
//  DWMenu
//
//  Created by Dwang on 16/4/26.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import "DWViewController.h"
#import "DWTableMenu.h"
#import "DWModel.h"
#import "DWMenusViewController.h"

@interface DWViewController ()

@property (weak, nonatomic) UIImageView *image;

@property (strong, nonatomic) DWTableMenu *menu;

@property (assign, nonatomic) CGPoint touchPoint;

@property (weak, nonatomic) UIView *viewClick;

@end

//设备的物理宽度
#define ScreenWidth self.view.frame.size.width

//设备的物理高度
#define ScreenHeight self.view.frame.size.height

//菜单的宽度 用来判断菜单是否为显示状态
#define MenuWidth self.menu.frame.size.width

//菜单显示的frame，宽度就是显示的尺寸
#define MenusFrame CGRectMake(0, 64, ScreenWidth / 4 * 3, ScreenHeight)

//菜单不显示的frame
#define MenusFrameAfter CGRectMake(0, 64, 0, ScreenHeight)

//背景图片在左侧菜单显示时的宽度
#define ImageFrame CGRectMake(ScreenWidth / 4 * 3, 0, ScreenWidth, ScreenHeight)

//背景图片在左侧菜单没有显示时的宽度
#define Frame CGRectMake(0, 0, ScreenWidth, ScreenHeight)
//背景图片在左侧菜单显示时的宽度
#define NavFrame CGRectMake(ScreenWidth / 4 * 3, 0, ScreenWidth, 64)

//背景图片在左侧菜单没有显示时的宽度
#define NFrame CGRectMake(0, 0, ScreenWidth, 64)

#define viewClickFrame CGRectMake(ScreenWidth / 4 * 3, 0, ScreenWidth / 4, ScreenHeight)

@implementation DWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MenuDemo";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:Frame];
    
//    image.image = [UIImage imageNamed:@"123"];
    
    self.image = image;
    
    [self.view addSubview:image];
    
    //创建左侧按钮
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuView)];
    
    self.navigationItem.leftBarButtonItem = leftBar;
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    
    //添加左菜单视图
    [self addMenu];
    
    //添加手势
    [self addSwipeGestureRecognizer];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sel:) name:@"push" object:nil];
    
}

- (void) 注意 {
    
    NSLog(@"添加的左菜单视图的层级必须为最高级，否则会被其他高层级视图覆盖");
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.viewClick removeFromSuperview];
    
    self.image.frame = Frame;
    
    self.menu.frame = MenusFrameAfter;
    self.navigationController.navigationBar.frame = NFrame;
}


#pragma mark ---通知方法
- (void) sel:(NSNotification *)cation {
    
    NSDictionary *dict = [cation object];
    DWModel *model = dict[@"model"];
    NSIndexPath *index = dict[@"indexPath"];
    NSLog(@"已经将第%ld个Cell传过来 -> %@",index.row,model.text);
    
    DWMenusViewController *vc = [DWMenusViewController new];
    
    vc.title = [NSString stringWithFormat:@"第%ld个Cell的跳转",index.row];
    
    [vc wodeyanse:^(NSString *colorName) {
        NSLog(@"%@",colorName);
    }];
//    vc.selfblock = ^(NSString *colorName) {
//        NSLog(@"%@",colorName);
//    };
//    if ([self.delegate respondsToSelector:@selector(dwDelegateIndex:)]) {
//        
//        [self.delegate dwDelegateIndex:index];
//        
//    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:vc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}

#pragma mark ---移除通知
- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark ---添加左菜单视图
- (void) addMenu {
    
    DWTableMenu *menu = [[DWTableMenu alloc] initWithFrame:MenusFrameAfter];
    
    self.menu = menu;
    
    self.menu.scrollEnabled = NO;
    
    self.menu.tableFooterView = [UIView new];
    
    [self.view addSubview:self.menu];
    
}

#pragma mark ---添加手势
- (void) addSwipeGestureRecognizer {
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pelletLeftMenu)];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnLeftMenu)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:swipeLeft];
    
}

#pragma mark --- 添加点击空白手势方法
- (void) tapGesture {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    
    UIView *view = [[UIView alloc] initWithFrame:viewClickFrame];
    
    view.backgroundColor = [UIColor clearColor];
    
    [view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:view];
    
    self.viewClick = view;
    
}


#pragma mark --- 左侧按钮点击方法
- (void) leftMenuView {
    
    if (MenuWidth == 0 || self.menu == nil) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self tapGesture];
            
            self.menu.frame = MenusFrame;
            
            self.image.frame = ImageFrame;
            self.navigationController.navigationBar.frame = NavFrame;
        }];
        
    }else {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.viewClick removeFromSuperview];
            
            self.menu.frame = MenusFrameAfter;
            
            self.image.frame = Frame;
            self.navigationController.navigationBar.frame = NFrame;
            
        }];
        
    }
}




#pragma mark --- 右滑手势方法
- (void) pelletLeftMenu {
    
    if (MenuWidth == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self tapGesture];
            
            self.menu.frame = MenusFrame;
            
            self.image.frame = ImageFrame;
            self.navigationController.navigationBar.frame = NavFrame;
            
        }];
    }else {
        
        return;
        
    }
}

#pragma mark --- 左滑手势方法
- (void) returnLeftMenu {
    
    if (MenuWidth != 0 ) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.viewClick removeFromSuperview];
            
            self.menu.frame = MenusFrameAfter;
            
            self.image.frame = Frame;
            self.navigationController.navigationBar.frame = NFrame;
            
        }];
    }else {
        
        return;
        
    }
    
}

#pragma mark ---获取点击坐标
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
    
    self.touchPoint = touchPoint;
    
}

#pragma mark ---点击空白执行
- (void) clickView {
    
    if (self.touchPoint.x < ScreenWidth / 4 * 3) {
        
        [self.viewClick removeFromSuperview];
        
        [self returnLeftMenu];
        
        self.image.frame = Frame;
        
    }else {
        
        return;
        
    }
    
    
}

@end
