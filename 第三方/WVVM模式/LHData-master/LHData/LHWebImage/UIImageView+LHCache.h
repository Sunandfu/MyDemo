//
//  UIImageView+LHCache.h
//  LHHTTPRequest
//
//  Created by 3wchina01 on 16/4/5.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHHTTPRequest.h"

@class LHImageCacheManager,LHImageDownloadManager;
@interface UIImageView (LHCache)

@property (nonatomic,copy) NSString* urlString;

@property (nonatomic,strong) LHImageCacheManager* cacheManager;

@property (nonatomic,strong) LHImageDownloadManager* downloadManager;

- (void)lh_setImageWithURL:(NSString*)urlString;

- (void)lh_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage;

- (void)lh_setImageWithURL:(NSString*)urlString
                            placeholderImage:(UIImage*)placeholderImage
                                    progress:(void(^)(float updateProgress))updateProgress
                                        complete:(void(^)(UIImage* image))complete;

@end
