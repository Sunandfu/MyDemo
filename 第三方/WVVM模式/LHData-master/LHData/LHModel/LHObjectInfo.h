//
//  LHObjectInfo.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/21.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger,LHBaseTypeEcoding) {
    LHBaseTypeEcodingUnknow,
    LHBaseTypeEcodingINT,
    LHBaseTypeEcodingLONG,
    LHBaseTypeEcodingULONG,
    LHBaseTypeEcodingCHAR,
    LHBaseTypeEcodingFLOAT,
    LHBaseTypeEcodingBOOL,
    LHBaseTypeEcodingDOUBLE
};

typedef NS_ENUM(NSUInteger,LHNSTypeEcoding) {
    LHNSTypeUNknow,
    LHNSTypeNSString,
    LHNSTypeNSNumber,
    LHNSTypeNSDate,
    LHNSTypeNSData,
    LHNSTypeNSURL,
    LHNSTypeNSArray,
    LHNSTypeNSDictionary,
    LHNSTypeUIImage
};

@interface LHObjectInfo : NSObject

@property (nonatomic) Class cls;

@property (nonatomic) objc_property_t property_t;

@property (nonatomic,copy) NSString* name;

@property (nonatomic,assign) LHBaseTypeEcoding baseTypeEcoding;

@property (nonatomic,assign) LHNSTypeEcoding nsTypeEcoding;

@property (nonatomic) SEL set;

@property (nonatomic) SEL get;

@property (nonatomic,copy) NSString* type;

- (instancetype)initWithProperty:(objc_property_t)property;

@end

@interface LHClassInfo : NSObject

@property (nonatomic)Class cls;

@property (nonatomic)Class superClass;

@property (nonatomic)Class metaClass;

@property (nonatomic,assign) BOOL isMetaClass;

@property (nonatomic,strong) NSMutableDictionary* objectInfoDic;

- (instancetype)initWithClass:(Class)cls;

+ (BOOL)isCacheWithClass:(Class)cls;

+ (LHClassInfo*)classInfoWithClass:(Class)cls;

- (LHObjectInfo*)objectInfoWithName:(NSString*)name;

@end
