//
//  LHImageCacheManager.m
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/4/5.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import "LHImageCacheManager.h"
#import "LHCache.h"
#import <UIKit/UIKit.h>

#define IMAGE_CACHE_NAME @"LHImageCache"

#define RUN_QUEUE @"LHImageQueue"

@implementation LHImageCacheManager

+ (instancetype)shareInstance
{
    static LHImageCacheManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LHImageCacheManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageMemoryCache = [[LHMemoryCache alloc] initWithName:IMAGE_CACHE_NAME];
        self.imageMemoryCache.countMax = 20;
        self.name = self.imageMemoryCache.name;
        self.run_queue = dispatch_queue_create([RUN_QUEUE UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.memoryCacheCountMax = self.imageMemoryCache.countMax;
        self.imageFileCache = [[LHFileCache alloc] init];
        self.imageFileCache.cacheShouldAppend = YES;
    }
    return self;
}

- (void)setMemoryImage:(UIImage*)image key:(NSString*)key
{
    [self.imageMemoryCache setObject:image forKey:key];
}

- (void)setImage:(UIImage*)image key:(NSString*)key
{
    [self.imageMemoryCache setObject:image forKey:key];
    [self.imageFileCache setData:(NSData*)image forKey:key];
}

- (UIImage*)objectImageWithKey:(NSString*)key
{
    if (key.length <= 0) return nil;
    UIImage* image = [self.imageMemoryCache objectForKey:key];
    if ([image isKindOfClass:[NSData class]]) return [UIImage imageWithData:(NSData*)image];
    if (image) return image;
    
    NSData* data = [self.imageFileCache dataForKey:[key stringByReplacingOccurrencesOfString:@"/" withString:@""]];
    if (data) {
        UIImage* image = [UIImage imageWithData:data];
        [self setMemoryImage:image key:key];
        return image;
    }
    return nil;
}

- (void)removeAllImageCache
{
    dispatch_async(self.run_queue, ^{
        [self.imageMemoryCache removeAllObject];
        [self.imageFileCache removeAllData];
    });
}

@end
