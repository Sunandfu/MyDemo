//
//  WeakScriptMessageDelegate.h
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/3/29.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
