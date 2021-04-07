//
//  SFMovieListViewController.m
//  ReadBook
//
//  Created by lurich on 2020/10/13.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMovieListViewController.h"
#import "SFMovieCollectionViewCell.h"
#import "SFMovieDetailViewController.h"

@interface SFMovieListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>{
    BOOL isFirst;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, strong) UITextField *keyWords;
@property (nonatomic, strong) UIView *top;

@end

@implementation SFMovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = YES;
    self.title = @"搜索视频";
    self.dataArray = @[];
    // Do any additional setup after loading the view.
    [self createSearchView];
    [self.view addSubview:self.collectionView];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)updateFrameWithSize:(CGSize)size{
    if (size.width>size.height) {
        self.top.frame = CGRectMake(0, 44, size.width, 60);
        self.collectionView.frame = CGRectMake(0, 44+60, size.width, size.height-60-44);
    } else {
        self.top.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), size.width, 60);
        self.collectionView.frame = CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+60, size.width, size.height-60-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44));
    }
    UIView *bar = [self.top viewWithTag:1];
    bar.frame = CGRectMake(15, 10, size.width-30, 40);
    UIButton *btn = [self.top viewWithTag:2];
    btn.frame = CGRectMake(CGRectGetWidth(bar.frame)-40, 0, 40, 40);
    self.keyWords.frame = CGRectMake(15, 0, CGRectGetWidth(bar.frame)-15-40, 40);
    [self.collectionView reloadData];
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
    keywords.placeholder = @"请输入电视剧名或电影名";
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
    isFirst = NO;
    [self.keyWords resignFirstResponder];
    [self getMovieData];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((self.view.bounds.size.width-60)/3.0, 230);
        layout.minimumInteritemSpacing = 10.0f;
        layout.minimumLineSpacing = 10.0f;
        layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)+60, self.view.bounds.size.width, self.view.bounds.size.height-60-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"SFMovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SFMovieCollectionViewCellID"];
        
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //垂直
            _collectionView.showsVerticalScrollIndicator = YES;
            _collectionView.showsHorizontalScrollIndicator = NO;
        } else {
            _collectionView.showsHorizontalScrollIndicator = YES;
            _collectionView.showsVerticalScrollIndicator = NO;
        }
    }
    return _collectionView;
}

- (void)createNoNetWorkView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)];
    footerView.tag = 5656;
    UILabel *label1 = [[UILabel alloc] initWithFrame:footerView.bounds];
    label1.textAlignment = NSTextAlignmentCenter;
    if (isFirst) {
        label1.text = @"在搜索框中输入关键词搜索\n\n可搜索电影、电视剧等热门视频";
    } else {
        label1.text = @"当前搜索结果为空哦\n\n换个关键词继续搜索吧";
    }
    label1.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    label1.numberOfLines = 0;
    [footerView addSubview:label1];
    [self.collectionView addSubview:footerView];
}
#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArray.count==0) {
        [self createNoNetWorkView];
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFMovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SFMovieCollectionViewCellID" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell.iconImgView yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:dict[@"Cover"]?dict[@"Cover"]:@""]] placeholder:[UIImage imageNamed:@"noBookImg"]];
    cell.titleLabel.text = dict[@"Name"];
    cell.nameLabel.text = dict[@"Tags"];
    cell.typeWidth.constant = [SFTool getWidthWithText:dict[@"MovieTitle"] height:cell.bookType.bounds.size.height font:cell.bookType.font]+5;
    cell.bookType.text = dict[@"MovieTitle"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (dict[@"ID"]) {
        SFMovieDetailViewController *detailVC = [SFMovieDetailViewController new];
        detailVC.movieId = [NSString stringWithFormat:@"%@",dict[@"ID"]];
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"该视频暂未更新"];
    }
}
- (void)getMovieData{
    UIView *footerView = [self.collectionView viewWithTag:5656];
    [footerView removeFromSuperview];
    NSString *url = [NSString stringWithFormat:@"http://api.skyrj.com/api/movies?searchKey=%@",self.keyWords.text];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            self.dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } else if (error) {
            NSLog(@"请求接口出错：error = %@",error);
        }
    }];
    [task resume];
}

@end
