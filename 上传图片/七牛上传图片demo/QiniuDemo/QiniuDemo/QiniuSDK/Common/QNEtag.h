//
//  QNEtag.h
//  QiniuSDK
//
//  Created by bailong on 14/10/4.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    服务器 hash etag 生成
 */
@interface QNEtag : NSObject

/**
 *    文件etag
 *
 *    @param filePath 文件路径
 *    @param error    输出文件读取错误
 *
 *    @return etag
 */
+ (NSString *)file:(NSString *)filePath
             error:(NSError **)error;

/**
 *    二进制数据etag
 *
 *    @param data 数据
 *
 *    @return etag
 */
+ (NSString *)data:(NSData *)data;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com