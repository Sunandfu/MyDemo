//
//  main.m
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/26.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSLog(@"%s",__func__);
    @autoreleasepool {
        NSLog(@"argc = %d",argc);
       // NSLog(@"%@", argv);
        for (int i = 0; i < argc; i++) {
            NSLog(@"%s",argv[i]);
        }
        

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));


    }
    
   
}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com