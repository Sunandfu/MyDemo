//
//  SFLoader.h
//  SFLoader
//
//  Created by 万众科技 on 16/6/24.
//  Copyright © 2016年 万众科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SFRequestTask.h"

#define MimeType @"video/mp4"

@class SFResourceLoader;
@protocol SFLoaderDelegate <NSObject>

@required
- (void)loader:(SFResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(SFResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface SFResourceLoader : NSObject<AVAssetResourceLoaderDelegate,SFRequestTaskDelegate>

@property (nonatomic, weak) id<SFLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识
@property (nonatomic, assign) BOOL cacheFinished;

- (void)stopLoading;

@end

