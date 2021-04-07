//
//  SFNetWork.h
//  ReadBook
//
//  Created by lurich on 2020/5/15.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYWebImage/YYWebImage.h>
#import "SVProgressHUD.h"
#import <MJRefresh/MJRefresh.h>
#import "ONOXMLDocument.h"
#import "SFConstant.h"
#import "SFBookSave.h"
#import "BookModel.h"
#import "NSObject+SF_MJParse.h"
#import "SFSafeAreaInsets.h"
#import "LBToAppStore.h"
#import "DCFileTool.h"

@interface SFNetWork : NSObject

//GET请求json数据
+ (void)getJsonDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id json))success fail:(void(^)(NSError * error))fail;
//GET请求xml数据
+ (void)getXmlDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id data))success fail:(void(^)(NSError * error))fail;
//POST请求xml数据
+ (void)postXmlDataWithURL:(NSString *)url parameters:(id)parameters success:(void(^)(id data))success fail:(void(^)(NSError * error))fail;

+ (void)cacheBooksWithBook:(BookModel *)book success:(void(^)(id data))success fail:(void(^)(NSError * error))fail;
+ (void)cacheBooksWithModelArray:(NSArray<BookDetailModel *> *)modelArray XPatn:(NSString *)xpath;
+ (void)cacheJsonBooksWithBook:(BookModel *)book success:(void(^)(id data))success fail:(void(^)(NSError * error))fail;
+ (void)cacheJsonBooksWithModelArray:(NSArray<BookDetailModel *> *)modelArray XPatn:(NSString *)xpath;
+ (void)cacheCartoonWithModelArray:(NSArray<BookDetailModel *> *)modelArray XPatn:(NSString *)xpath;
+ (NSString *)cachePathWithMD5:(NSString *)md5;

@end
