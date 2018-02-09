//
//  NSObject+YULog.m
//  YUKit<https://github.com/c6357/YUKit>
//
//  Created by BruceYu on 15/9/1.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "NSObject+YULog.h"

#define LOGRETURN @": "
#define IsSafeString(a)             ((a)&& (![(a) isEqual:[NSNull null]]) &&((a).length>0))
#define LOGPATH @"log path"

NSString *LogFileName;

@implementation NSObject (YULog)

+ (void)writeLog:(id)log{
#ifdef DEBUG
    if(!IsSafeString(LogFileName)){
        LogFileName =  [self fileNameString];
    }
    NSString* fileNamePackageRes = [[NSString alloc] initWithFormat:@"%@/%@%@",LOGPATH,LogFileName,@".txt"];

    NSString* oldLog =[[NSString alloc] initWithContentsOfFile:fileNamePackageRes encoding:NSUTF8StringEncoding error:nil];
    
    if (!oldLog) {
        NSString* strLogData = [[NSString alloc]initWithFormat:@"%@%@%@",[self timeString],LOGRETURN,log];
        [strLogData writeToFile:fileNamePackageRes atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        oldLog = [NSString stringWithFormat:@"%@\n\n%@%@%@",oldLog,[self timeString],LOGRETURN,log];
        [oldLog writeToFile:fileNamePackageRes atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
#endif
}


+(NSString*)fileNameString{
    NSDateFormatter *dateFormatter_fileName = [[NSDateFormatter alloc] init];
    [dateFormatter_fileName setDateFormat:@"yyyy.MM.dd.hh.mm.ss"];
    NSString *fileName                      = [dateFormatter_fileName stringFromDate:[NSDate date]];
    return fileName;
}


+(NSString*)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd:hh:mm:ss"];
    NSString *timeStr              = [dateFormatter stringFromDate:[NSDate date]];

    return timeStr;
}


@end
