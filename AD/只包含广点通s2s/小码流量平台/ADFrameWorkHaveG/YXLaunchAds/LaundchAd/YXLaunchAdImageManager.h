//
//  YXLaunchAdImageManager.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/3/23.
//  Copyright © 2018年 M. All rights reserved.
//  Version 2.2

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXLaunchAdDownloader.h"
#import "YXLaunchConfiguration.h"


typedef void(^XHExternalCompletionBlock)(UIImage * _Nullable image,NSData * _Nullable imageData, NSError * _Nullable error, NSURL * _Nullable imageURL);

@interface YXLaunchAdImageManager : NSObject

+(nonnull instancetype )sharedManager;
- (void)loadImageWithURL:(nullable NSURL *)url options:(YXLaunchAdImageOptions)options progress:(nullable YXLaunchAdDownloadProgressBlock)progressBlock completed:(nullable XHExternalCompletionBlock)completedBlock;

@end
