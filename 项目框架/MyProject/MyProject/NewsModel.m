//
//  NewsModel.m
//  MyProject
//
//  Created by 小富 on 16/4/25.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self =  [self initWithDictionary:dic error:&error];
    return self;
}

@end
