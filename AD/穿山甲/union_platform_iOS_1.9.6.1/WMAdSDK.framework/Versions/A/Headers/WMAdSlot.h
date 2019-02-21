//
//  WMAdSlot.h
//  WMAdSDK
//
//  Created by chenren on 10/05/2017.
//  Copyright © 2017 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSize.h"

typedef NS_ENUM(NSInteger, WMAdSlotAdType) {
    WMAdSlotAdTypeUnknown       = 0,
    WMAdSlotAdTypeBanner        = 1,       // 横幅广告
    WMAdSlotAdTypeInterstitial  = 2,       // 插屏广告
    WMAdSlotAdTypeSplash        = 3,       // 全屏广告
    WMAdSlotAdTypeSplash_Cache  = 4,       // 缓存开屏
    WMAdSlotAdTypeFeed          = 5,       // feed广告  
    WMAdSlotAdTypePaster        = 6,       // 后贴片
    WMAdSlotAdTypeRewardVideo   = 7,       // 激励视频
    WMAdSlotAdTypeFullscreenVideo = 8,     // 全屏视频
};

typedef NS_ENUM(NSInteger, WMAdSlotPosition) {
    WMAdSlotPositionTop = 1, // 顶部
    WMAdSlotPositionBottom = 2, // 底部
    WMAdSlotPositionFeed = 3, // 信息流内
    WMAdSlotPositionMiddle = 4, // 中部(插屏广告专用)
    WMAdSlotPositionFullscreen = 5, // 全屏
};

@interface WMAdSlot : NSObject

/// 代码位ID required
@property (nonatomic, copy) NSString *ID;

/// 广告类型 required
@property (nonatomic, assign) WMAdSlotAdType AdType;

/// 广告展现位置 required
@property (nonatomic, assign) WMAdSlotPosition position;

/// 接受一组图片尺寸，数组请传入WMSize对象
@property (nonatomic, strong) NSMutableArray<WMSize *> *imgSizeArray;

/// 图片尺寸 required
@property (nonatomic, strong) WMSize *imgSize;

/// 图标尺寸
@property (nonatomic, strong) WMSize *iconSize;

/// 标题的最大长度
@property (nonatomic, assign) NSInteger titleLengthLimit;

/// 描述的最大长度
@property (nonatomic, assign) NSInteger descLengthLimit;

/// 是否支持deeplink
@property (nonatomic, assign) BOOL isSupportDeepLink;

/// 1.9.5 原生banner广告、原生插屏广告设置为1，其他广告类型为0，默认是0
@property (nonatomic, assign) BOOL isOriginAd;

- (NSDictionary *)dictionaryValue;

@end

