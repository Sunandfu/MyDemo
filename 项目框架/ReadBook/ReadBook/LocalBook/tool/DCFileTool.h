//
//  DCFileTool.h
//  DCBooks
//
//  Created by cheyr on 2018/3/15.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DCHomeVC.h"
#import "DCPageVC.h"

#define DCBooksPath  [[DCFileTool getDocumentPath] stringByAppendingPathComponent:@"mybooks"] //书籍存放目录
#define DCBookSourcesPath  [[DCFileTool getDocumentPath] stringByAppendingPathComponent:@"myBookSources"] //书源json存放目录
#define DCBookThemePath  [[DCFileTool getDocumentPath] stringByAppendingPathComponent:@"myBookThemes"] //书源json存放目录

@interface DCFileTool : NSObject

+ (NSString *)getDocumentPath;
+ (NSString *)getCachePath;
+ (NSString *)getTmpPath;
/**创建根目录*/
+ (BOOL )creatRootDirectory;
/**根据文件路径，解析文件,utf8,GKB,GBK18030*/
+ (NSString *)transcodingWithPath:(NSString *)path;
/**从字符串中查找要找字符的位置（所有字符）*/
+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText;
///**获取书籍目录列表*/
//+ (NSMutableArray *)getBookListWithText:(NSString *)text;
///**将文件按章节分割*/
//+ (NSMutableArray *)getChapterArrWithString:(NSString *)text;

+(NSDictionary *)getBookDetailWithText:(NSString *)text;

@end
