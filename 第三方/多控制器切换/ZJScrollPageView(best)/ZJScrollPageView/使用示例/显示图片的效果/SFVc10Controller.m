//
//  SFVc10Controller.m
//  SFScrollPageView
//
//  Created by ZeroJ on 16/8/21.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "SFVc10Controller.h"
#import "SFScrollPageView.h"
#import "SFTestViewController.h"
#import "SFTest1Controller.h"
@interface SFVc10Controller ()<SFScrollPageViewDelegate>
@property(weak, nonatomic)SFScrollPageView *scrollPageView;
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController<SFScrollPageViewChildVcDelegate> *> *childVcs;

@end

@implementation SFVc10Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果示例";
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
    /// 显示遮盖
    style.showLine = YES;
    /// 设置滚动条高度
    style.segmentHeight = 80;
    /// 显示图片 (在显示图片的时候只有下划线的效果可以开启, 其他的'遮盖','渐变',效果会被内部关闭)
    style.showImage = YES;
    /// 平分宽度
//    style.scrollTitle = NO;
    /// 图片位置
    style.imagePosition = TitleImagePositionTop;
    // 当标题(和图片)宽度总和小于SFScrollPageView的宽度的时候, 标题会自适应宽度
    style.autoAdjustTitlesWidth = YES;
    // 初始化
    CGRect scrollPageViewFrame = CGRectMake(0, SF_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - SF_StatusBarAndNavigationBarHeight);

    self.titles = @[@"新闻头条",
                    @"国际要闻",
                    @"中国足球"
                    ];
    
    SFScrollPageView *scrollPageView = [[SFScrollPageView alloc] initWithFrame:scrollPageViewFrame segmentStyle:style titles:_titles parentViewController:self delegate:self];
    self.scrollPageView = scrollPageView;
    // 额外的按钮响应的block
    __weak typeof(self) weakSelf = self;
    self.scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn){
        weakSelf.title = @"点击了extraBtn";
        NSLog(@"点击了extraBtn");
        
    };
    [self.view addSubview:self.scrollPageView];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

/// 设置图片
- (void)setUpTitleView:(SFTitleView *)titleView forIndex:(NSInteger)index {
    titleView.normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"normal_%ld", index+1]];
    titleView.selectedImage = [UIImage imageNamed:@"selected"];
}

- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    // 根据不同的下标或者title返回相应的控制器, 但是控制器必须要遵守SFScrollPageViewChildVcDelegate
    // 并且可以通过实现协议中的方法来加载不同的数据
    // 注意SFScrollPageView不会保证viewWillAppear等生命周期方法一定会调用
    // 所以建议使用SFScrollPageViewChildVcDelegate中的方法来加载不同的数据
    
    if (index == 0) {
        // 注意这个效果和tableView的deque...方法一样, 会返回一个可重用的childVc
        // 请首先判断返回给你的是否是可重用的
        // 如果为nil就重新创建并返回
        // 如果不为nil 直接使用返回给你的reuseViewController并进行需要的设置 然后返回即可
        SFTestViewController *childVc = (SFTestViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[SFTestViewController alloc] init];
            childVc.view.backgroundColor = [UIColor yellowColor];
        }
        return childVc;
        
    } else if (index == 1) {
        SFTestViewController *childVc = (SFTestViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[SFTestViewController alloc] init];
            childVc.view.backgroundColor = [UIColor redColor];
        }
        
        return childVc;
    } else {
        SFTest1Controller *childVc = (SFTest1Controller *)reuseViewController;
        if (childVc == nil) {
            childVc = [[SFTest1Controller alloc] init];
            childVc.view.backgroundColor = [UIColor greenColor];
        }
        
        if (index%2==0) {
            childVc.view.backgroundColor = [UIColor orangeColor];
        }
        
        return childVc;
    }
}


@end
