//
//  BaiduMobAdWebSDK
//
//
//
#import <UIKit/UIKit.h>
#import "BaiduMobAdCommonConfig.h"

@interface BaiduMobAdSetting : NSObject
@property BOOL supportHttps;
@property BOOL trackCrash;

/**
 *  设置Landpage页面导航栏颜色
 */
+ (void)setLpStyle:(BaiduMobAdLpStyle)style;
+ (BaiduMobAdSetting *)sharedInstance;
/**
 * 设置视频缓存阀值，单位M, 取值范围15M-100M,默认30M
 */
+ (void)setMaxVideoCacheCapacityMb:(NSInteger)capacity;

@end

