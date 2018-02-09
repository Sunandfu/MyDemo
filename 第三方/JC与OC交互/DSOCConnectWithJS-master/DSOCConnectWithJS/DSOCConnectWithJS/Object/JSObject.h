//
//  JSObject.h
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/3/25.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

//此处我们测试几种参数的情况
-(void)TestNOParameter;
-(NSString *)TestOneParameter:(NSString *)message;
-(NSString *)TestTwoParameter:(NSString *)message1 SecondParameter:(NSString *)message2;

-(void)postMessage:(NSString *)message;
@end

@interface JSObject : NSObject<JSObjcDelegate>

@end
