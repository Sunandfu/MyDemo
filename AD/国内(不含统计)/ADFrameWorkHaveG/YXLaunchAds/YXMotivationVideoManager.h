//
//  YXMotivationVideoManager.h
//  LunchAd
//
//  Created by shuai on 2018/11/29.
//  Copyright © 2018 YX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YXMotivationDelegate;
NS_ASSUME_NONNULL_BEGIN

@protocol YXMotivationDelegate <NSObject>

@optional
- (void)didConnectSuccess;

- (void)didConnectFailed:(NSError*)error;

- (void)videoIsReadyToPlay;

- (void)videoContentDidAppear;

- (void)videoContentDidDisappear;

@end


@interface YXMotivationVideoManager : NSObject


@property(nonatomic,weak) id<YXMotivationDelegate> delegate;



/**
 开始请求视频
 
 @param placement 开始请求视频
 */
- (void)loadVideoPlacementWithName:(NSString*)placement;


/**
 请求完毕后调用此方法加载视频
 
 @param viewController 用于加载视频的控制器
 */
- (void)openVideo:(UIViewController*)viewController;


@end

NS_ASSUME_NONNULL_END
