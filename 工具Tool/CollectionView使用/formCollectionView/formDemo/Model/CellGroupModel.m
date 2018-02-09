//
//  CellGroupModel.m
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import "CellGroupModel.h"
#import "CellModel.h"

@implementation CellGroupModel

- (instancetype)initCellDataWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)cellDataWithDic:(NSDictionary *)dic
{
    return [[self alloc] initCellDataWithDic:dic];
}


@end
