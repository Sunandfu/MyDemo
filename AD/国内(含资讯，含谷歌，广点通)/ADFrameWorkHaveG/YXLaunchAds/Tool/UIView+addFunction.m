//
//  UIView+addFunction.m
//  TestAdA
//
//  Created by lurich on 2019/5/5.
//  Copyright © 2019 YX. All rights reserved.
//

#import "UIView+addFunction.h"

#import "WXApi.h"
#import "NetTool.h"
#import "YXImgUtil.h"
#import "Network.h"
#import <SafariServices/SafariServices.h>
#import "YXWebViewController.h"
#import "YXLaunchConfiguration.h"

@interface UIView (addFunction)<SFWebViewDelegate,YXWebViewDelegate>

@end

@implementation UIView (addFunction)

- (void)ViewClickWithDict:(NSDictionary *)currentDict Width:(NSString *)widthStr Height:(NSString *)heightStr X:(NSString *)x Y:(NSString *)y{
    if (currentDict==nil) {
        return;
    }
    // 1.跳转链接
    NSString *urlStr = currentDict[@"click_url"];
    
    NSString * click_position = [NSString stringWithFormat:@"%@",currentDict[@"click_position"]];
    if ([click_position isEqualToString:@"1"]) {
        if (currentDict[@"width"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",currentDict[@"width"]]];
        }
        if (currentDict[@"height"]) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_HEIGHT__" withString:[NSString stringWithFormat:@"%@",currentDict[@"height"]]];
        }
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
        
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
    }
    
    NSString * ac_type = [NSString stringWithFormat:@"%@",currentDict[@"ac_type"]];
    //下载类的
    if ([ac_type isEqualToString:@"1"] || [ac_type isEqualToString:@"2"]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (@available(iOS 9.0, *)) {
            SFWebViewController *safariVC = [[SFWebViewController alloc] initWithURL:url];
            safariVC.delegate = self;
            [[NetTool getCurrentViewController] presentViewController:safariVC animated:YES completion:nil];
            
        } else {
            YXWebViewController *VC = [[YXWebViewController alloc] init];
            VC.delegate = self;
            VC.URLString = urlStr;
            //此处不要直接取keyWindow
            [[NetTool getCurrentViewController] presentViewController:VC animated:NO completion:nil];
        }
    } else if ([ac_type isEqualToString:@"6"]) {
        if ([currentDict[@"inventory_source"] isEqualToString:@"1"]) {
            [Network notifyToServer:nil serverUrl:currentDict[@"start_deeplink_urls"] completionHandler:nil];
        }
        NSString *deeplick = currentDict[@"deep_url"];
        NSURL *deeplickUrl = [NSURL URLWithString:deeplick];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:deeplickUrl options:@{} completionHandler:^(BOOL success) {
                if (!success) {
                    NSURL *url = [NSURL URLWithString:urlStr];
                    if (@available(iOS 9.0, *)) {
                        SFWebViewController *safariVC = [[SFWebViewController alloc] initWithURL:url];
                        safariVC.delegate = self;
                        [[NetTool getCurrentViewController] presentViewController:safariVC animated:YES completion:nil];
                        
                    } else {
                        YXWebViewController *web = [YXWebViewController new];
                        web.delegate = self;
                        web.URLString = urlStr;
                        [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
                    }
                } else {
                    if ([currentDict[@"inventory_source"] isEqualToString:@"1"]) {
                        [Network notifyToServer:nil serverUrl:currentDict[@"end_deeplink_urls"] completionHandler:nil];
                    }
                }
            }];
        }else{
            NSURL *url = [NSURL URLWithString:urlStr];
            if (@available(iOS 9.0, *)) {
                SFWebViewController *safariVC = [[SFWebViewController alloc] initWithURL:url];
                safariVC.delegate = self;
                [[NetTool getCurrentViewController] presentViewController:safariVC animated:YES completion:nil];
                
            } else {
                YXWebViewController *web = [YXWebViewController new];
                web.delegate = self;
                web.URLString = urlStr;
                [[NetTool getCurrentViewController] presentViewController:web animated:YES completion:nil];
            }
        }
        
    } else if([ac_type isEqualToString:@"7"]){
        
        NSString * miniPath = [NSString stringWithFormat:@"%@",currentDict[@"miniPath"] ];
        miniPath = [miniPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString * miniProgramOriginId = [NSString stringWithFormat:@"%@",currentDict[@"miniProgramOriginId"]];
        
        
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = miniProgramOriginId;  //拉起的小程序的username
        launchMiniProgramReq.path = miniPath;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
        
        BOOL installWe = [WXApi isWXAppInstalled];
        if (installWe) {
            [WXApi sendReq:launchMiniProgramReq];
        }else{
            NSLog(@"未安装微信");
        }
        
        [Network notifyToServer:nil serverUrl:urlStr completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(connectionError){
                NSLog(@"#####%@\error",[connectionError debugDescription]);
            }else{
                NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (json) {
                    NSLog(@"%@",json);
                }
                
            }
        }];
    }else {
        if(urlStr && ![urlStr isEqualToString:@""]){
            YXWebViewController *VC = [[YXWebViewController alloc] init];
            VC.delegate = self;
            VC.URLString = urlStr;
            //此处不要直接取keyWindow
            [[NetTool getCurrentViewController] presentViewController:VC animated:NO completion:nil];
        }
    }
    // 2.上报服务器
    if (![[NetTool gettelModel] isEqualToString:@"iPhone Simulator"])
    {
        // 上报服务器
        NSArray *viewS = currentDict[@"click_notice_urls"];
        if(viewS && ![viewS isKindOfClass:[NSNull class]]&& viewS.count){
            if ([click_position isEqualToString:@"1"]) {
                
                if (currentDict[@"width"]) {
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:[NSString stringWithFormat:@"%@",currentDict[@"width"]]];
                }
                if (currentDict[@"height"]) {
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__REQ_HEIGHT__" withString:[NSString stringWithFormat:@"%@",currentDict[@"height"]]];
                }
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
                
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
            }
            [Network groupNotifyToSerVer:viewS];
        }
    }
}
- (void)customWebViewClicked{
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMCLICKNOTIFITION object:nil];
}

@end
