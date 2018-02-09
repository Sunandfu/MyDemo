//
//  NSObject+LHModel.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/21.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LHModel)

+ (id)lh_ModelWithJSON:(id)json;

+ (id)lh_ModelWithDictionary:(NSDictionary*)dic;

- (NSDictionary*)lh_ModelToDictionary;

- (NSData*)lh_ModelToData;

+ (NSDictionary*)getAllPropertyNameAndType;

+ (NSString*)getTypeNameWith:(NSString*)propertyName;

@end
