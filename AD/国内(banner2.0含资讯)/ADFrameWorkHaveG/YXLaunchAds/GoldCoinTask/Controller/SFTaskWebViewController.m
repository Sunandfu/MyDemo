//
//  SFWebViewController.m
//  fitness
//
//  Created by 小富 on 2017/7/19.
//  Copyright © 2017年 YunXiang. All rights reserved.
//

#import "SFTaskWebViewController.h"
#import "WebKit/WebKit.h"
#import "MJRefresh.h"

//竖屏幕宽高
#define DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//IPhoneX IPhoneXS 的逻辑分辨率相同
#define IPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)

//IPhoneXR IPhoneXSMax 的逻辑分辨率相同
#define IPhoneXR CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size)

//导航栏
#define StatusBarHeight ((IPhoneX || IPhoneXR) ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight ((IPhoneX || IPhoneXR) ? 88.f : 64.f)
#define TabbarHeight ((IPhoneX || IPhoneXR) ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight ((IPhoneX || IPhoneXR) ? (34.f) : (0.f))

@interface SFTaskWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSDictionary *jsonDict;

@end

@implementation SFTaskWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self removeJsMessageHandlers];
//    [self addJsMessageHandlers];
}
- (void)addJsMessageHandlers{
    [self.webView.configuration.userContentController addScriptMessageHandler:self  name:@"Browser"];
}
- (void)removeJsMessageHandlers{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Browser"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
//    self.navigationController.tabBarController.tabBar.hidden = NO;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jsonDict = [NSDictionary dictionary];
    
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
    //注册供js调用的方法
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self  name:@"Browser"];
    config.preferences.javaScriptEnabled = YES;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navStarBarHeight, DEVICE_WIDTH, DEVICE_HEIGHT-navStarBarHeight) configuration:config];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSURL *url;
    if (self.urlStr==nil) {
        return;
    }
    if ([self.urlStr hasPrefix:@"http"]) {
        if (@available(iOS 9.0, *)) {
            self.urlStr = [self.urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            self.urlStr = [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
        }
        url = [NSURL URLWithString:self.urlStr];
    } else {
        url = [NSURL fileURLWithPath:self.urlStr];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self cleanCacheAndCookie];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)backToHome {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //获取当前页面的title
    if (self.webTitle) {
        self.title = self.webTitle;
    } else {
        self.title = webView.title;
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
//    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
/*
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
*/
- (void)dealloc {
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;
    [self.webView stopLoading];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Browser"];
}
- (UIWindow *)window
{
    return [UIApplication sharedApplication].delegate.window;
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}
#pragma mark -  实现注册的供js调用的oc方法 关键
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    //message.body : js 传过来值
//    NSLog(@"didReceiveScriptMessage = %@",message.body);
    if(message.name == nil || [message.name isEqualToString:@""]){
        return;
    }
    //message.name  js发送的方法名称
    //每个方法传不传参数, 传什么类型的参数, 需要和后台确定
    if([message.name  isEqualToString:@"Browser"]){
        NSDictionary *Dic = message.body;
        //获取 js 传来的参数
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [Dic objectForKey:@"body"] ]]];
    }
}
-(void)reloadDayTableDate{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlStr]]];//创
    [self.webView loadRequest:request];//加载
    [self.webView.scrollView.mj_header endRefreshing];
}

@end
