//
//  SFMoreCartoonViewController.m
//  ReadBook
//
//  Created by lurich on 2020/6/30.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMoreCartoonViewController.h"
#import "SFScrollPageView.h"
#import "SFMoreListViewController.h"
#import "SFMoreSearchViewController.h"

@interface SFMoreCartoonViewController ()<SFScrollPageViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) SFContentView *contentView;
@property (nonatomic, strong) SFScrollPageView *scrollPageView;
@property (nonatomic, assign) BOOL isHaveNet;

@end

@implementation SFMoreCartoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有漫画";
    self.isHaveNet = NO;
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self updateFrameWithSize:self.view.bounds.size];
}
- (void)updateFrameWithSize:(CGSize)size{
    [self createTitleViewsWithSize:size];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!self.isHaveNet) {
        [self getClassify];
    }
}

- (void)getClassify{
    NSString *url = [NSString stringWithFormat:@"%@",@"http://www.biqug.org/index.php/category/"];
    [SFNetWork getXmlDataWithURL:url parameters:nil success:^(id data) {
        self.isHaveNet = YES;
        [self.dataArray removeAllObjects];
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@class=\"cate-list clearfix\"]"]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
        //遍历其子节点,
        [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[element tag] isEqualToString:@"li"]) {
                [self postWithHtmlStr:element Index:idx];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTitleViewsWithSize:self.view.bounds.size];
        });
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败:%@",error);
    }];
}
-(void)postWithHtmlStr:(ONOXMLElement*)element Index:(NSInteger)index{
    ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
    BookDetailModel *newp = [BookDetailModel new];
    newp.postUrl= [NSString stringWithFormat:@"%@%@",@"http://www.biqug.org",[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
    newp.title= [titleElement stringValue];
    [self.dataArray addObject:newp];
}
- (void)createTitleViewsWithSize:(CGSize)size{
    if (self.dataArray.count==1) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.contentView = nil;
        SFContentView *content = [[SFContentView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) segmentView:nil parentViewController:self delegate:self];
        self.contentView = content;
        [self.view addSubview:content];
    } else {
        [self.scrollPageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.scrollPageView = nil;
        SFSegmentStyle *style = [[SFSegmentStyle alloc] init];
        // 缩放标题
        style.scaleTitle = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.showLine = YES;
        style.scrollLineColor = [UIColor colorWithRed:20/255.0 green:121/255.0 blue:214/255.0 alpha:1.0];
        style.showDemarcationLine = YES;
        style.scrollDemarcationLineColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        style.scrollLineHeight = 2;
        style.titleMargin = 24;
        style.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        style.titleBigScale = 1.2;
        style.normalTitleColor = [UIColor colorWithRed:130/255.0 green:138/255.0 blue:148/255.0 alpha:1.0];
        style.selectedTitleColor = [UIColor colorWithRed:56/255.0 green:119/255.0 blue:208/255.0 alpha:1.0];
        style.backGroundColor = [UIColor groupTableViewBackgroundColor];
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
        for (BookDetailModel *model in self.dataArray) {
            [titles addObject:model.title];
        }
        if (size.width > size.height) {
            self.scrollPageView = [[SFScrollPageView alloc] initWithFrame:CGRectMake(0, 44, size.width, size.height-44) segmentStyle:style titles:titles parentViewController:self delegate:self];
        } else {
            self.scrollPageView = [[SFScrollPageView alloc] initWithFrame:CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), size.width, size.height-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)) segmentStyle:style titles:titles parentViewController:self delegate:self];
        }

        // 这里可以设置头部视图的属性(背景色, 圆角, 背景图片...)
//        scrollPageView.segmentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:self.scrollPageView];
    }
}
#pragma SFScrollPageViewDelegate 代理方法
- (NSInteger)numberOfChildViewControllers {
    return self.dataArray.count;
}

- (UIViewController<SFScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<SFScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<SFScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //    NSLog(@"%ld---------", index);
   
    if (!childVc) {
        BookDetailModel *model = self.dataArray[index];
        SFMoreListViewController *newChildVc = [[SFMoreListViewController alloc] init];
        newChildVc.title = model.title;
        newChildVc.cellArray = [NSArray arrayWithArray:self.dataArray];
        newChildVc.currentVC = reuseViewController;
        if (_contentView) {
            newChildVc.segmentHeight = 0.01;
        }
        return newChildVc;
    }
    return childVc;
}
//该方法返回NO则childViewController不会自动viewWillAppear和viewWillDisappear对应的方法
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}

//- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---将要出现",index);
//}
//
//- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---已经出现",index);
//}
//
//- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---将要消失",index);
//
//}
//
//- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index {
//    NSLog(@"%ld ---已经消失",index);
//
//}
- (void)searchClick{
    SFMoreSearchViewController *search = [SFMoreSearchViewController new];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

@end

