//
//  ViewController.m
//  JSAndOC
//
//  Created by ZhuJX on 16/4/19.
//  Copyright © 2016年 ZhuJX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>{
    UIWebView * _webView;
    BOOL _buttonCanChick;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _buttonCanChick = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,250, self.view.frame.size.width, self.view.frame.size.height -250)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    [self.view addSubview:_webView];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"JSTest1" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 20, 300, 100);
    [btn setTitle:@"这是iOS原生按钮,用来调用JS方法!" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - HTML开始加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlstr = request.URL.absoluteString;
    NSRange range = [urlstr rangeOfString:@"HelloWorld!"];
    if (range.length!=0) {
        
    }
    NSLog(@"这是JS按钮点击事件被OC捕获 %@",request.URL.absoluteString);
    if([request.URL.absoluteString isEqualToString:@"参加跑团"]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"这是OC代码的弹窗,捕获的URL是 : %@",request.URL.absoluteString] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return YES;
}
#pragma mark - 测试JS代码按钮
-(void)btnDown{
    if(_buttonCanChick == YES){
        [self ocCallJsHasParams];
    }else{
        NSLog(@"现在不能点击");
    }
}

#pragma mark - JS加载完成
-(void)webViewDidFinishLoad:(nonnull UIWebView *)webView{//JS加载完成
    NSLog(@"开始结束");
    //    对于调用js的时候最好这个方法里面或者之后
    _buttonCanChick = YES;
}


#pragma mark - OC调用JS的无参函数
- (void)ocCallJsNoParams {//OC调用JS的无参函数
    NSString *js = [NSString stringWithFormat:@"ocCallJsNoParamsFunction();"];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    
    NSLog(@"123123123123");
}


#pragma mark - OC调用JS带参函数
- (void)ocCallJsHasParams {//OC调用JS带参函数
    NSString *js = [NSString stringWithFormat:@"ocCallJsHasParamsFunction('%@','%@');",@"Hello",@"World"];
    [_webView stringByEvaluatingJavaScriptFromString:js];
}


@end
