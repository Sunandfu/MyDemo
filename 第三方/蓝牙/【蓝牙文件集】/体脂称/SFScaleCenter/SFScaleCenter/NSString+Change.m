//
//  NSString+Change.m
//  返回状态判断
//
//  Created by go  on 16/4/1.
//  Copyright © 2016年 Sherman. All rights reserved.
//

#import "NSString+Change.h"

@implementation NSString (Change)


+ (NSString *)translateToSixTeenWithNum:(NSInteger)num
{
   NSString * str = [[NSString alloc]initWithFormat:@"%02lx",(long)num & 0xff];
    
    return str;
}

+ (NSInteger)translateToTenWithString:(NSString *)string
{
    NSInteger num = (NSInteger)strtoull([string UTF8String], 0, 16);
    
    return (long)num;
}


@end
