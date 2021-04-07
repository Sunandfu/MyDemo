//
//  ViewController.m
//  GCDWebServerDemo
//
//  Created by shapp on 2017/8/23.
//  Copyright © 2017年 shapp. All rights reserved.
//

#import "SFWifiViewController.h"
#import "GCDWebUploader.h"
#import "SJXCSMIPHelper.h"
#import "DCFileTool.h"
#import "SFBookSave.h"
#import "SFConstant.h"
#import "SVProgressHUD.h"
#import "SFTaskWebViewController.h"

@interface SFWifiViewController () <GCDWebUploaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    GCDWebUploader * _webServer;
}

/* 显示ip地址 */
@property (nonatomic, strong) UILabel *showIpLabel;

@property (nonatomic, strong) UIButton *showBtn;

@property (nonatomic, strong) UIView *backView;
/* fileTableView */
@property (nonatomic, strong) UITableView *fileTableView;
/* fileArray */
@property (nonatomic, strong) NSArray *fileArray;
@end

@implementation SFWifiViewController

- (void)viewDidLoad {
    self.title = @"Wifi传书";
    [super viewDidLoad];
    [self.view addSubview:self.fileTableView];
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.backView addSubview:self.showIpLabel];
    [self.backView addSubview:self.showBtn];
    [self.view addSubview:self.backView];
    
    // 文件存储位置
    NSString* documentsPath = DCBooksPath;
    NSLog(@"文件存储位置 : %@", documentsPath);
    
    // 创建webServer，设置根目录
    _webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    // 设置代理
    _webServer.delegate = self;
    _webServer.allowHiddenItems = YES;
    
    // 限制文件上传类型
    _webServer.allowedFileExtensions = @[@"txt"];
    // 设置网页标题
    _webServer.title = @"本地小说管理平台";
    // 设置展示在网页上的文字(开场白)
    _webServer.prologue = @"欢迎使用Lurich的本地小说管理平台";
    // 设置展示在网页上的文字(收场白)
    _webServer.epilogue = @"真情告白：露露是世上最美的姑娘！我很爱她！哈哈哈~~~";
    
//    _webServer.header = @"小说传输平台";
    _webServer.footer = @"版本 1.0";
    
    if ([_webServer start]) {
        self.backView.hidden = NO;
        self.showIpLabel.text = [NSString stringWithFormat:@"确保电脑与手机在同一WIFI网络下\n请在电脑浏览器地址栏中输入\nhttp://%@:%zd/", [SJXCSMIPHelper deviceIPAdress], _webServer.port];
        NSLog(@"http://%@:%zd/", [SJXCSMIPHelper deviceIPAdress], _webServer.port);
    } else {
        self.showIpLabel.text = NSLocalizedString(@"GCDWebServer not running!", nil);
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"手机传书" style:UIBarButtonItemStyleDone target:self action:@selector(pushCourseView)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
//屏幕旋转之后，屏幕的宽高互换，我们借此判断重新布局
//横屏：size.width > size.height
//竖屏: size.width < size.height
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.showIpLabel.frame = CGRectMake(0, size.height * 0.5-100, size.width, 200);
    self.showBtn.frame = CGRectMake((size.width-200)/2.0, size.height * 0.5+100, 200, 50);
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.fileTableView.frame = self.view.bounds;
    self.backView.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_webServer stop];
    _webServer = nil;
}
- (void)pushCourseView{
    SFTaskWebViewController *taskVC = [[SFTaskWebViewController alloc] init];
    taskVC.URLString = @"https://shimo.im/docs/yWD3G3PQkwpCQRDG/read";
    taskVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:taskVC animated:YES];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    DCBookModel *book = self.fileArray[indexPath.row];
    cell.textLabel.text = book.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DCBookModel *book = self.fileArray[indexPath.row];
    DCPageVC *vc = [[DCPageVC alloc]init];
    vc.bookModel = book;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - <GCDWebUploaderDelegate>
- (void)webUploader:(GCDWebUploader*)uploader didListAtPath:(NSString*)path{
    NSLog(@"[LIST] %@", path);
    self.backView.hidden = YES;
    self.fileArray = [SFBookSave selectLocalBook];
    [self.fileTableView reloadData];
}
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    NSLog(@"[UPLOAD] %@", path);
    self.backView.hidden = YES;
    
    NSString *fileNameStr = [path lastPathComponent];
    fileNameStr = [fileNameStr stringByRemovingPercentEncoding];

    DCBookModel *book = [[DCBookModel alloc]init];
    book.path = fileNameStr;
    NSArray *arr = [fileNameStr componentsSeparatedByString:@"."];
    book.name = arr.firstObject;
    book.type = arr.lastObject;
    book.bookIndex = 0;
    book.bookPage = 0;
    book.pageOffset = 0.0;

    BOOL insert = [SFBookSave insertLocalBook:book];
    if (insert) {
        NSLog(@"加入书架成功");
    }
    self.fileArray = [SFBookSave selectLocalBook];
    [self.fileTableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    NSLog(@"[MOVE] %@ -> %@", fromPath, toPath);
}

- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    NSLog(@"[DELETE] %@", path);
    NSString *fileNameStr = [path lastPathComponent];
    fileNameStr = [fileNameStr stringByRemovingPercentEncoding];
    DCBookModel *book = [SFBookSave selectedLocalBookName:fileNameStr];
    BOOL isDelegate = [SFBookSave deleteLocalBook:book];
    if (isDelegate) {
        NSLog(@"删除成功 %d",isDelegate);
    }
    
    self.fileArray = [SFBookSave selectLocalBook];
    [self.fileTableView reloadData];
}

- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    NSLog(@"[CREATE] %@", path);
}

#pragma mark - <懒加载>
- (UILabel *)showIpLabel {
    if (!_showIpLabel) {
        _showIpLabel = [UILabel new];
        _showIpLabel.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 200);
        _showIpLabel.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
        _showIpLabel.textColor = [UIColor darkGrayColor];
        _showIpLabel.textAlignment = NSTextAlignmentCenter;
        _showIpLabel.font = [UIFont systemFontOfSize:15.0];
        _showIpLabel.numberOfLines = 0;
    }
    return _showIpLabel;
}
- (void)showBtnClick{
    UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
    pBoard.string = [NSString stringWithFormat:@"http://%@:%zd/", [SJXCSMIPHelper deviceIPAdress], _webServer.port];
    [SVProgressHUD showSuccessWithStatus:@"网址已复制"];
}
- (UITableView *)fileTableView {
    if (!_fileTableView) {
        _fileTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        // 设置代理
        _fileTableView.delegate = self;
        // 设置数据源
        _fileTableView.dataSource = self;
        // 清除表格底部多余的cell
        _fileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _fileTableView;
}
- (UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-200)/2.0, CGRectGetMaxY(self.showIpLabel.frame), 200, 50)];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _showBtn.titleLabel.numberOfLines = 0;
        _showBtn.backgroundColor = [UIColor orangeColor];
        _showBtn.layer.masksToBounds = YES;
        _showBtn.layer.cornerRadius = 25;
        _showBtn.exclusiveTouch = YES;
        [_showBtn setTitle:@"点击复制网址" forState:UIControlStateNormal];
        [_showBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBtn;
}
- (NSArray *)fileArray{
    if (!_fileArray) {
        _fileArray = [NSArray array];
    }
    return _fileArray;
}

@end
