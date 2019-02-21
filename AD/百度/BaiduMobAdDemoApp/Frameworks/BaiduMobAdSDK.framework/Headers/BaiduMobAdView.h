//
//  BaiduMobAdView.h
//  BaiduMobAdSdk
//
//  Created by jaygao on 11-9-6.
//  Copyright 2011年 Baidu. All rights reserved.
//
//

#import "BaiduMobAdDelegateProtocol.h"
#import <UIKit/UIKit.h>

/**
 *  投放广告的视图接口,更多信息请查看[百度移动联盟主页](http://mssp.baidu.com)
 */
/**
 *  广告类型
 * 0 banner广告
 */
typedef enum _BaiduMobAdViewType {
    BaiduMobAdViewTypeBanner = 0
} BaiduMobAdViewType;

@interface BaiduMobAdView : UIView
/**
 *  委托对象
 */
@property(nonatomic, assign) id<BaiduMobAdViewDelegate> delegate;

/**
 *  设置／获取需要展示的广告类型
 */
@property(nonatomic) BaiduMobAdViewType AdType;

/**
 *  设置/获取代码位id
 */
@property(nonatomic, copy) NSString *AdUnitTag;

/**
 *  SDK版本
 */
@property(nonatomic, readonly) NSString *Version;

/**
 *  开始广告展示请求,会触发所有资源的重新加载，推荐初始化以后调用一次
 */
- (void)start;

@end
