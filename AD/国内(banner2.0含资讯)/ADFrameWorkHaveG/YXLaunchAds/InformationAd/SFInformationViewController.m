//
//  SFInformationViewController.m
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import "SFInformationViewController.h"
#import "SFScrollPageView.h"
#import "SFPageTableViewController.h"
#import "SFChannelTags.h"
#import "Network.h"
#import "UIView+SFFrame.h"

@interface SFInformationViewController ()<SFScrollPageViewDelegate>{
    CGFloat navStarBarHeight;
}

@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation SFInformationViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.showLine = NO;
        self.scrollLineColor = [UIColor colorWithRed:20/255.0 green:121/255.0 blue:214/255.0 alpha:1.0];
        self.showDemarcationLine = YES;
        self.scrollDemarcationLineColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        self.scrollLineHeight = 2;
        self.titleMargin = 24;
        self.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        self.titleBigScale = 1.2;
        self.normalTitleColor = [UIColor colorWithRed:130/255.0 green:138/255.0 blue:148/255.0 alpha:1.0];
        self.selectedTitleColor = [UIColor colorWithRed:56/255.0 green:119/255.0 blue:208/255.0 alpha:1.0];
        self.isAddNavigation = YES;
    }
    return self;
}
-(void)backClick{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat navbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (self.navigationController) {
        if (self.backImage) {
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:self.backImage style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
            self.navigationItem.leftBarButtonItem = backBtn;
        } else {
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_leftback"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
            self.navigationItem.leftBarButtonItem = backBtn;
        }
        
        if (self.navigationController.navigationBar.translucent) {
            navStarBarHeight = navbarHeight+44;
            if (self.navigationController.navigationBar.hidden) {
                if (self.isAddNavigation) {
                    [self addCustomNavigationWithNavbarHeight:navbarHeight];
                } else {
                    
                }
            }
        } else {
            if (self.navigationController.navigationBar.hidden) {
                if (self.isAddNavigation) {
                    [self addCustomNavigationWithNavbarHeight:navbarHeight];
                    navStarBarHeight = navbarHeight+44;
                } else {
                    navStarBarHeight = 0;
                }
            } else {
                navStarBarHeight = 0;
            }
        }
    } else {
        [self addCustomNavigationWithNavbarHeight:navbarHeight];
        navStarBarHeight = navbarHeight+44;
    }
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    if (@available(iOS 11.0, *)) {
        
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getNetWorkTitles];
}
- (void)addCustomNavigationWithNavbarHeight:(CGFloat)navbarHeight{
    UIView *navVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, navbarHeight + 44)];
    navVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navVIew];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    UIImage *leftimage = [UIImage imageNamed:@"XibAndPng.bundle/sf_leftback"];
    [button setImage:leftimage forState:UIControlStateNormal];
    button.frame = CGRectMake(20,navbarHeight, 30, 44);
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navVIew addSubview:button];
}

- (void)getNetWorkTitles{
    [Network getJSONDataWithURL:[NSString stringWithFormat:@"%@/social/getYdFeedCatIds?mLocationId=%@",TASK_SEVERIN,self.mLocationId] parameters:nil success:^(id json) {
        self.titleArray = json;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTitleViews];
        });
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)createTitleViews{
    SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
    // 缩放标题
    style.scaleTitle = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    style.showLine = self.showLine;
    style.scrollLineColor = self.scrollLineColor;
    style.scrollLineHeight = self.scrollLineHeight;
    style.scrollDemarcationLineColor = self.scrollDemarcationLineColor;
    style.showDemarcationLine = self.showDemarcationLine;
    style.titleMargin = self.titleMargin;
    style.titleFont = self.titleFont;
    style.titleBigScale = self.titleBigScale;
    style.normalTitleColor = self.normalTitleColor;
    style.selectedTitleColor = self.selectedTitleColor;
    style.backGroundColor = self.backGroundColor;
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in self.titleArray) {
        [titles addObject:dict[@"ydCatName"]];
    }
    SFScrollPageView *scrollPageView = [[SFScrollPageView alloc] initWithFrame:CGRectMake(0, navStarBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - navStarBarHeight) segmentStyle:style titles:titles parentViewController:self delegate:self];
    
    // 设置附加按钮的背景图片
//    style.showExtraButton = YES;
//    style.extraBtnBackgroundImageName = @"XibAndPng.bundle/sf_add";
//    if (style.showExtraButton) {
//        scrollPageView.extraBtnOnClick = ^(UIButton *extraBtn) {
//            NSLog(@"附加按钮点击");
//            NSArray *recommandTags = @[@"小说",@"时尚",@"历史",@"育儿",@"直播",@"搞笑",@"数码",@"养生",@"电影",@"手机",@"旅游",@"宠物",@"情感",@"家居",@"教育",@"三农"];
//            //秀出来选择框
//            SFChannelTags *controller = [[SFChannelTags alloc]initWithMyTags:self.titles andRecommandTags:recommandTags];
//            [self presentViewController:controller animated:YES completion:nil];
//            __weak SFScrollPageView *weakSelf = scrollPageView;
//            controller.choosedTags = ^(NSArray *chooseTags, NSArray *recommandTags) {
//                NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
//                for (SFChannel *mod in recommandTags) {
//                    NSLog(@" 未选择 %@ ",mod.title);
//                }
//                for (SFChannel *mod in chooseTags) {
//                    [titleArray addObject:mod.title];
//                    NSLog(@" 已选择 %@ ",mod.title);
//                }
//                [weakSelf reloadWithNewTitles:titleArray];
//            };
//
//            //单选tag
//            controller.selectedTag = ^(SFChannel *channel) {
//                NSLog(@" 单选 %@ ",channel.title);
//            };
//        };
//    }
    // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
    //    scrollPageView.segmentView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollPageView];
}
//- (void)setShowDemarcationLine:(BOOL)showDemarcationLine{
//    _showDemarcationLine = showDemarcationLine;
//}
#pragma SFScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.titleArray.count;
}

- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
   
    if (!childVc) {
        NSDictionary *dict = self.titleArray[index];
        SFPageTableViewController *newChildVc = [[SFPageTableViewController alloc] init];
        newChildVc.title = dict[@"ydCatName"];
        newChildVc.titleArray = self.titleArray;
        newChildVc.mLocationId = self.mLocationId;
        newChildVc.isInfo = YES;
        return newChildVc;
    }
    return childVc;
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---将要出现",index);
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---已经出现",index);
    NSDictionary *titleDict = self.titleArray[index];
    NSString *ydCatIdStr = titleDict[@"ydCatId"];
    [Network newsStatisticsWithType:1 NewsID:@"" CatID:ydCatIdStr lengthOfTime:0];
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---将要消失",index);
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---已经消失",index);
    
}

//- (void)dealloc{
//    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
//    
//}

@end
