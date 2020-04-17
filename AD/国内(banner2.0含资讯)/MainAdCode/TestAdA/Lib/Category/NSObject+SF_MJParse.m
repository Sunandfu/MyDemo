//
//  NSObject+MJParse.m
//  BaseProject
//
//  Created by hzxsdz008 on 15/12/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NSObject+SF_MJParse.h"

@implementation NSObject (SF_MJParse)

+(id)SF_MJParse:(id)responseObj
{
    if([responseObj isKindOfClass:[NSArray class]])
    {
        return [self mj_objectArrayWithKeyValuesArray:responseObj];
    }
    if([responseObj isKindOfClass:[NSDictionary class]])
    {
        return [self mj_objectWithKeyValues:responseObj];
    }
    return responseObj;
}
/**如果MJExtension是从属性名 ->key*/
//如果key就是desc,那么下方代码自动切换为description则出错
+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    if([propertyName isEqualToString:@"ID"])
    {
        propertyName = @"id";
    }
    if([propertyName isEqualToString:@"Desc"])
    {
        propertyName = @"description";
    }
    if([propertyName isEqualToString:@"Register"])
    {
        propertyName = @"register";
    }
    return propertyName;
}
@end
