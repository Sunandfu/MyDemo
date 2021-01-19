//
//  SFSafeAreaInsets.m
//  Novel
//
//  Created by xx on 2018/9/5.
//  Copyright © 2018年 th. All rights reserved.
//

#import "SFSafeAreaInsets.h"

@interface SFSafeAreaInsets()

@end

@implementation SFSafeAreaInsets


+ (instancetype)shareInstance {
    static SFSafeAreaInsets * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SFSafeAreaInsets alloc] init];
        instance.safeAreaInsets = UIEdgeInsetsZero;
    });
    return instance;
}


- (void)setSafeAreaInsets:(UIEdgeInsets)safeAreaInsets {
    _safeAreaInsets = safeAreaInsets;
    if (xx_iPhoneX) {
        _safeAreaInsets.top = 44;
        _safeAreaInsets.left = 0;
        _safeAreaInsets.bottom = 34;
        _safeAreaInsets.right = 0;
    } else {
        _safeAreaInsets.top = 20;
        _safeAreaInsets.left = 0;
        _safeAreaInsets.bottom = 0;
        _safeAreaInsets.right = 0;
    }
}

@end
