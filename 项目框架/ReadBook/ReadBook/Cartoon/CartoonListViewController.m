//
//  CartoonListViewController.m
//  ReadBook
//
//  Created by lurich on 2020/6/16.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "CartoonListViewController.h"
#import "SFTool.h"
#import "BookModel.h"
#import "CartoonDetailViewController.h"
#import "SFMoreCartoonViewController.h"

@interface CartoonListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CartoonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self getCartoonData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多漫画" style:UIBarButtonItemStyleDone target:self action:@selector(goMoreCartoonPage)];
}
- (void)updateFrameWithSize:(CGSize)size{
    [self.tableView removeFromSuperview];
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height-self.tabBarController.tabBar.bounds.size.height);
    [self.view addSubview:self.tableView];
}

- (void)goMoreCartoonPage{
    SFMoreCartoonViewController *moreVC = [SFMoreCartoonViewController new];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (UIView *)tableViewHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//        _tableView.tableHeaderView = [self tableViewHeaderView];
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
    BookModel *model = self.dataArray[indexPath.row];
    [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:model.bookIcon]] placeholder:[UIImage imageNamed:@"noBookImg"]];
    cell.contentLabel.text = model.bookSynopsis;
    cell.titleLabel.text = model.bookTitle;
    cell.nameLabel.text = model.bookAuthor;
    cell.bookType.text = @"漫画";
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
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"缓存漫画" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        BookModel *model = self.dataArray[indexPath.row];
        [self cacheBookWithBook:model];
    }];
    action.backgroundColor = [UIColor orangeColor];
    return @[action];
}
- (void)cacheBookWithBook:(BookModel *)book{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SFNetWork getXmlDataWithURL:book.bookUrl parameters:nil success:^(id data) {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [SFNetWork cacheCartoonWithModelArray:tmpArray XPatn:book.bookContent?book.bookContent:@"//*[@id=\"content\"]"];
        });
    } fail:^(NSError *error) {
        NSLog(@"网络请求失败:%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

- (void)getCartoonData{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SFNetWork getXmlDataWithURL:@"https://www.nitianxieshen.com/manhua/" parameters:nil success:^(id data) {
        [self.dataArray removeAllObjects];
        //下载网页数据
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:nil];
        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@class=\"table table-striped table-hover\"]/tbody"]; //寻找该 XPath 代表的 HTML 节点,////*[@id="fj_1"]
        //遍历其子节点,
        [postsParentElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            BookModel *newp = [BookModel new];
            ONOXMLElement *image = [element firstChildWithXPath:@"a/img"];
            NSString *imgUrl = [image valueForAttribute:@"src"];
            if (![imgUrl hasPrefix:@"http"]) {
                newp.bookIcon = [NSString stringWithFormat:@"%@%@",@"https://www.nitianxieshen.com",imgUrl];
            } else {
                newp.bookIcon = imgUrl;
            }
            ONOXMLElement *aItem = [element firstChildWithXPath:@"td[1]/a"];
            newp.bookUrl= [NSString stringWithFormat:@"%@%@",@"https://www.nitianxieshen.com",[aItem valueForAttribute:@"href"]];
            ONOXMLElement *spanItem = [element firstChildWithXPath:@"td[2]"];
            NSString *bookAuthor = [SFTool sf_stringRemoveSpecialCharactersOfString:[spanItem stringValue]];
            if ([bookAuthor hasPrefix:@"作者"]) {
                newp.bookAuthor= [NSString stringWithFormat:@"%@",bookAuthor];
            } else {
                newp.bookAuthor= [NSString stringWithFormat:@"作者：%@",bookAuthor];
            }
            newp.bookTitle= [aItem stringValue];
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
//        ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@class=\"m-book_info\"]"];
        BookModel *newp = [BookModel new];
        newp.bookUrl= book.bookUrl;
        newp.bookAuthor= book.bookAuthor;
        newp.bookTitle= book.bookTitle;
        ONOXMLElement *image = [doc firstChildWithXPath:@"//*[@class=\"m-book_info\"]/div/div/a/img"];
        NSString *imgUrl = [image valueForAttribute:@"src"];
        if (![imgUrl hasPrefix:@"http"]) {
            newp.bookIcon = [NSString stringWithFormat:@"%@%@",@"https://www.nitianxieshen.com",imgUrl];
        } else {
            newp.bookIcon = imgUrl;
        }
        ONOXMLElement *synopsis = [doc firstChildWithXPath:@"//*[@class=\"m-book_info\"]/p"];
        NSString *bookSynopsis = [SFTool sf_stringRemoveSpecialCharactersOfString:[synopsis stringValue]];
        if ([bookSynopsis hasPrefix:@"简介"]) {
            newp.bookSynopsis= [NSString stringWithFormat:@"%@",bookSynopsis];
        } else {
            newp.bookSynopsis= [NSString stringWithFormat:@"简介：%@",bookSynopsis];
        }
        newp.bookIndex = 0;
        newp.bookCatalog = @"//*[@id=\"play_0\"]/ul";
        newp.bookContent = @"//*[@id=\"content\"]";
        newp.other1 = @"https://www.nitianxieshen.com";
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
        CartoonDetailViewController *detailVc = [[CartoonDetailViewController alloc] init];
        detailVc.cellArray = [self sortArrayWithArray:tmpArray];
        detailVc.bookModel = book;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    });
}
- (NSArray *)sortArrayWithArray:(NSArray *)array{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger i=array.count-1; i>=0; i--) {
        BookDetailModel *newp = array[i];
        [tmpArray addObject:newp];
    }
    return tmpArray;;
}

@end
