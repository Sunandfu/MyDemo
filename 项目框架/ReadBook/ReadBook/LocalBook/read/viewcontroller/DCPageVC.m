//
//  DCPageVC.m
//  ReadBook
//
//  Created by lurich on 2020/6/1.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "DCPageVC.h"
#import "SFReadDetailViewController.h"
#import "ONOXMLDocument.h"
#import "SFNetWork.h"
#import "SVProgressHUD.h"
#import "DetailTableViewCell.h"
#import "ReadSetModel.h"
#import "LNReaderSettingView.h"
#import "SFBookSave.h"
#import "SFSoundPlayer.h"
#import "SFTool.h"
#import <CoreText/CoreText.h>
#import "SFBookReadingBackViewController.h"
#import "SFSafeAreaInsets.h"
#import "BaiduMobStatForSDK.h"
#import "SFJsonContentModel.h"
#import "SFRequestModel.h"
#import "SFJsonBookModel.h"
#import "SFJsonCatelogModel.h"
#import "PagingEngine.h"
#import "ZQAutoReadViewController.h"
#import "DCFileTool.h"

#define SpaceWith self.view.bounds.size.width / 3
#define SpaceHeight self.view.bounds.size.height / 3
#define kShowMenuDuration 0.3f

@interface DCPageVC ()<UITableViewDelegate,UITableViewDataSource,LNReaderSettingViewDelegate,SFSoundPlayerDelegate,UIPageViewControllerDelegate,UIGestureRecognizerDelegate,ZQAutoViewDelegate,UIPageViewControllerDataSource>

/**是否正在显示菜单*/
@property (nonatomic, assign) BOOL menuIsShowing;
/**是否正在显示章节菜单*/
@property (nonatomic, assign) BOOL chapterListIsShowing;
/**是否正在显示设置*/
@property (nonatomic, assign) BOOL settingViewIsShowing;
/**遮罩*/
@property (nonatomic, weak) UIControl *coverView;
/**下方菜单栏*/
@property (nonatomic, strong) UIView *bottomView;
/**顶部导航栏*/
@property (nonatomic, strong) UIView *topNavView;
/**夜间数据源*/
@property (nonatomic, strong) ReadSetModel *nightSetModel;
/**日间数据源*/
@property (nonatomic, strong) ReadSetModel *daySetModel;
/**目录栏*/
@property (nonatomic, strong) UITableView *listTableView;
/**源列表*/
@property (nonatomic, strong) UITableView *sourceListTableView;
/**左侧目录view*/
@property (nonatomic, strong) UIView *menuContentView;
/**设置栏*/
@property (nonatomic, strong) LNReaderSettingView *settingView;
/**设置数据源*/
@property (nonatomic, strong) NSMutableArray *setArray;
@property (nonatomic, strong) SFJsonBookModel *jsonModel;
/**背景图片*/
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSArray *chapterContentDataArray;

@property (nonatomic, assign) CGFloat oldOffsetY;
@property (nonatomic, assign) CGFloat scrollOffsetY;
@property (nonatomic, assign) BOOL isFirst;
/**是否隐藏状态栏*/
@property (nonatomic, assign) BOOL statusBarHidden;
/**是否隐藏全面屏横条*/
@property (nonatomic, assign) BOOL homeIndicatorHidden;
/**是否夜间模式*/
@property (nonatomic, assign) BOOL isNignt;//夜间模式  状态栏白色

@property (nonatomic, strong) UIPageViewController *pageViewController;
/* 点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) BOOL isTaping;
@property (nonatomic, strong) BookDetailModel *bookDetailModel;
/** 判断是否是下一章，是即上一章  否即下一章 */
@property (nonatomic, assign) BOOL ispreChapter;
/** 判断是否需要更新内容源 */
@property (nonatomic, assign) BOOL isRefreshChapter;

@property (nonatomic, strong) ZQAutoReadViewController *autoReadController;
@property (nonatomic, assign) SFTransitionStyle oldTransitionStyle;

@end

@implementation DCPageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    BOOL BrightSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBrightSwitch];
    if (!BrightSwitch) {
        CGFloat currentBright = [[NSUserDefaults standardUserDefaults] floatForKey:@"currentBright"];
        [UIScreen mainScreen].brightness = currentBright;
    } else {
        [[NSUserDefaults standardUserDefaults] setFloat:[UIScreen mainScreen].brightness forKey:@"currentBright"];
    }
    BOOL currentChangeSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTimerDisabled];
    [UIApplication sharedApplication].idleTimerDisabled = currentChangeSwitch;
    [[BaiduMobStatForSDK defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",self.bookModel.name] withAppId:@"718527995f"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[BaiduMobStatForSDK defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",self.bookModel.name] withAppId:@"718527995f"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.statusBarHidden = NO;
    self.homeIndicatorHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
    [SVProgressHUD dismiss];
    BOOL BrightSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBrightSwitch];
    if (!BrightSwitch) {
        CGFloat oldBright = [[NSUserDefaults standardUserDefaults] floatForKey:@"oldBright"];
        [UIScreen mainScreen].brightness = oldBright;
    }
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [self onApplicationWillResignActive];
}
//进入后台 保存下进度
- (void)onApplicationWillResignActive {
    self.bookModel.readTime = [SFTool getTimeLocal];
    CGFloat offset = self.scrollOffsetY-self.oldOffsetY;
    if (offset>0) {
        self.bookModel.pageOffset = offset;
        self.bookModel.bookIndex = self.bookDetailModel.chapter;
        self.bookModel.bookPage = self.bookDetailModel.page;
        [SFBookSave updateLocalBook:self.bookModel];
    } else {
        self.bookModel.pageOffset = -64;
        self.bookModel.bookIndex = self.bookDetailModel.chapter;
        self.bookModel.bookPage = self.bookDetailModel.page;
        [SFBookSave updateLocalBook:self.bookModel];
    }
}
- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.whiteColor;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTextviewNotification:) name:@"SFTextViewClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwipeFrom:) name:@"SFTextViewSwipeGesture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endAutoReadBook) name:KeyBookEndAutoRead object:nil];
    self.isRefreshChapter = NO;
    self.menuIsShowing = NO;
    self.isNignt = [[NSUserDefaults standardUserDefaults] boolForKey:KeySelectNight];
    BOOL bookHiddleStatus = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookHiddleStatus];
    self.statusBarHidden = bookHiddleStatus;
    self.homeIndicatorHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
    self.settingViewIsShowing = NO;
    self.bookDetailModel = [BookDetailModel new];
    DCBookModel *bookModel = [SFBookSave selectedLocalBookID:self.bookModel.ID];
    if (bookModel) {
        self.bookDetailModel.chapter = bookModel.bookIndex;
        self.bookDetailModel.page = bookModel.bookPage;
    } else {
        self.bookDetailModel.chapter = 0;
        self.bookDetailModel.page = 0;
    }
    self.oldOffsetY = 0.0;
    self.scrollOffsetY = 0.0;
    
    self.setArray = [NSMutableArray array];
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookThemePath];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
    
    for (NSDictionary *dict in list) {
        ReadSetModel *model = [ReadSetModel SF_MJParse:dict];
        [self.setArray addObject:model];
    }
    self.nightSetModel = self.setArray[0];
    [self.setArray removeObjectAtIndex:0];
    self.view.clipsToBounds = YES;
    NSInteger selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"selModelIndex"];
    if (selectedIndex>=self.setArray.count) {
        selectedIndex = 0;
    }
    self.daySetModel = self.setArray[selectedIndex];
    // Do any additional setup after loading the view.
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.backImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.backImageView];
    
    NSString *string = [DCFileTool transcodingWithPath:[DCBooksPath stringByAppendingPathComponent:self.bookModel.path]];
    NSDictionary *dict = [DCFileTool getBookDetailWithText:string];
    self.dataArray = dict[@"listArr"];
    if (self.dataArray>0) {
        self.chapterContentDataArray = dict[@"contentArr"];
    } else {
        self.chapterContentDataArray = @[string];
    }
    [self getWebData];
    
    [self setupBottomView];
    [self refreshAllViews];

    NSString *chooseStr = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPageStyle];
    if ([chooseStr isEqualToString:@"7"]) {
        [self addAutoReadBook];
    }
    [self updateFrameWithSize:self.view.bounds.size];
}
//屏幕旋转之后，屏幕的宽高互换，我们借此判断重新布局
//横屏：size.width > size.height
//竖屏: size.width < size.height
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateFrameWithSize:size];
}
- (void)updateFrameWithSize:(CGSize)size{
    [self hideMenu];
    self.backImageView.frame = CGRectMake(0, 0, size.width, size.height);
    self.coverView.frame = CGRectMake(0, 0, size.width, size.height);
    self.settingView.frame = CGRectMake(0, size.height, size.width, 328);
    self.menuContentView.frame = CGRectMake(-size.width, 0, fminf(size.width,size.height) * 0.8, size.height);
    if (size.width > size.height) {
        self.listTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame));
        self.bottomView.frame = CGRectMake(0, size.height, size.width, 50);
        self.topNavView.frame = CGRectMake(0, -44, size.width, 44);
        UIButton *button1 = [self.topNavView viewWithTag:222];
        button1.frame = CGRectMake(20,0, 30, 44);
        UIButton *button2 = [self.topNavView viewWithTag:456];
        button2.frame = CGRectMake(40,0, size.width-80, 44);
        UIButton *button3 = [self.topNavView viewWithTag:333];
        button3.frame = CGRectMake(size.width-50,0, 30, 44);
    } else {
        self.listTableView.frame = CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame)-[SFSafeAreaInsets shareInstance].safeAreaInsets.top);
        self.bottomView.frame = CGRectMake(0, size.height, size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
        self.topNavView.frame = CGRectMake(0, -(44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top), size.width, (44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top));
        UIButton *button1 = [self.topNavView viewWithTag:222];
        button1.frame = CGRectMake(20,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
        UIButton *button2 = [self.topNavView viewWithTag:456];
        button2.frame = CGRectMake(40,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, size.width-80, 44);
        UIButton *button3 = [self.topNavView viewWithTag:333];
        button3.frame = CGRectMake(size.width-50,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
    }
    CGFloat buttonW = size.width/5;
    for (int i=0; i<5; i++) {
        UIButton *button = [self.bottomView viewWithTag:100+i];
        button.frame = CGRectMake(i*buttonW, 0, buttonW, 50);
    }
}
- (void)showAppStore{
    //用户好评系统
    LBToAppStore *toAppStore = [[LBToAppStore alloc]init];
    [toAppStore showAlwaysGotoAppStore:self];
}
- (void)getWebData{
    [self worldSet];
    SFReadDetailViewController *vc = [self getpageBookContent];
    if (vc) {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

// 换行\t制表符，缩进
- (NSString *)adjustParagraphFormat:(NSString *)string {
    if (!string) {
        return nil;
    }
    string = [@" 　" stringByAppendingString:string];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\n　　"];
    return string;
}
//画出某章节某页的范围
- (void)pagingWithBounds:(CGRect)bounds withModel:(BookDetailModel *)model {
    NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyFontName];
    UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:kFontSize weight:UIFontWeightRegular];
    }
    if (model.content.length>0) {
        NSString *tmpStr = [model.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"　" withString:@""];
        NSMutableArray *tmpArr = [self stringWithReplaceOccurrencesOfString:tmpStr];
        NSString *newStr = [tmpArr componentsJoinedByString:@"\n"];
        newStr = [self adjustParagraphFormat:newStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:newStr];
        // 设置label的行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        CGFloat lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookLineHeight];
        [paragraphStyle setLineSpacing:lineHeight];
        CGFloat paragraphHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookParagraphHeight];
        [paragraphStyle setParagraphSpacing:paragraphHeight];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, newStr.length)];
        [attr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, newStr.length)];
        model.attrText = attr;
        
        model.pageContentArray = [PagingEngine pagingwithContentString:newStr contentSize:bounds.size textAttribute:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:font}];
        model.pageCount = model.pageContentArray.count;
    }
}

- (void)worldSet{
    if (self.chapterContentDataArray.count>self.bookDetailModel.chapter) {
        NSString *content = self.chapterContentDataArray[self.bookDetailModel.chapter];
        self.bookDetailModel.content = content;
        self.bookDetailModel.title = self.bookModel.name;
        if (self.dataArray.count>self.bookDetailModel.chapter) {
            NSString *name = self.dataArray[self.bookDetailModel.chapter];
            self.bookDetailModel.title = name;
        }
        [self pagingWithBounds:[SFSafeAreaInsets shareInstance].getRect withModel:self.bookDetailModel];
    }
}
- (NSMutableArray *)stringWithReplaceOccurrencesOfString:(NSString *)strring{
    NSArray *strArr = [strring componentsSeparatedByString:@"\n"];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *tmpStr in strArr) {
        if (tmpStr.length>0) {
            [tmpArr addObject:tmpStr];
        }
    }
    return tmpArr;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    NSInteger index;
    BOOL menuReverse = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMenuReverse];
    if (menuReverse) {
        index = self.dataArray.count-1-indexPath.section;
    } else {
        index = indexPath.section;
    }
    NSString *name = self.dataArray[index];
    if (self.bookDetailModel.chapter == index) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@(当前)",name];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = name;
        cell.detailTextLabel.text = @"";
        cell.textLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor];
    }
    cell.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.bookDetailModel.page = 0;
    BOOL menuReverse = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMenuReverse];
    if (menuReverse) {
        self.bookDetailModel.chapter = self.dataArray.count-1-indexPath.section;
    } else {
        self.bookDetailModel.chapter = indexPath.section;
    }
    [self getWebData];
    [self hideMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIControl *)coverView{
    if (!_coverView) {
        UIControl *coverView = [[UIControl alloc] init];
        coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [coverView addTarget:self action:@selector(coverViewClick) forControlEvents:UIControlEventTouchUpInside];
        coverView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        coverView.alpha = 0;
        [self.view addSubview:coverView];
        _coverView = coverView;
    }
    return _coverView;
}
- (void)showMenuView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.coverView.alpha = 0;
    self.chapterListIsShowing = YES;
    [self.view bringSubviewToFront:self.menuContentView];
    [self.listTableView reloadData];
    [self.listTableView layoutIfNeeded];
    BOOL menuReverse = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMenuReverse];
    if (!menuReverse) {
        CGFloat offset = self.bookDetailModel.chapter*44.0;
        if (offset>(self.listTableView.contentSize.height-self.listTableView.bounds.size.height)) {
            if (self.listTableView.contentSize.height>self.listTableView.bounds.size.height) {
                [self.listTableView setContentOffset:CGPointMake(0, self.listTableView.contentSize.height-self.listTableView.bounds.size.height) animated:YES];
            } else {
                [self.listTableView setContentOffset:CGPointMake(0, 0.0) animated:YES];
            }
        } else {
            [self.listTableView setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 1;
        self.menuContentView.frame = CGRectMake(0, 0, fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    }];
}
- (void)coverViewClick{
    if (self.chapterListIsShowing) {
        [self dismissMenuView];
    }
    if (self.settingViewIsShowing) {
        [self dismissSettingView];
    }
}
- (void)dismissMenuView{
    [self dismissMenuViewFinished:nil];
    self.chapterListIsShowing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideMenu) withObject:nil afterDelay:3];
}
- (void)dismissMenuViewFinished:(void(^)(void))finishedBlock{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0;
        self.menuContentView.frame = CGRectMake(-self.view.bounds.size.width, 0, fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}
- (void)showSettingView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.coverView.alpha = 0;
    self.settingViewIsShowing = YES;
    [self.view bringSubviewToFront:self.settingView];
    
    BOOL currentChangeSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTimerDisabled];
    [self.settingView setNotLock:currentChangeSwitch];
    float currentBright = [[NSUserDefaults standardUserDefaults] floatForKey:@"currentBright"];
    [self.settingView setBright:currentBright];
    for (int i=0; i<self.setArray.count; i++) {
        ReadSetModel *tmpModel = self.setArray[i];
        if ([self.daySetModel.themeId isEqualToString:tmpModel.themeId]) {
            [self.settingView cancelAllSelect];
            [self.settingView setSelectAtIndex:i];
        }
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 1;
        self.settingView.frame = CGRectMake(0, self.view.bounds.size.height-328, self.view.bounds.size.width, 328);
    }];
}
- (void)dismissSettingView
{
    self.settingViewIsShowing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0;
        self.settingView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 328);
    } completion:nil];
    [self performSelector:@selector(hideMenu) withObject:nil afterDelay:3];
}
- (void)showMenu
{
    if (self.menuIsShowing) {
        [self hideMenu];
        return;
    }
    if (self.settingViewIsShowing || self.chapterListIsShowing) {
        return;
    }
    self.menuIsShowing = YES;
    self.statusBarHidden = NO;
    self.homeIndicatorHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (self.view.bounds.size.width>self.view.bounds.size.height) {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
            self.topNavView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        } else {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-(50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom), self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
            self.topNavView.frame = CGRectMake(0, 0, self.view.bounds.size.width, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44));
        }
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideMenu) withObject:nil afterDelay:5];
}

- (void)hideMenu
{
    if (self.menuIsShowing == NO) {
        return;
    }
    if (self.chapterListIsShowing == YES) {
        [self dismissMenuView];
    }
    if (self.settingViewIsShowing == YES) {
        [self dismissSettingView];
    }
    self.menuIsShowing = NO;
    BOOL bookHiddleStatus = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookHiddleStatus];
    self.statusBarHidden = bookHiddleStatus;
    self.homeIndicatorHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (self.view.bounds.size.width>self.view.bounds.size.height) {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50);
            self.topNavView.frame = CGRectMake(0, -44, self.view.bounds.size.width, 44);
        } else {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
            self.topNavView.frame = CGRectMake(0, -([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), self.view.bounds.size.width, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44));
        }
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setupBottomView
{
    [self.pageViewController setViewControllers:@[[self getpageBookContent]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.settingBtnColor]:[SFTool colorWithHexString:self.daySetModel.settingBtnColor];
    baseView.userInteractionEnabled = YES;
    baseView.clipsToBounds = YES;
    baseView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
    [self.view addSubview:baseView];
    
    NSArray *NorImgArr = @[@"ic_book_source_manage",@"ic_daytime",@"reader_shezhi_zidong_sel",@"ic_read_aloud",@"ic_settings"];
    NSArray *SelImgArr = @[@"ic_book_source_manage",@"ic_brightness",@"reader_shezhi_zidong_sel",@"ic_read_aloud_Sel",@"ic_settings"];
    CGFloat buttonW = self.view.bounds.size.width/NorImgArr.count;
    for (int i=0; i<NorImgArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*buttonW, 0, buttonW, 50);
        [button setTitleColor:self.isNignt?[SFTool colorWithHexString:self.nightSetModel.settingTextColor]:[SFTool colorWithHexString:self.daySetModel.settingTextColor] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:NorImgArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:SelImgArr[i]] forState:UIControlStateSelected];
        button.tag = 100+i;
        button.selected = NO;
        if (i==1) {
            button.selected = self.isNignt;
        }
        [button addTarget:self action:@selector(menuItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
    }
    self.bottomView = baseView;
    
    UIView *leftContentView = [[UIView alloc] init];
    leftContentView.frame = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width * 0.8, self.view.bounds.size.height);
    [self.view addSubview:leftContentView];
    self.menuContentView = leftContentView;
    [leftContentView addSubview:self.listTableView];
    
    LNReaderSettingView *setView = [[[NSBundle mainBundle] loadNibNamed:@"LNReaderSettingView" owner:nil options:nil] firstObject];
    setView.skinList = self.setArray;
    setView.currentModel = self.daySetModel;
    setView.fontSize = kFontSize;
    CGFloat lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookLineHeight];
    setView.lineHeight = lineHeight;
    CGFloat paragraphHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookParagraphHeight];
    setView.paragraphHeight = paragraphHeight;
    setView.delegate = self;
    setView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 328);
    [self.view addSubview:setView];
    self.settingView = setView;
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.settingBtnColor]:[SFTool colorWithHexString:self.daySetModel.settingBtnColor];
    navView.userInteractionEnabled = YES;
    navView.clipsToBounds = YES;
    navView.frame = CGRectMake(0, -([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), self.view.bounds.size.width, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44));
    [self.view addSubview:navView];
    self.topNavView = navView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor clearColor];
    button.tag = 222;
    UIImage *leftimage = [UIImage imageNamed:@"icon_return"];
    [button setImage:leftimage forState:UIControlStateNormal];
    button.frame = CGRectMake(20,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:button];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(40,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, self.view.bounds.size.width-80, 44)];
    navTitle.tag = 456;
    navTitle.text = self.bookModel.name;
    navTitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:navTitle];
    UIButton *bookshelf = [UIButton buttonWithType:UIButtonTypeCustom];
    bookshelf.backgroundColor =[UIColor clearColor];
    bookshelf.tag = 333;
    bookshelf.frame = CGRectMake(self.view.bounds.size.width-50,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
    [navView addSubview:bookshelf];
    UIImage *bookshelfIcon = [UIImage imageNamed:@"ic_author"];
    [bookshelf setImage:bookshelfIcon forState:UIControlStateNormal];
    [bookshelf addTarget:self action:@selector(showAppStore) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backAction{
    [self listenBookStop];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    //朗读开始
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    //朗读暂停
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance;{
    //朗读继续
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    [[SFSoundPlayer SharedSoundPlayer] stopSpeaking];
    //朗读结束
    [self tapNextPage];
    [self listenBookStart];
}
- (UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame)-[SFSafeAreaInsets shareInstance].safeAreaInsets.top) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tag = 333;
        _listTableView.estimatedRowHeight= 0;
        _listTableView.estimatedSectionHeaderHeight= 0;
        _listTableView.estimatedSectionFooterHeight= 0;
        _listTableView.tableFooterView = [UIView new];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _listTableView;
}
- (void)menuItemClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
            {
                [self showMenuView];
            }
            break;
        case 101:
            {
                sender.selected = !sender.selected;
                if (sender.selected) {
                    self.isNignt = YES;
                } else {
                    self.isNignt = NO;
                }
                [[NSUserDefaults standardUserDefaults] setBool:self.isNignt forKey:KeySelectNight];
                [self refreshAllViews];
                [self hideMenu];
            }
            break;
        case 102:
            {
                [self hideMenu];
                [self performSelector:@selector(addAutoReadBook) withObject:nil afterDelay:0.25];
            }
            break;
        case 103:
            {
                sender.selected = !sender.selected;
                if (sender.selected) {
                    [self listenBookStart];
                } else {
                    [self listenBookStop];
                }
                [self hideMenu];
            }
            break;
        case 104:
            {
                [self showSettingView];
            }
            break;
            
        default:
            break;
    }
}
- (void)refreshAllViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsStatusBarAppearanceUpdate];
        [self.listTableView reloadData];
        self.view.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.color]:[SFTool colorWithHexString:self.daySetModel.color];
        self.settingView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        self.backImageView.image = self.isNignt?nil:[UIImage imageNamed:self.daySetModel.bgImage];
        
        self.bottomView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        self.topNavView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        UILabel *titleLabel = [self.topNavView viewWithTag:456];
        titleLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor];
        UIButton *button = [self.bottomView viewWithTag:102];
        if (self.isNignt) {
            button.selected=YES;
        } else {
            button.selected=NO;
        }
        
        [self.pageViewController setViewControllers:@[[self getpageBookContent]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    });
}
- (void)receivedTextviewNotification:(NSNotification *)notification{
    NSDictionary *infoDict = notification.userInfo;
    NSString *clickX = [NSString stringWithFormat:@"%@",infoDict[@"clickX"]];
    NSString *clickY = [NSString stringWithFormat:@"%@",infoDict[@"clickY"]];
    /**
     @{@"show":@"左中右区域",@"time":@0,@"type":@"1"},
     @{@"show":@"上中下区域",@"time":@0,@"type":@"2"},
     @{@"show":@"四周包中区域",@"time":@0,@"type":@"3"},
     @{@"show":@"全屏区域",@"time":@0,@"type":@"4"}];
     */
    NSString *chooseStr = [[NSUserDefaults standardUserDefaults] objectForKey:KeyClickArea];
    switch (chooseStr.intValue) {
        case 1:
        {
            CGFloat noClickW = self.view.bounds.size.width/3.0;
            BOOL tapClickExchange = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTapClickExchange];
            if (tapClickExchange) {
                if (clickX.floatValue<noClickW) {
                    // 左边
                    [self tapNextPage];
                    [self hideMenu];
                } else if (clickX.floatValue>noClickW*2) {
                    //右边
                    [self tapPrePage];
                    [self hideMenu];
                } else {
                    //中间
                    [self showMenu];
                }
            } else {
                if (clickX.floatValue<noClickW) {
                    // 左边
                    [self tapPrePage];
                    [self hideMenu];
                } else if (clickX.floatValue>noClickW*2) {
                    //右边
                    [self tapNextPage];
                    [self hideMenu];
                } else {
                    //中间
                    [self showMenu];
                }
            }
        }
            break;
        case 2:
        {
            CGFloat noClickH = self.view.bounds.size.height/3.0;
            BOOL tapClickExchange = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTapClickExchange];
            if (tapClickExchange) {
                if (clickY.floatValue<noClickH) {
                    // 上边
                    [self tapNextPage];
                    [self hideMenu];
                } else if (clickY.floatValue>noClickH*2) {
                    //下边
                    [self tapPrePage];
                    [self hideMenu];
                } else {
                    //中间
                    [self showMenu];
                }
            } else {
                if (clickY.floatValue<noClickH) {
                    // 上边
                    [self tapPrePage];
                    [self hideMenu];
                } else if (clickY.floatValue>noClickH*2) {
                    //下边
                    [self tapNextPage];
                    [self hideMenu];
                } else {
                    //中间
                    [self showMenu];
                }
            }
        }
            break;
        case 3:
        {
            CGFloat noClickW = self.view.bounds.size.width/3.0;
            CGFloat noClickH = self.view.bounds.size.height/3.0;
            if (clickX.floatValue<noClickW || clickX.floatValue>noClickW*2 || clickY.floatValue<noClickH || clickY.floatValue>noClickH*2 ) {
                //下一页
                [self tapNextPage];
                [self hideMenu];
            } else {
                //中间
                [self showMenu];
            }
        }
            break;
        case 4:
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeySwipeBack];
            //下一页
            [self tapNextPage];
            [self hideMenu];
        }
            break;
            
        default:
            break;
    }
}
- (void)handleSwipeFrom:(NSNotification *)notification{
    NSDictionary *infoDict = notification.userInfo;
    NSString *direction = [NSString stringWithFormat:@"%@",infoDict[@"direction"]];
    if ([direction isEqualToString:@"up"]) {
        //上边
        BOOL swipeBack = [[NSUserDefaults standardUserDefaults] boolForKey:KeySwipeBack];
        if (swipeBack) {
            [self backAction];
        }
    }
    else if ([direction isEqualToString:@"down"]) {
        //下边
        BOOL swipeBack = [[NSUserDefaults standardUserDefaults] boolForKey:KeySwipeBack];
        if (swipeBack) {
            [self backAction];
        }
    }
}
#pragma mark - LNReaderSettingViewDelegate
//选中的model
- (void)settingViewDidClickSkinAtIndex:(NSInteger)index{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"selModelIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.daySetModel = self.setArray[index];
    self.isNignt = NO;
    [self refreshAllViews];
}
//字体大小
- (void)settingViewDidChangeFontSize:(float)size{
    self.settingView.fontSize = size;
    [[NSUserDefaults standardUserDefaults] setFloat:size forKey:@"textViewFontSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self worldSet];
    [self refreshAllViews];
}
//行高
- (void)settingViewDidChangeLineHeight:(float)height{
    self.settingView.lineHeight = height;
    [[NSUserDefaults standardUserDefaults] setFloat:height forKey:KeyBookLineHeight];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self worldSet];
    [self refreshAllViews];
}
//段高
- (void)settingViewDidChangeParagraphHeight:(float)height{
    self.settingView.paragraphHeight = height;
    [[NSUserDefaults standardUserDefaults] setFloat:height forKey:KeyBookParagraphHeight];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self worldSet];
    [self refreshAllViews];
}
//亮度
- (void)settingViewDidChangeBright:(float)bright{
    [[NSUserDefaults standardUserDefaults] setFloat:bright forKey:@"currentBright"];
    [UIScreen mainScreen].brightness = bright;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeyBrightSwitch];
}
//是否保持常亮
- (void)settingViewDidChangeSwitch:(BOOL)on{
    [UIApplication sharedApplication].idleTimerDisabled = on;
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:KeyTimerDisabled];
}
#pragma mark - 状态栏控制
//改变动画，有滑动、渐入渐出，无动画三种。
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}
//返回状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (!self.isNignt) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}
- (BOOL)prefersHomeIndicatorAutoHidden{
    return self.homeIndicatorHidden;
}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        BOOL isFollSys = [[NSUserDefaults standardUserDefaults] boolForKey:KeyNightFollowingSystem];
        if (isFollSys) {
            if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
                UIButton *button = [self.bottomView viewWithTag:101];
                if (previousTraitCollection.userInterfaceStyle==UIUserInterfaceStyleLight) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KeySelectNight];
                    self.isNignt = YES;
                } else {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:KeySelectNight];
                    self.isNignt = NO;
                }
                button.selected = self.isNignt;
                [self refreshAllViews];
                self.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
                self.navigationController.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
            }
        }
    }
}
#pragma mark - getter

//pageViewController
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        //NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        UIPageViewControllerTransitionStyle style;
        UIPageViewControllerNavigationOrientation orientation;
        NSDictionary *options;
        BOOL doubleSided = NO;
        /*
        NSArray *pageStyleArr = @[
        @{@"show":@"上下滑动",@"time":@0,@"type":@"1"},
        @{@"show":@"左右拟真翻页",@"time":@0,@"type":@"2"},
        @{@"show":@"左右平滑翻页",@"time":@0,@"type":@"3"},
        @{@"show":@"上下拟真翻页",@"time":@0,@"type":@"4"},
        @{@"show":@"上下平滑翻页",@"time":@0,@"type":@"5"},
        @{@"show":@"无动画",@"time":@0,@"type":@"6"},
        @{@"show":@"自动阅读",@"time":@0,@"type":@"7"}];
         */
        NSString *chooseStr = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPageStyle];
        switch (chooseStr.integerValue) {//type
            case 2:
                {
                    doubleSided = YES;
                    style = UIPageViewControllerTransitionStylePageCurl;
                    orientation = UIPageViewControllerNavigationOrientationHorizontal;
                    options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
                    self.bookDetailModel.transitionStyle = SFTransitionStyle_PageCurl;
                }
                break;
            case 3:
                {
                    doubleSided = NO;
                    style = UIPageViewControllerTransitionStyleScroll;
                    orientation = UIPageViewControllerNavigationOrientationHorizontal;
                    options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionInterPageSpacingKey];
                    self.bookDetailModel.transitionStyle = SFTransitionStyle_Scroll;
                }
                break;
            case 4:
                {
                    doubleSided = YES;
                    style = UIPageViewControllerTransitionStylePageCurl;
                    orientation = UIPageViewControllerNavigationOrientationVertical;
                    options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
                    self.bookDetailModel.transitionStyle = SFTransitionStyle_PageCurl;
                }
                break;
            case 5:
                {
                    doubleSided = NO;
                    style = UIPageViewControllerTransitionStyleScroll;
                    orientation = UIPageViewControllerNavigationOrientationVertical;
                    options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone] forKey: UIPageViewControllerOptionInterPageSpacingKey];
                    self.bookDetailModel.transitionStyle = SFTransitionStyle_Scroll;
                }
                break;
                
            default:
            {
                doubleSided = YES;
                style = UIPageViewControllerTransitionStylePageCurl;
                orientation = UIPageViewControllerNavigationOrientationHorizontal;
                self.bookDetailModel.transitionStyle = SFTransitionStyle_default;
            }
                break;
        }
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:orientation options:options];
        _pageViewController.doubleSided = doubleSided;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        
        [self.view addSubview:_pageViewController.view];
        [self addChildViewController:_pageViewController];
        
        for (UIGestureRecognizer *gesture in _pageViewController.gestureRecognizers) {
            /*
             /UIPageViewControllerTransitionStylePageCurl模拟翻页类型中有UIPanGestureRecognizer UITapGestureRecognizer两种手势，删除左右边缘的点击事件
             */
            if ([gesture isKindOfClass:UITapGestureRecognizer.class]) {
                [_pageViewController.view removeGestureRecognizer:gesture];
            }
        }
    }
    return _pageViewController;
}
#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSLog(@"将要开始动画");
    // 将要开始动画的时候关闭视图的交互性
//    pageViewController.view.userInteractionEnabled = NO;
}
/*
 [self.pageViewController setViewControllers: direction: animated: completion:]
 animated:NO 是不走这个方法的
 */
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        SFReadDetailViewController *readerPageVC = (SFReadDetailViewController *)previousViewControllers.firstObject;
        self.bookDetailModel.page = readerPageVC.page;
        self.bookDetailModel.chapter = readerPageVC.chapter;
    } else {
        SFReadDetailViewController *readPageVC = (SFReadDetailViewController *)pageViewController.viewControllers.firstObject;
        self.bookDetailModel.page = readPageVC.page;
        self.bookDetailModel.chapter = readPageVC.chapter;
    }
    _isTaping = NO;
    //动画结束后打开交互
//    if (finished) {
//        pageViewController.view.userInteractionEnabled = YES;
//    }
}


#pragma mark - UIPageViewControllerDataSource

//上一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSLog(@"滑动上一页");
    if (_isTaping) {
        return nil;
    }
    
    if (self.bookDetailModel.chapter == 0 && self.bookDetailModel.page == 0) {
        [SVProgressHUD showErrorWithStatus:@"已经是第一页了!"];
        return nil;
    }
    
    if ((self.bookDetailModel.transitionStyle == SFTransitionStyle_PageCurl || self.bookDetailModel.transitionStyle == SFTransitionStyle_default) && [viewController isKindOfClass:SFReadDetailViewController.class]) {
        SFBookReadingBackViewController *vc = [[SFBookReadingBackViewController alloc] init];
        [vc updateWithViewController:viewController];
        return vc;
    }
    
    if (self.bookDetailModel.page > 0) {
        self.bookDetailModel.page--;
        return [self getpageBookContent];
    } else {
        self.bookDetailModel.chapter--;
        [self worldSet];
        self.bookDetailModel.page = self.bookDetailModel.pageCount-1;
        _ispreChapter = YES;
        return [self getChapterBookContent];
    }
}


//下一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSLog(@"滑动下一页");
    if (_isTaping) {
        return nil;
    }
    
    if (self.bookDetailModel.page == self.bookDetailModel.pageCount - 1 && self.bookDetailModel.chapter >= self.chapterContentDataArray.count - 1) {
        [SVProgressHUD showErrorWithStatus:@"已经是最后一页了!"];
        return nil;
    }
    
    if ((self.bookDetailModel.transitionStyle == SFTransitionStyle_PageCurl || self.bookDetailModel.transitionStyle == SFTransitionStyle_default) && [viewController isKindOfClass:SFReadDetailViewController.class]) {
        SFBookReadingBackViewController *vc = [[SFBookReadingBackViewController alloc] init];
        [vc updateWithViewController:viewController];
        return vc;
    }
    
    if (self.bookDetailModel.page >= self.bookDetailModel.pageCount - 1) {
        self.bookDetailModel.page = 0;
        self.bookDetailModel.chapter++;
        [self worldSet];
        _ispreChapter = NO;
        return [self getChapterBookContent];;
        
    } else {
        self.bookDetailModel.page++;
        return [self getpageBookContent];
    }
}

- (SFReadDetailViewController *)getChapterBookContent {
    SFReadDetailViewController __block *contentVC = [[SFReadDetailViewController alloc] init];
    if (self.chapterContentDataArray.count>self.bookDetailModel.chapter) {
        NSDictionary *viewSetDict = @{@"isNignt":@(self.isNignt),@"nightSetModel":self.nightSetModel,@"daySetModel":self.daySetModel};
        contentVC.viewSetDict = viewSetDict;
        contentVC.bookTitleName = self.bookModel.name;
        contentVC.bookModel = self.bookDetailModel;
        contentVC.chapter = self.bookDetailModel.chapter;
        contentVC.page = self.bookDetailModel.page;
        self.isTaping = NO;
    }
    return contentVC;
}

- (SFReadDetailViewController *)getpageBookContent {
    // 创建一个新的控制器类，并且分配给相应的数据
    if (self.chapterContentDataArray.count>self.bookDetailModel.chapter) {
        SFReadDetailViewController *contentVC = [[SFReadDetailViewController alloc] init];
        NSDictionary *viewSetDict = @{@"isNignt":@(self.isNignt),@"nightSetModel":self.nightSetModel,@"daySetModel":self.daySetModel};
        contentVC.viewSetDict = viewSetDict;
        contentVC.bookTitleName = self.bookModel.name;
        contentVC.bookModel = self.bookDetailModel;
        contentVC.chapter = self.bookDetailModel.chapter;
        contentVC.page = self.bookDetailModel.page;
        return contentVC;
    } else {
        [SVProgressHUD showErrorWithStatus:@"当前章节超出目录"];
        return nil;
    }
}

//点击下一页
- (void)tapNextPage {
    NSLog(@"点击下一页chapter=%ld page=%ld", (long)self.bookDetailModel.chapter, (long)self.bookDetailModel.page);
    if (self.bookDetailModel.page == self.bookDetailModel.pageCount - 1 && self.bookDetailModel.chapter >= self.chapterContentDataArray.count - 1) {
        [SVProgressHUD showErrorWithStatus:@"已经是最后一页了!"];
        return;
    }
    if (self.bookDetailModel.page >= self.bookDetailModel.pageCount - 1) {
        self.bookDetailModel.page = 0;
        self.bookDetailModel.chapter++;
        [self worldSet];
        _ispreChapter = NO;
        [self requestDataAndSetViewController];
        
    } else {
        if (self.bookDetailModel.transitionStyle == SFTransitionStyle_default) {
            self.bookDetailModel.page++;
            SFReadDetailViewController *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
        else if (self.bookDetailModel.transitionStyle == SFTransitionStyle_PageCurl) {
            self.bookDetailModel.page++;
            SFReadDetailViewController *textVC = [self getpageBookContent];
            SFBookReadingBackViewController *backView = [[SFBookReadingBackViewController alloc] init];
            [backView updateWithViewController:textVC];
            [self.pageViewController setViewControllers:@[textVC, backView] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
        else {
            MJWeakSelf;
            _isTaping = YES;
            SFReadDetailViewController *firstVc = [self.pageViewController.viewControllers firstObject];
            self.bookDetailModel.page = firstVc.page + 1;
            self.view.userInteractionEnabled = NO;
            self.pageViewController.view.userInteractionEnabled = NO;
            SFReadDetailViewController *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.isTaping = NO;
                    weakSelf.pageViewController.view.userInteractionEnabled = YES;
                    weakSelf.view.userInteractionEnabled = YES;
                }
            }];
        }
    }
}


//点击上一页
- (void)tapPrePage {
    NSLog(@"点击上一页chapter=%ld page=%ld", (long)self.bookDetailModel.chapter, (long)self.bookDetailModel.page);
    if (self.bookDetailModel.chapter == 0 && self.bookDetailModel.page == 0) {
        [SVProgressHUD showErrorWithStatus:@"已经是第一页了!"];
        return;
    }
    
    if (self.bookDetailModel.page > 0) {
        
        if (self.bookDetailModel.transitionStyle == SFTransitionStyle_default) {
            self.bookDetailModel.page--;
            SFReadDetailViewController *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        }
        else if (self.bookDetailModel.transitionStyle == SFTransitionStyle_PageCurl) {
            self.bookDetailModel.page--;
            SFReadDetailViewController *textVC = [self getpageBookContent];
            SFBookReadingBackViewController *backView = [[SFBookReadingBackViewController alloc] init];
            [backView updateWithViewController:textVC];
            [self.pageViewController setViewControllers:@[textVC, backView] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        else {
            MJWeakSelf;
            SFReadDetailViewController *firstVc = [self.pageViewController.viewControllers firstObject];
            self.bookDetailModel.page = firstVc.page - 1;
            _isTaping = YES;
            self.view.userInteractionEnabled = NO;
            self.pageViewController.view.userInteractionEnabled = NO;
            SFReadDetailViewController *textVC = [self getpageBookContent];
            [self.pageViewController setViewControllers:@[textVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
                if (finished) {
                    weakSelf.isTaping = NO;
                    weakSelf.pageViewController.view.userInteractionEnabled = YES;
                    weakSelf.view.userInteractionEnabled = YES;
                }
            }];
        }
    } else {
        self.bookDetailModel.chapter--;
        [self worldSet];
        self.bookDetailModel.page = self.bookDetailModel.pageCount-1;
        _ispreChapter = YES;
        [self requestDataAndSetViewController];
    }
}
- (void)requestDataAndSetViewController {
    [SVProgressHUD dismiss];
    SFReadDetailViewController *contentVC = [[SFReadDetailViewController alloc] init];
    NSDictionary *viewSetDict = @{@"isNignt":@(self.isNignt),@"nightSetModel":self.nightSetModel,@"daySetModel":self.daySetModel};
    contentVC.viewSetDict = viewSetDict;
    contentVC.bookTitleName = self.bookModel.name;
    contentVC.bookModel = self.bookDetailModel;
    contentVC.chapter = self.bookDetailModel.chapter;
    contentVC.page = self.bookDetailModel.page;
    self.isTaping = NO;
    self.isRefreshChapter = NO;
    
    if (self.bookDetailModel.transitionStyle == SFTransitionStyle_PageCurl){
        SFBookReadingBackViewController *backView = [[SFBookReadingBackViewController alloc] init];
        [backView updateWithViewController:contentVC];
        if (self.ispreChapter) {
            [self.pageViewController setViewControllers:@[contentVC,backView] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        } else {
            [self.pageViewController setViewControllers:@[contentVC,backView] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
    else if (self.bookDetailModel.transitionStyle == SFTransitionStyle_default){
        if (self.ispreChapter) {
            [self.pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        } else {
            [self.pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }
    }
    else {
        if (self.ispreChapter) {
            [self.pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        } else {
            [self.pageViewController setViewControllers:@[contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
    }
}

#pragma mark -远程响应控制

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay://播放
                [[SFSoundPlayer SharedSoundPlayer] pauseSpeaking];
                
                break;
            case UIEventSubtypeRemoteControlPause://暂停
                [[SFSoundPlayer SharedSoundPlayer] pauseSpeaking];
                
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause: //耳机暂停/继续(只适用于耳机)
                [[SFSoundPlayer SharedSoundPlayer] pauseSpeaking];
                
                break;
                
            case UIEventSubtypeRemoteControlNextTrack://下一曲
                {
                    [[SFSoundPlayer SharedSoundPlayer] stopSpeaking];
                    //朗读结束
                    self.bookDetailModel.chapter ++;
                    [self requestDataAndSetViewController];
                }
                
                break;
            case UIEventSubtypeRemoteControlPreviousTrack://上一曲
                {
                    [[SFSoundPlayer SharedSoundPlayer] stopSpeaking];
                    //朗读结束
                    self.bookDetailModel.chapter --;
                    [self requestDataAndSetViewController];
                }
                
                break;
                
            default:
                break;
        }
        
    }
    
}

/**
 听书时被别的app打断通知
 */

- (void)addInterruptionNotification {
    //打断监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    
    //耳机监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];

    
}
/**
 听书时被别的app打断处理
 
 @param notification 通知内容
 */

- (void)handleInterruption:(NSNotification *) notification{
    if (notification.name != AVAudioSessionInterruptionNotification || notification.userInfo == nil) {
        return;
    }
    NSDictionary *info = notification.userInfo;
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        if ([[info valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"InterruptionTypeBegan");
            [[SFSoundPlayer SharedSoundPlayer] pauseSpeaking];
        } else {
            NSLog(@"InterruptionTypeEnded");
            [[SFSoundPlayer SharedSoundPlayer] pauseSpeaking];
        }
    }
}



- (void)handleRouteChange:(NSNotification *)notification{
    /*
     当耳机插入的时候，AVAudioSessionRouteChangeReason等于AVAudioSessionRouteChangeReasonNewDeviceAvailable
     代表一个新外接设备可用，但是插入耳机，我们不需要处理。所以不做判断。
     
     当耳机拔出的时候 AVAudioSessionRouteChangeReason等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable
     代表一个之前外的外接设备不可用了，此时我们需要处理，让他播放器静音 。
     
     AVAudioSessionRouteChangePreviousRouteKey：当之前的线路改变的时候，
     
     获取到线路的描述对象：AVAudioSessionRouteDescription，然后获取到输出设备，判断输出设备的类型是否是耳机,
     如果是就暂停播放
     */
    NSDictionary *info = notification.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [[SFSoundPlayer SharedSoundPlayer] pauseSpeaking];
        }
    }
//    NSLog(@"%@",info);
}

/**
 *  锁屏信息
 */
- (void)speechScreenInfo{
    NSString *novelName = self.bookModel.name;
    NSDictionary *dic = @{MPMediaItemPropertyTitle:novelName};
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}
- (void)listenBookStart{
    //开启后台
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    dispatch_queue_t queue = dispatch_queue_create("com.xiaofu.Lurich", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        CGFloat bookRate = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookRate];
        CGFloat bookPitchMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookPitch];
        SFSoundPlayer *speechAv = [SFSoundPlayer SharedSoundPlayer];
        [speechAv setDefaultWithVolume:1.0 rate:bookRate pitchMultiplier:bookPitchMultiplier];
        speechAv.delegate = self;
        BookDetailModel *bookModel = self.bookDetailModel;
        NSAttributedString *attStr = bookModel.pageContentArray[self.bookDetailModel.page];
        [speechAv play:attStr.string];
        [self speechScreenInfo];
    });
}
//退出
- (void)listenBookStop{
    SFSoundPlayer *speechAv = [SFSoundPlayer SharedSoundPlayer];
    [speechAv stopSpeaking];

    //取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
}
#pragma mark - 自动阅读
- (void)endAutoReadBook{
    self.bookDetailModel.transitionStyle = self.oldTransitionStyle;
}
- (void)addAutoReadBook{
    self.oldTransitionStyle = self.bookDetailModel.transitionStyle;
    self.bookDetailModel.transitionStyle = SFTransitionStyle_default;
    ZQAutoReadViewController *autoReadController = [ZQAutoReadViewController new];
    autoReadController.delegate = self;
    //加载当前界面
    [autoReadController updateWithView:[self captureView:self.view]];
    [autoReadController startAuto];
    [self.view addSubview:autoReadController.view];
    [self addChildViewController:autoReadController];
    self.autoReadController = autoReadController;
    //加载下一章||翻页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tapNextPage];
    });
}
- (UIImage *)captureView:(UIView *)view {
    CGRect rect = view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - autoReadDelegate

- (void)finishReadPage:(ZQAutoReadViewController *)controller {
    
    //重设自动阅读界面
    [self.autoReadController updateWithView:[self captureView:self.view]];
    [self.autoReadController startAuto];
    //加载下一章||翻页
    [self tapNextPage];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@===%s",self.class,__func__);
}

@end

