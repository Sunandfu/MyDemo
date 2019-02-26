//
//  YXLaunchImageView.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import <UIKit/UIKit.h>

/** 启动图来源 */
typedef NS_ENUM(NSInteger,SourceType) {
    /** LaunchImage(default) */
    SourceTypeLaunchImage = 1,
    /** LaunchScreen.storyboard */
    SourceTypeLaunchScreen = 2,
};

typedef NS_ENUM(NSInteger,LaunchImagesSource){
    LaunchImagesSourceLaunchImage = 1,
    LaunchImagesSourceLaunchScreen = 2,
};

@interface YXLaunchImageView : UIImageView

- (instancetype)initWithSourceType:(SourceType)sourceType;

@end
