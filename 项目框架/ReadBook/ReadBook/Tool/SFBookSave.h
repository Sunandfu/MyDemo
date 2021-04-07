//
//  SFBookSave.h
//  ReadBook
//
//  Created by lurich on 2020/5/20.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookModel.h"
#import "DCBookModel.h"
#import "SFBookGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFBookSave : NSObject

#pragma mark - 用户信息
//插入某个数据
+ (BOOL)insertBook:(BookModel *)book;
//删除某个数据
+ (BOOL)deleteBook:(BookModel *)book;
//更新某个数据
+ (BOOL)updateBook:(BookModel *)book;
//查询某个数据  根据书籍ID
+ (BookModel *)selectedBookID:(NSInteger)bookID;
//查询某个数据  根据书籍编号
+ (BookModel *)selectedBookNumber:(NSString *)bookNumber;
//查询某些数据  根据书籍分类
+ (NSArray<BookModel *> *)selectedBookWithGroupID:(NSInteger)groupID;
//删除整个表
+ (BOOL)deleteBookTable;
//查找所有数据
+ (NSArray<BookModel *> *)selectBook;
//数据库中是否有这个数据
+ (BOOL)isHaveBook:(BookModel *)book;


//插入某个数据
+ (BOOL)insertLocalBook:(DCBookModel *)book;
//删除某个数据
+ (BOOL)deleteLocalBook:(DCBookModel *)book;
//更新某个数据
+ (BOOL)updateLocalBook:(DCBookModel *)book;
//查询某个数据  根据书籍ID
+ (DCBookModel *)selectedLocalBookID:(NSInteger)bookID;
//查询某个数据  根据书籍名称
+ (DCBookModel *)selectedLocalBookName:(NSString *)bookName;
//查找所有数据
+ (NSArray<DCBookModel *> *)selectLocalBook;


//插入某个数据
+ (BOOL)insertBookGroup:(SFBookGroupModel *)book;
//删除某个数据
+ (BOOL)deleteBookGroup:(SFBookGroupModel *)book;
//更新某个数据
+ (BOOL)updateBookGroup:(SFBookGroupModel *)book;
//查询某个数据  根据书籍ID
+ (SFBookGroupModel *)selectedBookGroupID:(NSInteger)bookID;
//查找所有数据
+ (NSArray<SFBookGroupModel *> *)selectBookGroups;

@end

NS_ASSUME_NONNULL_END
