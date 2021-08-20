//
//  PDFWebView.m
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import "PDFWebView.h"

@implementation PDFWebView

- (void)loadPDFFile:(NSURL*)filePath;
{
    _filePath = filePath;
    
    NSString *viwerPath = [[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"html" inDirectory:@"minified/web"];
    NSString *urlStr = [NSString stringWithFormat:@"file://%@?file=%@#page=1",viwerPath,filePath];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self loadRequest:request];
}
@end
