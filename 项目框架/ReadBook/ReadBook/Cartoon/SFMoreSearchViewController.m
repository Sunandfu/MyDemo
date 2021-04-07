//
//  SFMoreSearchViewController.m
//  ReadBook
//
//  Created by lurich on 2020/7/1.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMoreSearchViewController.h"
#import "SFRequestModel.h"
#import "SFMoreDetailViewController.h"

@interface SFMoreSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *keyWords;
@property (nonatomic, strong) UIView *top;

@end

@implementation SFMoreSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索漫画";
    self.dataArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    [self createSearchView];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self updateFrameWithSize:self.view.bounds.size];
}
- (void)updateFrameWithSize:(CGSize)size{
    if (size.width>size.height) {
        self.top.frame = CGRectMake(0, 44, size.width, 60);
        self.tableView.frame = CGRectMake(0, 44+60, size.width, size.height-60-44);
    } else {
        self.top.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), size.width, 60);
        self.tableView.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+60, size.width, size.height-60-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44));
    }
    UIView *bar = [self.top viewWithTag:1];
    bar.frame = CGRectMake(15, 10, size.width-30, 40);
    UIButton *btn = [self.top viewWithTag:2];
    btn.frame = CGRectMake(CGRectGetWidth(bar.frame)-40, 0, 40, 40);
    self.keyWords.frame = CGRectMake(15, 0, CGRectGetWidth(bar.frame)-15-40, 40);
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)createSearchView{
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), self.view.bounds.size.width, 60)];
    top.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:top];
    self.top = top;
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(15, 10, self.view.bounds.size.width-30, 40)];
    bar.layer.masksToBounds = YES;
    bar.layer.cornerRadius = 20;
    bar.layer.borderWidth = 1;
    bar.tag = 1;
    bar.layer.borderColor = [UIColor orangeColor].CGColor;
    [top addSubview:bar];
    
    UITextField *keywords = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(bar.frame)-15-40, 40)];
    keywords.font = [UIFont systemFontOfSize:14];
    keywords.text = @"";
    keywords.placeholder = @"请输入作者或漫画名";
    keywords.delegate = self;
    keywords.returnKeyType = UIReturnKeySearch;
    keywords.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bar addSubview:keywords];
    self.keyWords = keywords;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetWidth(bar.frame)-40, 0, 40, 40);
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.tag = 2;
    [btn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:btn];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text>0) {
        [self searchBtnClick];
        return YES;
    } else {
        return NO;
    }
}
- (void)searchBtnClick{
    if (self.keyWords.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索关键字"];
        return;
    }
    [self.dataArray removeAllObjects];
    [self.keyWords resignFirstResponder];
    [self getRequestData];
}
- (void)getRequestData{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *searchUrl = [@"http://www.biqug.org/index.php/search?key=SFSearchKey" stringByReplacingOccurrencesOfString:@"SFSearchKey" withString:self.keyWords.text];
    NSString *md5 = [SFTool MD5WithUrl:searchUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [SFNetWork getXmlDataWithURL:searchUrl parameters:nil success:^(id data) {
        [SVProgressHUD dismiss];
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@class=\"cate-comic-list clearfix\"]"]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
        //遍历其子节点,
        [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            BookModel *newp = [BookModel new];
            ONOXMLElement *aItem = [element firstChildWithXPath:@"a"];
            newp.bookUrl= [NSString stringWithFormat:@"%@%@",@"http://www.biqug.org",[aItem valueForAttribute:@"href"]];
            newp.bookIndex = 0;
            [self getBookDetailWithBook:newp];
        }];
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败:%@",error);
        [SVProgressHUD dismiss];
    }];
}
- (void)getBookDetailWithBook:(BookModel *)book{
    [SFNetWork getXmlDataWithURL:book.bookUrl parameters:nil success:^(id data) {
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        BookModel *newp = [BookModel new];
        newp.bookUrl = [NSString stringWithFormat:@"%@",book.bookUrl];
        ONOXMLElement *titleItem = [doc firstChildWithXPath:@"//*[@class=\"comic-title j-comic-title\"]"];
        newp.bookTitle = [NSString stringWithFormat:@"%@",[titleItem stringValue]];
        ONOXMLElement *autherItem = [doc firstChildWithXPath:@"//*[@class=\"name\"]/a"];
        NSString *bookAuthor = [SFTool sf_stringRemoveSpecialCharactersOfString:[autherItem stringValue]];
        if ([bookAuthor hasPrefix:@"作者"]) {
            newp.bookAuthor= [NSString stringWithFormat:@"%@",bookAuthor];
        } else {
            newp.bookAuthor= [NSString stringWithFormat:@"作者：%@",bookAuthor];
        }
        ONOXMLElement *image = [doc firstChildWithXPath:@"//*[@class=\"de-info__cover\"]/img"];
        NSString *imgUrl = [image valueForAttribute:@"src"];
        if (![imgUrl hasPrefix:@"http"]) {
            newp.bookIcon = [NSString stringWithFormat:@"%@%@",@"https:",imgUrl];
        } else {
            newp.bookIcon = imgUrl;
        }
        ONOXMLElement *synopsis = [doc firstChildWithXPath:@"//*[@class=\"intro\"]"];
        NSString *bookSynopsis = [SFTool sf_stringRemoveSpecialCharactersOfString:[synopsis stringValue]];
        if ([bookSynopsis hasPrefix:@"简介"]) {
            newp.bookSynopsis= [NSString stringWithFormat:@"%@",bookSynopsis];
        } else {
            newp.bookSynopsis= [NSString stringWithFormat:@"简介：%@",bookSynopsis];
        }
        newp.bookIndex = 0;
        newp.bookCatalog = @"//*[@class=\"chapter__list clearfix\"]/ul";
        newp.bookContent = @"//*[@class=\"rd-article-wr clearfix\"]";
        newp.other1 = @"http://biqug.org";
        newp.other2 = @"漫画";
        [self.dataArray addObject:newp];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{newp.bookTitle:@0}];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败:%@",error);
    }];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+60, self.view.bounds.size.width, self.view.bounds.size.height-60-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"BookTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookTableViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableViewCellID" forIndexPath:indexPath];
    if (self.dataArray.count>indexPath.row) {
        BookModel *model = self.dataArray[indexPath.row];
        if (model.bookIcon.length>0) {
            [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
        } else {
            cell.iconImgView.image = [UIImage imageNamed:@"noBookImg"];
        }
        cell.contentLabel.text = model.bookSynopsis;
        cell.titleLabel.text = model.bookTitle;
        cell.nameLabel.text = model.bookAuthor;
        cell.bookType.text = @"漫画";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookModel *model = self.dataArray[indexPath.row];
    [self getBookMenuWithBook:model];
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
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"添加书架" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        BookModel *model = self.dataArray[indexPath.row];
        if ([SFBookSave isHaveBook:model]) {
            [SVProgressHUD showSuccessWithStatus:@"已经加入书架了哦"];
        } else {
            BOOL insert = [SFBookSave insertBook:model];
            if (insert) {
                [SVProgressHUD showSuccessWithStatus:@"加入书架成功"];
            }
        }
    }];
    action.backgroundColor = [UIColor orangeColor];
    return @[action];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)getBookMenuWithBook:(BookModel *)book{
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
            BookDetailModel *newp = [BookDetailModel new];
            ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
            newp.postUrl = [book.other1 stringByAppendingString:[titleElement valueForAttribute:@"href"]]; //获取 a 标签的  href 属性
            newp.title= [SFTool sf_stringRemoveSpecialCharactersOfString:[titleElement stringValue]];
            [tmpArray addObject:newp];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (tmpArray.count>0) {
            SFMoreDetailViewController *detailVc = [[SFMoreDetailViewController alloc] init];
            detailVc.cellArray = tmpArray;
            detailVc.bookModel = book;
            detailVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVc animated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"该漫画暂无更新"];
        }
    });
}

@end

