//
//  SFSqliteTool.h
//  ReadBook
//
//  Created by lurich on 2020/5/20.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSqliteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSqliteTool : NSObject

#pragma mark - 存储的信息
//插入某个数据
+ (BOOL)insertData:(SFSqliteModel *)data;
//删除某个数据
+ (BOOL)deleteData:(SFSqliteModel *)data;
//更新某个数据
+ (BOOL)updateData:(SFSqliteModel *)data;
//查询某个数据  根据scriptId
+ (SFSqliteModel *)selectedDataID:(NSString *)scriptId;
//删除整个表
+ (BOOL)deleteDataTable;
//查找所有数据
+ (NSArray<SFSqliteModel *> *)selectData;
//数据库中是否有这个数据
+ (BOOL)isHaveData:(SFSqliteModel *)data;

@end

NS_ASSUME_NONNULL_END
