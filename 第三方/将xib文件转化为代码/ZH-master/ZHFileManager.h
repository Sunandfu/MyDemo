#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FileType) {
    FileTypeDirectory,
    FileTypeFile,
    FileTypeNotExsit,
    FileTypeUnkown
};
@interface ZHFileManager : NSObject

#pragma mark 文件(夹)的基本属性和操作
/**获取文件(夹)的创建日期*/
+ (NSDate *)getFileCreateDate:(NSString *)filePath;
/**获取文件(夹)的修改日期*/
+ (NSDate *)getFileModDate:(NSString *)filePath;
/**获取文件(夹)的大小*/
+ (CGFloat)getFileSize:(NSString *)filePath;
/**获取文件(夹)的大小(字符串)*/
+ (NSString *)fileSizeString:(NSString *)filePath;
/**获取文件(夹)的类型*/
+ (FileType)getFileType:(NSString *)filePath;
/**获取文件名从文件路径中*/
+ (NSString *)getFileNameFromFilePath:(NSString *)filePath;
/**获取文件名(不带后缀)从文件路径中*/
+ (NSString *)getFileNameNoPathComponentFromFilePath:(NSString *)filePath;
/**在iOS手机里获取mac主机地址*/
+ (NSString *)getMacHomeDirectorInIOS;
/**获取上一层的文件路径*/
+ (NSString *)getUpLeverDirector:(NSString *)DirectorPath;
/**获取上一层的文件路径*/
+ (NSString *)getFilePathRemoveFileName:(NSString *)filePath;

#pragma mark 创建文件(夹)操作
/**创建文件夹,如果它不存在*/
+ (void)creatDirectorIfNotExsit:(NSString *)DirectorPath;
/**在某个文件夹目录下创建随机名字(数字)的文件夹*/
+ (NSString *)creatRandomDirectorContainDigitalInDirector:(NSString *)DirectorPath;
/**在某个文件夹目录下创建随机名字(字母)的文件夹*/
+ (NSString *)creatRandomDirectorContainCharacterInDirector:(NSString *)DirectorPath;
/**在某个文件夹目录下创建随机名字(数字和字母)的文件夹*/
+ (NSString *)creatRandomDirectorContainDigitalCharacterInDirector:(NSString *)DirectorPath;
/**在某个文件夹目录下创建随机名字(数字)的文件*/
+ (NSString *)creatRandomFileContainDigitalInDirector:(NSString *)DirectorPath pathExtension:(NSString *)pathExtension;
/**在某个文件夹目录下创建随机名字(字母)的文件*/
+ (NSString *)creatRandomFileContainCharacterInDirector:(NSString *)DirectorPath pathExtension:(NSString *)pathExtension;
/**在某个文件夹目录下创建随机名字(数字和字母)的文件*/
+ (NSString *)creatRandomFileContainDigitalCharacterInDirector:(NSString *)DirectorPath pathExtension:(NSString *)pathExtension;

#pragma mark 遍历文件夹操作
/**获取子路径 文件(夹) */
+ (NSArray *)subPathArrInDirector:(NSString *)DirectorPath;
/**获取子路径 文件 */
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath;
/**获取子路径 文件夹 */
+ (NSArray *)subPathDirectorArrInDirector:(NSString *)DirectorPath;
/**获取子路径 文件(带特定后缀) */
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath hasPathExtension:(NSArray *)pathExtension;
/**获取子路径 文件(文件名包含指定字符串) */
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath fileNameContain:(NSArray *)contents;
/**获取子路径 文件(路径包含指定路径名(段名)) */
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath pathContainDirector:(NSArray *)Directors;
/**获取子路径 文件(路径层数小于或等于某个层数) */
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath pathLessLimiteLevelDirector:(NSInteger)Level;
/**获取子路径 文件(路径层数大于或等于某个层数) */
+ (NSArray *)subPathFileArrInDirector:(NSString *)DirectorPath pathMoreLimiteLevelDirector:(NSInteger)Level;

#pragma mark 原生态自带的
/**判断某文件或者文件夹是否存在*/
+ (BOOL)fileExistsAtPath:(NSString *)path;
/**复制某个文件到另外一个路径下*/
+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
/**移动某个文件到另外一个路径下*/
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;
/**删除某个文件*/
+ (BOOL)removeItemAtPath:(NSString *)path;
/**创建文件夹到某个目录下*/
+ (BOOL)createDirectoryAtPath:(NSString *)path;
/**创建文件到某个目录下*/
+ (BOOL)createFileAtPath:(NSString *)path;
/**遍历所有子文件和文件夹*/
+ (NSArray<NSString *> *)subpathsAtPath:(NSString *)path;
/**遍历某文件夹的里面当层文件和文件夹,不会深层遍历*/
+ (NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path;
@end