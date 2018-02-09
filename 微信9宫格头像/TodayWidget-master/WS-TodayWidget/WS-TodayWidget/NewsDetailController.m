//
//  NewsDetailController.m
//  水云天
//
//  Created by iMac on 16/6/23.
//  Copyright © 2016年 Sinfotek. All rights reserved.
//

#import "NewsDetailController.h"
#import "AFNetworking.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabbarHeight 49
#define kNavHeight 64

@interface NewsDetailController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) id popGestureDelegate;

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)AFHTTPSessionManager *manager;


@property (nonatomic, strong)UILabel *warningLabel;
@property (nonatomic, strong)UIImageView *warningImageView;


@end

@implementation NewsDetailController {
    
    NSMutableString *titleStr;
    NSString *intro;
    NSString *imgURL;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.popGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.popGestureDelegate action:action];
    popPanGesture.maximumNumberOfTouches = 1;
    popPanGesture.delegate = self;
    [self.view addGestureRecognizer: popPanGesture];
    
    
    _manager = [AFHTTPSessionManager manager];
    
    
    [self initWebView];
    
    
    [self loadNews];//加载新闻
    
    
}


- (void)initWebView {
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.userInteractionEnabled = YES;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
}


- (void)loadNews {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://wangyi.butterfly.mopaasapp.com/detail/api?simpleId=%@",self.newsID];
        [_manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//            NSArray *array = responseObject[@"result"];
//            if (array.count > 0) {
            
                NSDictionary *dic = responseObject;
                
                //新闻的html
                NSMutableString *htmlStr = [[NSMutableString alloc]initWithString:dic[@"content"] ];

                //写一段接收主标题的html字符串,直接拼接到字符串
                titleStr = [dic objectForKey:@"title"];
                NSMutableString *allTitleStr = [NSMutableString stringWithFormat:@"<p><span style=\"line-height:1;font-size:19px;\"><strong>%@</strong></p>",titleStr];
                NSString * newHtmlStr = [allTitleStr stringByAppendingString:htmlStr];
                
                //设置导航栏为当前新闻的名字
                self.navigationItem.title = titleStr;
                
                //加载html
                [_webView loadHTMLString:[self reSizeImageWithHTML:newHtmlStr] baseURL:nil];
                
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
    
}


//牛逼的缩放
- (NSString *)reSizeImageWithHTML:(NSString *)html {
    
    return [NSString stringWithFormat:@"<html><head><style>img{max-width:%f;height:auto !important;width:auto !important;};</style><style>video{max-width:%f;height:auto !important;width:auto !important;};</style></head><body style='margin:8; padding:0;'>%@</body></html>",kScreenWidth-16,kScreenWidth-16, html];
}





- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Prevent Pan Gesture From Right To Left
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) return NO;
    
    // Root View Controller Can Not Begin The Pop Gesture
    if (self.navigationController.viewControllers.count <= 1) return NO;
    
    return YES;
}


@end
