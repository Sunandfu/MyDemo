#import "ZHFileManager.h"

@implementation ZHFileManager
#pragma mark 文件(夹)的基本属性
+ (NSDictionary *)getFileAttributes:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes=[fileManager attributesOfItemAtPath:filePath error:nil];
    return fileAttributes;
}
+ (NSDate *)getFileCreateDate:(NSString *)filePath{
    NSDictionary *fileAttributes=[self getFileAttributes:filePath];
    if (fileAttributes != nil) {
        //创建时间
        NSDate *fileCreateDate;
        fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
        return fileCreateDate;
    }
    return nil;
}
+ (NSDate *)getFileModDate:(NSString *)filePath{
    NSDictionary *fileAttributes=[self getFileAttributes:filePath];
    if (fileAttributes != nil) {
        //最后修改时间
        NSDate *fileModDate;
        fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        return fileModDate;
    }
    return nil;
}
+ (CGFloat)getDirectorySize:(NSString *)filePath{
    NSArray *files=[[NSFileManager defaultManager]contentsOfDirectoryAtPath:filePath error:nil];
    CGFloat size=0.0;
    for (NSString *str in files) {
        size+=[self getFileSize:[filePath stringByAppendingPathComponent:str]];
    }
    return size;
}
+ (CGFloat)getFileSize:(NSString *)filePath{
    switch ([self getFileType:filePath]) {
        case FileTypeNotExsit:case FileTypeUnkown:
            return 0;
            break;
        case FileTypeFile:
        {
            NSDictionary *fileAttributes=[self getFileAttributes:filePath];
                //文件大小
            CGFloat size=[[fileAttributes objectForKey:NSFileSize] floatValue];
            return size;
        }
        case FileTypeDirectory:
        {
//            NSDictionary *fileAttributes=[self getFileAttributes:filePath];
            //文件夹大小
//            CGFloat size=[[fileAttributes objectForKey:NSFileSize] floatValue];
            return [self getDirectorySize:filePath];
        }
    }
    return 0;
}
+ (NSString *)fileSizeString:(NSString *)filePath{
    CGFloat size=[self getFileSize:filePath];
    if (size<1000.0f) {
        return [NSString stringWithFormat:@"%.01fB",size];
    }
    else if (size<1000.0*1000.0){
        return [NSString stringWithFormat:@"%.01fKB",size/1000.0];
    }
    else if (size<1000.0*1000.0*1000.0){
        return [NSString stringWithFormat:@"%.01fM",size/1000.0/1000.0];
    }
    else if (size<1000.0*1000.0*1000.0*1000.0){
        return [NSString stringWithFormat:@"%.01fG",size/1000.0/1000.0/1000.0];
    }
    else if (size<1000.0*1000.0*1000.0*1000.0*1000.0){
        return [NSString stringWithFormat:@"%.01fT",size/1000.0/1000.0/1000.0/1000.0];
    }
    return @"0B";
}
+ (FileType)getFileType:(NSString *)filePath{
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]==NO) {
        return FileTypeNotExsit;
    }
    NSDictionary *fileAttributes=[self getFileAttributes:filePath];
    if (fileAttributes != nil) {
        //是否为文件还是目录NSFileTypeDirectory
        if ([[fileAttributes objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"]) {
            return FileTypeDirectory;
        }else if([[fileAttributes objectForKey:NSFileType] isEqualToString:@"NSFileTypeRegular"]){
            return FileTypeFile;
        }else{
            return FileTypeUnkown;
        }
    }
    return FileTypeUnkown;
}
+ (NSString *)getFileNameFromFilePath:(NSString *)filePath{
    return [filePath stringByReplacingOccurrencesOfString:[[filePath stringByDeletingLastPathComponent] stringByAppendingString:@"/"] withString:@""];
}
+ (NSString *)getFilePathRemoveFileName:(NSString *)filePath{
    NSString *fileName=[self getFileNameFromFilePath:filePath];
    filePath=[filePath stringByReplacingOccurrencesOfString:fileName withString:@""];
    if ([filePath hasSuffix:@"/"]) {
        filePath=[filePath substringToIndex:filePath.length-1];
    }
    return filePath;
}
+ (NSString *)getFileNameNoPathComponentFromFilePath:(NSString *)filePath{
    NSString *fileName=[filePath stringByReplacingOccurrencesOfString:[[filePath stringByDeletingLastPathComponent] stringByAppendingString:@"/"] withString:@""];
    return [fileName stringByDeletingPathExtension];
}
+ (NSString *)getMacHomeDirectorInIOS{
    if ([NSHomeDirectory() rangeOfString:@"Library/Developer"].location!=NSNotFound) {
        NSString *path=[NSHomeDirectory() substringToIndex:[NSHomeDirectory() rangeOfString:@"Library/Developer"].location];
        return [path substringToIndex:path.length-1];
    }else{
        return @"";
    }
}
+ (NSString *)getUpLeverDirector:(NSString *)DirectorPath{
    NSString *director=[DirectorPath stringByDeletingLastPathComponent];
    if (![director isEqualToString:@"/"]) {
        return director;
    }
    return @"";
}

#pragma mark 文件夹操作
+ (void)creatDirectorIfNotExsit:(NSString *)DirectorPath{
    BOOL yes;
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath isDirectory:&yes]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:DirectorPath withIntermediateDirectories:yes attributes:nil error:nil];
    }
}
+ (NSString *)getDigitalFileName{
    NSInteger len=25;
    unichar ch;
    NSMutableString *fileName=[NSMutableString string];
    for (NSInteger i=0; i<len; i++) {
        ch='0'+arc4random()%10;
        [fileName appendFormat:@"%C",ch];
    }
    return fileName;
}
+ (NSString *)getCharacterFileName{
    NSInteger len=25;
    unichar ch;
    NSMutableString *fileName=[NSMutableString string];
    for (NSInteger i=0; i<len; i++) {
        ch='A'+arc4random()%26;
        [fileName appendFormat:@"%C",ch];
    }
    return fileName;
}
+ (NSString *)getDigitalCharacterFileName{
    NSInteger len=25;
    unichar ch;
    NSMutableString *fileName=[NSMutableString string];
    for (NSInteger i=0; i<len; i++) {
        NSInteger type=arc4random()%3+1;
        if (type==1) {//数字
            ch='0'+arc4random()%10;
        }else{//字母(让字母更多一点)
            ch='A'+arc4random()%26;
        }
        [fileName appendFormat:@"%C",ch];
    }
    return fileName;
}
+ (NSString *)creatRandomDirectorContainDigitalInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return @"";
    }
    NSString *fileName=[self getDigitalFileName];
    while ([[NSFileManager defaultManager]fileExistsAtPath:[DirectorPath stringByAppendingPathComponent:fileName]]) {
        fileName=[self getDigitalFileName];
    }
    [[NSFileManager defaultManager]createDirectoryAtPath:[DirectorPath stringByAppendingPathComponent:fileName] withIntermediateDirectories:YES attributes:nil error:nil];
    return [DirectorPath stringByAppendingPathComponent:fileName];
}
+ (NSString *)creatRandomDirectorContainCharacterInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return @"";
    }
    NSString *fileName=[self getCharacterFileName];
    while ([[NSFileManager defaultManager]fileExistsAtPath:[DirectorPath stringByAppendingPathComponent:fileName]]) {
        fileName=[self getCharacterFileName];
    }
    [[NSFileManager defaultManager]createDirectoryAtPath:[DirectorPath stringByAppendingPathComponent:fileName] withIntermediateDirectories:YES attributes:nil error:nil];
    return [DirectorPath stringByAppendingPathComponent:fileName];
}
+ (NSString *)creatRandomDirectorContainDigitalCharacterInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return @"";
    }
    NSString *fileName=[self getDigitalCharacterFileName];
    while ([[NSFileManager defaultManager]fileExistsAtPath:[DirectorPath stringByAppendingPathComponent:fileName]]) {
        fileName=[self getDigitalCharacterFileName];
    }
    [[NSFileManager defaultManager]createDirectoryAtPath:[DirectorPath stringByAppendingPathComponent:fileName] withIntermediateDirectories:YES attributes:nil error:nil];
    return [DirectorPath stringByAppendingPathComponent:fileName];
}
+ (NSString *)creatRandomFileContainDigitalInDirector:(NSString *)DirectorPath pathExtension:(NSString *)pathExtension{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return @"";
    }
    NSString *fileName=[[self getDigitalFileName] stringByAppendingString:pathExtension];
    while ([[NSFileManager defaultManager]fileExistsAtPath:[DirectorPath stringByAppendingPathComponent:fileName]]) {
        fileName=[[self getDigitalFileName] stringByAppendingString:pathExtension];
    }
    [[NSFileManager defaultManager]createFileAtPath:[DirectorPath stringByAppendingPathComponent:fileName] contents:nil attributes:nil];
    return [DirectorPath stringByAppendingPathComponent:fileName];
}
+ (NSString *)creatRandomFileContainCharacterInDirector:(NSString *)DirectorPath pathExtension:(NSString *)pathExtension{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return @"";
    }
    NSString *fileName=[[self getCharacterFileName] stringByAppendingString:pathExtension];
    while ([[NSFileManager defaultManager]fileExistsAtPath:[DirectorPath stringByAppendingPathComponent:fileName]]) {
        fileName=[[self getCharacterFileName] stringByAppendingString:pathExtension];
    }
    [[NSFileManager defaultManager]createFileAtPath:[DirectorPath stringByAppendingPathComponent:fileName] contents:nil attributes:nil];
    return [DirectorPath stringByAppendingPathComponent:fileName];
}
+ (NSString *)creatRandomFileContainDigitalCharacterInDirector:(NSString *)DirectorPath pathExtension:(NSString *)pathExtension{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return @"";
    }
    NSString *fileName=[[self getDigitalCharacterFileName] stringByAppendingString:pathExtension];
    while ([[NSFileManager defaultManager]fileExistsAtPath:[DirectorPath stringByAppendingPathComponent:fileName]]) {
        fileName=[[self getDigitalCharacterFileName] stringByAppendingString:pathExtension];
    }
    [[NSFileManager defaultManager]createFileAtPath:[DirectorPath stringByAppendingPathComponent:fileName] contents:nil attributes:nil];
    return [DirectorPath stringByAppendingPathComponent:fileName];
}

#pragma mark 遍历文件夹操作
+ (NSArray *)subPathArrInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return nil;
    }
    NSArray *arrTemp=[[NSFileManager defaultManager]subpathsAtPath:DirectorPath];
    NSMutableArray *pathArr=[NSMutableArray array];
    for (NSString *str in arrTemp) {
        if (str.length>0) {
            [pathArr addObject:[DirectorPath stringByAppendingPathComponent:str]];
        }
    }
    if (pathArr.count>0) {
        return pathArr;
    }
    return nil;
}
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return nil;
    }
    NSArray *arrTemp=[[NSFileManager defaultManager]subpathsAtPath:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *str in arrTemp) {
        if (str.length>0) {
            if ([self getFileType:[DirectorPath stringByAppendingPathComponent:str]]==FileTypeFile) {
                [pathFileArr addObject:[DirectorPath stringByAppendingPathComponent:str]];
            }
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}
+ (NSArray *)subPathDirectorArrInDirector:(NSString *)DirectorPath{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return nil;
    }
    NSArray *arrTemp=[[NSFileManager defaultManager]subpathsAtPath:DirectorPath];
    NSMutableArray *pathDirectorArr=[NSMutableArray array];
    for (NSString *str in arrTemp) {
        if (str.length>0) {
            if ([self getFileType:[DirectorPath stringByAppendingPathComponent:str]]==FileTypeDirectory) {
                [pathDirectorArr addObject:[DirectorPath stringByAppendingPathComponent:str]];
            }
        }
    }
    if (pathDirectorArr.count>0) {
        return pathDirectorArr;
    }
    return nil;
}
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath hasPathExtension:(NSArray *)pathExtension{
    if (![[NSFileManager defaultManager]fileExistsAtPath:DirectorPath]) {
        return nil;
    }
    NSArray *arrTemp=[[NSFileManager defaultManager]subpathsAtPath:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *str in arrTemp) {
        if (str.length>0) {
            for (NSString *subPathExtension in pathExtension) {
                if ([str hasSuffix:subPathExtension]) {
                    [pathFileArr addObject:[DirectorPath stringByAppendingPathComponent:str]];
                    break;
                }
            }
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath fileNameContain:(NSArray *)contents{
    NSArray *fileArr=[self subPathFileArrInDirector:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *filePath in fileArr) {
        NSString *fileNameNoPathComponent=[self getFileNameNoPathComponentFromFilePath:filePath];
        for (NSString *content in contents) {
            if ([fileNameNoPathComponent rangeOfString:content].location!=NSNotFound) {
                [pathFileArr addObject:filePath];
                break;
            }
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath pathContainDirector:(NSArray *)Directors{
    NSArray *fileArr=[self subPathFileArrInDirector:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *filePath in fileArr) {
        
        NSString *fileNameNoFileName=[filePath stringByDeletingLastPathComponent];
        
        NSMutableArray *leverArr=[NSMutableArray array];
        for (NSString *subLever in [fileNameNoFileName componentsSeparatedByString:@"/"]) {
            if (subLever.length>0) {
                [leverArr addObject:subLever];
            }
        }
        
        //判断是否有交集
        if ([self arr:Directors HasContainObjectInOtherArr:leverArr]) {
            [pathFileArr addObject:filePath];
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}

+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath pathLessLimiteLevelDirector:(NSInteger)Level{
    NSArray *fileArr=[self subPathFileArrInDirector:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *filePath in fileArr) {
        
        NSMutableArray *leverArr=[NSMutableArray array];
        for (NSString *subLever in [filePath componentsSeparatedByString:@"/"]) {
            if (subLever.length>0) {
                [leverArr addObject:subLever];
            }
        }
        
        if (leverArr.count<=Level) {
            [pathFileArr addObject:filePath];
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath pathMoreLimiteLevelDirector:(NSInteger)Level{
    NSArray *fileArr=[self subPathFileArrInDirector:DirectorPath];
    NSMutableArray *pathFileArr=[NSMutableArray array];
    for (NSString *filePath in fileArr) {
        
        NSMutableArray *leverArr=[NSMutableArray array];
        for (NSString *subLever in [filePath componentsSeparatedByString:@"/"]) {
            if (subLever.length>0) {
                [leverArr addObject:subLever];
            }
        }
        
        if (leverArr.count>=Level) {
            [pathFileArr addObject:filePath];
        }
    }
    if (pathFileArr.count>0) {
        return pathFileArr;
    }
    return nil;
}

+ (BOOL)arr:(NSArray *)arr HasContainObjectInOtherArr:(NSArray *)otherArr{
    for (NSString *str in arr) {
        for (NSString *subStr in otherArr) {
            if ([str isEqualToString:subStr]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark 原生态自带的
/**判断某文件或者文件夹是否存在*/
+ (BOOL)fileExistsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}
/**复制某个文件到另外一个路径下*/
+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    return [[NSFileManager defaultManager]copyItemAtPath:srcPath toPath:dstPath error:nil];
}
/**移动某个文件到另外一个路径下*/
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    return [[NSFileManager defaultManager]moveItemAtPath:srcPath toPath:dstPath error:nil];
}
/**删除某个文件*/
+ (BOOL)removeItemAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
}
/**创建文件夹到某个目录下*/
+ (BOOL)createDirectoryAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}
/**创建文件到某个目录下*/
+ (BOOL)createFileAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]createFileAtPath:path contents:nil attributes:nil];
}
/**遍历所有子文件和文件夹*/
+ (NSArray<NSString *> *)subpathsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]subpathsAtPath:path];
}
/**遍历某文件夹的里面当层文件和文件夹,不会深层遍历*/
+ (NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path{
    return [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
}
@end