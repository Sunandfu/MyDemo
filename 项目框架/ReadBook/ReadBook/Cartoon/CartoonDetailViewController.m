//
//  CartoonDetailViewController.m
//  ReadBook
//
//  Created by lurich on 2020/6/17.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "CartoonDetailViewController.h"
#import "CartoonTableViewCell.h"

@interface CartoonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *listTableView;
/**是否正在显示菜单*/
@property (nonatomic, assign) BOOL menuIsShowing;
/**右侧目录view*/
@property (nonatomic, strong) UIView *menuContentView;
/**遮罩*/
@property (nonatomic, weak) UIControl *coverView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation CartoonDetailViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self onApplicationWillResignActive];
}
//进入后台 保存下进度
- (void)onApplicationWillResignActive {
    [[NSUserDefaults standardUserDefaults] setInteger:self.index forKey:self.bookModel.bookTitle];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    self.lastIndex = self.cellArray.count;
    NSInteger integer = [[NSUserDefaults standardUserDefaults] integerForKey:self.bookModel.bookTitle];
    self.index = integer;
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self addContentView];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"目录" style:UIBarButtonItemStyleDone target:self action:@selector(showCartoonMenuList)];
    [self updateFrameWithSize:self.view.bounds.size];
}
- (void)updateFrameWithSize:(CGSize)size{
    [self hideCartoonMenuList];
    self.coverView.frame = CGRectMake(0, 0, size.width, size.height);
    self.menuContentView.frame = CGRectMake(size.width, 0, fminf(size.width,size.height) * 0.8, size.height);
    if (size.width > size.height) {
        self.listTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame));
        self.tableView.frame = CGRectMake(0, 20, size.width, size.height-20);
    } else {
        self.listTableView.frame = CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top, CGRectGetWidth(self.menuContentView.frame), CGRectGetHeight(self.menuContentView.frame)-[SFSafeAreaInsets shareInstance].safeAreaInsets.top);
        self.tableView.frame = CGRectMake(0, [SFSafeAreaInsets shareInstance].safeAreaInsets.top+20, size.width, size.height-[SFSafeAreaInsets shareInstance].safeAreaInsets.top-20);
    }
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
}
- (void)getWebDataWithIndex:(NSInteger)index{
    if (index < 0) {
        self.index += 1;
        [SVProgressHUD showErrorWithStatus:@"已经是第一页了"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    } else if (index >= self.cellArray.count) {
        self.index -= 1;
        [SVProgressHUD showErrorWithStatus:@"没有最新了"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    BookDetailModel *detailModel = self.cellArray[index];
    self.title = detailModel.title;
    [SVProgressHUD showWithStatus:@"加载中..."];
    CGFloat screenW = self.tableView.bounds.size.width;
    [SFNetWork getXmlDataWithURL:detailModel.postUrl parameters:nil success:^(id data) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.lastIndex>index) {
            [self.dataArray removeAllObjects];
        }
        NSError *xmlError;
        ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:&xmlError];
        if (!xmlError) {
            NSString *docStr = [NSString stringWithFormat:@"%@",doc];
            NSString *CT_NUM = @"parseJSON(\\S*)";
            //判断返回字符串是否为所需数据
            if (docStr.length>0) {
                NSArray *strArr = [self matchString:docStr toRegexString:CT_NUM];
                NSString *reStr = [NSString stringWithFormat:@"%@",[strArr firstObject]];
                NSLog(@"%@",reStr);
                reStr = [reStr substringWithRange:NSMakeRange(2, reStr.length-5)];
                NSLog(@"%@",reStr);
                NSData *jsonData = [reStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                NSArray *tmpArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                if(error) {
                    NSLog(@"error = %@",error);
                } else {
                    for (NSString *imgStr in tmpArr) {
                        BookDetailModel *detailModel = [BookDetailModel new];
                        NSString *img = [self.bookModel.other1 stringByAppendingString:imgStr];
                        detailModel.postUrl = img;
                        [self.dataArray addObject:detailModel];
                    }

                    //请求线程组
                    dispatch_group_t group = dispatch_group_create();
                    for (BookDetailModel *detailModel in self.dataArray) {
                        {
                        dispatch_group_enter(group);
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            //设置真实高度
                            NSString *md5 = [SFTool MD5WithUrl:detailModel.postUrl];
                            NSString *cachePath = [SFTool cacheImagePathWithMD5:md5];
                            NSString *imageCache = [NSString stringWithFormat:@"%@.jpg",cachePath];
                            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:imageCache];
                            if (isExist) {
                                UIImage *image = [UIImage imageWithContentsOfFile:imageCache];
                                detailModel.height = image.size.height/(image.size.width/screenW);
                                dispatch_group_leave(group);
                            } else {
                                [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:detailModel.postUrl]] options:YYWebImageOptionIgnoreDiskCache progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                    if (error) {
                                        NSLog(@"error = %@ -> url = %@",error,url);
                                    } else {
                                        [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageCache atomically:YES];
                                        detailModel.height = image.size.height/(image.size.width/screenW);
                                    }
                                    dispatch_group_leave(group);
                                }];
                            }
                        });
                        }
                    }
                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self.lastIndex>index) {
                                [self.tableView setContentOffset:CGPointMake(0, -64.0) animated:NO];
                            }
                            self.lastIndex = index;
                            [SVProgressHUD dismiss];
                            [self.tableView reloadData];
                        });
                    });
                }
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"网络请求失败:%@",error);
        [SVProgressHUD dismiss];
    }];
}
- (void)showCartoonMenuList
{
    if (self.menuIsShowing) {
        [self hideCartoonMenuList];
        return;
    }
    self.menuIsShowing = YES;
    self.coverView.alpha = 0;
    [self.view bringSubviewToFront:self.menuContentView];
    [self.listTableView reloadData];
    [self.listTableView layoutIfNeeded];
    CGFloat offset = self.index*44.0-44.0;
    if (offset>(self.listTableView.contentSize.height-self.listTableView.bounds.size.height)) {
        if (self.listTableView.contentSize.height>self.listTableView.bounds.size.height) {
            [self.listTableView setContentOffset:CGPointMake(0, self.listTableView.contentSize.height-self.listTableView.bounds.size.height) animated:YES];
        } else {
            [self.listTableView setContentOffset:CGPointMake(0, -44.0) animated:YES];
        }
    } else {
        [self.listTableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 1;
        self.menuContentView.frame = CGRectMake(self.view.bounds.size.width - fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8, 0, fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    }];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollView = %f",scrollView.contentOffset.y);
//}
- (void)hideCartoonMenuList
{
    if (self.menuIsShowing == NO) {
        return;
    }
    self.menuIsShowing = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0;
        self.menuContentView.frame = CGRectMake(self.view.bounds.size.width, 0, fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)coverViewClick{
    if (self.menuIsShowing) {
        [self hideCartoonMenuList];
    }
}
- (void)addContentView{
    [self.view addSubview:self.tableView];
    UIView *leftContentView = [[UIView alloc] init];
    leftContentView.frame = CGRectMake(self.view.bounds.size.width, 0, fminf(self.view.bounds.size.width, self.view.bounds.size.height) * 0.8, self.view.bounds.size.height);
    [self.view addSubview:leftContentView];
    self.menuContentView = leftContentView;
    [leftContentView addSubview:self.listTableView];
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
- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr{
    if (string.length>0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:nil];
        NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        //match: 所有匹配到的字符,根据() 包含级
        NSMutableArray *array = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:1]];
            [array addObject:component];
        }
        return array;
    } else {
        return @[@""];
    }
}
- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"CartoonTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartoonTableViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 333) {
        return self.cellArray.count;
    } else {
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 333) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        BookDetailModel *cellModel = self.cellArray[indexPath.row];
        if (self.index == indexPath.row) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(当前)",cellModel.title];
            cell.textLabel.textColor = [UIColor orangeColor];
        } else {
            cell.textLabel.text = cellModel.title;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    } else {
        CartoonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartoonTableViewCellID" forIndexPath:indexPath];
        BookDetailModel *detailModel = self.dataArray[indexPath.row];
        [SFTool setImage:cell.showImgView WithURLStr:detailModel.postUrl placeholderImage:[UIImage imageNamed:@"loading"]];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 333) {
        self.lastIndex = self.cellArray.count;
        self.index = indexPath.row;
        [self getWebDataWithIndex:indexPath.row];
        [self hideCartoonMenuList];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 333) {
        return 44;
    } else {
        BookDetailModel *detailModel = self.dataArray[indexPath.row];
        return detailModel.height;
    }
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@===%s",self.class,__func__);
}


@end
