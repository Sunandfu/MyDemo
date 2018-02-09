//
//  PageAppViewController.m
//  UIPageViewController
//
//  Created by Boss Lin on 16/5/24.
//  Copyright © 2016年 zhigong123. All rights reserved.
//

/*
    UIPageViewController的基本使用
    1、创建UIPageViewController self.pageController
    2、在页面上，显示UIPageViewController对象的view
       [self addChildViewController:self.pageController];
       [self.view addSubview:self.pageController.view];
    3、实现UIPageViewControllerDataSource
 */


#import "PageAppViewController.h"
#import "MoreViewController.h"

@interface PageAppViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property(nonatomic,strong) UIPageViewController *pageController;

@property(nonatomic,strong) NSArray *pageContent;

@end

@implementation PageAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self createContentPages];
    
    // 在页面上，显示UIPageViewController对象的view
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    
}

// 初始所有数据
- (void)createContentPages {
    NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    for (int i = 0; i < 11; i++) {
        NSString *contentString = [[NSString alloc] initWithFormat:@"UIPageViewController %d",i];
        [pageStrings addObject:contentString];
    }
    self.pageContent = [NSArray arrayWithArray:pageStrings];
}

// 得到相应的VC对象
- (MoreViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (self.pageContent.count == 0 || index >= self.pageContent.count) {
        return nil;
    }
    MoreViewController *dataViewController = [[MoreViewController alloc] init];
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
  
    return dataViewController;
}

// 根据数组元素值，得到下标值
- (NSUInteger)indexOfViewController:(MoreViewController *)viewControlller {
    return [self.pageContent indexOfObject:viewControlller.dataObject];
}


#pragma mark - UIPageViewControllerDataSource
// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(MoreViewController *)viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法，自动来维护次序。
    // 不用我们去操心每个ViewController的顺序问题。
    return [self viewControllerAtIndex:index];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = [self indexOfViewController:(MoreViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

// 开始翻页调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    NSLog(@"1");
}

// 翻页完成调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSLog(@"2");
}

// Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
// Delegate may set new view controllers or update double-sided state within this method's implementation as well.
//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation __TVOS_PROHIBITED {
//
//}

//- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
//    return UIInterfaceOrientationMaskPortraitUpsideDown;
//}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - lazy load

- (UIPageViewController *)pageController {
    if (!_pageController) {
        // 设置UIPageViewController的配置项
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey:UIPageViewControllerOptionSpineLocationKey];
        
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        _pageController.dataSource = self;
        _pageController.delegate = self;
        
        // 定义“这本书”的尺寸
//        [[_pageController view] setFrame:self.view.bounds];
        _pageController.view.frame = CGRectMake(50, 100, 200, 300);
        
        // 让UIPageViewController对象，显示相应的页数据。
        // UIPageViewController对象要显示的页数据封装成为一个NSArray。
        // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
        // 如果要显示2页，NSArray中，应该有2个相应页数据。
        MoreViewController *initialViewController =[self viewControllerAtIndex:0];// 得到第一页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
       
    }
    return _pageController;
}






@end











