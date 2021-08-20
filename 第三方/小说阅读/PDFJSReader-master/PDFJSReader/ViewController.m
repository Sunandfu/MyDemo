//
//  ViewController.m
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import "ViewController.h"
#import "PDFWebView.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.preferences setValue:@"TRUE" forKey:@"allowFileAccessFromFileURLs"];
    PDFWebView *webView = [[PDFWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.view addSubview:webView];
    NSURL *pdfFileURL = [[NSBundle mainBundle] URLForResource:@"git.pdf" withExtension:nil];
    [webView loadPDFFile:pdfFileURL];
}
@end
