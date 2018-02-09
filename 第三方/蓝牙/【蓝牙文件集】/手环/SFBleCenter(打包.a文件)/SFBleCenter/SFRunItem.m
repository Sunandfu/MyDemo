//
//  YXRunItem.m
//  fitness
//
//  Created by 云镶网络科技公司 on 2016/11/30.
//  Copyright © 2016年 YunXiang. All rights reserved.
//

#import "SFRunItem.h"

@implementation SFRunItem

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _heartArr = [NSArray array];
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"gap:%ld,runSteps:%ld,startDate:%@,endDate:%@,heartCount:%ld,heartRate:%@",(long)self.gap,(long)self.runSteps,self.startDate,self.stopDate,(long)self.heartCount,self.heartArr];
}
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Undefined key:%@ in:%@",key,[self class]);
}

@end
