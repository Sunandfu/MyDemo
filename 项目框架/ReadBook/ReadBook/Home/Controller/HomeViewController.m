//
//  HomeViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/20.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "HomeViewController.h"
#import "SFSetViewController.h"
#import "SFReadViewController.h"
#import "SFMoreDetailViewController.h"
#import "SFJsonCatelogModel.h"
#import "DCHomeVC.h"
#import "SFTaskWebViewController.h"
#import "YBPopupMenu.h"
#import "SFNavTitleView.h"
#import "SFMovieCollectionViewCell.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SFNavTitleView *titleView;

@end

@implementation HomeViewController

- (void)showKeyUserAgent{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请仔细查看用户隐私协议说明，确保您已知晓并同意相关协议！" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"同意并查看协议" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SFTaskWebViewController *taskVC = [[SFTaskWebViewController alloc] init];
        taskVC.URLString = @"https://shimo.im/docs/QT9QkDQthcTHPtG8/read";
        taskVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:taskVC animated:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    SFNavTitleView *titleView = [[SFNavTitleView alloc] initWithFrame:CGRectMake(100,0, self.view.bounds.size.width-200,44)];
    titleView.intrinsicContentSize = CGSizeMake(self.view.bounds.size.width,44);
    self.navigationItem.titleView = titleView;
    [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewClick)]];
    self.titleView = titleView;
    
//    if ([[SFTool getUserAgent] isEqualToString:@""]) {
//        [self showKeyUserAgent];
//    }
    // Do any additional setup after loading the view.
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top+44, self.view.bounds.size.width, 40)];
    headerView.tag = 138;
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.view.bounds.size.width/2.0, CGRectGetHeight(headerView.frame)-10)];
    leftLabel.tag = 6140;
    leftLabel.text = @"排序方式：最后阅读时间";
    leftLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    leftLabel.textColor = [SFTool colorWithHexString:@"333333"];
    leftLabel.userInteractionEnabled = YES;
    [leftLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftLabelClick)]];
    [headerView addSubview:leftLabel];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage imageNamed:@"liebiao"],[UIImage imageNamed:@"gongge"]]];
    segmentedControl.tag = 4016;
    segmentedControl.frame = CGRectMake(self.view.bounds.size.width-80-15, 5, 80, CGRectGetHeight(headerView.frame)-10);
    [segmentedControl addTarget:self action:@selector(sementedControlClick:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:segmentedControl];
    [self.view addSubview:headerView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarController.tabBar.bounds.size.height-CGRectGetMaxY(headerView.frame)) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BookTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookTableViewCellID"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.view addSubview:self.tableView];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.view.bounds.size.width-40)/3.0, 230);
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(headerView.frame)-self.tabBarController.tabBar.bounds.size.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SFMovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SFMovieCollectionViewCellID"];
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直
        self.collectionView.showsVerticalScrollIndicator = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    } else {
        self.collectionView.showsHorizontalScrollIndicator = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
    }
    [self.view addSubview:self.collectionView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_settings"] style:UIBarButtonItemStyleDone target:self action:@selector(goBookSetting)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"localBook"] style:UIBarButtonItemStyleDone target:self action:@selector(goLocalBook)];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"本地书籍" style:UIBarButtonItemStyleDone target:self action:@selector(goLocalBook)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
#ifdef DEBUG
    // 仅用于测试，观察启动图
//    sleep(1.5);
#endif
}
- (void)sementedControlClick:(UISegmentedControl *)segment{
    NSLog(@"%ld",(long)segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0) {
        //列表模式
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        [self.tableView reloadData];
    } else {
        //九宫格模式
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }
    [[NSUserDefaults standardUserDefaults] setBool:segment.selectedSegmentIndex forKey:KeyBookJiugongStyle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)leftLabelClick{
    UILabel *tmpLabel = [self.view viewWithTag:6140];
    CGFloat tmpW = [SFTool getWidthWithText:tmpLabel.text height:40 font:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]];
    [YBPopupMenu showAtPoint:CGPointMake(15+tmpW/2.0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top+44+30) titles:@[@"排序方式：书籍添加日期",@"排序方式：最后阅读时间"] icons:nil menuWidth:tmpW+40 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.tag = 2;
        popupMenu.delegate = self;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.cornerRadius = 8;
        popupMenu.itemHeight = 40;
        popupMenu.fontSize = 12;
//        popupMenu.rectCorner = UIRectCornerTopLeft| UIRectCornerTopRight;
        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
//        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }];
}
- (void)titleViewClick{
    NSArray *modelArr = [SFBookSave selectBookGroups];
    if (modelArr.count==0) {
        SFBookGroupModel *group = [SFBookGroupModel new];
        group.name = @"书架(默认全部书籍,无法删除)";
        group.createTime = [SFTool getTimeLocal];
        group.other1 = @"";
        group.other2 = @"";
        group.other3 = 0.0;
        [SFBookSave insertBookGroup:group];
        modelArr = [SFBookSave selectBookGroups];
    }
    NSMutableArray *titleArr = [NSMutableArray array];
    CGFloat tmpW = [SFTool getWidthWithText:@"书架" height:50 font:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
    CGFloat btnW = tmpW;
    for (SFBookGroupModel *model in modelArr) {
        if (model.ID==1) {
            [titleArr addObject:@"书架"];
        } else {
            [titleArr addObject:model.name];
            tmpW = [SFTool getWidthWithText:model.name height:50 font:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
            if (tmpW>btnW) {
                btnW = tmpW;
            }
        }
    }
    [YBPopupMenu showAtPoint:CGPointMake(self.view.bounds.size.width/2.0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top+44) titles:titleArr icons:nil menuWidth:btnW+40 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.dismissOnSelected = YES;
        popupMenu.isShowShadow = YES;
        popupMenu.tag = 1;
        popupMenu.delegate = self;
        popupMenu.type = YBPopupMenuTypeDefault;
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.cornerRadius = 8;
        popupMenu.itemHeight = 50;
        popupMenu.fontSize = 18;
//        popupMenu.rectCorner = UIRectCornerTopLeft| UIRectCornerTopRight;
        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
//        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (ybPopupMenu.tag == 1) {
        NSArray *modelArr = [SFBookSave selectBookGroups];
        SFBookGroupModel *model = modelArr[index];
        [[NSUserDefaults standardUserDefaults] setInteger:model.ID forKey:KeySelectGroup];
    } else if (ybPopupMenu.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:index forKey:KeyBookReadTimeSolt];
        UILabel *leftLabel = [self.view viewWithTag:6140];
        if (index) {
            leftLabel.text = @"排序方式：最后阅读时间";
        } else {
            leftLabel.text = @"排序方式：书籍添加日期";
        }
    }
    [self updateTableDataArray];
}
- (void)goLocalBook{
    DCHomeVC *setVC = [DCHomeVC new];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
//屏幕旋转之后，屏幕的宽高互换，我们借此判断重新布局
//横屏：size.width > size.height
//竖屏: size.width < size.height
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UIView *headerView = [self.view viewWithTag:138];
    UISegmentedControl *segmentedControl = [self.view viewWithTag:4016];
    if (size.width>size.height) {
        headerView.frame = CGRectMake(0, 32, size.width, 40);
        segmentedControl.frame = CGRectMake(size.width-80-15, 5, 80, 40-10);
        self.tableView.frame = CGRectMake(0, 32+40, size.width, size.height-40-32-self.tabBarController.tabBar.bounds.size.height);
        self.collectionView.frame = CGRectMake(0, 32+40, size.width, size.height-40-32-self.tabBarController.tabBar.bounds.size.height);
    } else {
        headerView.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), size.width, 40);
        segmentedControl.frame = CGRectMake(size.width-80-15, 5, 80, 40-10);
        self.tableView.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+40, size.width, size.height-40-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)-self.tabBarController.tabBar.bounds.size.height);
        self.collectionView.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+40, size.width, size.height-40-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)-self.tabBarController.tabBar.bounds.size.height);
    }
}
- (void)goBookSetting{
    SFSetViewController *setVC = [SFSetViewController new];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self updateTableDataArray];
}
- (void)updateTableDataArray{
    self.dataArray = [SFBookSave selectBook];
    
    NSInteger selectGroup = [[NSUserDefaults standardUserDefaults] integerForKey:KeySelectGroup];
    if (selectGroup==1) {
        self.titleView.title = @"书架";
    } else {
        SFBookGroupModel *model = [SFBookSave selectedBookGroupID:selectGroup];
        self.titleView.title = model.name;
        self.dataArray = [SFBookSave selectedBookWithGroupID:model.ID];
    }
    
    UILabel *leftLabel = [self.view viewWithTag:6140];
    BOOL bookReadTimeSolt = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookReadTimeSolt];
    if (bookReadTimeSolt) {
        NSArray *sortedArray = [self.dataArray sortedArrayUsingComparator:^NSComparisonResult(BookModel *book1, BookModel *book2) {
            //降序，key表示比较的关键字
            if (book1.bookDate.integerValue < book2.bookDate.integerValue) return NSOrderedDescending;
            else return NSOrderedAscending;
        }];
        self.dataArray = sortedArray;
        leftLabel.text = @"排序方式：最后阅读时间";
    } else {
        leftLabel.text = @"排序方式：书籍添加日期";
    }
    
    UISegmentedControl *segmentedControl = [self.view viewWithTag:4016];
    BOOL bookJiugongStyle = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookJiugongStyle];
    if (bookJiugongStyle) {
        //九宫格模式
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        segmentedControl.selectedSegmentIndex = 1;
    } else {
        //列表模式
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
        segmentedControl.selectedSegmentIndex = 0;
    }
    
    BOOL bookUpdateReminder = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookUpdateReminder];
    if (bookUpdateReminder) {
        for (BookModel *book in self.dataArray) {
            if ([book.other2 isEqualToString:@"漫画"]) {
                [self getCartoonUpdateCountWithBook:book];
            } else {
                [self getBookUpdateCountWithBook:book];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.collectionView reloadData];
        });
    } else {
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
}

- (UIView *)createNoBookView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    footerView.tag = 98765;
    UILabel *label1 = [[UILabel alloc] initWithFrame:footerView.bounds];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"当前书架为空哦\n\n快去搜索添加你喜爱的书籍吧";
    label1.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    label1.numberOfLines = 0;
    [footerView addSubview:label1];
    return footerView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count>0) {
        tableView.tableFooterView = [UIView new];
    } else {
        tableView.tableFooterView = [self createNoBookView];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableViewCellID" forIndexPath:indexPath];
    BookModel *model = self.dataArray[indexPath.row];
    [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
    cell.contentLabel.text = model.bookSynopsis;
    cell.titleLabel.text = model.bookTitle;
    cell.nameLabel.text = model.bookAuthor;
    cell.bookType.text = model.other2.length==2?model.other2:@"小说";
    
    BOOL bookUpdateReminder = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookUpdateReminder];
    NSInteger update = model.bookNewCount-model.bookIndex;
    if (bookUpdateReminder && update>0) {
        cell.redView.hidden = NO;
        if (update>99) {
            cell.redView.bubbleText = @"99+";
        } else {
            cell.redView.bubbleText = [NSString stringWithFormat:@"%ld",(long)update];
        }
    } else {
        cell.redView.hidden = YES;
    }
    /**
     AceCuteView *view = [[AceCuteView alloc] initWithFrame:CGRectMake(50, 50, 40, 25)];
     //黏性距离，不设置默认50，允许设置范围30~90
     view.viscosity = 90;
     //需要显示的文字
     view.bubbleText = @"55";
     //小圆点背景色，默认是红色
     view.bgColor = [UIColor redColor];
     [self.view addSubview:view];
     */
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookModel *model = self.dataArray[indexPath.row];
    if ([model.other2 isEqualToString:@"漫画"]) {
        [self getCartoonMenuWithBook:model];
    } else {
        BOOL cacheBook = [[NSUserDefaults standardUserDefaults] boolForKey:KeyCacheBooks];
        if (cacheBook) {
            NSString *md5 = [SFTool MD5WithUrl:model.bookUrl];
            NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (isExist) {
                NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
                if ([model.bookCatalog isEqualToString:@"json"]) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
                    [self handleJsonData:dict WithBook:model];
                } else {
                    [self handleData:cacheData WithBook:model];
                }
            } else {
                [self getBookMenuWithBook:model];
            }
        } else {
            [self getBookMenuWithBook:model];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *model = self.dataArray[indexPath.row];
    UITableViewRowAction *addGroup = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移至分组" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        BookModel *model = self.dataArray[indexPath.row];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择分组" preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *groupArray = [SFBookSave selectBookGroups];
        for (SFBookGroupModel *groupModel in groupArray) {
            if (groupModel.ID != 0) {
                [alertVC addAction:[UIAlertAction actionWithTitle:groupModel.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了%@分组",action.title);
                    model.bookDelegate = groupModel.ID;
                    BOOL isUpdate = [SFBookSave updateBook:model];
                    if (isUpdate) {
                        NSLog(@"更新成功");
                        [self updateTableDataArray];
                    }
                }]];
            }
        }
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了%@",action.title);
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    addGroup.backgroundColor = [UIColor greenColor];
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移出书架" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        BookModel *model = self.dataArray[indexPath.row];
        BOOL isDelegate = [SFBookSave deleteBook:model];
        if (isDelegate) {
            NSLog(@"删除成功");
            self.dataArray = [SFBookSave selectBook];
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
    }];
    if ([model.other2 isEqualToString:@"漫画"]) {
        BOOL cacheBook = [[NSUserDefaults standardUserDefaults] boolForKey:KeyCacheBooks];
        if (cacheBook) {
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"缓存漫画" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                BookModel *model = self.dataArray[indexPath.row];
                [self cacheCartoonWithBook:model];
            }];
            action1.backgroundColor = [UIColor orangeColor];
            return @[addGroup,action,action1];
        }
        return @[addGroup,action];
    } else {
        BOOL cacheBook = [[NSUserDefaults standardUserDefaults] boolForKey:KeyCacheBooks];
        if (cacheBook) {
            BookModel *model = self.dataArray[indexPath.row];
            NSString *md5 = [SFTool MD5WithUrl:model.bookUrl];
            NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更新缓存" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                if (isExist) {
                    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
                }else{
                }
                BookModel *model = self.dataArray[indexPath.row];
                [self cacheBookWithBook:model];
            }];
            action1.backgroundColor = [UIColor orangeColor];
            return @[addGroup,action,action1];
        }
        return @[addGroup,action];
    }
}

- (void)cacheCartoonWithBook:(BookModel *)book{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SFNetWork getXmlDataWithURL:book.bookUrl parameters:nil success:^(id data) {
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        NSMutableArray *tmpArray = [NSMutableArray array];
        ONOXMLElement *menuList = [doc firstChildWithXPath:book.bookCatalog];
        //遍历其子节点,
        [menuList.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
            if (titleElement) {
                BookDetailModel *newp = [BookDetailModel new];
                newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
                newp.title= [titleElement stringValue];
                [tmpArray addObject:newp];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SFNetWork cacheCartoonWithModelArray:tmpArray XPatn:@"homeCartoon"];
        });
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}
- (void)cacheBookWithBook:(BookModel *)book{
    [SVProgressHUD showWithStatus:@"下载中..."];
    
    if ([book.bookCatalog isEqualToString:@"json"]) {
        [SFNetWork cacheJsonBooksWithBook:book success:^(id data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            SFJsonCatelogModel *catelogModel = [SFJsonCatelogModel SF_MJParse:dict];
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
                    [SFNetWork cacheJsonBooksWithModelArray:tmpArray XPatn:book.bookContent?book.bookContent:@"//*[@id=\"content\"]"];
                });
            }
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
    } else {
        [SFNetWork cacheBooksWithBook:book success:^(id data) {
            NSMutableArray *tmpArray = [NSMutableArray array];
            //下载网页数据
            ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
            ONOXMLElement *postsParentElement= [doc firstChildWithXPath:book.bookCatalog]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
            //遍历其子节点,
            [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
                if (titleElement) {
                    BookDetailModel *newp = [BookDetailModel new];
                    newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
                    newp.title= [titleElement stringValue];
                    [tmpArray addObject:newp];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SFNetWork cacheBooksWithModelArray:tmpArray XPatn:book.bookContent?book.bookContent:@"//*[@id=\"content\"]"];
            });
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }];
    }
}
- (void)getCartoonMenuWithBook:(BookModel *)book{
    [SVProgressHUD showWithStatus:@"加载中..."];
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
                [self pushCartoonDetailzWithBook:book Data:cacheData];
            }
        } else {
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (isExist) {
                [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
            }
            [data writeToFile:cachePath atomically:YES];
            [self pushCartoonDetailzWithBook:book Data:data];
        }
    }];
    [task resume];
}
- (void)pushCartoonDetailzWithBook:(BookModel *)book Data:(NSData *)data{
    //下载网页数据
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
    NSMutableArray *tmpArray = [NSMutableArray array];
    ONOXMLElement *menuList = [doc firstChildWithXPath:book.bookCatalog];
    //遍历其子节点,
    [menuList.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[element tag] isEqualToString:@"li"]) {
            ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
            if (titleElement) {
                BookDetailModel *newp = [BookDetailModel new];
                newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
                newp.title= [titleElement stringValue];
                [tmpArray addObject:newp];
            }
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (tmpArray.count<=0) {
            [SVProgressHUD showErrorWithStatus:@"该书源暂无更新"];
            return;;
        }
        [SVProgressHUD dismiss];
        SFMoreDetailViewController *detailVc = [[SFMoreDetailViewController alloc] init];
        detailVc.cellArray = tmpArray;
        detailVc.bookModel = book;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    });
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
                    [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络配置"];
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
            NSString *chooseStr = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPageStyle];
            switch (chooseStr.integerValue) {
                case 1:
                    {
                        DetailViewController *detailVc = [[DetailViewController alloc] init];
                        detailVc.cellArray = tmpArray;
                        detailVc.bookModel = book;
                        detailVc.xpath = book.bookCatalog;
                        detailVc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:detailVc animated:YES];}
                    break;
                    
                default:
                {
                    SFReadViewController *detailVc = [[SFReadViewController alloc] init];
                    detailVc.cellArray = tmpArray;
                    detailVc.bookModel = book;
                    detailVc.xpath = book.bookCatalog;
                    detailVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailVc animated:YES];}
                    break;
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus:@"该书籍书源已失效，请去书籍搜索页面换源阅读"];
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
            ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
            if (titleElement) {
                BookDetailModel *newp = [BookDetailModel new];
                newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
                newp.title= [titleElement stringValue];
                [tmpArray addObject:newp];
            }
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (tmpArray.count<=0) {
            [SVProgressHUD showErrorWithStatus:@"该书源暂无更新"];
            return;;
        }
        [SVProgressHUD dismiss];
        NSString *chooseStr = [[NSUserDefaults standardUserDefaults] objectForKey:KeyPageStyle];
        switch (chooseStr.integerValue) {
            case 1:
                {
                    DetailViewController *detailVc = [[DetailViewController alloc] init];
                    detailVc.cellArray = tmpArray;
                    detailVc.bookModel = book;
                    detailVc.xpath = book.bookContent?book.bookContent:@"//*[@id=\"content\"]";
                    detailVc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailVc animated:YES];}
                break;
                
            default:
            {
                SFReadViewController *detailVc = [[SFReadViewController alloc] init];
                detailVc.cellArray = tmpArray;
                detailVc.bookModel = book;
                detailVc.xpath = book.bookContent?book.bookContent:@"//*[@id=\"content\"]";
                detailVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVc animated:YES];}
                break;
        }
    });
}
#pragma mark - 获取更新的章节数

- (void)getCartoonUpdateCountWithBook:(BookModel *)book{
    NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:cacheData error:nil];
        NSMutableArray *tmpArray = [NSMutableArray array];
        ONOXMLElement *menuList = [doc firstChildWithXPath:book.bookCatalog];
        //遍历其子节点,
        [menuList.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[element tag] isEqualToString:@"li"]) {
                ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
                if (titleElement) {
                    BookDetailModel *newp = [BookDetailModel new];
                    newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
                    newp.title= [titleElement stringValue];
                    [tmpArray addObject:newp];
                }
            }
        }];
        book.bookNewCount = tmpArray.count;
    } else {
        book.bookNewCount = 0;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
        } else {
            [data writeToFile:cachePath atomically:YES];
            //下载网页数据
            ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
            NSMutableArray *tmpArray = [NSMutableArray array];
            ONOXMLElement *menuList = [doc firstChildWithXPath:book.bookCatalog];
            //遍历其子节点,
            [menuList.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[element tag] isEqualToString:@"li"]) {
                    BookDetailModel *newp = [BookDetailModel new];
                    ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
                    newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
                    newp.title= [titleElement stringValue];
                    [tmpArray addObject:newp];
                }
            }];
            book.bookNewCount = tmpArray.count;
        }
    }];
    [task resume];
}
- (void)getBookUpdateCountWithBook:(BookModel *)book{
    NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    if ([book.bookCatalog isEqualToString:@"json"]) {
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
        if (isExist) {
            NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
            NSMutableArray *tmpArray = [NSMutableArray array];
            SFJsonCatelogModel *catelogModel = [SFJsonCatelogModel SF_MJParse:dict];
            for (SFJsonCatelogModelRows *model in catelogModel.rows) {
                BookDetailModel *newp = [BookDetailModel new];
                NSString *postUrl = [book.bookContent stringByReplacingOccurrencesOfString:@"SFresourceid" withString:book.bookNumber];
                postUrl = [postUrl stringByReplacingOccurrencesOfString:@"SFserialid" withString:model.serialID];
                newp.postUrl = postUrl;
                newp.title= model.serialName;
                [tmpArray addObject:newp];
            }
            book.bookNewCount = tmpArray.count;
        } else {
            book.bookNewCount = 0;
        }
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
            } else {
                [data writeToFile:cachePath atomically:YES];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSMutableArray *tmpArray = [NSMutableArray array];
                SFJsonCatelogModel *catelogModel = [SFJsonCatelogModel SF_MJParse:dict];
                for (SFJsonCatelogModelRows *model in catelogModel.rows) {
                    BookDetailModel *newp = [BookDetailModel new];
                    NSString *postUrl = [book.bookContent stringByReplacingOccurrencesOfString:@"SFresourceid" withString:book.bookNumber];
                    postUrl = [postUrl stringByReplacingOccurrencesOfString:@"SFserialid" withString:model.serialID];
                    newp.postUrl = postUrl;
                    newp.title= model.serialName;
                    [tmpArray addObject:newp];
                }
                book.bookNewCount = tmpArray.count;
            }
        }];
        [task resume];
    } else {
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
        if (isExist) {
            NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
            NSMutableArray *tmpArray = [NSMutableArray array];
            //下载网页数据
            ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:cacheData error:nil];
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
            book.bookNewCount = tmpArray.count;
        } else {
            book.bookNewCount = 0;
        }
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[book.bookUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        request.HTTPMethod = @"GET";
        request.allHTTPHeaderFields = @{@"Content-Type":@"text/html"};
        request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        request.timeoutInterval = 5;
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
            } else {
                [data writeToFile:cachePath atomically:YES];
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
                book.bookNewCount = tmpArray.count;
            }
        }];
        [task resume];
    }
}
#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFMovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SFMovieCollectionViewCellID" forIndexPath:indexPath];
    BookModel *model = self.dataArray[indexPath.row];
    [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
    cell.titleLabel.text = model.bookTitle;
    cell.nameLabel.text = model.bookAuthor;
    NSString *typeStr = model.other2.length==2?model.other2:@"小说";
    cell.typeWidth.constant = [SFTool getWidthWithText:typeStr height:cell.bookType.bounds.size.height font:cell.bookType.font]+5;
    cell.bookType.text = typeStr;
    BOOL bookUpdateReminder = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookUpdateReminder];
    NSInteger update = model.bookNewCount-model.bookIndex;
    if (bookUpdateReminder && update>0) {
        cell.redView.hidden = NO;
        if (update>99) {
            cell.redView.bubbleText = @"99+";
        } else {
            cell.redView.bubbleText = [NSString stringWithFormat:@"%ld",(long)update];
        }
    } else {
        cell.redView.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *model = self.dataArray[indexPath.row];
    if ([model.other2 isEqualToString:@"漫画"]) {
        [self getCartoonMenuWithBook:model];
    } else {
        BOOL cacheBook = [[NSUserDefaults standardUserDefaults] boolForKey:KeyCacheBooks];
        if (cacheBook) {
            NSString *md5 = [SFTool MD5WithUrl:model.bookUrl];
            NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
            if (isExist) {
                NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
                if ([model.bookCatalog isEqualToString:@"json"]) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
                    [self handleJsonData:dict WithBook:model];
                } else {
                    [self handleData:cacheData WithBook:model];
                }
            } else {
                [self getBookMenuWithBook:model];
            }
        } else {
            [self getBookMenuWithBook:model];
        }
    }
}

@end
