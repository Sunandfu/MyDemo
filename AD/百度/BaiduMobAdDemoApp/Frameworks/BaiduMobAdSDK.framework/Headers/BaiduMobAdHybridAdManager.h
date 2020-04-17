//
//  BaiduMobAdHybridAdManager.h
//  XAdSDKDevSample
//
//  Created by lishan04 on 09/04/2018.
//  Copyright © 2018 Baidu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol BaiduMobAdHybridAdManagerDelegate <NSObject>

@optional
/**
 *  广告展示失败
 */
- (void)failedDisplayAd;

/**
 *  广告展示成功
 */
- (void)didAdImpressed;

/**
 *  广告点击
 */
- (void)didAdClicked;

@end

@interface BaiduMobAdHybridAdManager: NSObject

@property (nonatomic, copy) NSString *publisherId;
@property (nonatomic, weak) id <BaiduMobAdHybridAdManagerDelegate> delegate;


//重要，把wkwebview传给BaiduMobAdHybridAdManager进行注册
- (void)injectJavaScriptBridgeForWKWebView:(WKWebView *)webview;

//重要，在wkwebview回调时通知BaiduMobAdHybridAdManager，返回是否继续加载
- (BOOL)webView:(WKWebView *)webView shouldStartLoadForNavigationAction:(WKNavigationAction *)navigationAction;

@end
