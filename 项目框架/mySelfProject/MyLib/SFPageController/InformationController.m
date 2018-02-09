//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//


#import "InformationController.h"
#import "WMPageConst.h"
#import "InfoTableViewViewController.h"
#import "SingleUserDefault.h"

NSString * const KVO_SELECTEDSECTIONTITLES_CONTEXT = @"kvo_selectSectionTitles_context";

@interface InformationController () <WMMenuViewDelegate,UIScrollViewDelegate> {
    CGFloat viewHeight;
    CGFloat viewWidth;
    CGFloat targetX;
    BOOL    animate;
}
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
@property (nonatomic, weak) WMMenuView *menuView;
@property (nonatomic, weak) UIScrollView *scrollView;

// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrames;
// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
@property (nonatomic, strong) NSMutableDictionary *displayVC;
// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
@property (nonatomic, strong) NSMutableDictionary *posRecords;
// 用于缓存加载过的控制器
@property (nonatomic, strong) NSCache *memCache;
// 收到内存警告的次数
@property (nonatomic, assign) int memoryWarningCount;

//原来被选中的item的下标
@property (nonatomic, assign) int originalSelectedIndex;
//原来被选中的item的标题
@property (nonatomic, copy)NSString *originalItem;
//原来标题数组
@property (nonatomic, strong) NSArray *originalTitles;

@property (nonatomic, strong) NSMutableArray *diffItemWidths;
@end

@implementation InformationController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    NSDictionary *navTitleColor=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navTitleColor];
    self.navigationController.navigationBar.barTintColor=RedColor;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [GiFHUD dismiss];
}
//类方法
+ (void)setViewControllersWith:(InformationController *)pvc
{
    pvc.navigationController.navigationBar.barTintColor = RedColor;
    //设置导航栏title的颜色
    NSDictionary *navTitle = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [pvc.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [pvc.navigationController.navigationBar setTitleTextAttributes:navTitle];
    //pvc.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    pvc.navigationItem.title = @"资讯" ;
}
//对象调用的方法
- (void)setViewControllers
{
    self.navigationController.navigationBar.barTintColor = RedColor;
    //设置导航栏title的颜色
    NSDictionary *navTitle = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:navTitle];
    //pvc.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"资讯" ;
}

#pragma mark - Lazy Loading
- (NSMutableDictionary *)posRecords {
    if (_posRecords == nil) {
        _posRecords = [[NSMutableDictionary alloc] init];
    }
    return _posRecords;
}
- (NSMutableDictionary *)displayVC {
    if (_displayVC == nil) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

#pragma mark - Public Methods

- (instancetype)init {
    if (self = [super init]) {
        //self.diffItemWidths=[[NSMutableArray alloc]init];

        self.viewControllerClasses = [[NSMutableArray alloc]init];
       
        
        if ([SingleUserDefault sharedInstance].selectedSectionTitles.count!=0) {
            self.titles = [SingleUserDefault sharedInstance].selectedSectionTitles;
        }else{
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            NSDictionary *userDict=[userDefault objectForKey:@"user"];
            if ([[userDefault objectForKey:[NSString stringWithFormat:@"user%@Channel",userDict[@"id"]]] count]!=0) {
                self.titles =[userDefault objectForKey:[NSString stringWithFormat:@"user%@Channel",userDict[@"id"]]];
            }else{
                self.titles =[[NSMutableArray alloc]initWithArray:@[@"推荐",@"热门",@"三七"]];
            }
            
        }
        
        
        for (NSInteger i = 0; i < self.titles.count; i ++) {
            
            Class vcClass=[InfoTableViewViewController class];
            [self.viewControllerClasses addObject:vcClass];
        }
        
        [self setMenuItemsWidth];
        
        [self setup];
    }
    return self;
}

#pragma mark -设置各个menuItems的宽度
- (void)setMenuItemsWidth{
    NSMutableArray *titleWidesArry=[[NSMutableArray alloc]init];
    for (NSInteger i=0; i<self.titles.count; i++) {
        NSString *title=self.titles[i];
        CGSize size=[title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(1000, 20) lineBreakMode:NSLineBreakByCharWrapping];
        [titleWidesArry addObject:[NSString stringWithFormat:@"%f",size.width+20]];
        
    }
    self.itemsWidths=titleWidesArry;
}
- (void)setCachePolicy:(WMPageControllerCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    self.memCache.countLimit = _cachePolicy;
}

- (void)setItemsWidths:(NSArray *)itemsWidths {
    NSAssert(itemsWidths.count == self.titles.count, @"itemsWidths.count != self.titles.count");
    _itemsWidths = itemsWidths;
}

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;
    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    }
}

#pragma mark - Private Methods

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification
                                                        object:info];
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification
                                                        object:info];
    
    InfoTableViewViewController *infoVC = (InfoTableViewViewController *)[self.displayVC objectForKey:@(index)];
    infoVC.channel = [SingleUserDefault sharedInstance].selectedSectionTitles[index];
    
    //[infoVC getChannelStings];
    
}

// 初始化一些参数，在init中调用
- (void)setup {
    // title
    self.titleSizeSelected = WMTitleSizeSelected;
    self.titleColorSelected = WMTitleColorSelected;
    self.titleSizeNormal = WMTitleSizeNormal;
    self.titleColorNormal = WMTitleColorNormal;
    // menu
    self.menuBGColor = WMMenuBGColor;
    self.menuHeight = WMMenuHeight;
    self.menuItemWidth = WMMenuItemWidth;
//    self.listTitleArry=[[NSMutableArray alloc]init];
    // cache
    self.memCache = [[NSCache alloc] init];
}

// 包括宽高，子控制器视图frame
- (void)calculateSize {
    viewHeight = self.view.frame.size.height - self.menuHeight;
    viewWidth = self.view.frame.size.width;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    for (int i = 0; i < self.viewControllerClasses.count; i++) {
        CGRect frame = CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addMenuView {
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight);
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];
    menuView.delegate = self;
    menuView.style = self.menuViewStyle;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    [self.view addSubview:menuView];
    self.menuView = menuView;
    // 如果设置了初始选择的序号，那么选中该item
    if (self.selectIndex != 0) {
        [self.menuView selectItemAtIndex:self.selectIndex];
    }
    [self createAddChannelButton];
}
#pragma mark -添加“+”button
-(void)createAddChannelButton{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(self.view.frame.size.width-30, 0, 30, 35);
    button.backgroundColor=[UIColor whiteColor];
    [button setImage:[[UIImage imageNamed:@"+"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addChannel:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:button];
    
}

#pragma mark -“+”的响应 事件--跳转到下一个页面
-(void)addChannel:(UIButton *)button{
    
}
- (void)layoutChildViewControllers {
    int currentPage = (int)self.scrollView.contentOffset.x / viewWidth;
    int start,end;
    if (currentPage == 0) {
        start = currentPage;
        end = currentPage + 1;
    }else if (currentPage + 1 == self.viewControllerClasses.count){
        start = currentPage - 1;
        end = currentPage;
    }else{
        start = currentPage - 1;
        end = currentPage + 1;
    }
    for (int i = start; i <= end; i++) {
        CGRect frame = [self.childViewFrames[i] CGRectValue];
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {
                // 先从 cache 中取
                vc = [self.memCache objectForKey:@(i)];
                if (vc) {
                    // cache 中存在，添加到 scrollView 上，并放入display
                    [self addCachedViewController:vc atIndex:i];
                }else{
                    // cache 中也不存在，创建并添加到display
                    [self addViewControllerAtIndex:i];
                }
                
                [self postAddToSuperViewNotificationWithIndex:i];
            }
            
        }else{
            if (vc) {
                // vc不在视野中且存在，移除他
                [self removeViewController:vc atIndex:i];
            }
        }
    }
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
}

// 添加子控制器
- (void)addViewControllerAtIndex:(int)index {
    Class vcClass = self.viewControllerClasses[index];
    UIViewController *viewController = [[vcClass alloc] init];
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
    
    [self backToPositionIfNeeded:viewController atIndex:index];
    
    //[self setItemsWidths:self.diffItemWidths];
}

// 移除控制器，且从display中移除
- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    // 放入缓存
    if (![self.memCache objectForKey:@(index)]) {
        [self.memCache setObject:viewController forKey:@(index)];
    }
    
}

- (void)backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    if ([self.memCache objectForKey:@(index)]) return;
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecords[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            // 奇怪的现象，我发现collectionView的contentSize是 {0, 0};
            [scrollView setContentOffset:pos];
        }
    }
}

- (void)rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecords[@(index)] = [NSValue valueWithCGPoint:pos];
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        // Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    }else if (controller.view.subviews.count >= 1) {
        // Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (BOOL)isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat Width = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < Width) {
        return YES;
    }else{
        return NO;
    }
}

- (void)resetMenuView {
    WMMenuView *oldMenuView = self.menuView;
    
    //从频道管理界面返回资讯列表主界面时   一定要将oldMenuView.delegate设置为nil
    oldMenuView.delegate=nil;
    
    [self addMenuView];
    [oldMenuView removeFromSuperview];
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = WMPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0];
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = WMPageControllerCachePolicyHigh;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;


    
    [self setViewControllers];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addScrollView];
    [self addMenuView];
    
    [self addViewControllerAtIndex:self.selectIndex];
    [self createRedLabel];
   
    //添加监听
    [self addObserver];
}

-(void)returnLastViewController:(returnRefreshBlock)block{
    self.refreshBlock=block;
}

-(void)addItemWithCustomView:(NSArray *)arry isLeft:(BOOL)isLeft{
    NSMutableArray *item=[[NSMutableArray alloc]init];
    for (UIView *view in arry) {
        UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
        [item addObject:buttonItem];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems=item;
    }else{
        self.navigationItem.rightBarButtonItems=item;
    }
}
-(void)createRedLabel{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.menuHeight, self.view.frame.size.width, 1)];
    label.backgroundColor=RedColor;
    [self.view addSubview:label];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 计算宽高及子控制器的视图frame
    [self calculateSize];
    CGRect scrollFrame = CGRectMake(0, self.menuHeight, viewWidth, viewHeight);
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(self.titles.count*viewWidth, viewHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectIndex*viewWidth, 0)];

    self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];
    
    [self resetMenuView];

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.memoryWarningCount++;
    self.cachePolicy = WMPageControllerCachePolicyLowMemory;
    // 取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memCache removeAllObjects];
    [self.posRecords removeAllObjects];
    self.posRecords = nil;
    
    // 如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWarningCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    if (animate) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        CGFloat rate = contentOffsetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / viewWidth;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = targetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    targetX = targetContentOffset->x;
}

#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    animate = NO;
    CGPoint targetP = CGPointMake(viewWidth*index, 0);
    
    [self.scrollView setContentOffset:targetP animated:gap > 1?NO:self.pageAnimatable];
    if (gap > 1 || !self.pageAnimatable) {
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
        // 由于不触发-scrollViewDidScroll: 手动清除控制器..
        UIViewController *vc = [self.displayVC objectForKey:@(currentIndex)];
        if (vc) {
            [self removeViewController:vc atIndex:currentIndex];
        }
    }
    _selectIndex = (int)index;
    self.currentViewController = [self.displayVC objectForKey:@(self.selectIndex)];
    
    NSLog(@"\n%d================\n%@",self.selectIndex,self.displayVC);
    
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths) {
        return [self.itemsWidths[index] floatValue];
    }
    return self.menuItemWidth;
}

#pragma mark - 监听事件

- (void)addObserver {
    
    //设置监听 (对单例中selectedSectionTitles进行监听)
    [[SingleUserDefault sharedInstance] addObserver:self forKeyPath:@"selectedSectionTitles" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(KVO_SELECTEDSECTIONTITLES_CONTEXT)];
    
}

//监听到单例中 菜单栏 数组发生变化触发  [SingleUserDefault sharedInstance].selectedSectionTitles
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //注意：这里只是坐了添加操作，切在AddChannelViewController中的每添加一个频道都会触发改方法
    if ([keyPath isEqualToString:@"selectedSectionTitles"]) {
        //监听到值的变化后  （注意self.titles 和 self.viewControllerClasses个数相等且要对应）---- 自个做删除操作（同样是对单例操作 记得同时删除对应的VC）self.selectIndex 做相应的调整

        //添加一个vc到viewControllerClasses中，
        if (self.titles.count < [SingleUserDefault sharedInstance].selectedSectionTitles.count) {
            for (NSInteger i=0; i<([SingleUserDefault sharedInstance].selectedSectionTitles.count-self.titles.count); i++) {
                [self.viewControllerClasses addObject:[InfoTableViewViewController class]];
            }
            
        }
        else if (self.titles.count > [SingleUserDefault sharedInstance].selectedSectionTitles.count) {
            for (NSInteger i=0; i<(self.titles.count-[SingleUserDefault sharedInstance].selectedSectionTitles.count); i++) {
                [self.viewControllerClasses removeLastObject];
            }
            
        }
        [self calculateSize];
        
        self.titles = [SingleUserDefault sharedInstance].selectedSectionTitles;
        
        
        
        NSInteger currentItem = 0;
        if ([self.titles containsObject:self.originalItem]) {
            for (NSInteger i=0; i<self.titles.count; i++) {
                if ([self.titles[i] isEqualToString:self.originalItem]) {
                    currentItem=i;
                }
            }
        }else{
            currentItem=0;
        }
//        self.selectIndex=currentItem;
        [self setSelectIndex:currentItem];
        
        [self setMenuItemsWidth];
        
        
        //增加一个titles 及 增加一个vc  及刷新
        [self viewDidLayoutSubviews];
    }
}
- (void)dealloc {
    
    [[SingleUserDefault sharedInstance] removeObserver:self forKeyPath:@"selectedSectionTitles"];
    
}

@end
