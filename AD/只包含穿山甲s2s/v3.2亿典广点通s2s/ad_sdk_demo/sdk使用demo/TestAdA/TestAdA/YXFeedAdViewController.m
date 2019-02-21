//
//  YXFeedAdViewController.m
//  LunchAd
//
//  Created by shuai on 2018/10/14.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedAdViewController.h"

#import "AppDelegate.h"

#import <YXLaunchAds/YXFeedAdManager.h>
#import "YXFeedAdRegisterView.h"

static  NSString * feedMediaID = @"yst_ios_native";

@interface YXFeedAdViewController () <YXFeedAdManagerDelegate >
{
    YXFeedAdManager *feedManager;
}

@property (nonatomic, strong) YXFeedAdRegisterView *registAdView;

@end

@implementation YXFeedAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FeedAd";
    
    
    
    
    UIButton *feedAdBtn = ({
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 400, [UIScreen mainScreen].bounds.size.width - 100, 40)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"FeedADTest" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(feedAdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:feedAdBtn];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)feedAdBtnClicked
{
    feedManager = nil;
    [self.registAdView removeFromSuperview];
    
    [self.view addSubview:self.registAdView];
    [self loadFeedAds];
    
}
- (void)closeFeedAd
{
    feedManager = nil;
    [self.registAdView removeFromSuperview];
}


- (void)loadFeedAds
{
    feedManager = [YXFeedAdManager new];
    feedManager.adSize = YXADSize690X388;
    feedManager.mediaId = feedMediaID;
    
    feedManager.controller = self;
    feedManager.delegate = self;
    feedManager.adCount = 1;
    [feedManager loadFeedAd];
}
- (YXFeedAdRegisterView *)registAdView
{
    if (!_registAdView) {
        _registAdView =  [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([YXFeedAdRegisterView class]) owner:nil options:nil]firstObject];
        _registAdView.frame = CGRectMake(0, 80, self.view.bounds.size.width, 200);

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
#pragma mark ad delegate
- (void)didLoadFeedAd:(NSArray<YXFeedAdData *> *)data
{
    YXFeedAdData * adData = [data lastObject];
    [self initadViewWithData:adData];
    [feedManager registerAdViewForInteraction:self.registAdView adData:adData];
    
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
