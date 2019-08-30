//
//  AdCompVideo.h
//  KuaiYouAdHello
//
//  Created by maming on 2018/8/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AdCompVideo;
@protocol AdCompVideoDelegate <NSObject>

@optional
//***** ADVideoTypeInstl 应用回调

/*
 * 视频可以开始播放该回调调用后可以调用showVideoWithController:展示视频广告
 */
- (void)adCompVideoIsReadyToPlay:(AdCompVideo*)video;

/*
 * 视频广告播放开始回调
 */
- (void)adCompVideoPlayStarted;

/*
 * 视频广告播放结束回调
 */
- (void)adCompVideoPlayEnded;

/*
 * 视频广告关闭回调
 */
- (void)adCompVideoClosed;

//***** 两种模式共用部分回调
/*
 * 请求广告数据成功回调
 * @param vastString:贴片模式下返回视频内容字符串(vast协议标准);非贴片模式下返回为nil;
 */
- (void)adCompVideoDidReceiveAd:(NSString *)vastString;

/*
 * 请求广告数据失败回调
 * @param error:数据加载失败错误信息;(播放失败回调也包含再该回调中)
 */
- (void)adCompVideoFailReceiveDataWithError:(NSError*)error;
@end

typedef NS_ENUM(NSUInteger, AdCompVideoType) {
    AdCompVideoTypeInstl,
    AdCompVideoTypePreMovie,
};

@interface AdCompVideo : NSObject
@property (nonatomic, assign) BOOL enableGPS; // 是否打开位置信息获取功能，默认为NO；

+ (id)playVideoWithAppId:(NSString*)appId positionId:(NSString*)positionID videoType:(AdCompVideoType)videoType delegate:(id<AdCompVideoDelegate>)videoDelegate;

/**
 * 设置视频展示方向
 * @param orientation:视频展示方向 默认为竖屏（UIInterfaceOrientationPortrait）
 */
- (void)setInterfaceOrientations:(UIInterfaceOrientation)orientation;

/**
 * 加载视频广告
 */
- (void)getVideoAD;

/**
 * 设置视频背景颜色，默认为黑色，建议在showVideoWithController:方法之前使用，否则延迟生效
 * @param colorString:颜色色值，例如：@“#FFFFFF”
 */
- (void)setVideoBackgroundColorWithString:(NSString*)colorString;

/**
 * 展示广告，AdViewVideoIsReadyToPlay:回调之后调用，否则展示不出来(请求一次广告,只能调用一次展示广告)；
 */
- (void)showVideoWithController:(UIViewController *)controller;

/**
 * 清理视频缓存
 */
- (void)clearVideoBuffer;

@end
