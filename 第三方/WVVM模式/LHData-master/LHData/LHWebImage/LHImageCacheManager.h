
//
//  LHImageCacheManager.h
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/4/5.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHMemoryCache,LHFileCache,UIImage;
@interface LHImageCacheManager : NSObject

@property (nonatomic,copy) NSString* name;

@property (nonatomic,strong) LHMemoryCache* imageMemoryCache;

@property NSUInteger memoryCacheCountMax;//default = 8；

@property (nonatomic,strong) LHFileCache* imageFileCache;

@property dispatch_queue_t run_queue;

+ (instancetype)shareInstance;

- (void)setImage:(UIImage*)image key:(NSString*)key;

- (UIImage*)objectImageWithKey:(NSString*)key;

- (void)removeAllImageCache;

@end
