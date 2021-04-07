//
//  BookListViewController.m
//  ReadBook
//
//  Created by lurich on 2020/5/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "BookListViewController.h"
#import "SFReadViewController.h"

@interface BookListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy  ) NSString *nextUrl;

@end

@implementation BookListViewController

- (void)sf_viewDidLoadForIndex:(NSInteger)index {
    self.dataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BookTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookTableViewCellID"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.tableFooterView = [UIView new];
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
    self.view.frame = CGRectMake(0, 0, size.width, size.height-self.tabBarController.tabBar.bounds.size.height);
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height-self.tabBarController.tabBar.bounds.size.height);
    [self.tableView reloadData];
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
    NSString *requestUrl;
    if (isTop) {
        requestUrl = [NSString stringWithFormat:@"%@",model.postUrl];
    } else {
        requestUrl = self.nextUrl;
    }
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
        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@id=\"main\"]"]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
        //遍历其子节点,
        [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[element tag] isEqualToString:@"div"]) {
                BookModel *newp = [BookModel new];
                ONOXMLElement *image = [element firstChildWithXPath:@"a/img"];
                NSString *imgUrl = [image valueForAttribute:@"src"];
                if (![imgUrl hasPrefix:@"http"]) {
                    newp.bookIcon = [NSString stringWithFormat:@"%@%@",@"https://wap.xsbiquge.com",imgUrl];
                } else {
                    newp.bookIcon = imgUrl;
                }
                ONOXMLElement *aItem = [element firstChildWithXPath:@"a"];
                newp.bookUrl= [NSString stringWithFormat:@"%@%@",@"https://www.xsbiquge.com",[aItem valueForAttribute:@"href"]];
                ONOXMLElement *spanItem = [element firstChildWithXPath:@"a/p[2]"];
                NSString *bookAuthor = [SFTool sf_stringRemoveSpecialCharactersOfString:[spanItem stringValue]];
                if ([bookAuthor hasPrefix:@"作者"]) {
                    newp.bookAuthor= [NSString stringWithFormat:@"%@",bookAuthor];
                } else {
                    newp.bookAuthor= [NSString stringWithFormat:@"作者：%@",bookAuthor];
                }
                ONOXMLElement *titleItem = [element firstChildWithXPath:@"a/p[1]"];
                newp.bookTitle= [titleItem stringValue];
                ONOXMLElement *descItem1 = [element firstChildWithXPath:@"p[1]"];
                ONOXMLElement *descItem2 = [element firstChildWithXPath:@"p[2]"];
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
                newp.bookCatalog = @"//*[@id=\"list\"]/dl";
                newp.bookContent = @"//*[@id=\"content\"]";
                newp.other1 = @"https://www.xsbiquge.com";
                newp.other2 = @"小说";
                [self.dataArray addObject:newp];
            }
        }];
        ONOXMLElement *nextParentElement= [doc firstChildWithXPath:@"//*[@class=\"current\"]"];
        self.nextUrl = [NSString stringWithFormat:@"%@%@",@"https://wap.xsbiquge.com",[nextParentElement valueForAttribute:@"href"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"网络请求失败:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createNoNetWorkView];
        });
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
    BookModel *model = self.dataArray[indexPath.row];
    [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
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

- (void)getBookMenuWithBook:(BookModel *)book{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *md5 = [SFTool MD5WithUrl:book.bookUrl];
    NSString *cachePath = [SFNetWork cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    }
    [SFNetWork getXmlDataWithURL:book.bookUrl parameters:nil success:^(id data) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@id=\"list\"]/dl"]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
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

@end
