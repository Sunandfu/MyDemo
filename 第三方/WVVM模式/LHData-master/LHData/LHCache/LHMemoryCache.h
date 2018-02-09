//
//  LHMemoryCache.h
//  LHDBDemo
//
//  Created by 3wchina01 on 16/3/23.
//  Copyright © 2016年 李浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHMemoryCache : NSObject

@property (nonatomic,strong) NSString* name;

@property (nonatomic,readonly) NSUInteger count;

@property (nonatomic,assign,readwrite) NSUInteger countMax;
/*
 程序进入后台是否释放缓存 default = YES
 */
@property (nonatomic,assign) BOOL shouldClearCacheWhenEnterBackground;

- (instancetype)initWithName:(NSString*)name;

- (void)setObject:(id)object forKey:(NSString*)key;

- (id)objectForKey:(NSString*)key;

- (BOOL)isContainObjectWithKey:(NSString*)key;

- (void)removeAllObject;

@end
