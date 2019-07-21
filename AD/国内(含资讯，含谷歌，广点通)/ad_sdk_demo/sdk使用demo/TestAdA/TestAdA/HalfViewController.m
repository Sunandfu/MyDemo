//
//  ViewController.m
//  WebViewDemo
//
//  Created by lurich on 2019/4/12.
//  Copyright © 2019 lurich. All rights reserved.
//

#import "HalfViewController.h"
#import <YXLaunchAds/YXLaunchAds.h>

//竖屏幕宽高
#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//IPhoneX IPhoneXS 的逻辑分辨率相同
#define IPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)

//IPhoneXR IPhoneXSMax 的逻辑分辨率相同
#define IPhoneXR CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size)

//导航栏
#define StatusBarHeight ((IPhoneX || IPhoneXR) ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight ((IPhoneX || IPhoneXR) ? 88.f : 64.f)
#define TabbarHeight ((IPhoneX || IPhoneXR) ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight ((IPhoneX || IPhoneXR) ? (34.f) : (0.f))

@interface SFScrollerView : UIScrollView<UIGestureRecognizerDelegate>

@end

@implementation SFScrollerView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

@interface HalfViewController () <UIScrollViewDelegate,SFHalfPageControllerDelegate>

@property (nonatomic, strong) SFScrollerView *scrollView;
@property (nonatomic, strong) SFHalfPageViewController *webVC;

@property (nonatomic,assign) BOOL canScroll;

@end

@implementation HalfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    // Do any additional setup after loading the view.
    self.scrollView = [[SFScrollerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height+300);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    headView.backgroundColor = [UIColor purpleColor];
    [self.scrollView addSubview:headView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height)];
    footView.backgroundColor = [UIColor cyanColor];
    [self.scrollView addSubview:footView];
    
    
    [self addChildViewController:self.webVC];
    [footView addSubview:self.webVC.view];
    
    //添加请求数据的 HUD 开始请求推荐数据
    [self.webVC refreshNewsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:LEAVETOPNOTIFITION object:nil];
    
}
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.webVC.vcCanScroll = NO;
}
- (SFHalfPageViewController *)webVC{
    if (_webVC == nil) {
        _webVC = [[SFHalfPageViewController alloc] init];
        _webVC.mediaId = @"4";
        _webVC.mLocationId = @"3";
        _webVC.vcCanScroll = NO;
        _webVC.halfDelegate = self;
        _webVC.isShowAllChannels = self.isShowAll;
    }
    return _webVC;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat bottomCellOffset = 300 - StatusBarAndNavigationBarHeight;
    if (offset >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.webVC.vcCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.scrollView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}
#pragma mark - SFPageViewControllerDelegate
- (void)newsDataRefreshSuccess{
    NSLog(@"数据加载成功");
}
- (void)newsDataRefreshFail:(NSError *)error{
    NSLog(@"数据加载失败，error = %@",error);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
}

@end
