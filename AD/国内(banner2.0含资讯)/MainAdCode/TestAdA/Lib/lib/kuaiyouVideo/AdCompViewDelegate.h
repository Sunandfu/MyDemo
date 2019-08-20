//
//  AdCompViewDelegate.h
//  KuaiYouAdHello
//
//  Created by adview on 13-12-12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>

//开屏位置 1居上 2居下
typedef enum{
    AdCompSpreadShowTypeTop = 1,
    AdCompSpreadShowTypeBottom = 2,
}AdCompSpreadShowType;

@class AdCompView;
@protocol AdCompViewDelegate <NSObject>

@optional


- (NSString*)appPwd;

/**
 * 设置小程序广告应用绑定相关微信开发者ID，不提供developerId的话不返回小程序广告
 */
- (NSString*)miniProgramAdDeveloperId;

- (UIColor*)adTextColor;
- (UIColor*)adBackgroundColor;
- (NSString*)adBackgroundImgName;
- (NSString*)logoImgName;//开屏logo图片的名字;


- (BOOL)usingSKStoreProductViewController;//是否使用应用内打开AppStore

/**
 * 广告请求成功
 */

- (void)didReceivedAd:(AdCompView*)adView reuse:(BOOL)isReuse;

/**
 * 广告请求失败
 */

- (void)didFailToReceiveAd:(AdCompView*)adView Error:(NSError*)error;

/**
 * 插屏预备好回调
 */
- (void)adinstlDidReadyToShow:(AdCompView*)adView;

- (NSString*)AdCompViewHost;
- (int)autoRefreshInterval;	//<=0 - none, <15 - 15, unit: seconds
- (int)gradientBgType;		//-1 - none, 0 - fix, 1 - random

- (UIViewController*)viewControllerForShowModal;

/**
 * 广告网页将要展示回调
 */

- (void)adViewWillPresentScreen:(AdCompView *)adView;

/**
 * 广告网页将要关闭回调
 */

- (void)adViewDidDismissScreen:(AdCompView *)adView;

/*
 * 广告点击之后应用进入后台时回调
 */
- (void)adViewResignActive:(AdCompView *)adView;

/**
 * 插屏/开屏关闭回调
 */

- (void)adInstlDidDismissScreen:(AdCompView *)adInstl;

/**
 * 是否为测试模式
 */
- (BOOL)testMode;

/**
 * 是否使用缓存
 */
- (BOOL)usingCache;

/**
 * 是否打印日志
 */
- (BOOL)logMode;

- (int)configVersion;

/**
 * 获取 location 信息
 */
- (CLLocation*)getLocation;
/**
 * 有些开发者需要展示广告的位置变动 默认为屏幕中心 例子: return 20 即广告中心点向上移动 20
 */

- (float)moveCentr;
/**
 * 等比例缩放 有限制范围为 0.8 - 1.2 之间
 */
- (float)scaleProportion;


/**
 * wkwebview需要提前添加到视图
 */
- (void)needPreAddView:(AdCompView *)adview;


@required

- (NSString*)appId;



@end
