//
//  JSObject.m
//  DSOCConnectWithJS
//
//  Created by dasheng on 16/3/25.
//  Copyright © 2016年 dasheng. All rights reserved.
//

#import "JSObject.h"

@implementation JSObject

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)TestNOParameter{
    
    NSLog(@"this is ios TestNOParameter");
}

-(NSString *)TestOneParameter:(NSString *)message{
    
    NSLog(@"this is ios TestOneParameter=%@",message);
    return @"this is ios TestOneParameter";
}

-(NSString *)TestTwoParameter:(NSString *)message1 SecondParameter:(NSString *)message2{
    
    NSLog(@"this is ios TestTwoParameter=%@  Second=%@",message1,message2);
    return @"this is ios TestTwoParameter";
}

- (void)postMessage:(NSString *)message{
    
    NSLog(@"this is ios TestTwoParameter=%@",message);
}

@end
