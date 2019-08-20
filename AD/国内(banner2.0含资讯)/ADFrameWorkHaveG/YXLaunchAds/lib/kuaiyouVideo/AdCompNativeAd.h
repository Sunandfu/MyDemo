//
//  AdCompNativeAd.h
//  KuaiYouAdHello
//
//  Created by maming on 15/10/22.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AdCompNativeAd;
@class RolloverManager;

typedef NS_ENUM(NSUInteger, AdCompNativeMediaPlayerStatus) {
    AdCompNativeMediaPlayerStatusInitial = 0,         // 初始状态
    AdCompNativeMediaPlayerStatusLoading = 1,         // 加载中
    AdCompNativeMediaPlayerStatusStarted = 2,         // 开始播放
    AdCompNativeMediaPlayerStatusPaused = 3,          // 用户行为导致暂停
    AdCompNativeMediaPlayerStatusStoped = 4,          // 播放停止
    AdCompNativeMediaPlayerStatusError = 5,           // 播放出错
};

typedef NS_ENUM(NSUInteger, AdCompNativeVideoStatus) {
    AdCompNativeVideoStatus_StartPlay,
    AdCompNativeVideoStatus_MiddlePlay,
    AdCompNativeVideoStatus_CompletePlay,
    AdCompNativeVideoStatus_Pause,
    AdCompNativeVideoStatus_TerminationPlay,
};

@interface AdCompNativeData : NSObject
/*
 * 广告内容字典
 * 详解：开发者调用loadNativeAdWithCount:成功之后返回广告内容，
 *       从该属性中获取以字典形式存储的广告数据
 */
@property (nonatomic, strong) NSDictionary *adProperties;

@property (nonatomic, strong) NSString* nativeAdId;

@property (nonatomic, strong) RolloverManager *rolloverManager;

@end

@interface AdCompNativeVideoDataAcquisitionObject : NSObject

@property (nonatomic, assign) int duration; // 视频总时长，单位为秒
@property (nonatomic, assign) int beginTime; // 视频播放开始时间，单位为妙。如果视频从头开始播放，则为0
@property (nonatomic, assign) int endTime; // 视频播放结束时间，单位为妙。如果视频播放到结尾，则等于视频总时长
@property (nonatomic, assign) int firstFrame; // 视频是否从第一帧开始播放。是的话为1，否则为0
@property (nonatomic, assign) int lastFrame; // 视频是否播放到最后一帧。播放到最后一帧则为1；否则为0
@property (nonatomic, assign) int scene;
        // 视频播放场景；
        // 1-> 在广告曝光区域播放
        // 2-> 全屏竖屏、只展示视频
        // 3-> 全屏竖屏、屏幕上方展示视频、下方展示广告推广页面
        // 4-> 全屏横屏、只展示视频
        // 0-> 其他自定义场景

@property (nonatomic, assign) int type;
        // 播放类型
        // 1-> 第一次播放
        // 2-> 暂停后继续播放
        // 3-> 重新开始播放

@property (nonatomic, assign) int behavior;
        // 播放行为
        // 1-> 自动播放
        // 2-> 点击播放

@property (nonatomic, assign) int status;
        // 播放状态
        // 0-> 正常播放
        // 1-> 视频加载中
        // 2-> 下载或播放错误

@end

@protocol AdCompNativeAdDelegate <NSObject>

/*
 * 原⽣广告加载广告数据成功回调
 * @param nativeDataArray 为 AdCompNativeData对象或者View类型的数组，即广告内容数组或广告View数组
 */
- (void)adCompNativeAdSuccessToLoadAd:(AdCompNativeAd*)adCompNativeAd NativeData:(NSArray*)nativeDataArray;

/*
 * 原⽣广告加载广告数据失败回调
 * @param error 为加载失败返回的错误信息
 */
- (void)adCompNativeAdFailToLoadAd:(AdCompNativeAd*)adCompNativeAd WithError:(NSError*)error;

/*
 * 原⽣广告后将要展示内嵌浏览器回调
 */
- (void)adCompNativeAdWillShowPresent;

/*
 * 原⽣广告点击后，内嵌浏览器被关闭时回调
 */
- (void)adCompNativeAdDismissScreen;

/*
 * 原⽣广告点击之后应用进入后台时回调
 */
- (void)adCompNativeAdResignActive;

/*
 * 原⽣广告视图模板广告view点击关闭按钮是调用，作用于 AdCompNativeAdType_View(视图广告) 广告下
 * @param view 关闭的视图view
 */
- (void)adCompNativeAdViewClickClosed:(UIView*)view;

/*
 * 原⽣广告视频播放状态更新回调，作用于 AdCompNativeAdType_View(视图广告) 广告下
 */
- (void)adCompNativeViewVideoPlayerStatusChanged:(AdCompNativeMediaPlayerStatus)status;

@end

/*
 * 原生广告返回数据的类型
 */
typedef NS_ENUM(NSUInteger, AdCompNativeAdType) {
    AdCompNativeAdType_Data = 0,  // 数据类型
    AdCompNativeAdType_View   // 视图类型
};

@interface AdCompNativeAd : NSObject
@property (nonatomic, weak) id<AdCompNativeAdDelegate> delegate;
/*
 * viewControllerForPresentingModalView
 */
@property (nonatomic, weak) UIViewController *controller;

@property (nonatomic, assign, readonly) AdCompNativeAdType natviewAdType;

/*
 * 在非WiFi网络下是否自动播放，默认为 NO，load前设置。作用于 AdCompNativeAdType_View 广告形式下
 */
@property (nonatomic, assign) BOOL autoPlayVideoOnWWAN;

/*
 * 播放广告时，是否需要静音，默认为 YES，load前设置。作用于 AdCompNativeAdType_View 广告形式下
 */
@property (nonatomic, assign) BOOL isNeedMuted;

/*
 * 广告展示宽高，load前设置。作用于AdCompNativeAdType_View广告形式下
 */
@property (nonatomic, assign) CGSize adSize;

/*
 * 初始化方法
 * @param appkey 为应用id
 * @param positionID 为广告位id
 */
- (instancetype)initWithAppKey:(NSString*)appkey positionID:(NSString*)positionID;

/*
 * 广告加载方法
 * @param count 一次请求广告的个数
 */
- (void)loadNativeAdWithCount:(int)count;

/*
 * 广告view渲染完毕后即将展示调用方法（用于发送相关汇报），作用于 AdCompNativeAdType_Data 广告形式下
 * @param nativeData 渲染广告的数据对象
 * @param view 渲染出的广告页面
 */
- (void)showNativeAdWithData:(AdCompNativeData*)nativeData onView:(UIView*)view;

/*
 * 广告点击调用的方法，作用于 AdCompNativeAdType_Data 广告形式下
 * 当⽤户点击广告时,开发者需调用本方法,sdk会做出相应响应（用于发送点击汇报）
 * @param nativeData 被点击的广告的数据对象
 * @param point 点击坐标，广告需要用户点击坐标的位置，否则会影响收益；如果广告视图size为（300，200），左上角point值为（0，0），右下角为（300，200）,以此为例计算point大小；
 * @param view 渲染出的广告页面
 */
- (void)clickNativeAdWithData:(AdCompNativeData*)nativeData withClickPoint:(CGPoint)point onView:(UIView*)view;

/*
 * 用于视频原生数据汇报方法，作用于 AdCompNativeAdType_Data 广告形式下
 * 当触发AdCompNativeVideoStatus中某个状态时，调用该方法
 * @param nativeData 当前广告使用的数据对象
 * @param videoStatus 视频播放的状态
 * @param dataAcquistionObj 该对象中的数据用于替换响应汇报中的宏字段，务必填写
 */
- (void)reportWithData:(AdCompNativeData*)nativeData withStatus:(AdCompNativeVideoStatus)videoStatus withDataAcquisitionObject:(AdCompNativeVideoDataAcquisitionObject*)dataAcquistionObj;

@end
