//
//  PDFWebView.h
//  PDFJSReader
//
//  Created by lilu on 2017/5/12.
//  Copyright © 2017年 lilu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface PDFWebView : WKWebView

/**
 pdf file path
 **/
@property (readonly) NSURL *filePath;

/**
 load pdf file

 @param filePath pdf file path
 */
- (void)loadPDFFile:(NSURL *)filePath;
@end
