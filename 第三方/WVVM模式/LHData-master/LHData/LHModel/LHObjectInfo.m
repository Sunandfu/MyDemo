//
//  LHObjectInfo.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/21.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "LHObjectInfo.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation LHObjectInfo

static LHBaseTypeEcoding baseTypeEcoding(char type)
{
    switch (type) {
        case 'Q':
            return LHBaseTypeEcodingULONG;
        case 'i':
            return LHBaseTypeEcodingINT;
        case 'q':
            return LHBaseTypeEcodingLONG;
        case 'f':
            return LHBaseTypeEcodingFLOAT;
        case 'd':
            return LHBaseTypeEcodingDOUBLE;
        case 'B':
            return LHBaseTypeEcodingBOOL;
        case 'b':
            return LHBaseTypeEcodingBOOL;
        case 'c':
            return LHBaseTypeEcodingCHAR;
        default:
           return LHBaseTypeEcodingUnknow;
    }
}

static LHNSTypeEcoding nsTypeEcoding(NSString* type)
{
    if ([type isEqualToString:@"NSString"]) {
        return LHNSTypeNSString;
    }
    if ([type isEqualToString:@"NSNumber"]) {
        return LHNSTypeNSNumber;
    }
    if ([type isEqualToString:@"NSDate"]) {
        return LHNSTypeNSDate;
    }
    if ([type isEqualToString:@"NSData"]) {
        return LHNSTypeNSData;
    }
    if ([type isEqualToString:@"NSURL"]) {
        return LHNSTypeNSURL;
    }
    if ([type isEqualToString:@"NSArray"]) {
        return LHNSTypeNSArray;
    }
    if ([type isEqualToString:@"NSDictionary"]) {
        return LHNSTypeNSDictionary;
    }
    if ([type isEqualToString:@"UIImage"]) {
        return LHNSTypeUIImage;
    }
    return LHNSTypeUNknow;
}

- (instancetype)initWithProperty:(objc_property_t)property
{
    if (property == nil) return nil;
    self = [super init];
    if (self) {
        _property_t = property;
        _name = [NSString stringWithUTF8String:property_getName(property)];
        unsigned int count;
        objc_property_attribute_t* t = property_copyAttributeList(property, &count);
        for (unsigned int i=0; i<count; i++) {
            objc_property_attribute_t p = t[i];
            size_t len = strlen(p.value);
            if (len > 3) {
                char name[len - 2];
                name[len - 3] = '\0';
                memcpy(name, p.value + 2, len - 3);
                _cls = objc_getClass(name);
                _type = [NSString stringWithUTF8String:name];
                _nsTypeEcoding = nsTypeEcoding(_type);
                break;
            }else {
                _type = [NSString stringWithUTF8String:p.value];
                if (_type.length>1) {
                    _type = [_type substringToIndex:1];
                }
                if (_type.length>0) {
                    _baseTypeEcoding = baseTypeEcoding([_type characterAtIndex:0]);
                }
                break;
            }
        }
        free(t);
        
        if (_name.length>0) {
            _set = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",[[_name substringToIndex:1] uppercaseString],[_name substringFromIndex:1]]);
            _get = NSSelectorFromString(_name);
        }
    }
    return self;
}

@end

static NSMutableDictionary* objectInfoCacheDic;

@implementation LHClassInfo

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        _cls = cls;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            objectInfoCacheDic = [NSMutableDictionary dictionary];
        });
        _objectInfoDic = [NSMutableDictionary dictionary];
        unsigned int count;
        objc_property_t* t = class_copyPropertyList(cls, &count);
        for (int i=0; i<count; i++) {
            LHObjectInfo* info = [[LHObjectInfo alloc] initWithProperty:t[i]];
            [_objectInfoDic setValue:info forKey:[NSString stringWithUTF8String:property_getName(t[i])]];
        }
        free(t);
        [objectInfoCacheDic setValue:self forKey:NSStringFromClass(cls)];
    }
    return self;
}

+ (BOOL)isCacheWithClass:(Class)cls
{
    if ([objectInfoCacheDic objectForKey:NSStringFromClass(cls)]) {
        return YES;
    }
    return NO;
}

+ (LHClassInfo*)classInfoWithClass:(Class)cls
{
    return objectInfoCacheDic[NSStringFromClass(cls)];
}

- (LHObjectInfo*)objectInfoWithName:(NSString*)name
{
    return _objectInfoDic[name];
}

- (void)receiveMemoryWarning:(NSNotification*)noti
{
    [objectInfoCacheDic removeAllObjects];
}

@end
