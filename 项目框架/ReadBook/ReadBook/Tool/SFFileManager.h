//
//  SFFileManager.h
//  SFNewDriverServer
//
//  Created by Pro on 2019/4/1.
//  Copyright © 2019 hpkj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFFileManager : NSObject

//获取沙盒根目录
+(NSString*)homeDirectory;
//获取Documents目录
+(NSString*)documentsDirectory;
//获取Library目录
+(NSString*)libraryDirectory;
//获取Cache目录
+(NSString*)cacheDirectory;
//获取tmp目录
+(NSString*)tmpDirectory;
//创建文件夹
+(BOOL)createDirectoryInPath:(NSString*)path directoryName:(NSString*)name;
//创建文件
+(BOOL)createFileInPath:(NSString*)path fileName:(NSString*)fileName;
//查询文件/文件夹是否存在
+(BOOL)fileExistInPath:(NSString*)path;

//简单读文件
+ (NSString*)readFileFromPath:(NSString*)path;
//简单覆盖写文件
+ (BOOL)writeString:(NSString*)content toPath:(NSString*)path;

//读取文件(使用NSFileHandle)
+ (NSString*)readFileUsingFileHandleFromPath:(NSString*)path;
//覆盖写文件(使用NSFilfHandle)
+(BOOL)writeStringUsingFileHandle:(NSString*)content toPath:(NSString*)path;
//追加写文件(使用NSFilfHandle)
+(BOOL)appendStringUsingFileHandle:(NSString*)content toPath:(NSString*)path;
//将字典保存在Plist文件中
+(BOOL)saveDictionary:(NSDictionary*)dict isPlistFileOfPath:(NSString*)path;
//从Plist文件中读取字典
+(NSDictionary*)dictionaryInPlistFileOfPath:(NSString*)path;
+(NSArray *)arrayInPlistFileOfPath:(NSString*)path;

+(BOOL)saveJson:(id)json OfPath:(NSString*)path;

//递归打印沙盒下所有的文件和文件夹
+ (void) printHierachyOfSandBox;
//格式化Log到文件中
+ (void)logWithFormat:(NSString*)format, ...;

+(BOOL)appendStringUsingFileHandleForArrayStr:(NSDictionary*)dic toPath:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
