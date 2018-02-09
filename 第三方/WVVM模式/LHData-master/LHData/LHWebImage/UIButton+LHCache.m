//
//  UIButton+LHCache.m
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/6.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "UIButton+LHCache.h"
#import <objc/runtime.h>
#import "LHImageCacheManager.h"
#import "LHImageDownloadManager.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;

#define URLSTRING_KEY @"URLString"

#define CACHE_MANAGER_KEY @"LHImageCacheManager"

#define DOWNLOAD_MANAGER_KEY @"LHImageDownloadManager"

@implementation UIButton (LHCache)

- (void)setUrlString:(NSString *)urlString
{
    objc_setAssociatedObject(self, [URLSTRING_KEY UTF8String], urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)urlString
{
    return objc_getAssociatedObject(self, [URLSTRING_KEY UTF8String]);
}

- (void)setCacheManager:(LHImageCacheManager *)cacheManager
{
    objc_setAssociatedObject(self, [CACHE_MANAGER_KEY UTF8String], cacheManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LHImageCacheManager*)cacheManager
{
    return objc_getAssociatedObject(self, [CACHE_MANAGER_KEY UTF8String]);
}

- (void)setDownloadManager:(LHImageDownloadManager *)downloadManager
{
    objc_setAssociatedObject(self, [DOWNLOAD_MANAGER_KEY UTF8String], downloadManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LHImageDownloadManager*)downloadManager
{
    return objc_getAssociatedObject(self, [DOWNLOAD_MANAGER_KEY UTF8String]);
}

- (void)lh_setImageWithURL:(NSString*)urlString forState:(UIControlState)state
{
    [self lh_setImageWithURL:urlString placeholderImage:nil forState:state];
}

- (void)lh_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage forState:(UIControlState)state
{
    [self lh_setImageWithURL:urlString placeholderImage:placeholderImage forState:state progress:nil complete:nil];
}

- (void)lh_setImageWithURL:(NSString*)urlString
          placeholderImage:(UIImage*)placeholderImage
                                forState:(UIControlState)state
                                    progress:(void(^)(float updateProgress))updateProgress
                                        complete:(void(^)(UIImage* image))complete
{
    self.urlString = urlString;
    if (urlString.length==0||!urlString) {
        [self setImage:placeholderImage forState:state];
        return;
    }
    self.cacheManager = self.cacheManager?:[LHImageCacheManager shareInstance];
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image = [weakSelf.cacheManager objectImageWithKey:urlString];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setImage:image forState:state];
                if (complete) {
                    complete(image);
                }
                return;
                
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setImage:placeholderImage forState:state];
            });
            weakSelf.downloadManager = weakSelf.downloadManager?:[LHImageDownloadManager shareInstance];
            [weakSelf.downloadManager addOperationWithUrlString:urlString progress:^(float progress, NSString *urlString) {
                if (![urlString isEqualToString:weakSelf.urlString]) return ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (updateProgress) {
                        updateProgress(progress);
                    }
                });
            } receiveData:^(NSData *data, LHHTTPRequest *request) {
            } complete:^(NSData* resultData,NSString* urlString) {
                UIImage* image = [UIImage imageWithData:resultData];
                [weakSelf.cacheManager setImage:(UIImage*)resultData key:urlString];
                if (![urlString isEqualToString:weakSelf.urlString]) return ;
                [weakSelf setImage:image forState:state];
                if (complete) {
                    complete(image);
                }
            }];
        }
        
    });
}

- (void)lh_setBackgroundImageWithURL:(NSString*)urlString forState:(UIControlState)state
{
    [self lh_setBackgroundImageWithURL:urlString placeholderImage:nil forState:state progress:nil complete:nil];
}

- (void)lh_setBackgroundImageWithURL:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage forState:(UIControlState)state
{
    [self lh_setBackgroundImageWithURL:urlString placeholderImage:placeholderImage forState:state progress:nil complete:nil];
}


- (void)lh_setBackgroundImageWithURL:(NSString*)urlString
                    placeholderImage:(UIImage*)placeholderImage
                            forState:(UIControlState)state
                            progress:(void(^)(float updateProgress))updateProgress
                            complete:(void(^)(UIImage* image))complete
{
    self.urlString = urlString;
    if (urlString.length==0||!urlString) {
        [self setBackgroundImage:placeholderImage forState:state];
        return;
    }
    self.cacheManager = self.cacheManager?:[LHImageCacheManager shareInstance];
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image = [weakSelf.cacheManager objectImageWithKey:urlString];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setBackgroundImage:image forState:state];
                if (complete) {
                    complete(image);
                }
                return;
                
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setBackgroundImage:placeholderImage forState:state];
            });
            weakSelf.downloadManager = weakSelf.downloadManager?:[LHImageDownloadManager shareInstance];
            [weakSelf.downloadManager addOperationWithUrlString:urlString progress:^(float progress, NSString *urlString) {
                if (![urlString isEqualToString:weakSelf.urlString]) return ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (updateProgress) {
                        updateProgress(progress);
                    }
                });
            } receiveData:^(NSData *data, LHHTTPRequest *request) {
            } complete:^(NSData* resultData,NSString* urlString) {
                UIImage* image = [UIImage imageWithData:resultData];
                [weakSelf.cacheManager setImage:(UIImage*)resultData key:urlString];
                if (![urlString isEqualToString:weakSelf.urlString]) return ;
                [weakSelf setBackgroundImage:image forState:state];
                if (complete) {
                    complete(image);
                }
            }];
        }
        
    });
}

@end
