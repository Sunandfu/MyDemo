//
//  YXLaunchAdView.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#if __has_include(<YXFLAnimatedImage/YXFLAnimatedImage.h>)
#import <YXFLAnimatedImage/YXFLAnimatedImage.h>
#else
#import "YXFLAnimatedImage.h"
#endif

#if __has_include(<YXFLAnimatedImage/YXFLAnimatedImageView.h>)
#import <YXFLAnimatedImage/YXFLAnimatedImageView.h>
#else
#import "YXFLAnimatedImageView.h"
#endif


#pragma mark - image
@interface YXLaunchAdImageView : YXFLAnimatedImageView

@property (nonatomic, copy) void(^click)(CGPoint point);

@end

#pragma mark - video
API_AVAILABLE(ios(8.0))
@interface YXLaunchAdVideoView : UIView

@property (nonatomic, copy) void(^click)(CGPoint point);
@property (nonatomic, strong) AVPlayerViewController *videoPlayer;
@property (nonatomic, assign) MPMovieScalingMode videoScalingMode;
@property (nonatomic, assign) AVLayerVideoGravity videoGravity;
@property (nonatomic, assign) BOOL videoCycleOnce;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, strong) NSURL *contentURL;

-(void)stopVideoPlayer;

@end

