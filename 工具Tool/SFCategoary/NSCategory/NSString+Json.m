//
//  NSString+Json.m
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 14-8-19.
//  Copyright (c) 2014年 BruceYu. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

- (NSDictionary *)jsonDictionary
{
    return [self JSONValue];
}

- (NSArray *)jsonArray
{
    return [self JSONValue];
}

- (id)JSONValue
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *__autoreleasing error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
- (NSString *)HMEJSONString
{
    
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    //
    
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSError *__autoreleasing error = nil;
    NSData *result = [NSJSONSerialization dataWithJSONObject:self
                                                     options:kNilOptions error:&error];
    NSLog(@"result  1 %@",result);
    if (error != nil) return nil;
    
    NSString *jsonStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonStr  3 %@",jsonStr);
    
    
    return jsonStr;
}

@end
