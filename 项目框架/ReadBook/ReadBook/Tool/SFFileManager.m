//
//  SFFileManager.m
//  SFNewDriverServer
//
//  Created by Pro on 2019/4/1.
//  Copyright © 2019 hpkj. All rights reserved.
//

#import "SFFileManager.h"

@implementation SFFileManager


//获取沙盒根目录
+(NSString*)homeDirectory{
    return NSHomeDirectory();
}

//获取Documents目录
+(NSString*)documentsDirectory{
    NSString* documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return documentsDir;
}

//获取Library目录
+(NSString*)libraryDirectory{
    
    NSString* libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    return libraryDir;
}

//获取Cache目录，这里使用cache目录，cache目录的内存由我们程序员自己管理，（只有当cache目录内存溢出，系统才会自动清理）
+(NSString*)cacheDirectory{
    NSString* cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return cacheDir;
}

//获取tmp目录
+(NSString*)tmpDirectory{
    return NSTemporaryDirectory();
}

+(BOOL)createDirectoryInPath:(NSString*)path directoryName:(NSString*)name{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* newDirectory = [path stringByAppendingPathComponent:name];//创建新的文件夹路径
    BOOL result = [fileManager createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (result) {
        return YES;
    }else{
        return NO;
    }
    
}
//创建文件
+(BOOL)createFileInPath:(NSString*)path fileName:(NSString*)fileName{
    //获取文件管理器
    NSFileManager* fileManager = [NSFileManager defaultManager];
    //新文件的完整路径
    NSString* newFilePath = [path stringByAppendingPathComponent:fileName];
    BOOL result = [fileManager createFileAtPath:newFilePath contents:nil attributes:nil];
    if (result) {
        //文件创建成功
        return YES;
    }else{
        //文件创建失败
        return NO;
    }
}


+(BOOL)fileExistInPath:(NSString*)path{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];
    if (exist) {
        //文件或文件夹存在
        return YES;
    }else{
        //文件或文件夹不存在
        return NO;
    }
}

//通过路径来读取字符串内容
+ (NSString*)readFileFromPath:(NSString*)path{
    
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

//写入字符串到文件（覆盖写）
+ (BOOL)writeString:(NSString*)content toPath:(NSString*)path{
    
    BOOL result = [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (result) {
        //文件写入成功
        return YES;
    }else{
        //文件写入失败;
        return NO;
    }
}

//读取文件
+ (NSString*)readFileUsingFileHandleFromPath:(NSString*)path{
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:path];
    if (file) {
        NSData* content = [file readDataToEndOfFile];
        [file closeFile];
        NSString* contentString = [[NSString alloc]initWithData:content encoding:NSUTF8StringEncoding];
        return contentString;
    }
    return nil;
}

//覆盖写文件(使用NSFilfHandle)
+(BOOL)writeStringUsingFileHandle:(NSString*)content toPath:(NSString*)path{
    if (![self fileExistInPath:path]) {
        //文件不存在，创建这个文件
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        if (result == NO) {
            return NO;
        }
    }
    //获取FileHandle实例，对文件进行操作
    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file) {
        NSData* dataContent = [content dataUsingEncoding:NSUTF8StringEncoding];
        [file truncateFileAtOffset:0];//清空文件内容
        [file writeData:dataContent];//写入文件
        [file closeFile];//关闭文件
        return YES;
    }
    return NO;
}

//追加文件内容
 
+(BOOL)appendStringUsingFileHandle:(NSString*)content toPath:(NSString*)path{
    if (![self fileExistInPath:path]) {
        //文件不存在，创建这个文件
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        if (result == NO) {
            return NO;
        }
    }
    //获取FileHandle实例，对文件进行操作
    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file) {
        NSData* dataContent = [content dataUsingEncoding:NSUTF8StringEncoding];
        [file seekToEndOfFile];//将文件操作的指针，指向文件的结尾
        [file writeData:dataContent];//写入文件
        [file closeFile];//关闭文件
        return YES;
    }
    return NO;
}

//写入字典到文件
+(BOOL)saveDictionary:(NSDictionary*)dict isPlistFileOfPath:(NSString*)path{
    //判断dict是否是有效的字典
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        //dict有效
        return [dict writeToFile:path atomically:YES];
    }
    return NO;
}

//plist
+(NSDictionary*)dictionaryInPlistFileOfPath:(NSString*)path{
    //判断文件是否存在
    if ([self fileExistInPath:path]) {
        //文件存在
        //读取文件
        NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        //判断读取到的dict实例是否有效
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            return dict;
        }
    }
    return nil;
}
+ (NSArray *)arrayInPlistFileOfPath:(NSString*)path{
    //判断文件是否存在
    if ([self fileExistInPath:path]) {
        //文件存在
        //读取文件
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        //判断读取到的dict实例是否有效
        if (array && [array isKindOfClass:[NSArray class]]) {
            return array;
        }
    }
    return nil;
}
//写入json数据到文件
+(BOOL)saveJson:(id)json OfPath:(NSString*)path{
    //判断dict是否是有效的字典
    if (json && ([json isKindOfClass:[NSDictionary class]] || [json isKindOfClass:[NSArray class]])) {
        //dict有效
        return [json writeToFile:path atomically:YES];
    }
    return NO;
}

//列出某个路径下所有的文件或文件夹
 
+ (NSArray*)listForPath:(NSString*)path{
    return [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
}

//递归打印某个路径下所有的文件和文件夹

+ (void)recursionPrintListOfPath:(NSString*)path forLevel:(NSInteger)level{
    
    NSArray* fileList = [self listForPath:path];
    for (NSString* fileName in fileList) {
        //确定打印的缩进
        NSString* indent = @"";
        for (int i = 0; i < level; i++) {
            indent = [indent stringByAppendingString:@"..."];
        }
        //打印这个文件名／文件夹名
        NSLog(@"%@/%@",indent,fileName);
        NSString* filePath = [path stringByAppendingPathComponent:fileName];
        BOOL isDirectory;
        //判断路径是一个文件还是一个文件夹
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        if (isDirectory) {
            //如果要打印的路径，是一个文件夹，则递归打印这个文件夹下所有的文件和文件夹
            [self recursionPrintListOfPath:filePath forLevel:level+1];
        }
        
    }
    
}
/**
 *  递归打印沙盒下所有的文件和文件夹
 */
+ (void) printHierachyOfSandBox{
    [self recursionPrintListOfPath:[self homeDirectory] forLevel:0];
}


//
+ (void)logWithFormat:(NSString*)format, ...{
    va_list paramList;
    va_start(paramList, format);//初始化参数列表
    
    NSString* logString = [[NSString alloc]initWithFormat:format arguments:paramList];//生成格式化字符串
    NSString* logToStore = [logString stringByAppendingString:@"\n"];
    
    va_end(paramList);//释放paramList内存
    
    //生成log存储的文件路径
    NSString* logPath = [[self cacheDirectory] stringByAppendingPathComponent:@"log.txt"];
    //存储log，追加内容到log文件中
    BOOL writeResult = [self appendStringUsingFileHandle:logToStore toPath:logPath];
    if (writeResult) {
        //写入Log成功
        NSLog(@"%@",logString);
    }else{
        //写入log失败
        NSLog(@"写入log失败：%@",logString);
    }
}


+(BOOL)appendStringUsingFileHandleForArrayStr:(NSDictionary*)dic toPath:(NSString*)path{
    if (![self fileExistInPath:path]) {
        //文件不存在，创建这个文件
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        if (result == NO) {
            return NO;
        }
    }
    //获取FileHandle实例，对文件进行操作
    NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
    if (file) {
        NSString * dataContent = [self readFileUsingFileHandleFromPath:path];
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray * array1 = (NSMutableArray *)[self jsonToObject:dataContent];
        if (array1) {
            array = [NSMutableArray arrayWithArray:array1];
        }
        [array addObject:dic];
        NSString * arrstr = [self objectToJson:array];
        NSData * dataContent1 = [arrstr dataUsingEncoding:NSUTF8StringEncoding];
        
        [file writeData:dataContent1];
        [file closeFile];//关闭文件
        return YES;
    }
    return NO;
}

//jsonstr转成对象返回id类型可强转成array类
+(id)jsonToObject:(NSString *)json{
    //string转data
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    //json解析
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return obj;
}
//对象转jsonstr(这里用作将nsarray类型转成jsonstr)
+(NSString *)objectToJson:(id)obj{
    if (obj == nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:0
                                                         error:&error];
    
    if ([jsonData length] && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

@end
