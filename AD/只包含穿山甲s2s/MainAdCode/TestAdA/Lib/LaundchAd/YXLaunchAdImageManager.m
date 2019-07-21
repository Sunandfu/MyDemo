//
//  YXLaunchAdImageManager.m
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import "YXLaunchAdImageManager.h"
#import "YXLaunchAdCache.h"

@interface YXLaunchAdImageManager()

@property(nonatomic,strong) YXLaunchAdDownloader *downloader;
@end

@implementation YXLaunchAdImageManager

+(nonnull instancetype )sharedManager{
    static YXLaunchAdImageManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[YXLaunchAdImageManager alloc] init];
        
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _downloader = [YXLaunchAdDownloader sharedDownloader];
    }
    return self;
}

- (void)loadImageWithURL:(nullable NSURL *)url options:(YXLaunchAdImageOptions)options progress:(nullable YXLaunchAdDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock{
    if(!options) options = YXLaunchAdImageDefault;
    if(options & YXLaunchAdImageOnlyLoad){
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
        }];
    }else if (options & YXLaunchAdImageRefreshCached){
        NSData *imageData = [YXLaunchAdCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock) completedBlock(image,imageData,nil,url);
        [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
            if(completedBlock) completedBlock(image,data,error,url);
            [YXLaunchAdCache async_saveImageData:data imageURL:url completed:nil];
        }];
    }else if (options & YXLaunchAdImageCacheInBackground){
        NSData *imageData = [YXLaunchAdCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                [YXLaunchAdCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }else{//default
        NSData *imageData = [YXLaunchAdCache getCacheImageDataWithURL:url];
        UIImage *image =  [UIImage imageWithData:imageData];
        if(image && completedBlock){
            completedBlock(image,imageData,nil,url);
        }else{
            [_downloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error) {
                if(completedBlock) completedBlock(image,data,error,url);
                [YXLaunchAdCache async_saveImageData:data imageURL:url completed:nil];
            }];
        }
    }
}

@end
