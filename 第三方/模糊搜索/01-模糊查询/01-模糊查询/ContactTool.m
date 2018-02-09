//
//  ContactTool.m
//  01-模糊查询
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ContactTool.h"
#import <sqlite3.h>
#import "Contact.h"

@implementation ContactTool
/*
 1.打开数据库，第一次使用这个业务类
 2.创建表格
 */
static sqlite3 *_db;
+ (void)initialize
{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"contact.sqlite"];
    
    // 打开数据库
    if (sqlite3_open(filePath.UTF8String, &_db) == SQLITE_OK) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    
    // 创建表格
    NSString *sql = @"create table if not exists t_contact (id integer primary key autoincrement,name text,phone text);";
    char *error;
    
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    
    if (error) {
        NSLog(@"创建表格失败");
    }else{
        NSLog(@"创建表格成功");

    }
    
}

+ (BOOL)execWithSql:(NSString *)sql
{
    BOOL flag;
    char *error;
    
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    
    if (error) {
        flag = NO;
        NSLog(@"%s",error);
    }else{
        
        flag = YES;
        
    }
    
    return flag;
}

+ (void)saveWithContact:(Contact *)contact
{
    NSString *sql = [NSString stringWithFormat:@"insert into t_contact (name,phone) values ('%@','%@')",contact.name,contact.phone];
    BOOL flag = [self execWithSql:sql];
    if (flag) {
        NSLog(@"插入成功");
    }else{
         NSLog(@"插入失败");
    }
}

+ (NSArray *)contacts
{
  return  [self contactWithSql:@"select * from t_contact"];
}

+ (NSArray *)contactWithSql:(NSString *)sql
{
    NSMutableArray *arrM = [NSMutableArray array];
    // 准备查询，生成句柄，操作查询数据结果
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        
        // 执行句柄
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 1)];
             NSString *phone = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 2)];
            
            Contact *c = [Contact contactWithName:name phone:phone];
            [arrM addObject:c];
        }
        
        
    }
    
    return arrM;
    
}

@end
