//
//  DCHomeVC.m
//  DCBooks
//
//  Created by cheyr on 2018/3/15.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import "DCHomeVC.h"
#import "DCBookModel.h"
#import "DCPageVC.h"
#import "MJRefresh.h"
#import "DCFileTool.h"
#import "WHCFileManager.h"
#import "SFBookSave.h"
#import "SFConstant.h"
#import "SFWifiViewController.h"
#import "SFSafeAreaInsets.h"
#import "SVProgressHUD.h"

@interface DCHomeVC ()<UITableViewDelegate,UITableViewDataSource,UIDocumentPickerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray<DCBookModel *> *books;
@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;

@end

static NSString *const cellKey = @"cellKey";

@implementation DCHomeVC
#pragma mark  - life cycle
- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.whiteColor;
    [super viewDidLoad];
    self.title = @"本地书籍";
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Wifi传书" style:UIBarButtonItemStyleDone target:self action:@selector(pushWifiView)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self loadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (UIView *)tableViewFooterView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 70)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0-100, 10, 200, 50)];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [button setTitle:@"导入本地书籍" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    return headerView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    tableView.tableFooterView = [self tableViewFooterView];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellKey];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellKey];
    }
    DCBookModel *book = self.books[indexPath.row];
    cell.textLabel.text = book.name;
    if (book.readTime.integerValue>0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:book.readTime.integerValue/1000];
        NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
        recordDateFormatter.dateFormat = @"YYYY年MM月dd日 HH时mm分ss秒";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"上次阅读时间：%@",[recordDateFormatter stringFromDate:date]];
    }
    return cell;
}
#pragma mark  - private
-(void)loadData{
    //获取文件夹中的所有文件
    self.books = [SFBookSave selectLocalBook];
    BOOL bookReadTimeSolt = [[NSUserDefaults standardUserDefaults] boolForKey:KeyBookReadTimeSolt];
    if (bookReadTimeSolt) {
        NSArray *sortedArray = [self.books sortedArrayUsingComparator:^NSComparisonResult(DCBookModel *book1, DCBookModel *book2) {
            //降序，key表示比较的关键字
            if (book1.readTime.integerValue < book2.readTime.integerValue) return NSOrderedDescending;
            else return NSOrderedAscending;
        }];
        self.books = sortedArray;
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DCBookModel *book = self.books[indexPath.row];
    DCPageVC *vc = [[DCPageVC alloc]init];
    vc.bookModel = book;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除该书" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        DCBookModel *book = self.books[indexPath.row];
        BOOL isDelegate = [SFBookSave deleteLocalBook:book];
        if (isDelegate) {
            BOOL isDelegate2 = [WHCFileManager removeItemAtPath:[DCBooksPath stringByAppendingPathComponent:book.path]];
            if (isDelegate2) {
                NSLog(@"删除成功 %d-%d",isDelegate,isDelegate2);
                [self loadData];
            }
        }
    }];
    return @[action];
}
#pragma mark  - setter or getter
-(UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

- (void)pushWifiView{
    [self.navigationController pushViewController:[SFWifiViewController new] animated:YES];
}
- (void)addBookBtnClick{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:self.documentPickerVC animated:YES completion:nil];
    });
}
- (UIDocumentPickerViewController *)documentPickerVC {
    if (!_documentPickerVC) {
        NSArray *types = @[@"public.content",@"public.text"];
        self.documentPickerVC = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
        // 设置代理
        _documentPickerVC.delegate = self;
        // 设置模态弹出方式
        _documentPickerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return _documentPickerVC;
}
#pragma mark - UIDocumentPickerDelegate
 
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    // 获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        // 通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            if (error) {
                // 读取出错
                [SVProgressHUD showErrorWithStatus:@"读取文件出错"];
                NSLog(@"error : %@", error);
                [self dismissViewControllerAnimated:YES completion:NULL];
            } else {
                // 上传
                NSString *fileNameStr = [newURL lastPathComponent];
                fileNameStr = [fileNameStr stringByRemovingPercentEncoding];
                NSArray *arr = [fileNameStr componentsSeparatedByString:@"."];
                NSLog(@"fileName : %@", fileNameStr);
                if ([arr.lastObject isEqualToString:@"txt"]) {
                    DCBookModel *model = [SFBookSave selectedLocalBookName:arr.firstObject];
                    if (model.name.length>0) {
                        //用阅读器打开这个文件
                        DCPageVC *vc = [[DCPageVC alloc]init];
                        vc.bookModel = model;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        NSString *toPath = [DCBooksPath stringByAppendingPathComponent:fileNameStr];
                        NSData *data = [NSData dataWithContentsOfURL:newURL];
                        [data writeToFile:toPath atomically:YES];
                        
                        DCBookModel *book = [[DCBookModel alloc]init];
                        book.path = fileNameStr;
                        book.name = arr.firstObject;
                        book.type = arr.lastObject;
                        book.bookIndex = 0;
                        book.bookPage = 0;
                        book.pageOffset = 0.0;
                        
                        BOOL insert = [SFBookSave insertLocalBook:book];
                        if (insert) {
                            NSLog(@"加入书架成功");
                        }
                        
                        DCPageVC *vc = [[DCPageVC alloc]init];
                        vc.bookModel = book;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"请选择txt格式文本文件"];
                }
                [self dismissViewControllerAnimated:YES completion:NULL];
                // [self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];
            }
            
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        // 授权失败
    }
}

@end
