//
//  SearchViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/20.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SearchViewController.h"
#import "SFRequestModel.h"
#import "SFReadViewController.h"
#import "SFJsonBookModel.h"
#import "SFJsonCatelogModel.h"
#import "SFRecommendBookView.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *keyWords;
@property (nonatomic, strong) UIView *top;

@property (nonatomic, strong) NSMutableArray *requestArray;

@property (nonatomic, strong) SFJsonBookModel *jsonModel;
@property (nonatomic, strong) SFJsonCatelogModel *catelogModel;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索书籍";
    self.dataArray = [NSMutableArray array];
    self.requestArray = [NSMutableArray array];
    if (self.descDict) {
        SFRequestModel *model = [SFRequestModel SF_MJParse:self.descDict];
        [self.requestArray addObject:model];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存书源" style:UIBarButtonItemStyleDone target:self action:@selector(saveBookSource)];
        self.navigationItem.rightBarButtonItem = rightItem;
    } else {
        //在读取的时候首先去文件中读取为NSData类对象，然后通过NSJSONSerialization类将其转化为foundation对象
        NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookSourcesPath];
        NSArray *list = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
        for (NSDictionary *dict in list) {
            SFRequestModel *model = [SFRequestModel SF_MJParse:dict];
            [self.requestArray addObject:model];
        }
    }
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
- (void)saveBookSource{
    NSData *jsonData = [[NSFileManager defaultManager] contentsAtPath:DCBookSourcesPath];
    NSArray *tmpList = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:nil];
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:tmpList];
    [mutArr addObject:self.descDict];
    //首先判断能否转化为一个json数据，如果能，接下来先把foundation对象转化为NSData类型，然后写入文件
    if ([NSJSONSerialization isValidJSONObject:mutArr]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutArr options:1 error:nil];
        [jsonData writeToFile:DCBookSourcesPath atomically:YES];
        NSLog(@"书源存储成功：%@",DCBookSourcesPath);
        [SVProgressHUD showSuccessWithStatus:@"书源保存成功"];
        [self performSelector:@selector(popToRootVC) withObject:nil afterDelay:1];
    }
}
- (void)popToRootVC{
    for (UIViewController *infoVC in self.navigationController.viewControllers) {
        if ([infoVC isKindOfClass:NSClassFromString(@"SFBookSourceMangerViewController")]) {
            [self.navigationController popToViewController:infoVC animated:YES];
            return;
        }
    }
}
- (void)updateFrameWithSize:(CGSize)size{
    if (size.width>size.height) {
        self.top.frame = CGRectMake(0, 32, size.width, 60);
        self.tableView.frame = CGRectMake(0, 32+60, size.width, size.height-60-32);
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
    bar.layer.borderColor = [UIColor orangeColor].CGColor;
    bar.tag = 1;
    [top addSubview:bar];
    
    UITextField *keywords = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(bar.frame)-15-40, 40)];
    keywords.font = [UIFont systemFontOfSize:14];
    keywords.text = @"";
    keywords.placeholder = @"请输入作者或书名";
    keywords.delegate = self;
    keywords.returnKeyType = UIReturnKeySearch;
    keywords.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bar addSubview:keywords];
    self.keyWords = keywords;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetWidth(bar.frame)-40, 0, 40, 40);
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 2;
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
    for (SFRequestModel *model in self.requestArray) {
        [self getRequestData:model];
    }
}
- (void)getRequestData:(SFRequestModel *)model{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *searchUrl = [model.search stringByReplacingOccurrencesOfString:@"SFSearchKey" withString:self.keyWords.text];
    NSString *md5 = [SFTool MD5WithUrl:searchUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    if ([model.requestType isEqualToString:@"html"]) {
        if ([searchUrl hasPrefix:@"post"]) {
            [SFNetWork postXmlDataWithURL:[searchUrl substringFromIndex:4] parameters:nil success:^(id data) {
                [self handleHtmlSuccessData:data BookModel:model];
            } fail:^(NSError *error) {
                NSLog(@"网络请求失败:%@",error);
                [SVProgressHUD dismiss];
            }];
        } else {
            [SFNetWork getXmlDataWithURL:searchUrl parameters:nil success:^(id data) {
                [self handleHtmlSuccessData:data BookModel:model];
            } fail:^(NSError *error) {
                NSLog(@"网络请求失败:%@",error);
                [SVProgressHUD dismiss];
            }];
        }
    }
    else {
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
                    [self.dataArray addObject:newp];
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
                    [self.dataArray addObject:newp];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (self.dataArray.count>0) {
                    [self.tableView reloadData];
                    [self.tableView setContentOffset:CGPointMake(0, 0.0) animated:NO];
                }
            });
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD dismiss];
        }];
    }
}
- (void)handleHtmlSuccessData:(NSData *)data BookModel:(SFRequestModel *)model{
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
                if (model.wapReq) {
                    newp.bookUrl = [NSString stringWithFormat:@"%@%@",newp.bookUrl,model.wapReq];
                }
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
            [self.dataArray addObject:newp];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dataArray.count>0) {
            [self.tableView reloadData];
        }
    });
}
- (UIView *)createNoBookView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44))];
    footerView.tag = 98765;
    UILabel *label1 = [[UILabel alloc] initWithFrame:footerView.bounds];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"请确保从搜书到看书都无问题后在保存书源\n以免浪费手机在书城搜书的时间";
    label1.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    label1.numberOfLines = 0;
    [footerView addSubview:label1];
    return footerView;
}
- (UIView *)tableViewFooterView{
    SFRecommendBookView *footerView = [[SFRecommendBookView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
    __weak typeof(self) weakSelf = self;
    footerView.selectedTagsBlock = ^(NSString * _Nonnull selectedTag) {
        weakSelf.keyWords.text = selectedTag;
        [weakSelf searchBtnClick];
    };
    return footerView;;
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
        [_tableView registerNib:[UINib nibWithNibName:@"BookTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookTableViewCellID"];
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count>0) {
        tableView.tableFooterView = [UIView new];
    } else {
        if (self.descDict) {
            tableView.tableFooterView = [self createNoBookView];
        } else {
            tableView.tableFooterView = [self tableViewFooterView];
        }
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookTableViewCellID" forIndexPath:indexPath];
    BookModel *model = self.dataArray[indexPath.row];
    if (model.bookIcon.length>0) {
        [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
    } else {
        cell.iconImgView.image = [UIImage imageNamed:@"noBookImg"];
    }
    cell.contentLabel.text = model.bookSynopsis;
    cell.titleLabel.text = model.bookTitle;
    cell.nameLabel.text = model.bookAuthor;
    cell.bookType.text = @"小说";
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
    NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    if ([book.bookCatalog isEqualToString:@"json"]) {
        [SFNetWork getJsonDataWithURL:book.bookUrl parameters:nil success:^(id json) {
            self.catelogModel = [SFJsonCatelogModel SF_MJParse:json];
            if (self.catelogModel.ret == 0) {
                NSMutableArray *tmpArray = [NSMutableArray array];
                for (SFJsonCatelogModelRows *model in self.catelogModel.rows) {
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
                [SVProgressHUD showErrorWithStatus:@"此书为会员书籍，爬不到哦"];
            }
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD dismiss];
        }];
    } else {
        [SFNetWork getXmlDataWithURL:book.bookUrl parameters:nil success:^(id data) {
            NSMutableArray *tmpArray = [NSMutableArray array];
            //下载网页数据
            ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
            ONOXMLElement *postsParentElement= [doc firstChildWithXPath:book.bookCatalog]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
            //遍历其子节点,
            [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[element tag] isEqualToString:@"dd"]) {
                    BookDetailModel *newp = [BookDetailModel new];
                    ONOXMLElement *titleElement= [element firstChildWithXPath:@"a"];
                    if (titleElement) {
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
        } fail:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [SVProgressHUD dismiss];
        }];
    }
}
/**
 https://druid.if.qidian.com/Atom.axd/Api/Tops/GetTopGroupList?siteId=0
 {
     "Result": 0,
     "Message": "",
     "Data": [{
         "Name": "风云榜",
         "DefaultTopId": 0,
         "SubItems": [{
             "Name": "月榜",
             "TopId": 0
         }]
     }, {
         "Name": "畅销榜",
         "DefaultTopId": 65,
         "SubItems": [{
             "Name": "24小时榜",
             "TopId": 65
         }]
     }
 }
 //获取排行榜列表
 https://druid.if.qidian.com/Atom.axd/Api/Tops/GetTopBooks?pageIndex=1&topId=0
 */
@end
