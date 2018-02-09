//
//  ContactTool.h
//  01-模糊查询
//
//  Created by apple on 15-3-16.
//  Copyright (c) 2015年 apple. All rights reserved.
//  做sqlite存储

#import <Foundation/Foundation.h>
@class Contact;
@interface ContactTool : NSObject

// 存

/**
 *  存储联系人
 *  contact：联系人模型
 */
+ (void)saveWithContact:(Contact *)contact;

// 取
/**
 *  获取联系人数据
 *
 *  @param sql 查询的语句
 *
 */
+ (NSArray *)contactWithSql:(NSString *)sql;

+ (NSArray *)contacts;

@end
