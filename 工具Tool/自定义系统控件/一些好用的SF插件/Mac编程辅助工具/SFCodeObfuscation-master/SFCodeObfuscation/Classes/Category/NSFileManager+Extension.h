//
//  NSFileManager+Extension.h
//  SFCodeObfuscation
//
//  Created by SF on 2018/8/16.
//  Copyright © 2018年 Lurich All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extension)

/** 获得文件的MIMEType */
+ (void)sf_getMIMEType:(NSString*)filepath
            completion:(void (^)(NSString *MIMEType))completion;

/** 将文件名分割成文件名+拓展名 */
+ (void)sf_divideFilename:(NSString *)filename
               completion:(void (^)(NSString *filename, NSString *extension))completion;

/** 获得dir的所有符合extensions拓展名的子路径 */
+ (NSArray *)sf_subpathsAtPath:(NSString *)dir
                    extensions:(NSArray *)extensions;

/** 获得dir的所有子目录 */
+ (NSArray *)sf_subdirsAtPath:(NSString *)dir;

/** 检查某个路径是否存在，如果存在，就生成新的路径名，直到不存在为止 */
+ (NSString *)sf_checkPathExists:(NSString *)path;

@end
