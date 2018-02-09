//
//  WSDownloadView.h
//  下载动画
//
//  Created by iMac on 16/9/21.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WSDownloadAnimationDelegate <NSObject>

@required
- (void)animationStart;

@optional
- (void)animationSuspend;

- (void)animationEnd;

@end

@interface WSDownloadView : UIView
/**
 *  进度:0~1
 */
@property (nonatomic, assign) CGFloat progress;
/**
 *  进度宽
 */
@property (nonatomic, assign) CGFloat progressWidth;
/**
 *  是否下载成功
 */
@property (nonatomic, assign) BOOL isSuccess;
/**
 *  委托代理
 */
@property (nonatomic, weak) id<WSDownloadAnimationDelegate> delegate;

@end
