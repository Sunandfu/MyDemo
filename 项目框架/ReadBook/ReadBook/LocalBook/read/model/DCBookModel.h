//
//  DCBookModel.h
//  DCBooks
//
//  Created by cheyr on 2018/3/15.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilsMacro.h"

@interface DCBookModel : NSObject

@property (nonatomic,copy) NSString *name;//文件名
@property (nonatomic,copy) NSString *path;//文件路径
@property (nonatomic,copy) NSString *type;//文件类型
@property (nonatomic,copy) NSString *readTime;//阅读时间

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic, assign) NSInteger bookIndex;//当前阅读章节下标
@property (nonatomic, assign) NSInteger bookPage;//当前阅读章节下标
@property (nonatomic, assign) float pageOffset;//当前阅读章节内容偏移位

@property (nonatomic,copy) NSString *menuData;
@property (nonatomic,copy) NSString *contentData;

@property (copy,nonatomic) NSString *other1;//备用1
@property (copy,nonatomic) NSString *other2;//备用2
@property (nonatomic, assign) float other3;//备用3

@end
