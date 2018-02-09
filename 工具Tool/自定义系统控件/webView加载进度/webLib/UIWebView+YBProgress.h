//
//  UIWebView+YBProgress.h
//  testProgress
//
//  Created by LYB on 16/6/4.
//  Copyright © 2016年 LYB. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef yb_weak
#if __has_feature(objc_arc_weak)
#define yb_weak weak
#else
#define yb_weak unsafe_unretained
#endif

/**进度条计算类*/
extern const float YBInitialProgressValue;
extern const float YBInteractiveProgressValue;
extern const float YBFinalProgressValue;

@class YBWebViewProgress;
@protocol YBWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(YBWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end


@interface YBWebViewProgress : NSObject<UIWebViewDelegate>

@property (nonatomic, yb_weak) id<YBWebViewProgressDelegate> progressDelegate;
@property (nonatomic, yb_weak) id<UIWebViewDelegate> webViewProxyDelegate;
@property (nonatomic, readonly) float progress;
@property (nonatomic, copy) void (^YBWebViewProgressBlock) (float progress);

/**重置*/
- (void)reset;
@end


/**进度条*/

@interface YBWebViewProgressView : UIView

@property (nonatomic) float progress;

@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // 默认 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // 默认 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // 默认 0.1
/**设置进度条颜色*/
@property (nonatomic) UIColor *tintColor;//默认是蓝色

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end


/**自动添加进度条*/
@interface UIWebView (YBProgress)
<
UIWebViewDelegate,
YBWebViewProgressDelegate
>

@property (nonatomic, strong) YBWebViewProgressView *progressView;

@property (nonatomic, strong) YBWebViewProgress *progressProxy;

@property (nonatomic, copy) void (^YBProgressBlock) (float progress);

/**设置进度条颜色*/
@property (nonatomic, strong) UIColor *yb_tintColor;//默认是蓝色

/**手动添加进度条（有progress回调,默认自动加载）*/
- (void)yb_addProgressViewUsingBlock:(void (^) (float progress))progressBack;

/**重置*/
- (void)yb_reset;

@end

