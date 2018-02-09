//
//  LHPredicate.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/2/14.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHPredicate.h"

@implementation LHPredicate

- (NSMutableArray*)propertyNameArray
{
    if (!_propertyNameArray) {
        _propertyNameArray = [NSMutableArray array];
    }
    return _propertyNameArray;
}

- (instancetype)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        _predicateFormat = string;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string OrderBy:(NSString*)sortString
{
    self = [super init];
    if (self) {
        _predicateFormat = string;
        _sortString = sortString;
    }
    return self;
}

+ (instancetype)predicateWithString:(NSString *)string
{
    LHPredicate* predicate  = [[self alloc] initWithString:string];
    return predicate;
}

+ (instancetype)predicateWithString:(NSString *)string OrderBy:(NSString *)sortString
{
    LHPredicate* predicate = [[LHPredicate alloc] initWithString:string OrderBy:sortString];
    return predicate;
}

- (instancetype)initWithFormat:(NSString *)name, ...
{
    self = [super init];
    if (self) {
        va_list args;
        va_start(args, name);
        _predicateFormat = [[NSString alloc] initWithFormat:name arguments:args];
        va_end(args);
    }
    return self;
}

- (instancetype)initWithOrderBy:(NSString *)sortString Format:(NSString *)name, ...
{
    self = [super init];
    if (self) {
        _sortString = sortString;
        va_list args;
        va_start(args, name);
        _predicateFormat = [[NSString alloc] initWithFormat:name arguments:args];
        va_end(args);
    }
    return self;
}

+ (instancetype)predicateWithFormat:(NSString*)name, ...
{
    LHPredicate* predicate = [[LHPredicate alloc] init];
    va_list args;
    va_start(args, name);
    predicate.predicateFormat = [[NSString alloc] initWithFormat:name arguments:args];
    va_end(args);
    return predicate;
}

- (instancetype)initWithPropertyName:(NSString*)name, ...
{
    self = [super init];
    if (self) {
        if (self.propertyNameArray.count>0) {
            [self.propertyNameArray removeAllObjects];
        }
        [self.propertyNameArray addObject:name];
        va_list args;
        va_start(args, name);
        if (name) {
            NSString* ohterName;
            while (ohterName == va_arg(args, NSString*)) {
                [self.propertyNameArray addObject:ohterName];
            }
        }
        va_end(args);
    }
    return self;
}

+ (instancetype)predicateWithPropertyName:(NSString*)name, ...
{
    LHPredicate* predicate = [[LHPredicate alloc] init];
    if (predicate.propertyNameArray.count>0) {
        [predicate.propertyNameArray removeAllObjects];
    }
    [predicate.propertyNameArray addObject:name];
    va_list args;
    va_start(args, name);
    if (name) {
        NSString* ohterName;
        while (ohterName == va_arg(args, NSString*)) {
            [predicate.propertyNameArray addObject:ohterName];
        }
    }
    va_end(args);
    return predicate;
}

@end
