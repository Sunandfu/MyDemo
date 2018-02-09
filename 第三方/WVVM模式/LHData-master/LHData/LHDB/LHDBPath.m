//
//  LHDBPath.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/2/26.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHDBPath.h"

@implementation LHDBPath


+ (instancetype)instanceManagerWith:(NSString*)dbPath
{
    static LHDBPath* path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        path = [[LHDBPath alloc] init];
    });
    if (dbPath) {
        path.dbPath = dbPath;

    }
    return path;
}

@end
