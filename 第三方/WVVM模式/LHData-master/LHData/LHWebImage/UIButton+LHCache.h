//
//  UIButton+LHCache.h
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/6.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHHTTPRequest.h"

@class LHImageCacheManager,LHImageDownloadManager;
@interface UIButton (LHCache)

@property (nonatomic,copy) NSString* urlString;

@property (nonatomic,strong) LHImageCacheManager* cacheManager;

@property (nonatomic,strong) LHImageDownloadManager* downloadManager;

- (void)lh_setImageWithURL:(NSString*)urlString forState:(UIControlState)state;

- (void)lh_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage forState:(UIControlState)state;

- (void)lh_setImageWithURL:(NSString*)urlString
          placeholderImage:(UIImage*)placeholderImage
                  forState:(UIControlState)state
                  progress:(void(^)(float updateProgress))updateProgress
                  complete:(void(^)(UIImage* image))complete;

- (void)lh_setBackgroundImageWithURL:(NSString*)urlString forState:(UIControlState)state;

- (void)lh_setBackgroundImageWithURL:(NSString *)urlString placeholderImage:(UIImage*)placeholderImage forState:(UIControlState)state;


- (void)lh_setBackgroundImageWithURL:(NSString*)urlString
                    placeholderImage:(UIImage*)placeholderImage
                            forState:(UIControlState)state
                            progress:(void(^)(float updateProgress))updateProgress
                            complete:(void(^)(UIImage* image))complete;

@end
