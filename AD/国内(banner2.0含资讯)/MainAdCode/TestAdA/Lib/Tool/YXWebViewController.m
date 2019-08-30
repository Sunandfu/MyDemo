//
//  WebViewController.m
//  YXLaunchAdExample
//
//  Created by zhuxiaohui on 16/9/8.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/YXLaunchAd
//  广告详情页

#import "YXWebViewController.h"
#import <WebKit/WebKit.h>
#import "YXLaunchAd.h"
#import "Network.h"
#import "NetTool.h"
#import "SFCircleProgress.h"
#import "GetFeedTaskModel.h"
#import "YXLoading.h"

API_AVAILABLE(ios(8.0))
@interface YXWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>
{
    UIWebView * webview;
    NSInteger lengthOfTime;
    CGFloat circleFloat;
}
@property(nonatomic,strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) GetFeedTaskModelData *model;
@property (nonatomic, strong) SFCircleProgress *circleProgress;
@property (nonatomic, assign) CGFloat lastOffset;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation YXWebViewController

-(void)dealloc
{
    /**
     如果你设置了APP从后台恢复时也显示广告,
     当用户停留在广告详情页时,APP从后台恢复时,你不想再次显示启动广告,
     请在广告详情控制器销毁时,发下面通知,告诉YXLaunchAd,广告详情页面已显示完
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdDetailPageShowFinishNotification object:nil];
    
    if (@available(iOS 8.0, *)) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }else{
        [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    circleFloat = 0;
//    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat navbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navStarBarHeight;
    if (self.navigationController) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_leftback"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_close"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
        self.navigationItem.leftBarButtonItems = @[backBtn,closeBtn];
        
        if (self.navigationController.navigationBar.translucent) {
            navStarBarHeight = navbarHeight+44;
            if (self.navigationController.navigationBar.hidden) {
                [self addCustomNavigationWithNavbarHeight:navbarHeight];
            }
        } else {
            if (self.navigationController.navigationBar.hidden) {
                [self addCustomNavigationWithNavbarHeight:navbarHeight];
                navStarBarHeight = navbarHeight+44;
            } else {
                navStarBarHeight = 0;
            }
        }
    } else {
        [self addCustomNavigationWithNavbarHeight:navbarHeight];
        navStarBarHeight = navbarHeight+44;
    }
    if (@available(iOS 8.0, *)) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navStarBarHeight, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-(navbarHeight+44))];
        self.webView.scrollView.delegate = self;
        self.webView.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:self.webView];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        if(!self.URLString) return;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(self.URLString)]];
        [self.webView loadRequest:request];
    } else {
        webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, navStarBarHeight, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-(navbarHeight+44))];
        webview.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:webview];
        [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        if(!self.URLString) return;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:(self.URLString)]];
        [webview loadRequest:request];
    }
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, navStarBarHeight-2, self.view.bounds.size.width, 2)];
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.progressTintColor = [UIColor blackColor];
    [self.view addSubview:self.progressView];
    
    [self getTaskDesc];
}
- (void)addCustomNavigationWithNavbarHeight:(CGFloat)navbarHeight{
    UIView *navVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, navbarHeight + 44)];
    navVIew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navVIew];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    NSString *lang;
    NSString *close;
    if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        lang = @"返回";
        close = @"关闭";
    }else{//非中文
        lang = @"back";
        close = @"close";
    }
    
    UIImage *leftimage = [UIImage imageNamed:@"XibAndPng.bundle/sf_leftback"];
    [button setImage:leftimage forState:UIControlStateNormal];
    
    button.frame = CGRectMake(20,navbarHeight, 30, 44);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [navVIew addSubview:button];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonBack.backgroundColor =[UIColor whiteColor];
    [buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonBack.titleLabel.font = [UIFont systemFontOfSize:15];
    UIImage *closeimage = [UIImage imageNamed:@"XibAndPng.bundle/sf_close"];
    [buttonBack setImage:closeimage forState:UIControlStateNormal];
    
    buttonBack.frame = CGRectMake(60,navbarHeight, 30, 44);
    [buttonBack addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    
    [navVIew addSubview:buttonBack];
    
}
-(NSString*)currentLanguage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /**
     如果你设置了APP从后台恢复时也显示广告,
     当用户停留在广告详情页时,APP从后台恢复时,你不想再次显示启动广告,
     请在广告详情控制器将要显示时,发下面通知,告诉YXLaunchAd,广告详情页面将要显示
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:YXLaunchAdDetailPageWillShowNotification object:nil];
    if (!self.show) {
        lengthOfTime = [[NSDate date] timeIntervalSince1970];
        return;
    }
    
    if (nil!=[YXAdSDKManager defaultManager].webCustomView) {
        NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:[YXAdSDKManager defaultManager].webCustomView];
        UIView *redView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        redView.autoresizesSubviews =YES;
        for (UIView *view in redView.subviews) {
            view.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin   |
            UIViewAutoresizingFlexibleWidth        |
            UIViewAutoresizingFlexibleRightMargin  |
            UIViewAutoresizingFlexibleTopMargin    |
            UIViewAutoresizingFlexibleHeight       |
            UIViewAutoresizingFlexibleBottomMargin ;
        }
        redView.frame = CGRectMake(SF_ScreenW-redView.bounds.size.width-10, SF_ScreenH-SF_TabbarHeight-redView.bounds.size.height-10, redView.bounds.size.width, redView.bounds.size.height);
        redView.tag = 998;
        redView.layer.masksToBounds = YES;
        redView.layer.cornerRadius = (redView.bounds.size.height<redView.bounds.size.width?redView.bounds.size.height:redView.bounds.size.width)/2.0;
        redView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewClick)];
        [redView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:redView];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.progressView removeFromSuperview];
    if (!self.show) {
        NSTimeInterval tmpDisTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval time = tmpDisTime - lengthOfTime;
        [Network newsStatisticsWithType:4 NewsID:self.newsIdStr CatID:self.catIdStr lengthOfTime:time>300?300:time];
        return;
    }
    UIView *redView = [[UIApplication sharedApplication].keyWindow viewWithTag:998];
    [redView removeFromSuperview];
}
- (void)customViewClick{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customWebViewClicked)]) {
        [self.delegate customWebViewClicked];
    }
}
- (void)backToHome
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)backAction
{
    if (@available(iOS 8.0, *)) {
        if([_webView canGoBack]) {
            [_webView goBack];
        } else {
            [self backToHome];
        }
    } else{
        [self backToHome];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.progressView setProgress:progress animated:YES];
        if(progress == 1.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.progressView setProgress:0.0 animated:NO];
            });
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getTaskDesc{
    NSString *channel = [[NSUserDefaults standardUserDefaults] objectForKey:KeyChannel];
    NSString *vuid = [[NSUserDefaults standardUserDefaults] objectForKey:KeyVuid];
    NSDictionary *parameterDict = @{
                                    @"deviceType":@"1",
                                    @"osType":@"2",
                                    @"osVersion":[NetTool getOS],
                                    @"vendor":@"apple",
                                    @"brand":@"apple",
                                    @"model":[NetTool gettelModel],
                                    @"imei":@"",
                                    @"androidId":@"",
                                    @"idfa":[NetTool getIDFA],
                                    @"connectionType":@([NetTool getNetTyepe]),
                                    @"operateType":@([NetTool getYunYingShang]),
                                    };
    __weak typeof(self) weakSelf = self;
    [Network postJSONDataWithURL:[NSString stringWithFormat:@"%@/task/getFeedTask?channel=%@&&vuid=%@&feed_id=%@",TASK_SEVERIN,channel?channel:@"",vuid?vuid:@"",self.newsIdStr?self.newsIdStr:@""] parameters:parameterDict success:^(id json) {
        GetFeedTaskModel *model = [GetFeedTaskModel SF_MJParse:json];
        if (model.code == 200) {
            weakSelf.model = [model.data firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.webView.scrollView.delegate = self;
                self->webview.scrollView.delegate = self;
                [weakSelf showCircleProgress];
            });
        } else {
//            NSLog(@"接口请求失败 message = %@",model.msg);
        }
    } fail:^(NSError *error) {
//        NSLog(@"网络请求错误 error = %@",error);
    }];
}
- (SFCircleProgress *)circleProgress{
    if (_circleProgress==nil) {
        _circleProgress = [[SFCircleProgress alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height-self.tabBarController.tabBar.bounds.size.height-70, 43, 43) progress:0.0];
        _circleProgress.bottomColor = [UIColor whiteColor];
        _circleProgress.topColor = HColor(255, 102, 26, 1);
        _circleProgress.progressWidth = 6.0;
    }
    return _circleProgress;
}
- (void)showCircleProgress{
    [self.view addSubview:self.circleProgress];
    UIImageView *jinbiImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
    jinbiImg.image = [UIImage imageNamed:@"XibAndPng.bundle/readNews"];
    [self.circleProgress addSubview:jinbiImg];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
    if (self.lastOffset != offset) {
        if (circleFloat<1.0) {
            [self progressRunWithTime:self.model.scroll_time.integerValue TotalTime:self.model.cost_time.integerValue];
        }
    }
    self.lastOffset = offset;
}
- (void)progressRunWithTime:(NSInteger)time TotalTime:(NSInteger)totalTime{
    time = time*10;
    if (self.count+10>time) {
        return;
    }
    self.count = time;
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    CGFloat sunID = 1.0/(totalTime * 10);
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建一个定时器（dispatch_source_t本质上还是一个OC对象）
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //设置定时器的各种属性
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100*NSEC_PER_MSEC));
    uint64_t interval = (uint64_t)(100*NSEC_PER_MSEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    //设置回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        self->circleFloat = self->circleFloat + sunID;
        weakSelf.count -= 1;
        //定时器需要执行的操作
        [weakSelf.circleProgress setProgress:self->circleFloat];
        if (weakSelf.count <= 0 || self->circleFloat>=1.0) {
            dispatch_cancel(weakSelf.timer);
            weakSelf.timer = nil;
            if (self->circleFloat>=1.0) {
                [weakSelf.circleProgress removeFromSuperview];
                [weakSelf showSuccessOrError];
            }
        }
    });
    //启动定时器（默认是暂停）
    dispatch_resume(self.timer);
}
- (void)showSuccessOrError{
    [Network getJSONDataWithURL:self.model.complete_url parameters:nil success:^(id json) {
        NSDictionary *dict = json;
        if ([dict[@"msg"] isEqualToString:@"success"]) {
            NSString *dataStr = [NSString stringWithFormat:@"%@",dict[@"data"]];
            [YXLoading showStatus:dataStr];
        } else {
//            NSLog(@"接口返回错误 error message = %@",dict[@"msg"]);
            [YXLoading showStatus:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
//        NSLog(@"网络错误 error = %@",error);
    }];
}

@end
