//
//  UIWebView+WebViewAdditions.m
//  MPWebViewLongTap
//
//  Created by Plum on 16/4/26.
//  Copyright © 2016年 ManPao. All rights reserved.
//

#import "UIWebView+WebViewAdditions.h"

@implementation UIWebView (WebViewAdditions)
- (CGSize)windowSize
{
        CGSize size;
        size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
       size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
        return size;
 }

- (CGPoint)scrollOffset
 {
       CGPoint pt;
       pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
         pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
       return pt;
 }
@end
