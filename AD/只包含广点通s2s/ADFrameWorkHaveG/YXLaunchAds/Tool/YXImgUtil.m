//
//  YXImgUtil.m
//  WalkerDSP
//
//  Created by Luo on 15/12/14.
//  Copyright © 2015年 emaryjf. All rights reserved.
//

#import "YXImgUtil.h"
#define KADWalkerPopFrameAdDirectoryName @"ADWalkerPopFrameAdDirectoryName"
@implementation YXImgUtil
+(NSString *) getSavePath:(NSString *)imgUrl
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [[imgUrl componentsSeparatedByString:@"/"] lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *directoryPath = [[paths lastObject] stringByAppendingPathComponent:KADWalkerPopFrameAdDirectoryName];
    NSString *savePath = [directoryPath stringByAppendingPathComponent:fileName];
    return savePath;
}
+(void)saveImg:(NSString *)imgUrl savedSuccess:(savedSuccessBlock)sucBlock failBlock:(failBlock)failBlock
{
    
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       
                       NSFileManager *fileManager = [NSFileManager defaultManager];
                       NSString *fileName = [[imgUrl componentsSeparatedByString:@"/"] lastObject];
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
                       NSString *directoryPath = [paths lastObject];
                       NSString *savePath = [directoryPath stringByAppendingPathComponent:fileName];
                       // 缓存广告信息
                       if(![fileManager fileExistsAtPath:savePath]){
                           NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                           UIImage *image = [UIImage imageWithData:data];
                           if(image){
                               [UIImagePNGRepresentation(image)writeToFile:savePath atomically:YES];
                           }
                           if(data){
                               //忽略图片格式
                               BOOL flag;
                              flag =  [data writeToFile:savePath atomically:YES];
                               if(flag){
                                   dispatch_async( dispatch_get_main_queue(), ^(void){
                                       sucBlock();
                                   });
                               }else{
                                   dispatch_async( dispatch_get_main_queue(), ^(void){
                                       failBlock([NSError errorWithDomain:@"本地保存图片失败" code:90000 userInfo:nil]);
                                   });
                               }
                            
                           }
                       }
                   }
                   );

}

+(void)imgWithUrl:(NSString *)imgUrl successBlock:(successBlock)sucBlock failBlock:(failBlock)faiBlock
{
      dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSString *fileName = [[imgUrl componentsSeparatedByString:@"/"] lastObject];
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
                       NSString *directoryPath = [paths lastObject];
                       NSString *savePath = [directoryPath stringByAppendingPathComponent:fileName];
                       NSData *data = [NSData dataWithContentsOfFile:savePath];
                       if(data){
                           __block  UIImage * image = [[UIImage alloc] initWithData:data];//这个方法也是异步
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if(image)
                                   sucBlock(image);
                           });
                       }else{
                           //本地没有从网络获取
                           NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                           if(datas){
                               __block  UIImage * image = [[UIImage alloc] initWithData:datas];//这个方法也是异步
                              [datas writeToFile:savePath atomically:YES];
 
                               dispatch_async( dispatch_get_main_queue(), ^(void){
                                   if(image)
                                       sucBlock(image);
                               });
                           }else{
                               dispatch_async( dispatch_get_main_queue(), ^(void){
                                   NSError *error = [NSError errorWithDomain:@"url 非法,图片不存在" code:999 userInfo:nil];
                                   faiBlock(error);
                               });
                           }
                       }
        });

}

+(void)imgWithUrlWithOutCache:(NSString *)imgUrl successBlock:(successBlock)sucBlock failBlock:(failBlock)faiBlock
{
      dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       //本地没有从网络获取
                       NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                       if(datas){
                           
                           __block  UIImage * image = [[UIImage alloc] initWithData:datas];//这个方法也是异步
                           
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               if(image)
                                   sucBlock(image);
                           });
                           
                       }else{
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               NSError *error = [NSError errorWithDomain:@"url 非法,图片不存在" code:999 userInfo:nil];
                               faiBlock(error);
                           });
                       }
                   }
                   );
    
}


+(void)gifImgWithUrl:(NSString *)imgUrl successBlock:(gifSuccessBlock)sucBlock failBlock:(failBlock)faiBlock
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSString *fileName = [[imgUrl componentsSeparatedByString:@"/"] lastObject];
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
                       NSString *directoryPath = [paths lastObject];
                       NSString *savePath = [directoryPath stringByAppendingPathComponent:fileName];
                       __block  NSData *data = [NSData dataWithContentsOfFile:savePath];
                       if(data){
                           dispatch_async( dispatch_get_main_queue(), ^(void){
                               sucBlock(data);
                           });
                       }else{
                           //本地没有从网络获取
                            __block  NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
                           if(datas){
//                               BOOL flag =  [datas writeToFile:savePath atomically:YES];
                               dispatch_async( dispatch_get_main_queue(), ^(void){
                                   sucBlock(datas);
                               });
                               
                           }else{
                               dispatch_async( dispatch_get_main_queue(), ^(void){
                                   NSError *error = [NSError errorWithDomain:@"url 非法,图片不存在" code:999 userInfo:nil];
                                   faiBlock(error);
                               });
                           }
                       }
                   }
                   );

}
@end
