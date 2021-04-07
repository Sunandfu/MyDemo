//
//  SFMovieDetailViewController.m
//  ReadBook
//
//  Created by lurich on 2020/10/14.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMovieDetailViewController.h"
#import "SFBookSetTableViewCell.h"
#import "SFMovieHeaderView.h"
#import "BaiduMobStatForSDK.h"

@interface SFMovieDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSDictionary *jsonDict;

@end

@implementation SFMovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频详情";
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    [self getMovieData];
}
- (void)updateFrameWithSize:(CGSize)size{
    self.tableView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (UIView *)tableViewHeaderView{
    SFMovieHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"SFMovieHeaderView" owner:nil options:nil] firstObject];
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    [headerView.iconViewImg yy_setImageWithURL:[NSURL URLWithString:[SFTool URLEncodedString:self.jsonDict[@"Cover"]?self.jsonDict[@"Cover"]:@""]] placeholder:[UIImage imageNamed:@"noBookImg"]];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@",self.jsonDict[@"Name"]?self.jsonDict[@"Name"]:@""];
    headerView.detailLabel.text = [NSString stringWithFormat:@"%@",self.jsonDict[@"Tags"]?self.jsonDict[@"Tags"]:@""];
    headerView.yearLabel.text = [NSString stringWithFormat:@"%@",self.jsonDict[@"Year"]?self.jsonDict[@"Year"]:@""];
    NSString *score = [NSString stringWithFormat:@"%@",self.jsonDict[@"Score"]?self.jsonDict[@"Score"]:@""];
    if (score.floatValue>0.0) {
        headerView.scoreLabel.text = [NSString stringWithFormat:@"评分：%@",score];
        headerView.scoreLabel.hidden = NO;
    } else {
        headerView.scoreLabel.text = @"";
        headerView.scoreLabel.hidden = YES;
    }
    headerView.typeLabel.text = [NSString stringWithFormat:@"%@",self.jsonDict[@"Type"]?self.jsonDict[@"Type"]:@""];
    headerView.contentLabel.text = [NSString stringWithFormat:@"%@",self.jsonDict[@"Introduction"]?self.jsonDict[@"Introduction"]:@""];
    return headerView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44), self.view.bounds.size.width, self.view.bounds.size.height-([SFSafeAreaInsets shareInstance].safeAreaInsets.top+44)) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count>0) {
        tableView.tableHeaderView = [self tableViewHeaderView];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFBookSetTableViewCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"SFBookSetTableViewCellIDlastObject0"];
    if (!otherCell) {
        otherCell = [[NSBundle mainBundle] loadNibNamed:@"SFBookSetTableViewCell" owner:nil options:nil][0];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    otherCell.nameLabel.text = dict[@"Name"];
    otherCell.chooseLabel.text = @"";
    return otherCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (dict[@"PlayUrl"]) {
        NSString *videoUrl = dict[@"PlayUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:videoUrl] options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"打开成功");
                [[BaiduMobStatForSDK defaultStat] logEvent:@"LookVideoClick" eventLabel:[NSString stringWithFormat:@"%@-%@",self.jsonDict[@"Name"],dict[@"Name"]] withAppId:@"718527995f"];
            }
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"该视频链接已失效"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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

- (void)getMovieData{
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url = [NSString stringWithFormat:@"http://api.skyrj.com/api/movie?id=%@",self.movieId];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    request.HTTPMethod = @"GET";
    request.allHTTPHeaderFields = @{@"Content-Type":@"application/json"};
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    request.timeoutInterval = 5;
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        if (data) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            self.dataArray = jsonDict[@"MoviePlayUrls"];
            self.jsonDict = jsonDict;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else if (error) {
            NSLog(@"请求接口出错：error = %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"接口请求错误"];
            });
        }
    }];
    [task resume];
}

@end
