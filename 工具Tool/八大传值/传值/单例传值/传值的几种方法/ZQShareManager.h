//
//  ZQShareManager.h
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/29.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQShareManager : NSObject

@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;
// 申明一个类方法
+ (ZQShareManager *)shareUserInfo;

@end
