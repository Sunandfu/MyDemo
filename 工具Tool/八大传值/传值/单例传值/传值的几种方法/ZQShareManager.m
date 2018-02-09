//
//  ZQShareManager.m
//  传值的几种方法
//
//  Created by lin zhi qing on 16/3/29.
//  Copyright © 2016年 linzhiqing. All rights reserved.
//

#import "ZQShareManager.h"

@implementation ZQShareManager
+ (ZQShareManager *)shareUserInfo{
    static ZQShareManager *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}
@end
