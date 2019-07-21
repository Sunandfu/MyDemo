//
//  YXLaunchAdDownloaderManager.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - YXLaunchAdDownload

typedef void(^YXLaunchAdDownloadProgressBlock)(unsigned long long total, unsigned long long current);

typedef void(^YXLaunchAdDownloadImageCompletedBlock)(UIImage *_Nullable image, NSData * _Nullable data, NSError * _Nullable error);

typedef void(^YXLaunchAdDownloadVideoCompletedBlock)(NSURL * _Nullable location, NSError * _Nullable error);

typedef void(^YXLaunchAdBatchDownLoadAndCacheCompletedBlock) (NSArray * _Nonnull completedArray);

@protocol YXLaunchAdDownloadDelegate <NSObject>

- (void)downloadFinishWithURL:(nonnull NSURL *)url;

@end

@interface YXLaunchAdDownload : NSObject
@property (assign, nonatomic ,nonnull)id<YXLaunchAdDownloadDelegate> delegate;
@end

@interface YXLaunchAdImageDownload : YXLaunchAdDownload

@end

@interface YXLaunchAdVideoDownload : YXLaunchAdDownload

@end

#pragma mark - YXLaunchAdDownloader
@interface YXLaunchAdDownloader : NSObject

+(nonnull instancetype )sharedDownloader;

- (void)downloadImageWithURL:(nonnull NSURL *)url progress:(nullable YXLaunchAdDownloadProgressBlock)progressBlock completed:(nullable YXLaunchAdDownloadImageCompletedBlock)completedBlock;

- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadImageAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable YXLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock;

- (void)downloadVideoWithURL:(nonnull NSURL *)url progress:(nullable YXLaunchAdDownloadProgressBlock)progressBlock completed:(nullable YXLaunchAdDownloadVideoCompletedBlock)completedBlock;

- (void)downLoadVideoAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray;
- (void)downLoadVideoAndCacheWithURLArray:(nonnull NSArray <NSURL *> * )urlArray completed:(nullable YXLaunchAdBatchDownLoadAndCacheCompletedBlock)completedBlock;

@end

