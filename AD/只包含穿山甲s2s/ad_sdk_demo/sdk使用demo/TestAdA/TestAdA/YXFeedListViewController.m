//
//  YXFeedListViewController.m
//  TestAdA
//
//  Created by shuai on 2018/10/23.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedListViewController.h"

#import <YXLaunchAds/YXFeedAdManager.h>
#import <YXLaunchAds/YXFeedAdData.h>

#import "AppDelegate.h"
#import "YXFeedAdRegisterView.h"

#import "YXFeedAdTableViewCell.h"

static  NSString * feedMediaID = @"beta_ios_feed";

@interface YXFeedListViewController () <YXFeedAdManagerDelegate ,UITableViewDelegate,UITableViewDataSource>
{
    YXFeedAdManager *feedManager;
}

@property (nonatomic, strong) YXFeedAdRegisterView *registAdView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation YXFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FeedAd";
    
    self.dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < 20; i ++ ) {
        NSString * title = [NSString stringWithFormat:@"Number:%d  临时数据",i];
        [self.dataSource addObject:title];
    }
    
    [self.view addSubview:self.tableView];
    
    [self loadFeedAds];
    
    // Do any additional setup after loading the view.
}

- (YXFeedAdRegisterView *)registAdView
{
    if (!_registAdView) {
        _registAdView =  [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YXFeedAdRegisterView class]) owner:nil options:nil]firstObject];
        _registAdView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 220);
        
    }
    return _registAdView;
}

- (void)initadViewWithData:(YXFeedAdData *)data
{
    //    self.registAdView
    self.registAdView.adTitleLabel.text = data.adTitle;
    [self setImage:self.registAdView.adIconImageView WithURL:[NSURL URLWithString:data.IconUrl] placeholderImage:nil];
    [self setImage:self.registAdView.adImageView WithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:nil];
    self.registAdView.adContentLabel.text = data.adContent;
    if(!data.buttonText){
        [self.registAdView.infoBtn setTitle:@"点击下载" forState:UIControlStateNormal];
    }else{
        [self.registAdView.infoBtn setTitle:data.buttonText forState:UIControlStateNormal];
    }
}
- (void)setImage:(UIImageView*)imageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    NSURLSession *shareSessin = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [shareSessin dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }];
    [dataTask resume];
}

- (UITableView *)tableView
{
    if (!_tableView ) {
        _tableView = ({
            UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerNib:[UINib nibWithNibName:@"YXFeedAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"YXFeedAdTableViewCell"];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
            
            tableView;
        });
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[YXFeedAdData class]]) {
        YXFeedAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXFeedAdTableViewCell" forIndexPath:indexPath];
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        [cell.contentView addSubview:self.registAdView];
        [feedManager registerAdViewForInteraction:self.registAdView];
        
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.textLabel.text = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[YXFeedAdData class]]) {
        return 220; 
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loadFeedAds
{
    feedManager = [YXFeedAdManager new];
    feedManager.adSize = YXADSize690X388;
    feedManager.mediaId = feedMediaID;
    
    feedManager.controller = self;
    feedManager.delegate = self;
    [feedManager loadFeedAd];
    
}



#pragma mark ad delegate
- (void)didLoadFeedAd:(YXFeedAdData *)data
{
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    
    NSUInteger index = rand() % dataSources.count;
    [dataSources insertObject:data atIndex:index];
    self.dataSource = [dataSources copy];
    
    [self initadViewWithData:data];
    
    [self.tableView reloadData];
    
}
- (void)didFeedAdRenderSuccess
{
    
}
-(void)didFailedLoadFeedAd:(NSError *)error
{
    NSLog(@"%@",error);
}
-(void)didClickedFeedAd
{
    NSLog(@"点击");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
