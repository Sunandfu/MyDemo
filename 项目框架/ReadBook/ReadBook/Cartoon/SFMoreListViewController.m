//
//  SFMoreListViewController.m
//  ReadBook
//
//  Created by lurich on 2020/6/30.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMoreListViewController.h"
#import "SFMoreDetailViewController.h"

@interface SFMoreListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy  ) NSString *nextUrl;

@end

@implementation SFMoreListViewController

- (void)sf_viewDidLoadForIndex:(NSInteger)index {
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    /// 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf getNetWorkDataWithTop:YES];
    }];
//    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    /// 上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex += 1;
        [weakSelf getNetWorkDataWithTop:NO];
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"我是有底线的哦..." forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    [self getFirstNetWork];
    
    [self updateFrameWithSize:self.view.bounds.size];
}
- (void)updateFrameWithSize:(CGSize)size{
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.tableView reloadData];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BookTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookTableViewCellID"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;;
}
- (void)sf_viewWillAppearForIndex:(NSInteger)index{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.index = index;
}
- (void)sf_viewDidAppearForIndex:(NSInteger)index {
    //    NSLog(@"已经出现   标题: --- %@  index: -- %ld", self.title, index);
}
- (void)createNoNetWorkView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    footerView.tag = 98765;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.bounds.size.width, 30)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"当前网络不可用，请检查你的网络设置";
    label1.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [footerView addSubview:label1];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 226, 292)];
    imageView.image = [UIImage imageNamed:@"sf_img_no_data"];
    imageView.center = footerView.center;
    [footerView addSubview:imageView];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, footerView.bounds.size.height-30, footerView.bounds.size.width, 30)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"点击页面进行刷新";
    label2.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [footerView addSubview:label2];
    [footerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getFirstNetWork)]];
    [self.view addSubview:footerView];
}
- (void)getFirstNetWork{
    [self.tableView.mj_header beginRefreshing];
}
- (void)getNetWorkDataWithTop:(BOOL)isTop{
    UIView *view = [self.view viewWithTag:98765];
    if (view) {
        [view removeFromSuperview];
    }
    BookDetailModel *model = self.cellArray[self.index];
    NSString *requestUrl = [NSString stringWithFormat:@"%@/page/%ld",model.postUrl,(long)self.pageIndex];
    NSString *md5 = [SFTool MD5WithUrl:requestUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [SFNetWork getXmlDataWithURL:requestUrl parameters:nil success:^(id data) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (isTop) {
            [self.dataArray removeAllObjects];
        }
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@class=\"cate-comic-list clearfix\"]"]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
        if (postsParentElement.children.count>0) {
            //遍历其子节点,
            [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                BookModel *newp = [BookModel new];
                ONOXMLElement *aItem = [element firstChildWithXPath:@"p[1]/a"];
                newp.bookUrl= [NSString stringWithFormat:@"%@%@",@"http://www.biqug.org",[aItem valueForAttribute:@"href"]];
                newp.bookIndex = 0;
                [self getBookDetailWithBook:newp];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"没有更多了"];
        }
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"网络请求失败:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createNoNetWorkView];
        });
    }];
}

- (void)getBookDetailWithBook:(BookModel *)book{
    [SFNetWork getXmlDataWithURL:book.bookUrl parameters:nil success:^(id data) {
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        BookModel *newp = [BookModel new];
        newp.bookUrl= book.bookUrl;
        ONOXMLElement *titleItem = [doc firstChildWithXPath:@"//*[@class=\"comic-title j-comic-title\"]"];
        newp.bookTitle= [titleItem stringValue];
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
        [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
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

