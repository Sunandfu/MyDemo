//
//  YXFeedAdViewController.m
//  LunchAd
//
//  Created by shuai on 2018/10/14.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedAdViewController.h"
#import <YXLaunchAds/YXFeedAdManager.h>

#import "AppDelegate.h"
#import "YXFeedAdRegisterView.h"

#import "YXFeedAdTableViewCell.h"

static  NSString * feedMediaID = @"beta_ios_native";

@interface YXFeedAdViewController () <YXFeedAdManagerDelegate ,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) YXFeedAdManager *feedManager;

@property (nonatomic, strong) YXFeedAdRegisterView *registAdView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation YXFeedAdViewController

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

- (void)initadViewWithData:(YXFeedAdData *)data adView:(YXFeedAdRegisterView*)adView
{
    //    self.registAdView
    adView.adTitleLabel.text = data.adTitle;
    [self setImage:adView.adIconImageView WithURL:[NSURL URLWithString:data.IconUrl] placeholderImage:nil];
    [self setImage:adView.adImageView WithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:nil];
    adView.adContentLabel.text = data.adContent;
    if(!data.buttonText){
        [adView.infoBtn setTitle:@"点击下载" forState:UIControlStateNormal];
    }else{
        [adView.infoBtn setTitle:data.buttonText forState:UIControlStateNormal];
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
        YXFeedAdRegisterView * adregistAdView =  [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YXFeedAdRegisterView class]) owner:nil options:nil]firstObject];
        adregistAdView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 220);
        
//        [_feedManager registerAdViewForInteraction:adregistAdView adData:model];
        [_feedManager registerAdViewForInCell:cell adData:model];
        
        [self initadViewWithData:model adView:adregistAdView];
        
        [cell.contentView addSubview:adregistAdView];
        
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
    _feedManager = [YXFeedAdManager new];
    _feedManager.adSize = YXADSize690X388;
    _feedManager.mediaId = feedMediaID;
    _feedManager.controller = self;
    _feedManager.delegate = self;
    _feedManager.adCount = 1;
    
    [_feedManager loadFeedAd];
    
}

#pragma mark ad delegate
- (void)didLoadFeedAd:(NSArray<YXFeedAdData *> *)data
{
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    if (data.count > 0) {
        for (YXFeedAdData * model in data) {
            NSUInteger index = rand() % dataSources.count;
            [dataSources insertObject:model atIndex:index];
            self.dataSource = [dataSources copy];
        }
        [self.tableView reloadData];
    }
    
    
    
    
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

- (void)dealloc
{
    NSLog(@"%@ %@",[self class],NSStringFromSelector(_cmd));
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
