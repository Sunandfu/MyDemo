//
//  UIViewController+Extension.h
//  XCFApp
//
//  Created by callmejoejoe on 16/4/17.
//  Copyright © 2016年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

- (void)presentNegotiateWebViewWithURL:(NSString *)URL;
- (void)presentWebViewWithURL:(NSString *)URL Title:(NSString *)title;
- (void)presentWebViewWithURL:(NSString *)URL;
- (void)pushWebViewWithURL:(NSString *)URL Title:(NSString *)title;

@end
