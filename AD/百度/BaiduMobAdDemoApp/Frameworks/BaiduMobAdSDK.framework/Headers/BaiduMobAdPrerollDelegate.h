//
//  BaiduMobAdPrerollDelegate.h
//  BaiduMobAdSdk
//
//  Created by lishan04 on 15-6-8.
//
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"

@class BaiduMobAdPreroll;

@protocol BaiduMobAdPrerollDelegate <NSObject>

@optional
/**
 *  渠道ID
 */
- (NSString *)channelId;
/**
 *  启动位置信息
 */
-(BOOL) enableLocation;

/**
 *  广告准备播放
 */
- (void)didAdReady:(BaiduMobAdPreroll *)preroll;

/**
 *  广告展示失败
 */
- (void)didAdFailed:(BaiduMobAdPreroll *)preroll withError:(BaiduMobFailReason) reason;

/**
 *  广告展示成功
 */
- (void)didAdStart:(BaiduMobAdPreroll *)preroll;

/**
 *  广告展示结束
 */
- (void)didAdFinish:(BaiduMobAdPreroll *)preroll;

/**
 *  广告点击
 */
- (void)didAdClicked:(BaiduMobAdPreroll *)preroll;

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)didDismissLandingPage;


@end
