//
//  NSObject+LHModel.m
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/21.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import "NSObject+LHModel.h"
#import "LHObjectInfo.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation NSObject (LHModel)

static void ModelSetValueToProperty(const void *key, const void *value, void *context)
{
    ModelSetContext* modelContext = context;
    NSString* dicKey = (__bridge NSString *)(key);
    id dicValue = (__bridge id)(value);
    LHObjectInfo* objectInfo = [((__bridge LHClassInfo*)modelContext->classInfo) objectInfoWithName:dicKey];
    NSObject* object = (__bridge NSObject*)modelContext->model;
    if (objectInfo) {
        if (objectInfo.cls) {
            setNSTypePropertyValue(object, dicValue, objectInfo.nsTypeEcoding, objectInfo.set);
            
        }else if (objectInfo.type.length>0) {
            NSNumber* number = numberWithValue(dicValue);
            setBaseTypePropertyValue(object, number, objectInfo.baseTypeEcoding,objectInfo.set);
        }
    }
}

static void ModelGetValueToDic(const void* key,const void* value,void* context)
{
    ModelSetContext* modelContext = context;
    NSMutableDictionary* dic = (__bridge NSMutableDictionary *)(modelContext->classInfo);
    id object = (__bridge id)(modelContext->model);
    NSString* dicKey = (__bridge NSString *)(key);
    LHObjectInfo* objectInfo = (__bridge LHObjectInfo*)(value);
    if (objectInfo) {
        if (objectInfo.cls) {
            [dic setValue:((id(*)(id,SEL))(void*) objc_msgSend)(object,objectInfo.get) forKey:dicKey];;
        }else if (objectInfo.type.length>0) {
            NSNumber* number = getBaseTypePropertyValue(object, objectInfo.baseTypeEcoding, objectInfo.get);
            [dic setValue:number forKey:dicKey];
        }
    }
}

static NSNumber* numberWithValue(__unsafe_unretained id value)
{
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        if ([value containsString:@"."]) {
            const char *cstring = ((NSString *)value).UTF8String;
            if (!cstring) return nil;
            double num = atof(cstring);
            if (isnan(num) || isinf(num)) return nil;
            return @(num);
        }else {
            const char *cstring = ((NSString*)value).UTF8String;
            if (!cstring) return nil;
            NSNumber* number = @(atoll(cstring));
            if (!atoll(cstring)) {
                number = [NSNumber numberWithChar:*(cstring+0)];
            }
            return number;
        }
    }
    return nil;
    
}

static void setBaseTypePropertyValue(__unsafe_unretained NSObject* object,__unsafe_unretained NSNumber* value, NSUInteger type,SEL set)
{
    switch (type) {
        case LHBaseTypeEcodingINT:
            ((void (*)(id, SEL, int))(void *) objc_msgSend)(object, set, value.intValue);
            break;
        
        case LHBaseTypeEcodingLONG:
            ((void(*)(id,SEL,long))(void*) objc_msgSend)(object,set,value.integerValue);
            break;
        case LHBaseTypeEcodingULONG:
            ((void(*)(id,SEL,long))(void*) objc_msgSend)(object,set,value.unsignedIntegerValue);
            break;
            
        case LHBaseTypeEcodingFLOAT:
            ((void(*)(id,SEL,float))(void*) objc_msgSend)(object,set,value.floatValue);
            break;
        case LHBaseTypeEcodingDOUBLE:
            ((void(*)(id,SEL,double))(void*) objc_msgSend)(object,set,value.doubleValue);
            break;
        case LHBaseTypeEcodingBOOL:
            ((void(*)(id,SEL,BOOL))(void*) objc_msgSend)(object,set,value.boolValue);
            break;
            
        case LHBaseTypeEcodingCHAR:
            ((void(*)(id,SEL,char))(void*) objc_msgSend)(object,set,value.charValue);
            break;
        default:
            ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,nil);
            break;
    }
}

static void setNSTypePropertyValue(__unsafe_unretained id object,__unsafe_unretained id value,LHNSTypeEcoding typeEcoding,SEL set)
{
    switch (typeEcoding) {
        case LHNSTypeUNknow:
            ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,value);
            break;
        
        case LHNSTypeNSString:
            if ([value isKindOfClass:[NSString class]]) {
                ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,value);
            }else if ([value isKindOfClass:[NSNumber class]]) {
                ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,[value stringValue]);
            }else if ([value isKindOfClass:[NSData class]]) {
                ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,[[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding]);
            }else if ([value isKindOfClass:[NSDate class]]) {
                ((void(*)(id,SEL,NSString*))(void*) objc_msgSend)(object,set,stringFormDate(value));
            }else
                ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,value);
            break;
            
        case LHNSTypeNSNumber:
            ((void(*)(id,SEL,NSNumber*))(void*) objc_msgSend)(object,set,numberWithValue(value));
            break;
            
        case LHNSTypeNSDate:
            if ([value isKindOfClass:[NSDate class]]) {
                ((void(*)(id,SEL,NSDate*))(void*) objc_msgSend)(object,set,value);
            }else if ([value isKindOfClass:[NSString class]]) {
                ((void(*)(id,SEL,NSDate*))(void*) objc_msgSend)(object,set,dateFromString(value));
            }else if ([value isKindOfClass:[NSData class]]) {
                NSString* dateStr = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
                ((void(*)(id,SEL,NSDate*))(void*) objc_msgSend)(object,set,dateFromString(dateStr));
            }else
                ((void(*)(id,SEL,id))(void*) objc_msgSend)(object,set,value);
            break;
            
        case LHNSTypeNSData:
            ((void(*)(id,SEL,NSData*))(void*) objc_msgSend)(object,set,dataFromObject(value));
            break;
            
        case LHNSTypeNSURL:
            ((void(*)(id,SEL,NSURL*))(void*) objc_msgSend)(object,set,urlFromObject(value));
            break;
            
        case LHNSTypeNSArray:
            ((void(*)(id,SEL,NSArray*))(void*) objc_msgSend)(object,set,arrayFromObject(value));
            break;
            
        case LHNSTypeNSDictionary:
            ((void(*)(id,SEL,NSDictionary*))(void*) objc_msgSend)(object,set,dicFromObject(value));
            break;
            
        case LHNSTypeUIImage:
            ((void(*)(id,SEL,UIImage*))(void*) objc_msgSend)(object,set,imageFromObject(value));
            break;
        
        default:
            break;
    }
}

static NSNumber* getBaseTypePropertyValue(__unsafe_unretained NSObject* object, NSUInteger type,SEL get)
{
    switch (type) {
        case LHBaseTypeEcodingINT:
            
            return @(((int (*)(id, SEL))(void *) objc_msgSend)(object, get));
            
        case LHBaseTypeEcodingLONG:
            
            return @(((long (*)(id, SEL))(void *) objc_msgSend)(object,get));
            
        case LHBaseTypeEcodingULONG:
            
            return @(((NSUInteger(*)(id,SEL))(void*) objc_msgSend)(object,get));
            
        case LHBaseTypeEcodingFLOAT:
            
            return @(((float(*)(id,SEL))(void*) objc_msgSend)(object,get));

        case LHBaseTypeEcodingDOUBLE:
            
            return @(((double(*)(id,SEL))(void*) objc_msgSend)(object,get));

        case LHBaseTypeEcodingBOOL:
            
            return @(((BOOL(*)(id,SEL))(void*) objc_msgSend)(object,get));
            
        case LHBaseTypeEcodingCHAR:
            
           return @(((char(*)(id,SEL))(void*) objc_msgSend)(object,get));

        default:
            return nil;
            break;
    }
}

typedef struct {
    void *classInfo;
    void *model;
} ModelSetContext;

+ (id)lh_ModelWithJSON:(id)json
{
    if (!json) return nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        return [self lh_ModelWithDictionary:(NSDictionary*)json];
    }
    NSData* jsonData;
    if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString*)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]])
        jsonData = json;
    if (jsonData) {
        return [self lh_ModelWithDictionary:[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil]];
    }
    return nil;
}

+ (id)lh_ModelWithDictionary:(NSDictionary*)dic
{
    if (!dic ||![dic isKindOfClass:[NSDictionary class]]) return nil;
    NSObject* object = [[self alloc] init];
    ModelSetContext context = {0};
    LHClassInfo* info;
    //判断缓存中是否有这个类的信息
    if ([LHClassInfo isCacheWithClass:self]) {
        info = [LHClassInfo classInfoWithClass:self];
    }else
        info = [[LHClassInfo alloc] initWithClass:self];
    context.classInfo = (__bridge void *)(info);
    context.model = (__bridge void *)(object);
    
    CFDictionaryApplyFunction((__bridge CFDictionaryRef)dic, ModelSetValueToProperty, &context);
    return object;
}

- (NSDictionary*)lh_ModelToDictionary
{
    if ([self isKindOfClass:[NSArray class]]) {
        return nil;
    }else if ([self isKindOfClass:[NSDictionary class]]){
        return (NSDictionary*)self;
    }else if ([self isKindOfClass:[NSString class]]||[self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:dataFromObject(self) options:NSJSONReadingMutableContainers error:nil];
    }else {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        ModelSetContext context = {0};
        context.classInfo = (__bridge void *)(dic);
        context.model = (__bridge void *)(self);
        LHClassInfo* classInfo;
        //判断缓存中是否有这个类的信息
        if ([LHClassInfo isCacheWithClass:object_getClass(self)]) {
            classInfo = [LHClassInfo classInfoWithClass:object_getClass(self)];
        }else
            classInfo = [[LHClassInfo alloc] initWithClass:object_getClass(self)];
        CFDictionaryApplyFunction((__bridge CFMutableDictionaryRef)classInfo.objectInfoDic, ModelGetValueToDic, &context);
        return dic;
    }
    return nil;
}

- (NSData*)lh_ModelToData
{
    return [NSJSONSerialization dataWithJSONObject:[self lh_ModelToDictionary] options:NSJSONWritingPrettyPrinted error:nil];;
}

+ (NSDictionary*)getAllPropertyNameAndType
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t* property_t = class_copyPropertyList(self, &count);
    for (int i=0; i<count; i++) {
        objc_property_t propert = property_t[i];
        NSString* propertyName = [NSString stringWithUTF8String:property_getName(propert)];
        NSString* propertyType = [NSString stringWithUTF8String:property_getAttributes(propert)];
        [dic setValue:objectType(propertyType) forKey:propertyName];
    }
    free(property_t);
    return dic;
}

+ (NSString*)getTypeNameWith:(NSString*)propertyName
{
    NSString* typeStr = [[self getAllPropertyNameAndType]valueForKey:propertyName];
    if ([typeStr isEqualToString:@"i"]) {
        return @"INT";
    }else if ([typeStr isEqualToString:@"f"]) {
        return @"FLOAT";
    }else if ([typeStr isEqualToString:@"B"]) {
        return @"BOOL";
    }else if ([typeStr isEqualToString:@"d"]) {
        return @"DOUBLE";
    }else if ([typeStr isEqualToString:@"q"]) {
        return @"LONG";
    }else if ([typeStr isEqualToString:@"NSData"]||[typeStr isEqualToString:@"UIImage"]) {
        return @"BLOB";
    }else if ([typeStr isEqualToString:@"NSNumber"]){
        return @"INT";
    } else
        return @"TEXT";
}

static id objectType(NSString* typeString)
{
    if ([typeString containsString:@"@"]) {
        NSArray* strArray = [typeString componentsSeparatedByString:@"\""];
        if (strArray.count >= 1) {
            return strArray[1];
        }else
            return nil;
    }else
        return [typeString substringWithRange:NSMakeRange(1, 1)];
}


static NSString* stringFormDate(NSDate* date)
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

static NSDate* dateFromString(NSString* string)
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:string];
}

static NSData* dataFromObject(id object)
{
    if ([object isKindOfClass:[NSData class]]) {
        return object;
    }else if ([object isKindOfClass:[NSString class]]) {
        return [object dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([object isKindOfClass:[NSDate class]]) {
        return [stringFormDate(object) dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSDictionary class]]) {
        return [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    }else if ([object isKindOfClass:NSClassFromString(@"UIImage")]) {
        return UIImageJPEGRepresentation(object, 1);
    }else
        return [object dataUsingEncoding:NSUTF8StringEncoding];
}

static NSURL* urlFromObject(id object)
{
    if ([object isKindOfClass:[NSURL class]]) {
        return object;
    }else if ([object isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:[object stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else  {
        return [NSURL URLWithString:[[[NSString alloc] initWithData:dataFromObject(object) encoding:NSUTF8StringEncoding] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

static NSArray* arrayFromObject(id object)
{
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }else if ([object isKindOfClass:[NSDictionary class]]){
        return nil;
    }else {
        id value = [NSJSONSerialization JSONObjectWithData:dataFromObject(object) options:NSJSONReadingMutableContainers error:nil];
        if ([value isKindOfClass:[NSArray class]]) {
            return value;
        }
        return nil;
    }
}

static NSDictionary* dicFromObject(id object)
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }else {
        NSData* data = dataFromObject(object);
        id value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return value;
        }
        return nil;
    }
}

static UIImage* imageFromObject(id object)
{
    if ([object isKindOfClass:[UIImage class]]) {
        return object;
    }else {
        return [UIImage imageWithData:dataFromObject(object)];
    }
}

@end





