//
//  DCFileTool.m
//  DCBooks
//
//  Created by cheyr on 2018/3/15.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import "DCFileTool.h"

@implementation DCFileTool
+(NSString *)getDocumentPath
{
    return  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}
+(NSString *)getCachePath
{
    return  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}
+(NSString *)getTmpPath
{
    return  NSTemporaryDirectory();
}
+(BOOL )creatRootDirectory
{
    NSFileManager *fileMag = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if(![fileMag fileExistsAtPath:DCBooksPath isDirectory:&isDir])
    {
        //如果没有则创建文件夹
        [fileMag createDirectoryAtPath:DCBooksPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //将mainbundle的文件拷贝到沙盒
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"龙王传说" ofType:@"txt"];
//    if(![fileMag fileExistsAtPath:[DCBooksPath stringByAppendingPathComponent:@"龙王传说.txt"]])
//    {
//        [fileMag copyItemAtPath:filePath toPath:[DCBooksPath stringByAppendingPathComponent:@"龙王传说.txt"] error:nil];
//        NSLog(@"filepath = %@ , topath = %@",filePath,[DCBooksPath stringByAppendingPathComponent:@"龙王传说.txt"]);
//    }
    return YES;
}
+(NSString *)transcodingWithPath:(NSString *)path
{
    NSLog(@"transcodingWithPath = %@",path);
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    NSStringEncoding * usedEncoding = nil;
    //带编码头的如 utf-8等 这里会识别
    NSString *body = [NSString stringWithContentsOfURL:fileUrl usedEncoding:usedEncoding error:nil];
    if(body)
    {
        return body;
    }
    //如果之前不能解码，现在使用GBK解码
    NSLog(@"GBK");
    body = [NSString stringWithContentsOfURL:fileUrl encoding:0x80000632 error:nil];
    if (body)
    {
        return body;
    }

    //再使用GB18030解码
    NSLog(@"GBK18030");
    body = [NSString stringWithContentsOfURL:fileUrl encoding:0x80000631 error:nil];
    if(body)
    {
        return body;
    }else
    {
        return nil;
    }
}

#pragma mark - 获取这个字符串text中的所有findText的所在的NSRange
+ (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    if (findText == nil && [findText isEqualToString:@""])
    {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText options:NSRegularExpressionSearch];
    if (rang.location != NSNotFound && rang.length != 0)
    {
        [arrayRanges addObject:[NSValue valueWithRange:rang]];
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            if (0 == i)
            {
                //去掉这个abc字符串
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }
            else
            {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            //在一个range范围内查找另一个字符串的range
            rang1 = [text rangeOfString:findText options:NSRegularExpressionSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                break;
            }
            else//添加符合条件的location进数组
                [arrayRanges addObject:[NSValue valueWithRange:rang1]];
            
        }
        return arrayRanges;
    }
    return nil;
}
+(NSMutableArray *)getBookListWithText:(NSString *)text
{
    text = [@"\r\n" stringByAppendingString:text];
    NSMutableArray *marr = [DCFileTool getRangeStr:text findText:@"[\r\n]+[ 　]*[第]{0,1}[0-9一二三四五六七八九十百千万]+[章回]{0,1}[ 　]+.*[\r\n]+|\r\n第[0-9一二三四五六七八九十百千万]+章.*\r\n|[\r\n]+[ 　]*序章[ 　]*[\r\n]+|[\r\n]+[ 　]*楔子[ 　]*[\r\n]+|[\r\n]+[ 　]*前言[ 　]*[\r\n]+"];
    NSMutableArray *strMarr = [NSMutableArray array];
    for (int i = 0; i<marr.count; i++) {
        NSValue *value = marr[i];
        NSString *string = [text substringWithRange:value.rangeValue];
        NSLog(@"%@",string);
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"　　" withString:@""];
        [strMarr addObject:string];
    }
    return strMarr;
}
+(NSMutableArray *)getChapterArrWithString:(NSString *)text
{
    text = [@"\r\n" stringByAppendingString:text];
    NSMutableArray *marr = [DCFileTool getRangeStr:text findText:@"[\r\n]+[ 　]*[第]{0,1}[0-9一二三四五六七八九十百千万]+[章回]{0,1}[ 　]+.*[\r\n]+|\r\n第[0-9一二三四五六七八九十百千万]+章.*\r\n|[\r\n]+[ 　]*序章[ 　]*[\r\n]+|[\r\n]+[ 　]*楔子[ 　]*[\r\n]+|[\r\n]+[ 　]*前言[ 　]*[\r\n]+"];
    NSMutableArray *strMarr = [NSMutableArray array];
    NSRange lastRange = NSMakeRange(0, 0);
    for (int i = 1; i<marr.count; i++) {
        NSValue *value = marr[i];
        NSString *string = [text substringWithRange:NSMakeRange(lastRange.location, value.rangeValue.location - lastRange.location)];
        lastRange = value.rangeValue;
        if([string isEqualToString:@""])
        {
            string = @"\r\n";
        }
        [strMarr addObject:string];
    }
    //最后一章到结尾
    NSString *string = [text substringFromIndex:lastRange.location];
    if(!string || [string isEqualToString:@""])
    {
        string = @"\r\n";
    }
    [strMarr addObject:string];
    return strMarr;
}
+(NSDictionary *)getBookDetailWithText:(NSString *)text
{
    if (!text) {
        return @{@"listArr":@[],@"contentArr":@[]};
    }
    text = [@"\r\n" stringByAppendingString:text];
    NSMutableArray *marr = [DCFileTool getRangeStr:text findText:@"[\r\n]+[ 　]*[第（]{0,1}[ 　]*[0-9一二三四五六七八九十百千万]+[ 　]*[节章回）]{0,1}[ 　]+.*[\r\n]+|[\r\n]+[ 　]*序[ 　]*章[ 　]*[\r\n]+|[\r\n]+[ 　]*楔[ 　]*子[ 　]*[\r\n]+|[\r\n]+[ 　]*后[ 　]*记[ 　]*[\r\n]+|[\r\n]+[ 　]*[第（]{0,1}[0-9一二三四五六七八九十百千万]+[节章回）]{0,1}[ 　]*[\r\n]+"];
    if (!marr) {
        marr = [DCFileTool getRangeStr:text findText:@"[\r\n]+.*[第（]{0,1}[ 　]*[0-9一二三四五六七八九十百千万]+[ 　]*[节章回）]{0,1}.*[\r\n]+"];
    }
    NSMutableArray *listArr = [NSMutableArray array];
    NSMutableArray *contentArr = [NSMutableArray array];
    NSRange lastRange = NSMakeRange(0, 0);
    for (int i = 0; i<marr.count; i++) {
        NSValue *value = marr[i];
        NSString *listName = [text substringWithRange:value.rangeValue];
        listName = [listName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        listName = [listName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listName = [listName stringByReplacingOccurrencesOfString:@"  " withString:@""];
        listName = [listName stringByReplacingOccurrencesOfString:@"　　" withString:@""];
        [listArr addObject:listName];
        if (i!=0) {
            NSString *content = [text substringWithRange:NSMakeRange(lastRange.location, value.rangeValue.location - lastRange.location)];
            lastRange = value.rangeValue;
            if(!content || [content isEqualToString:@""]) {
                content = @"\r\n";
            }
            [contentArr addObject:content];
        }
    }
    //最后一章到结尾
    NSString *string = [text substringFromIndex:lastRange.location];
    if(!string || [string isEqualToString:@""]) {
        string = @"\r\n";
    }
    [contentArr addObject:string];
    return @{@"listArr":listArr,@"contentArr":contentArr};
}

@end
