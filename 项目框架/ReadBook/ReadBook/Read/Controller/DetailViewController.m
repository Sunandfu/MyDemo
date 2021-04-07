//
//  DetailViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/13.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "DetailViewController.h"
#import "ONOXMLDocument.h"
#import "SFNetWork.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "DetailTableViewCell.h"
#import "ReadSetModel.h"
#import "LNReaderSettingView.h"
#import "SFBookSave.h"
#import "SFSoundPlayer.h"
#import "SFTool.h"
#import "SFSafeAreaInsets.h"
#import "BaiduMobStatForSDK.h"
#import "SFJsonContentModel.h"
#import "SFRequestModel.h"
#import "SFJsonBookModel.h"
#import "SFJsonCatelogModel.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,LNReaderSettingViewDelegate,SFSoundPlayerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger lastIndex;
/**章节标题*/
@property (nonatomic, strong) UILabel *chapterTitleLabel;
/**是否正在显示菜单*/
@property (nonatomic, assign) BOOL menuIsShowing;
/**是否正在显示源列表*/
@property (nonatomic, assign) BOOL sourceIsShowing;
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
/**右侧源列表view*/
@property (nonatomic, strong) UIView *sourceContentView;
/**右侧源列表*/
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) SFJsonBookModel *jsonModel;
/**设置栏*/
@property (nonatomic, strong) LNReaderSettingView *settingView;
/**设置数据源*/
@property (nonatomic, strong) NSMutableArray *setArray;
/**背景图片*/
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, assign) CGFloat oldOffsetY;
@property (nonatomic, assign) CGFloat scrollOffsetY;
@property (nonatomic, assign) BOOL isFirst;
/**是否隐藏状态栏*/
@property (nonatomic, assign) BOOL statusBarHidden;
/**是否隐藏全面屏横条*/
@property (nonatomic, assign) BOOL homeIndicatorHidden;
/**是否夜间模式*/
@property (nonatomic, assign) BOOL isNignt;//夜间模式  状态栏白色
/**当前请求到的小说内容*/
@property (nonatomic, copy  ) NSString *currentStr;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    BOOL BrightSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBrightSwitch];
    if (!BrightSwitch) {
        CGFloat currentBright = [[NSUserDefaults standardUserDefaults] floatForKey:@"currentBright"];
        [UIScreen mainScreen].brightness = currentBright;
    }
    BOOL currentChangeSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:KeyTimerDisabled];
    [UIApplication sharedApplication].idleTimerDisabled = currentChangeSwitch;
    [[BaiduMobStatForSDK defaultStat] pageviewStartWithName:[NSString stringWithFormat:@"%@",self.bookModel.bookTitle] withAppId:@"718527995f"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[BaiduMobStatForSDK defaultStat] pageviewEndWithName:[NSString stringWithFormat:@"%@",self.bookModel.bookTitle] withAppId:@"718527995f"];
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
    self.bookModel.bookDate = [SFTool getTimeLocal];
    CGFloat offset = self.scrollOffsetY-self.oldOffsetY;
    if (offset>0) {
        self.bookModel.pageOffset = offset;
        self.bookModel.bookIndex = self.index;
        [SFBookSave updateBook:self.bookModel];
    } else {
        self.bookModel.pageOffset = -64;
        self.bookModel.bookIndex = self.index;
        [SFBookSave updateBook:self.bookModel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTextviewNotification:) name:@"SFTextViewClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwipeFrom:) name:@"SFTextViewSwipeGesture" object:nil];
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    BookModel *bookModel = [SFBookSave selectedBookNumber:self.bookModel.bookNumber];
    if (bookModel) {
        self.index = bookModel.bookIndex;
    } else {
        self.index = 0;
    }
    self.oldOffsetY = 0.0;
    self.scrollOffsetY = 0.0;
    self.isFirst = YES;
    self.sourceArray = [NSMutableArray array];
    
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
    [self.view addSubview:self.backImageView];
    UILabel *chapterTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, self.view.bounds.size.width, 20)];
    chapterTitle.backgroundColor = [UIColor clearColor];
    chapterTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    chapterTitle.textColor = [UIColor blackColor];
    chapterTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:chapterTitle];
    self.chapterTitleLabel = chapterTitle;
    [self.view addSubview:self.tableView];
    
    [self setupBottomView];
    
    __weak typeof(self) weakSelf = self;
    /// 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.index -= 1;
        [weakSelf getWebDataWithIndex:weakSelf.index];
    }];
    /// 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.index += 1;
        [weakSelf getWebDataWithIndex:weakSelf.index];
    }];
//    footer.onlyRefreshPerDrag = YES;
    self.tableView.mj_footer = footer;
    [self getWebDataWithIndex:self.index];
    
    [self refreshAllViews];
    
    [self addInterruptionNotification];
    
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
    self.sourceContentView.frame = CGRectMake(size.width, 0, fminf(size.width,size.height) * 0.8, size.height);
    self.menuContentView.frame = CGRectMake(-size.width, 0, fminf(size.width,size.height) * 0.8, size.height);
    if (size.width > size.height) {
        self.listTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame));
        self.sourceListTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.sourceContentView.frame), CGRectGetHeight(self.sourceContentView.frame));
        self.chapterTitleLabel.frame = CGRectMake(0,0, size.width, 20);
        self.bottomView.frame = CGRectMake(0, size.height, size.width, 50);
        self.topNavView.frame = CGRectMake(0, -44, size.width, 44);
        UIButton *button1 = [self.topNavView viewWithTag:222];
        button1.frame = CGRectMake(20,0, 30, 44);
        UIButton *button2 = [self.topNavView viewWithTag:456];
        button2.frame = CGRectMake(40,0, size.width-80, 44);
        UIButton *button3 = [self.topNavView viewWithTag:333];
        button3.frame = CGRectMake(size.width-50,0, 30, 44);
        self.tableView.frame = CGRectMake(0, 20, size.width, size.height-20);
    } else {
        self.listTableView.frame = CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame)-[SFSafeAreaInsets shareInstance].safeAreaInsets.top);
        self.sourceListTableView.frame = CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, CGRectGetWidth(self.sourceContentView.frame), CGRectGetHeight(self.sourceContentView.frame)-[SFSafeAreaInsets shareInstance].safeAreaInsets.top);
        self.chapterTitleLabel.frame = CGRectMake(0,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, size.width, 20);
        self.bottomView.frame = CGRectMake(0, size.height, size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
        self.topNavView.frame = CGRectMake(0, -(44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top), size.width, (44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top));
        UIButton *button1 = [self.topNavView viewWithTag:222];
        button1.frame = CGRectMake(20,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
        UIButton *button2 = [self.topNavView viewWithTag:456];
        button2.frame = CGRectMake(40,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, size.width-80, 44);
        UIButton *button3 = [self.topNavView viewWithTag:333];
        button3.frame = CGRectMake(size.width-50,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
        self.tableView.frame = CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top+20, size.width, size.height-[SFSafeAreaInsets shareInstance].safeAreaInsets.top-20);
    }
    CGFloat buttonW = size.width/4;
    for (int i=0; i<4; i++) {
        UIButton *button = [self.bottomView viewWithTag:100+i];
        button.frame = CGRectMake(i*buttonW, 0, buttonW, 50);
    }
    
    [self.tableView reloadData];
}

- (void)addBook{
    if ([SFBookSave isHaveBook:self.bookModel]) {
        [SVProgressHUD showSuccessWithStatus:@"已经加入书架了哦"];
    } else {
        BOOL insert = [SFBookSave insertBook:self.bookModel];
        if (insert) {
            BookModel *bookModel = [SFBookSave selectedBookNumber:self.bookModel.bookNumber];
            self.bookModel = bookModel;
            [SVProgressHUD showSuccessWithStatus:@"加入书架成功"];
            UIButton *bookshelf = [self.topNavView viewWithTag:333];
            UIImage *bookshelfIcon = [UIImage imageNamed:@"icon_change"];
            [bookshelf setImage:bookshelfIcon forState:UIControlStateNormal];
            [bookshelf removeTarget:self action:@selector(addBook) forControlEvents:UIControlEventTouchUpInside];
            [bookshelf addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self performSelector:@selector(showAppStore) withObject:nil afterDelay:2];
}
- (void)showAppStore{
    //用户好评系统
    LBToAppStore *toAppStore = [[LBToAppStore alloc]init];
    [toAppStore showGotoAppStore:self];
}
- (void)getWebDataWithIndex:(NSInteger)index{
    if (index < 0) {
        self.index += 1;
        [SVProgressHUD showErrorWithStatus:@"已经是第一页了"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self listenBookStop];
        return;
    } else if (index >= self.cellArray.count) {
        self.index -= 1;
        [SVProgressHUD showErrorWithStatus:@"没有最新了"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self listenBookStop];
        return;
    }
    [SFBookSave updateBook:self.bookModel];
    BookDetailModel *model = self.cellArray[index];
    self.oldOffsetY = self.tableView.contentSize.height;
    if ([self.xpath isEqualToString:@"json"]) {
        NSLog(@"postUrl:%@",model.postUrl);
        [SFNetWork getJsonDataWithURL:model.postUrl parameters:nil success:^(id json) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([json isKindOfClass:[NSData class]]) {
                return;
            }
            if (self.lastIndex>index) {
                [self.dataArray removeAllObjects];
            }
            SFJsonContentModel *contentModel = [SFJsonContentModel SF_MJParse:json];
            if (contentModel.ret == 0) {
                BookDetailModel *cellModel = [BookDetailModel new];
                cellModel.title = model.title;
                cellModel.content = [contentModel.data.content componentsJoinedByString:@"\n"];
                [self refreshNewDataWithModel:cellModel];
                self.currentStr = [NSString stringWithFormat:@"%@，%@",model.title,cellModel.attrText.string];
                [self.dataArray addObject:cellModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.chapterTitleLabel.text = model.title;
                if (self.lastIndex>index) {
                    [self.tableView setContentOffset:CGPointMake(0, 0.0) animated:NO];
                }
                UIButton *listenBtn = [self.bottomView viewWithTag:102];
                if (listenBtn.selected) {
                    [self listenBookStart];
                } else {
                    [self listenBookStop];
                }
                [self.tableView reloadData];
                [self.listTableView reloadData];
                self.lastIndex = index;
                if (self.isFirst) {
                    self.isFirst = NO;
                    BookModel *bookModel = [SFBookSave selectedBookNumber:self.bookModel.bookNumber];
                    if (bookModel.pageOffset == 0.0) {
                        [self.tableView setContentOffset:CGPointMake(0, 0.0) animated:NO];
                    } else {
                        [self.tableView setContentOffset:CGPointMake(0, bookModel.pageOffset) animated:NO];
                    }
                }
            });
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    } else {
        [SFNetWork getXmlDataWithURL:model.postUrl parameters:nil success:^(id  _Nonnull data) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (self.lastIndex>index) {
                [self.dataArray removeAllObjects];
            }
            NSError *xmlError;
            ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&xmlError];
            if (!xmlError) {
                ONOXMLElement *postsParentElement = [doc firstChildWithXPath:self.xpath];
                BookDetailModel *cellModel = [BookDetailModel new];
                cellModel.title = model.title;
                NSString *contentStr = [NSString stringWithFormat:@"%@",postsParentElement];
                NSAttributedString *htmlText = [[NSAttributedString alloc] initWithData:[contentStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                if (htmlText) {
                    cellModel.content = htmlText.string;
                    [self refreshNewDataWithModel:cellModel];
                    self.currentStr = [NSString stringWithFormat:@"%@，%@",model.title,cellModel.attrText.string];
                    [self.dataArray addObject:cellModel];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.chapterTitleLabel.text = model.title;
                    if (self.lastIndex>index) {
                        [self.tableView setContentOffset:CGPointMake(0, 0.0) animated:NO];
                    }
                    UIButton *listenBtn = [self.bottomView viewWithTag:102];
                    if (listenBtn.selected) {
                        [self listenBookStart];
                    } else {
                        [self listenBookStop];
                    }
                    [self.tableView reloadData];
                    [self.listTableView reloadData];
                    self.lastIndex = index;
                    if (self.isFirst) {
                        self.isFirst = NO;
                        BookModel *bookModel = [SFBookSave selectedBookNumber:self.bookModel.bookNumber];
                        if (bookModel.pageOffset == 0.0) {
                            [self.tableView setContentOffset:CGPointMake(0, 0.0) animated:NO];
                        } else {
                            [self.tableView setContentOffset:CGPointMake(0, bookModel.pageOffset) animated:NO];
                        }
                    }
                });
            }
        } fail:^(NSError * _Nonnull error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}
- (void)refreshNewDataWithModel:(BookDetailModel *)model{
    NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyFontName];
    UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:kFontSize weight:UIFontWeightRegular];
    }
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentJustified;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    paraStyle01.firstLineHeadIndent = kFontSize * 2;//首行缩进
    paraStyle01.lineBreakMode=NSLineBreakByWordWrapping;
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    CGFloat lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookLineHeight];
    paraStyle01.lineSpacing = lineHeight;//行间距
    CGFloat paragraphHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookParagraphHeight];
    paraStyle01.paragraphSpacing = paragraphHeight;//段间距
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle01,NSFontAttributeName:font};
    NSString *tmpStr = [SFTool sf_contentRemoveSpecialCharactersOfString:model.content];
    NSMutableArray *tmpArr = [self stringWithReplaceOccurrencesOfString:tmpStr];
    if (tmpArr.count>0) {
        NSString *firstStr = [tmpArr firstObject];
        if ([firstStr isEqualToString:[model.title stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
            [tmpArr removeObjectAtIndex:0];
        }
    }
    NSString *newStr = [tmpArr componentsJoinedByString:@"\n"];
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:newStr attributes:dic];
    model.attrText = attrText;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize size = [attrText boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-16-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        model.height = size.height+50;
    });
}
- (void)worldSet{
    NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:KeyFontName];
    UIFont *font = [UIFont fontWithName:fontName size:kFontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:kFontSize weight:UIFontWeightRegular];
    }
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentJustified;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    paraStyle01.firstLineHeadIndent = kFontSize * 2;//首行缩进
    paraStyle01.lineBreakMode=NSLineBreakByWordWrapping;
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    CGFloat lineHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookLineHeight];
    paraStyle01.lineSpacing = lineHeight;//行间距
    CGFloat paragraphHeight = [[NSUserDefaults standardUserDefaults] floatForKey:KeyBookParagraphHeight];
    paraStyle01.paragraphSpacing = paragraphHeight;//段间距
    
    for (BookDetailModel *model in self.dataArray) {
        NSString *tmpStr = [SFTool sf_contentRemoveSpecialCharactersOfString:model.attrText.string];
        NSMutableArray *tmpArr = [self stringWithReplaceOccurrencesOfString:tmpStr];
        if (tmpArr.count>0) {
            NSString *firstStr = [tmpArr firstObject];
            if ([firstStr isEqualToString:[model.title stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                [tmpArr removeObjectAtIndex:0];
            }
        }
        NSString *newStr = [tmpArr componentsJoinedByString:@"\n"];//NSLinkAttributeName
        NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle01,NSFontAttributeName:font};
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:newStr attributes:dic];
        model.attrText = attrText;
        // UITextView 的 内边距 padding  默认为5
        CGSize size = [attrText boundingRectWithSize:CGSizeMake(self.view.bounds.size.width-16-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        model.height = size.height+50;
    }
    [self refreshAllViews];
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
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top+20, self.view.bounds.size.width, self.view.bounds.size.height-[SFSafeAreaInsets shareInstance].safeAreaInsets.top-20) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 999;
        _tableView.estimatedRowHeight= 0;
        _tableView.estimatedSectionHeaderHeight= 0;
        _tableView.estimatedSectionFooterHeight= 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 999) {
        return self.dataArray.count;
    }
    else if (tableView.tag == 666) {
        return self.sourceArray.count;
    }
    else {
        return self.cellArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 999) {
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCellID" forIndexPath:indexPath];
        BookDetailModel *cellModel = self.dataArray[indexPath.section];
        cell.textView.attributedText = cellModel.attrText;
        cell.textView.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
        return cell;
    }
    else if (tableView.tag == 666) {
        static NSString *sourceCellID = @"sourceCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sourceCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sourceCellID];
        }
        BookModel *cellModel = self.sourceArray[indexPath.section];
        if ([cellModel.bookUrl isEqualToString:self.bookModel.bookUrl]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(当前源)",cellModel.bookTitle];
            cell.textLabel.textColor = [UIColor orangeColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",cellModel.bookAuthor];
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        } else {
            cell.textLabel.text = cellModel.bookTitle;
            cell.textLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",cellModel.bookAuthor];
            cell.detailTextLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor];
        }
        cell.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        return cell;
    }
    else {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        
        NSInteger index;
        BOOL menuReverse = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMenuReverse];
        if (menuReverse) {
            index = self.cellArray.count-1-indexPath.section;
        } else {
            index = indexPath.section;
        }
        BookDetailModel *cellModel = self.cellArray[index];
        if (self.index == index) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(当前)",cellModel.title];
            cell.textLabel.textColor = [UIColor orangeColor];
            cell.detailTextLabel.text = @"";
        } else {
            NSString *md5 = [SFTool MD5WithUrl:cellModel.postUrl];
            NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (isExist) {
                cell.textLabel.text = cellModel.title;
                cell.detailTextLabel.text = @"";
                cell.textLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",cellModel.title];
                cell.textLabel.textColor = self.isNignt?[[SFTool colorWithHexString:self.nightSetModel.textColor] colorWithAlphaComponent:0.5]:[[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor] colorWithAlphaComponent:0.5];
                cell.detailTextLabel.text = @"未缓存";
                cell.detailTextLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightLight];
                cell.detailTextLabel.textColor = self.isNignt?[[SFTool colorWithHexString:self.nightSetModel.textColor] colorWithAlphaComponent:0.5]:[[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor] colorWithAlphaComponent:0.5];
            }
            
        }
        cell.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 999) {
    }
    else if (tableView.tag == 666) {
        BookModel *cellModel = self.sourceArray[indexPath.section];
        [self getBookMenuWithBook:cellModel];
        [self hideMenu];
    }
    else {
        self.lastIndex = self.cellArray.count;
        self.index = indexPath.section;
        BOOL menuReverse = [[NSUserDefaults standardUserDefaults] boolForKey:KeyMenuReverse];
        if (menuReverse) {
            [self getWebDataWithIndex:self.cellArray.count-1-indexPath.section];
        } else {
            [self getWebDataWithIndex:indexPath.section];
        }
        [self hideMenu];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 999) {
        BookDetailModel *cellModel = self.dataArray[indexPath.section];
        return cellModel.height;
    }
    else if (tableView.tag == 666) {
        return 60;
    }
    else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if (tableView.tag == 999) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
        headerView.backgroundColor = [UIColor clearColor];
        [headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)]];
        BookDetailModel *cellModel = self.dataArray[section];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.numberOfLines = 2;
        headerLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
        headerLabel.text = cellModel.title;
        BOOL bookHiddleTitle = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookHiddleTitle];
        headerLabel.hidden = bookHiddleTitle;
        headerLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
        [headerView addSubview:headerLabel];
        return headerView;
    } else {
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 999) {
        return 80;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.scrollOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.tag == 999) {
        if (self.menuIsShowing) {
            [self hideMenu];
        }
    } else {
    }
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
        CGFloat offset = self.index*44.0;
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
        self.menuContentView.frame = CGRectMake(0, 0, fminf(self.view.bounds.size.width,self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    }];
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
        self.menuContentView.frame = CGRectMake(-self.view.bounds.size.width, 0, fminf(self.view.bounds.size.width,self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}
- (void)coverViewClick{
    if (self.chapterListIsShowing) {
        [self dismissMenuView];
    }
    if (self.settingViewIsShowing) {
        [self dismissSettingView];
    }
    if (self.menuIsShowing) {
        [self dismissSourceMenuList];
    }
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
    if (self.settingViewIsShowing || self.chapterListIsShowing || self.sourceIsShowing) {
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
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
            self.topNavView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
        } else {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-(50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom), self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
            self.topNavView.frame = CGRectMake(0, 0, self.view.bounds.size.width, (44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top));
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
    if (self.sourceIsShowing == YES) {
        [self dismissSourceMenuList];
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
        if (self.view.bounds.size.width > self.view.bounds.size.height) {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
            self.topNavView.frame = CGRectMake(0, -44, self.view.bounds.size.width, 44);
        } else {
            //动画显示与消失
            self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
            self.topNavView.frame = CGRectMake(0, -(44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top), self.view.bounds.size.width, (44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top));
        }
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setupBottomView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.settingBtnColor]:[SFTool colorWithHexString:self.daySetModel.settingBtnColor];
    baseView.userInteractionEnabled = YES;
    baseView.clipsToBounds = YES;
    baseView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50+[SFSafeAreaInsets shareInstance].safeAreaInsets.bottom);
    [self.view addSubview:baseView];
    
    NSArray *NorImgArr = @[@"ic_book_source_manage",@"ic_daytime",@"ic_read_aloud",@"ic_settings"];
    NSArray *SelImgArr = @[@"ic_book_source_manage",@"ic_brightness",@"ic_read_aloud_Sel",@"ic_settings"];
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
    
    UIView *rightContentView = [[UIView alloc] init];
    rightContentView.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width * 0.8, self.view.bounds.size.height);
    [self.view addSubview:rightContentView];
    self.sourceContentView = rightContentView;
    [rightContentView addSubview:self.sourceListTableView];
    
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
    navView.frame = CGRectMake(0, -(44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top), self.view.bounds.size.width, (44+[SFSafeAreaInsets shareInstance].safeAreaInsets.top));
    [self.view addSubview:navView];
    self.topNavView = navView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor clearColor];
    UIImage *leftimage = [UIImage imageNamed:@"icon_return"];
    [button setImage:leftimage forState:UIControlStateNormal];
    button.frame = CGRectMake(20,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
    button.tag = 222;
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:button];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(40,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, self.view.bounds.size.width-80, 44)];
    navTitle.tag = 456;
    navTitle.text = self.bookModel.bookTitle;
    navTitle.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    navTitle.textColor = [UIColor whiteColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:navTitle];
    UIButton *bookshelf = [UIButton buttonWithType:UIButtonTypeCustom];
    bookshelf.backgroundColor =[UIColor clearColor];
    bookshelf.tag = 333;
    bookshelf.frame = CGRectMake(self.view.bounds.size.width-50,[SFSafeAreaInsets shareInstance].safeAreaInsets.top, 30, 44);
    [navView addSubview:bookshelf];
    if ([SFBookSave isHaveBook:self.bookModel]) {
        UIImage *bookshelfIcon = [UIImage imageNamed:@"icon_change"];
        [bookshelf setImage:bookshelfIcon forState:UIControlStateNormal];
        [bookshelf addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UIImage *bookshelfIcon = [UIImage imageNamed:@"ic_arrange"];
        [bookshelf setImage:bookshelfIcon forState:UIControlStateNormal];
        [bookshelf addTarget:self action:@selector(addBook) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)changeSource{
    //换源功能
    [self showSourceMenuList];
    [self searchBtnClick];
}
- (void)showSourceMenuList{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.coverView.alpha = 0;
    self.sourceIsShowing = YES;
    [self.view bringSubviewToFront:self.sourceContentView];
    [self.sourceListTableView reloadData];
    [self.sourceListTableView layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 1;
        self.sourceContentView.frame = CGRectMake(self.view.bounds.size.width-(fminf(self.view.bounds.size.width,self.view.bounds.size.height) * 0.8), 0, fminf(self.view.bounds.size.width,self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    }];
}
- (void)dismissSourceMenuList{
    [self dismissSourceMenuListFinished:nil];
    self.sourceIsShowing = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideMenu) withObject:nil afterDelay:3];
}
- (void)dismissSourceMenuListFinished:(void(^)(void))finishedBlock{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0;
        self.sourceContentView.frame = CGRectMake(self.view.bounds.size.width, 0, fminf(self.view.bounds.size.width,self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}
- (void)backAction{
    BOOL exitAlert = [[NSUserDefaults standardUserDefaults] boolForKey:KeyExitAlert];
    if (exitAlert) {
        if ([SFBookSave isHaveBook:self.bookModel]) {
            NSLog(@"已经加入书架了");
            [self backActionClick];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"加入书架" message:[NSString stringWithFormat:@"将 %@ 加入书架",self.bookModel.bookTitle] preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"不了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消");
                [self performSelector:@selector(backActionClick) withObject:nil afterDelay:0.3];
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"加入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了加入");
                [self addBook];
                [self performSelector:@selector(backActionClick) withObject:nil afterDelay:1.1];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else {
        [self backActionClick];
    }
}
- (void)backActionClick{
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
    self.index += 1;
    [self getWebDataWithIndex:self.index];
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
- (UITableView *)sourceListTableView{
    if (!_sourceListTableView) {
        _sourceListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, CGRectGetWidth(self.sourceContentView.frame), CGRectGetHeight(self.sourceContentView.frame)-[SFSafeAreaInsets shareInstance].safeAreaInsets.top) style:UITableViewStylePlain];
        _sourceListTableView.delegate = self;
        _sourceListTableView.dataSource = self;
        _sourceListTableView.tag = 666;
        _sourceListTableView.estimatedRowHeight= 0;
        _sourceListTableView.estimatedSectionHeaderHeight= 0;
        _sourceListTableView.estimatedSectionFooterHeight= 0;
        _sourceListTableView.tableFooterView = [UIView new];
        _sourceListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _sourceListTableView;
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
                sender.selected = !sender.selected;
                if (sender.selected) {
                    [self listenBookStart];
                } else {
                    [self listenBookStop];
                }
                [self hideMenu];
            }
            break;
        case 103:
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
        if (@available(iOS 11.0, *)) {
            [self setNeedsUpdateOfHomeIndicatorAutoHidden];
        } else {
            // Fallback on earlier versions
        }
        [self.tableView reloadData];
        [self.listTableView reloadData];
        [self.sourceListTableView reloadData];
        self.view.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.color]:[SFTool colorWithHexString:self.daySetModel.color];
        self.settingView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        self.backImageView.image = self.isNignt?nil:[UIImage imageNamed:self.daySetModel.bgImage];
        
        self.bottomView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        self.topNavView.backgroundColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.controlViewBgColor]:[SFTool colorWithHexString:self.daySetModel.controlViewBgColor];
        UILabel *titleLabel = [self.topNavView viewWithTag:456];
        titleLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.isCustom?@"333333":self.daySetModel.textColor];
        self.chapterTitleLabel.textColor = self.isNignt?[SFTool colorWithHexString:self.nightSetModel.textColor]:[SFTool colorWithHexString:self.daySetModel.textColor];
        for (int i=0; i<4; i++) {
            UIButton *button = [self.bottomView viewWithTag:100+i];
            [button setTitleColor:self.isNignt?[SFTool colorWithHexString:self.nightSetModel.settingTextColor]:[SFTool colorWithHexString:self.daySetModel.settingTextColor] forState:UIControlStateNormal];
        }
    });
}
- (void)receivedTextviewNotification:(NSNotification *)notification{
    NSDictionary *infoDict = notification.userInfo;
    NSString *clickX = [NSString stringWithFormat:@"%@",infoDict[@"clickX"]];
    CGFloat noClickW = self.view.bounds.size.width/3.0;
    if (clickX.floatValue>noClickW && clickX.floatValue<noClickW*2) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}
- (void)handleSwipeFrom:(NSNotification *)notification{
    NSDictionary *infoDict = notification.userInfo;
    NSString *direction = [NSString stringWithFormat:@"%@",infoDict[@"direction"]];
    if ([direction isEqualToString:@"right"]) {
        // 左边
        BOOL swipeBack = [[NSUserDefaults standardUserDefaults] boolForKey:KeySwipeBack];
        if (swipeBack) {
            [self backAction];
        }
    }
    else if ([direction isEqualToString:@"left"]) {
        //右边
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
}
//行高
- (void)settingViewDidChangeLineHeight:(float)height{
    self.settingView.lineHeight = height;
    [[NSUserDefaults standardUserDefaults] setFloat:height forKey:KeyBookLineHeight];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self worldSet];
}
//段高
- (void)settingViewDidChangeParagraphHeight:(float)height{
    self.settingView.paragraphHeight = height;
    [[NSUserDefaults standardUserDefaults] setFloat:height forKey:KeyBookParagraphHeight];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self worldSet];
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
#pragma mark - source search
- (void)searchBtnClick{
    if (self.sourceArray.count>0) {
        [self.sourceListTableView reloadData];
        return;
    }
    //在读取的时候首先去文件中读取为NSData类对象，然后通过NSJSONSerialization类将其转化为foundation对象
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookSourcesPath];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
    for (NSDictionary *dict in list) {
        SFRequestModel *model = [SFRequestModel SF_MJParse:dict];
        [self getRequestData:model];
    }
}
- (void)getRequestData:(SFRequestModel *)model{
//    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *searchUrl = [model.search stringByReplacingOccurrencesOfString:@"SFSearchKey" withString:self.bookModel.bookTitle];
    NSString *md5 = [SFTool MD5WithUrl:searchUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    if ([model.requestType isEqualToString:@"html"]) {
        [SFNetWork getXmlDataWithURL:searchUrl parameters:nil success:^(id data) {
            [SVProgressHUD dismiss];
            //下载网页数据
            ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
            ONOXMLElement *postsParentElement= [doc firstChildWithXPath:model.list]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
            //遍历其子节点,
            [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                ONOXMLElement *aItem = [element firstChildWithXPath:model.aclick];
                if (aItem) {
                    BookModel *newp = [BookModel new];
                    NSString *clickUrl = [aItem valueForAttribute:@"href"];
                    if (![clickUrl hasPrefix:@"http"]) {
                        newp.bookUrl= [NSString stringWithFormat:@"%@%@",model.wwwReq,[aItem valueForAttribute:@"href"]];
                    } else {
                        newp.bookUrl = clickUrl;
                    }
                    ONOXMLElement *image = [element firstChildWithXPath:model.icon];
                    NSString *imgUrl = [image valueForAttribute:@"src"];
                    if (![imgUrl hasPrefix:@"http"]) {
                        if ([imgUrl hasPrefix:@"/"]) {
                            newp.bookIcon = [NSString stringWithFormat:@"%@%@",model.wwwReq,imgUrl];
                        } else {
                            newp.bookIcon = @"";
                        }
                    } else {
                        newp.bookIcon = imgUrl;
                    }
                    ONOXMLElement *spanItem = [element firstChildWithXPath:model.auther];
                    NSString *bookAuthor = [SFTool sf_stringRemoveSpecialCharactersOfString:[spanItem stringValue]];
                    if ([bookAuthor hasPrefix:@"作者"]) {
                        newp.bookAuthor= [NSString stringWithFormat:@"%@",bookAuthor];
                    } else {
                        newp.bookAuthor= [NSString stringWithFormat:@"作者：%@",bookAuthor];
                    }
                    ONOXMLElement *titleItem = [element firstChildWithXPath:model.title];
                    NSString *bookTitle = [titleItem stringValue];
                    newp.bookTitle= [SFTool sf_stringRemoveSpecialCharactersOfString:bookTitle];
                    ONOXMLElement *descItem1 = [element firstChildWithXPath:model.synopsis];
                    ONOXMLElement *descItem2 = [element firstChildWithXPath:model.synopsisDetail];
                    NSString *descItem1Str = [descItem1 stringValue];
                    if (descItem2 && descItem1) {
                        descItem1Str = [SFTool sf_stringRemoveSpecialCharactersOfString:descItem1Str];
                        if ([descItem1Str hasPrefix:@"简介"]) {
                            newp.bookSynopsis = [NSString stringWithFormat:@"%@%@",descItem1Str,[SFTool sf_stringRemoveSpecialCharactersOfString:[descItem2 stringValue]]];
                        } else {
                            newp.bookSynopsis = [NSString stringWithFormat:@"简介：%@%@",descItem1Str,[SFTool sf_stringRemoveSpecialCharactersOfString:[descItem2 stringValue]]];
                        }
                    } else if (descItem1) {
                        descItem1Str = [SFTool sf_stringRemoveSpecialCharactersOfString:descItem1Str];
                        if ([descItem1Str hasPrefix:@"简介"]) {
                            newp.bookSynopsis= [NSString stringWithFormat:@"%@",[SFTool sf_stringRemoveSpecialCharactersOfString:descItem1Str]];
                        } else {
                            newp.bookSynopsis= [NSString stringWithFormat:@"简介：%@",[SFTool sf_stringRemoveSpecialCharactersOfString:descItem1Str]];
                        }
                    } else {
                        newp.bookSynopsis= [NSString stringWithFormat:@"简介：此书源暂无简介"];
                    }
                    newp.bookIndex = 0;
                    NSString *bookNumber = [SFTool getNumberFromDataStr:[aItem valueForAttribute:@"href"]];
                    newp.bookNumber = bookNumber;
                    newp.bookCatalog = model.catalog;
                    newp.bookContent = model.content;
                    newp.other1 = model.wwwReq;
                    newp.other2 = @"小说";
                    if ([self.bookModel.bookTitle isEqualToString:newp.bookTitle]) {
                        [self.sourceArray addObject:newp];
                    }
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.sourceArray.count>0) {
                    [self.sourceListTableView reloadData];
                }
            });
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD dismiss];
        }];
    } else {
        [SFNetWork getJsonDataWithURL:searchUrl parameters:nil success:^(id json) {
            self.jsonModel = [SFJsonBookModel SF_MJParse:json];
            if (self.jsonModel.ret == 0) {
                if (self.jsonModel.direct) {
                    BookModel *newp = [BookModel new];
                    NSString *bookUrl = [model.catalog stringByReplacingOccurrencesOfString:@"SFbookId" withString:self.jsonModel.direct.resourceid];
                    newp.bookUrl= bookUrl;
                    newp.bookIcon = self.jsonModel.direct.picurl;
                    NSString *bookAuthor = [SFTool sf_stringRemoveSpecialCharactersOfString:self.jsonModel.direct.author];
                    if ([bookAuthor hasPrefix:@"作者"]) {
                        newp.bookAuthor= [NSString stringWithFormat:@"%@",bookAuthor];
                    } else {
                        newp.bookAuthor= [NSString stringWithFormat:@"作者：%@",bookAuthor];
                    }
                    newp.bookTitle= self.jsonModel.direct.resourcename;
                    NSString *bookSynopsis = [SFTool sf_stringRemoveSpecialCharactersOfString:self.jsonModel.direct.summary];
                    if ([bookSynopsis hasPrefix:@"简介"]) {
                        newp.bookSynopsis= [NSString stringWithFormat:@"%@",bookSynopsis];
                    } else {
                        newp.bookSynopsis= [NSString stringWithFormat:@"简介：%@",bookSynopsis];
                    }
                    newp.bookIndex = 0;
                    newp.bookNumber = self.jsonModel.direct.resourceid;
                    newp.bookCatalog = model.requestType;
                    newp.bookContent = model.content;
                    newp.other1 = model.wwwReq;
                    newp.other2 = @"小说";
                    if ([self.bookModel.bookTitle isEqualToString:newp.bookTitle]) {
                        [self.sourceArray addObject:newp];
                    }
                }
                for (SFJsonBookModelRows *rowModel in self.jsonModel.rows) {
                    BookModel *newp = [BookModel new];
                    NSString *bookUrl = [model.catalog stringByReplacingOccurrencesOfString:@"SFbookId" withString:rowModel.resourceid];
                    newp.bookUrl= bookUrl;
                    newp.bookIcon = rowModel.picurl;
                    NSString *bookAuthor = [SFTool sf_stringRemoveSpecialCharactersOfString:rowModel.author];
                    if ([bookAuthor hasPrefix:@"作者"]) {
                        newp.bookAuthor= [NSString stringWithFormat:@"%@",bookAuthor];
                    } else {
                        newp.bookAuthor= [NSString stringWithFormat:@"作者：%@",bookAuthor];
                    }
                    newp.bookTitle= rowModel.resourcename;
                    NSString *bookSynopsis = [SFTool sf_stringRemoveSpecialCharactersOfString:rowModel.summary];
                    if ([bookSynopsis hasPrefix:@"简介"]) {
                        newp.bookSynopsis= [NSString stringWithFormat:@"%@",bookSynopsis];
                    } else {
                        newp.bookSynopsis= [NSString stringWithFormat:@"简介：%@",bookSynopsis];
                    }
                    newp.bookIndex = 0;
                    newp.bookNumber = rowModel.resourceid;
                    newp.bookCatalog = model.requestType;
                    newp.bookContent = model.content;
                    newp.other1 = model.wwwReq;
                    newp.other2 = @"小说";
                    if ([self.bookModel.bookTitle isEqualToString:newp.bookTitle]) {
                        [self.sourceArray addObject:newp];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (self.sourceArray.count>0) {
                    [self.sourceListTableView reloadData];
                    [self.sourceListTableView setContentOffset:CGPointMake(0, 0.0) animated:NO];
                }
            });
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD dismiss];
        }];
    }
}
- (void)getBookMenuWithBook:(BookModel *)book{
    [SVProgressHUD showWithStatus:@"加载中..."];
    if ([book.bookCatalog isEqualToString:@"json"]) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
            NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
                if (isExist) {
                    NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
                    [self handleJsonData:dict WithBook:book];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络配置"];
                }
            } else {
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
                if (isExist) {
                    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
                }
                [data writeToFile:cachePath atomically:YES];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                [self handleJsonData:dict WithBook:book];
            }
        }];
        [task resume];
    } else {
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
            NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
                if (isExist) {
                    NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
                    [self handleData:cacheData WithBook:book];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"此书暂无更新"];
                }
            } else {
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
                if (isExist) {
                    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
                }
                [data writeToFile:cachePath atomically:YES];
                [self handleData:data WithBook:book];
            }
        }];
        [task resume];
    }
}
- (void)handleJsonData:(NSDictionary *)json WithBook:(BookModel *)book{
    SFJsonCatelogModel *catelogModel = [SFJsonCatelogModel SF_MJParse:json];
    if (catelogModel.ret == 0) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (SFJsonCatelogModelRows *model in catelogModel.rows) {
            BookDetailModel *newp = [BookDetailModel new];
            NSString *postUrl = [book.bookContent stringByReplacingOccurrencesOfString:@"SFresourceid" withString:book.bookNumber];
            postUrl = [postUrl stringByReplacingOccurrencesOfString:@"SFserialid" withString:model.serialID];
            newp.postUrl = postUrl;
            newp.title= model.serialName;
            [tmpArray addObject:newp];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tmpArray.count<=0) {
                [SVProgressHUD showErrorWithStatus:@"该书源暂无更新"];
                return;;
            }
            [SVProgressHUD dismiss];
            NSInteger tmpID = self.bookModel.ID;
            NSDictionary *dict = [book mj_keyValues];
            self.bookModel = [BookModel SF_MJParse:dict];
            self.bookModel.ID = tmpID;
            [self onApplicationWillResignActive];
            self.isFirst = YES;
            self.cellArray = tmpArray;
            self.xpath = book.bookCatalog;
            [self getWebDataWithIndex:self.index];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"该书籍书源已失效，请更换书源"];
        });
    }
}
- (void)handleData:(id)data WithBook:(BookModel *)book{
    NSMutableArray *tmpArray = [NSMutableArray array];
    //下载网页数据
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
    ONOXMLElement *postsParentElement= [doc firstChildWithXPath:book.bookCatalog]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
    //遍历其子节点,
    [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[element tag] isEqualToString:@"dd"]) {
            BookDetailModel *newp = [BookDetailModel new];
            ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
            newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
            newp.title= [titleElement stringValue];
            [tmpArray addObject:newp];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        NSInteger tmpID = self.bookModel.ID;
        NSDictionary *dict = [book mj_keyValues];
        self.bookModel = [BookModel SF_MJParse:dict];
        self.bookModel.ID = tmpID;
        [self onApplicationWillResignActive];
        self.isFirst = YES;
        self.cellArray = tmpArray;
        self.xpath = book.bookContent?book.bookContent:@"//*[@id=\"content\"]";
        [self getWebDataWithIndex:self.index];
    });
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
                    self.index += 1;
                    [self getWebDataWithIndex:self.index];
                }
                
                break;
            case UIEventSubtypeRemoteControlPreviousTrack://上一曲
                {
                    [[SFSoundPlayer SharedSoundPlayer] stopSpeaking];
                    //朗读结束
                    self.index -= 1;
                    [self getWebDataWithIndex:self.index];
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
    NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.bookModel.bookIcon]];
    UIImage *image = [UIImage imageWithData:datas];
    NSString *novelName = self.bookModel.bookTitle;
    NSString *authorName = self.bookModel.bookAuthor;
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithBoundsSize:image.size requestHandler:^UIImage * _Nonnull(CGSize size) {
        return image;
    }];
    NSDictionary *dic = @{MPMediaItemPropertyTitle:novelName,
                          MPMediaItemPropertyArtist:authorName,
                          MPMediaItemPropertyArtwork:artWork
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}
- (void)listenBookStart{
    [SVProgressHUD showSuccessWithStatus:@"听书开启时，默认从当前章节处开始听书" duration:2];
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
        [speechAv play:self.currentStr];
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@===%s",self.class,__func__);
}

@end

