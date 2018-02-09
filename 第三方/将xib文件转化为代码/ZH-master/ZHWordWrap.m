#import "ZHWordWrap.h"
#import "ZHFileManager.h"

@interface ZHWordWrap ()
@property (nonatomic,assign)NSInteger specialCount;
@end
@implementation ZHWordWrap
- (NSString *)description{
    return @"请将要整理的代码文件或者工程路径拖到这个输入框中";
}
- (void)Begin:(NSString *)str{
    NSString *filePath=str;
    switch ([ZHFileManager getFileType:filePath]) {
        case FileTypeNotExsit:
        {
            [self saveData:@"路劲不存在"];
        }
            break;
        case FileTypeFile:
        {
            if ([filePath hasSuffix:@".m"]||[filePath hasSuffix:@".h"]) {
                [self wordWrapFile:filePath];
                [self saveData:@"整理代码完毕!"];
            }else{
                [self saveData:@"文件不是.h或者.m文件,无法整理代码!"];
            }
        }
            break;
        case FileTypeDirectory:
        {
            NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:filePath hasPathExtension:@[@".h",@".m"]];
            NSUInteger sum=0;
            for (NSString *fileName in fileArr) {
                [self wordWrapFile:fileName];
                sum++;
            }
            [self saveData:[NSString stringWithFormat:@"共处理了:%ld个编程文件",sum]];
        }
            break;
        case FileTypeUnkown:
        {
            [self saveData:@"文件类型未知,无法整理代码"];
        }
            break;
    }
}

- (void)wordWrap:(NSString *)path{
    NSString *filePath=path;
    switch ([ZHFileManager getFileType:filePath]) {
        case FileTypeFile:
        {
            if ([filePath hasSuffix:@".m"]||[filePath hasSuffix:@".h"]) {
                [self wordWrapFile:filePath];
            }
        }
            break;
        case FileTypeDirectory:
        {
            NSArray *fileArr=[ZHFileManager subPathFileArrInDirector:filePath hasPathExtension:@[@".h",@".m"]];
            for (NSString *fileName in fileArr) {
                [self wordWrapFile:fileName];
            }
        }
            break;
    }
}
- (NSString *)wordWrapText:(NSString *)text{
    NSMutableArray *arrM=[NSMutableArray array];
    NSArray *arr=[text componentsSeparatedByString:@"\n"];
    for (NSString *str in arr) {
        if (str.length>0) {
            [arrM addObject:[self removeSpacePrefix:str]];
        }else{
            [arrM addObject:@""];
        }
    }
    
    NSInteger count=0;
    
    NSString *tempStr;
    
    NSMutableArray *arrMText=[NSMutableArray array];
    
    for (NSString *str in arrM) {
        if (str.length>0) {
            
            tempStr=[self removeSpaceSuffix:str];
            
            if ([self hasOutIndex:tempStr]){
                count--;
                if (count==-1)count=0;
            }else{
                if (self.specialCount==1) {
                    count++;
                }
            }
            
            [arrMText addObject:[[self getIndentationWithCount:count] stringByAppendingString:tempStr]];
            
            if ([self hasInIndex:tempStr]) {
                count++;
            }
            
            if ([self hasInIndexSpecial:tempStr]==NO) {
                if (self.specialCount==1) {
                    count--;
                    if (count==-1)count=0;
                }
                self.specialCount=0;
            }
        }else{
            [arrMText addObject:[self getIndentationWithCount:count]];
        }
    }
    
    text=[arrMText componentsJoinedByString:@"\n"];
    return text;
}

- (void)wordWrapFile:(NSString *)fileName{
    NSMutableArray *arrM=[NSMutableArray array];
    NSString *strTemp=[NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr=[strTemp componentsSeparatedByString:@"\n"];
    for (NSString *str in arr) {
        if (str.length>0) {
            [arrM addObject:[self removeSpacePrefix:str]];
        }else{
            [arrM addObject:@""];
        }
    }
    [self wordWrapArr:arrM File:fileName];
}

- (void)wordWrapArr:(NSMutableArray *)arrM File:(NSString *)fileName{
    
    NSInteger count=0;
    
    NSString *tempStr;
    
    NSMutableArray *arrMText=[NSMutableArray array];
    
    for (NSString *str in arrM) {
        if (str.length>0) {
            
            tempStr=[self removeSpaceSuffix:str];
            
            if ([self hasOutIndex:tempStr]){
                count--;
                if (count==-1)count=0;
            }else{
                if (self.specialCount==1) {
                    count++;
                }
            }
            
            [arrMText addObject:[[self getIndentationWithCount:count] stringByAppendingString:tempStr]];
            
            if ([self hasInIndex:tempStr]) {
                count++;
            }
            
            if ([self hasInIndexSpecial:tempStr]==NO) {
                if (self.specialCount==1) {
                    count--;
                    if (count==-1)count=0;
                }
                self.specialCount=0;
            }
        }else{
            [arrMText addObject:[self getIndentationWithCount:count]];
        }
    }
    
    NSString *text=[arrMText componentsJoinedByString:@"\n"];
    [text writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (BOOL)hasOutIndex:(NSString *)text{
    NSArray *arr=@[@"}",@"});"];
    for (NSString *str in arr) {
        if ([text hasSuffix:str]) {
            return YES;
        }
    }
    
    NSArray *arrPrefix=@[@"}"];
    for (NSString *str in arrPrefix) {
        if ([text hasPrefix:str]) {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)hasInIndex:(NSString *)text{
    NSArray *arr=@[@"{"];
    for (NSString *str in arr) {
        if ([text hasSuffix:str]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)hasInIndexSpecial:(NSString *)text{
    
    if ([text hasSuffix:@"else"]) {
        self.specialCount=1;
        return YES;
    }
    
    if ([text hasSuffix:@")"]) {
        if ([text hasPrefix:@"if"]) {
            self.specialCount=1;
            return YES;
        }
    }
    
    return NO;
}
- (NSString *)getIndentationWithCount:(NSInteger)count{
    NSMutableString *strM=[NSMutableString string];
    for (NSInteger i=0; i<count; i++) {
        [strM appendString:@"\t"];
    }
    return strM;
}

- (NSString *)removeSpacePrefix:(NSString *)text{
    if ([text hasPrefix:@" "]) {
        text=[text substringFromIndex:1];
        return [self removeSpacePrefix:text];
    }
    else if([text hasPrefix:@"\t"]){
        text=[text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpacePrefix:text];
    }else
        return text;
}
- (NSString *)removeSpaceSuffix:(NSString *)text{
    if ([text hasSuffix:@" "]) {
        text=[text substringToIndex:text.length-1];
        return [self removeSpaceSuffix:text];
    }
    else return text;
}

@end