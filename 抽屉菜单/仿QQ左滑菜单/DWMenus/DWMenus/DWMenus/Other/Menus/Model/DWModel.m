//
//  DWModel.m
//  DWMenu
//
//  Created by Dwang on 16/4/26.
//  Copyright © 2016年 git@git.oschina.net:dwang_hello/WorldMallPlus.git chuangkedao. All rights reserved.
//

#import "DWModel.h"

@implementation DWModel

- (instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}


+ (instancetype) leftMenuWithDict:(NSDictionary *)dict {
    
    return [[self alloc]initWithDict:dict];
    
}

+ (NSArray *) menuModel {
    
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Menus" ofType:@"plist"]];
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        DWModel  *menus = [DWModel leftMenuWithDict:dict];
        
        [arrayM addObject:menus];
        
    }
    
    return arrayM;
    
}

@end
