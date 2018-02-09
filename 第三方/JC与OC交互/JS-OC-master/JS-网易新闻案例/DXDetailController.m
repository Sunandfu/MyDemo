//
//  DXDetailController.m
//  JS-网易新闻案例
//
//  Created by xiongdexi on 15/12/6.
//  Copyright © 2015年 DXSmile. All rights reserved.
//

#import "DXDetailController.h"
#import "DXHTTPManager.h"
#import "DXHeadline.h"
#import "DXDetail.h"
#import "DXDetailImg.h"
#import "MJExtension.h"
#import "DXStatusBarHUD.h"
#import "DXDetailTool.h"


@interface DXDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

// 模型属性
@property (nonatomic, strong) DXDetail *dtl;

@end

@implementation DXDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新闻详情";

    self.webView.delegate = self;

    [self getUpData:self.headline.docid];
    
}

#pragma mark - 发送get请求 获取数据

- (void)getUpData:(NSString *) docid {
    
    [DXDetailTool detailWithDicid:docid successBlock:^(DXDetail *tetail) {
        self.dtl = tetail;     
        // 显示到页面
        [self showDetailForWebView];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"链接出错 %@", error);
    }];
  
}

#pragma mark - 拼接html,显示数据到webView上
 /** 显示到webView上 */
- (void)showDetailForWebView {
    NSMutableString *html = [NSMutableString string];
    // 拼接html代码
    [html appendString:@"<html>"];

    [html appendString:@"<head>"];
    
    // 引入css文件
    NSURL *path = [[NSBundle mainBundle]URLForResource:@"DXDetail.css" withExtension:nil];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", path];

    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    
    // 将图片插入插入body对应的标记中
    [html appendString:[self setupBody]];
    
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    // 显示网页
    [self.webView loadHTMLString:html baseURL:nil];
    

}

/** 拼接body的内容  (也就是初始化body内容) */
- (NSString *)setupBody {
    
    NSMutableString *bodyM = [NSMutableString string];
   
    // 拼接标题
    [bodyM appendFormat:@"<div class=\"title\">%@</div>", self.dtl.title];
    
    // 拼接时间
    [bodyM appendFormat:@"<div class=\"time\">%@</div>",self.dtl.ptime];
    
    // 拼接图片
    [bodyM appendString:self.dtl.body];
    
    for (DXDetailImg *img in self.dtl.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        
        NSArray *pixel = [img.pixel componentsSeparatedByString:@"*"];
        int width = [[pixel firstObject] intValue];
        int height = [[pixel lastObject] intValue];
        int maxWidth = [UIScreen mainScreen].bounds.size.width * 0.8;

        if (width > maxWidth) {
            height = height * maxWidth / width;
            width = maxWidth;
        }
     
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        NSString *onload = @"this.onclick = function() {"
                            "window.location.href = 'dx://?src=' + this.src;"
                            "};";
        
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%d\" height=\"%d\" src=\"%@\">",onload, width, height, img.src];
        
        [imgHtml appendString:@"</div>"];
        
        [bodyM replaceOccurrencesOfString:img.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, bodyM.length)];

    }
    
    return bodyM;
}

#pragma mark - 用户点击图片后的事件 JS与OC代码的交互
/** 图片保存到相册 */
- (void)saveImageToAlbum:(NSString *)imgSrc {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您是否需要将图片保存到相册?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self saveToAlbum:imgSrc];
      
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - 保存图片到相册
- (void)saveToAlbum:(NSString *)imgSrc {
    NSURLCache *cache = [NSURLCache sharedURLCache];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgSrc]];
    NSCachedURLResponse *response = [cache cachedResponseForRequest:request];
    NSData *imageData = response.data;
    
    UIImage *image = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存图片失败");
        [DXStatusBarHUD showError:@"图片保存失败"];
        
    } else {

        [DXStatusBarHUD showSuccess:@"保存图片成功"];
        
    }
    
}

#pragma mark - 实现<UIWebViewDelegate>的代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"dx://?src="];
    if (range.length > 0) {
        NSUInteger loc = range.location + range.length;
        NSString *imgSrc = [url substringFromIndex:loc];
        [self saveImageToAlbum:imgSrc];
        return NO;
    }
  
    return YES;
}


@end
