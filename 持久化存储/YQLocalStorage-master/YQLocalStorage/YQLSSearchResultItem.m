//
//  YQLSSearchResultItem.m
//  YQDataBaseDevelop
//
//  Created by FreakyYang on 2017/11/14.
//  Copyright © 2017年 FreakyYang. All rights reserved.
//

#import "YQLSSearchResultItem.h"

#import "YQLocalStorage.h"

@interface YQLSSearchResultItem ()

@end

@implementation YQLSSearchResultItem

- (instancetype)initWithLocalStorage:(YQLocalStorage *)localStorage
                               table:(NSString *)tableName
                                  ID:(long)ID
                           creatTime:(double)creatTime
                          updateTime:(double)updateTime
                                data:(NSDictionary<NSString *,NSString *> *)data {
    self = [super init];
    
    _localStorage  = localStorage;
    _fromTable = tableName;
    _ID = ID;
    _creatTime  = creatTime;
    _updateTime = updateTime;
    _data = data;
    
    return self;
}

- (void)setLocalStorage:(YQLocalStorage *)localStorage {
    NSAssert(NO, @"localStorage cannot be write");
}

- (void)setData:(NSDictionary<NSString *,NSString *> *)data {
    [self updateData:data withBlock:nil];
}

- (void)reloadFromLS {
    [self reloadFromLSWithBlock:nil];
}

- (void)reloadFromLSWithBlock:(void(^)(BOOL succeed,NSString *reason))block {
    if (!self.localStorage) {
        block ? block(NO,@"localStorage has been free") : nil;
    } else if (self.fromTable.length <= 0) {
        block ? block(NO,@"tableName was nil") : nil;
    } else {
        [self.localStorage searchStorageWithTableName:self.fromTable
                                            condition:[NSString stringWithFormat:@" id=%ld ",self.ID]
                                                 Keys:nil
                                                block:^(BOOL succeed, NSArray<YQLSSearchResultItem *> *result)
         {
             if (!succeed) {
                 block ? block(NO,[NSString stringWithFormat:@"updateFail : %@",result]) : nil;
             } else if(result.count == 1) {
                 YQLSSearchResultItem *newItem = result[0];
                 _creatTime = newItem.creatTime;
                 _updateTime = newItem.updateTime;
                 _data = newItem.data;
                 block ? block(YES,nil) : nil;
             } else if(result.count == 0) {
                 block ? block(NO,[NSString stringWithFormat:@"Object has already been deleted"]) : nil;
             } else {
                 block ? block(NO,[NSString stringWithFormat:@"internal Error"]) : nil;
             }
         }];
    }
}

- (void)deleteMyself {
    [self deleteMyselfWithBlock:nil];
}

- (void)deleteMyselfWithBlock:(void(^)(BOOL succeed,NSString *reason))block {
    _data = nil;
    if (!self.localStorage) {
        block ? block(NO,@"localStorage has been free") : nil;
    } else if (self.fromTable.length <= 0) {
        block ? block(NO,@"tableName was nil") : nil;
    } else {
        [self.localStorage deleteObjectWithTableName:self.fromTable ID:self.ID block:block];
    }
}

- (void)updateData:(NSDictionary<NSString *,NSString *> *)data
         withBlock:(void(^)(BOOL succeed,NSString *reason))block {
    if (!self.localStorage) {
        block ? block(NO,@"localStorage has been free") : nil;
    } else if (self.fromTable.length <= 0) {
        block ? block(NO,@"tableName was nil") : nil;
    } else {
        [self.localStorage updateObjectWithTableName:self.fromTable
                                            objectID:self.ID
                                                data:data
                                               block:^(BOOL succeed, NSString * _Nullable reason)
         {
             succeed ? _data = data : nil;
             block ? block(succeed,reason) : nil;
         }];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{id:%ld,creat:%f,update:%f,data:%@}",self.ID,self.creatTime,self.updateTime,self.data];
}

@end

