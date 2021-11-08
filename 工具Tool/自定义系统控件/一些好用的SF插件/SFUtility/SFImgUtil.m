//
//  SFImgUtil.m
//  WalkerDSP
//
//  Created by Luo on 15/12/14.
//  Copyright © 2015年 emaryjf. All rights reserved.
//

#import "SFImgUtil.h"

#define SFImageAdDirectoryName @"SFImageAdDirectoryName"

@implementation SFImgUtil
+ (NSString *) getSavePath:(NSString *)imgUrl{
    NSString *fileName = [[imgUrl componentsSeparatedByString:@"/"] lastObject];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *directoryPath = [[paths lastObject] stringByAppendingPathComponent:SFImageAdDirectoryName];
    NSString *savePath = [directoryPath stringByAppendingPathComponent:fileName];
    return savePath;
}
+ (void)saveImg:(NSString *)imgUrl savedSuccess:(savedSuccessBlock)sucBlock failBlock:(failBlock)failBlock{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void) {
        NSString *savePath = [self getSavePath:imgUrl];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 缓存广告信息
        if(![fileManager fileExistsAtPath:savePath]){
           NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
           if(data){
               //忽略图片格式
               BOOL flag = [data writeToFile:savePath atomically:YES];
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
    });
}

+ (void)imgWithUrl:(NSString *)imgUrl successBlock:(successBlock)sucBlock failBlock:(failBlock)faiBlock{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void) {
        NSString *savePath = [self getSavePath:imgUrl];
        NSData *data = [NSData dataWithContentsOfFile:savePath];
        if(data){
            SFImageType imageType = [self typeWithData:data];
            if (imageType == SFImageTypeGif) {
                __block  UIImage * image = [self sf_animatedGIFWithData:data];//这个方法也是异步
                dispatch_async( dispatch_get_main_queue(), ^(void){
                   if(image) {
                       sucBlock(image,data,imageType);
                   }
                });
            } else {
                __block  UIImage * image = [[UIImage alloc] initWithData:data];//这个方法也是异步
                dispatch_async( dispatch_get_main_queue(), ^(void){
                   if(image) {
                       sucBlock(image,data,imageType);
                   }
                });
            }
        }else{
            //本地没有从网络获取
            NSData *datas = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            SFImageType imageType = [self typeWithData:datas];
            if(datas){
                [datas writeToFile:savePath atomically:YES];
                if (imageType == SFImageTypeGif) {
                    __block  UIImage * image = [self sf_animatedGIFWithData:datas];//这个方法也是异步
                    dispatch_async( dispatch_get_main_queue(), ^(void){
                       if(image) {
                           sucBlock(image,datas,imageType);
                       }
                    });
                } else {
                    __block  UIImage * image = [[UIImage alloc] initWithData:datas];//这个方法也是异步
                    dispatch_async( dispatch_get_main_queue(), ^(void){
                       if(image) {
                           sucBlock(image,datas,imageType);
                       }
                    });
                }
            }else{
                dispatch_async( dispatch_get_main_queue(), ^(void){
                   NSError *error = [NSError errorWithDomain:@"url 非法,图片不存在" code:999 userInfo:nil];
                   faiBlock(error);
                });
            }
        }
    });
}

+ (SFImageType)typeWithData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return SFImageTypeJpeg;
        case 0x89:
            return SFImageTypePng;
        case 0x47:
            return SFImageTypeGif;
        default:
            return SFImageTypeOther;
    }
}
+ (UIImage *)sf_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }

    //获取数据源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    // 获取图片数量(如果传入的是gif图的二进制，那么获取的是图片帧数)
    size_t count = CGImageSourceGetCount(source);

    UIImage *animatedImage;

    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];

        NSTimeInterval duration = 0.0f;

        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);

            duration += [self sf_frameDurationAtIndex:i source:source];

            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];

            CGImageRelease(image);
        }
    // 如果上面的计算播放时间方法没有成功，就按照下面方法计算
   // 计算一次播放的总时间：每张图播放1/10秒 * 图片总数
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }

        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }

    CFRelease(source);

    return animatedImage;
}
//**************************************
//计算每帧需要播放的时间
+ (float)sf_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    // 获取这一帧的属性字典
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];

    // 从字典中获取这一帧持续的时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }

    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }

    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
