//
//  YXLaunchConfiguration.h
//  LunchAd
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.
//

#ifndef YXLaunchConfiguration_h
#define YXLaunchConfiguration_h

typedef NS_ENUM(NSUInteger, YXADTYPE) {
    /**广告种类  banner  */
    YXBannerType = 1,
    /**广告种类  插屏  */
    YXInstertitialType = 2,
    /**广告种类  开屏  */
    YXScreenType = 7,
    /**广告种类  icon  */
    YXIconType = 4
};
typedef NS_OPTIONS(NSUInteger, YXLaunchAdImageOptions) {
    /** 有缓存,读取缓存,不重新下载,没缓存先下载,并缓存 */
    YXLaunchAdImageDefault = 1 << 0,
    /** 只下载,不缓存 */
    YXLaunchAdImageOnlyLoad = 1 << 1,
    /** 先读缓存,再下载刷新图片和缓存 */
    YXLaunchAdImageRefreshCached = 1 << 2 ,
    /** 后台缓存本次不显示,缓存OK后下次再显示(建议使用这种方式)*/
    YXLaunchAdImageCacheInBackground = 1 << 3
};
/** 显示完成动画时间默认时间 */
static CGFloat const showFinishAnimateTimeDefault = 0.8;

/** 显示完成动画类型 */
typedef NS_ENUM(NSInteger , ShowFinishAnimate) {
    /** 无动画 */
    ShowFinishAnimateNone = 1,
    /** 普通淡入(default) */
    ShowFinishAnimateFadein = 2,
    /** 放大淡入 */
    ShowFinishAnimateLite = 3,
    /** 左右翻转(类似网易云音乐) */
    ShowFinishAnimateFlipFromLeft = 4,
    /** 下上翻转 */
    ShowFinishAnimateFlipFromBottom = 5,
    /** 向上翻页 */
    ShowFinishAnimateCurlUp = 6,
};
/**
 *  倒计时类型
 */
typedef NS_ENUM(NSInteger,SkipType) {
    SkipTypeNone      = 1,//无
    /** 方形 */
    SkipTypeTime      = 2,//方形:倒计时
    SkipTypeText      = 3,//方形:跳过
    SkipTypeTimeText  = 4,//方形:倒计时+跳过 (default)
    /** 圆形 */
    SkipTypeRoundTime = 5,//圆形:倒计时
    SkipTypeRoundText = 6,//圆形:跳过
    SkipTypeRoundProgressTime = 7,//圆形:进度圈+倒计时
    SkipTypeRoundProgressText = 8,//圆形:进度圈+跳过
};
/**
 *  banner位置
 */
typedef NS_ENUM(NSInteger,BannerLocationType) {
    TopBannerType      = 1,//顶部约束 只需设置距离顶部的距离
    
    BottomBannerType      = 2,//底部约束 只需设置距离底部的距离
    
};


/**
 原生广告尺寸
 
 - YXADSize690X388: 690 X 388 尺寸
 - YXADSize288X150: 288 X 150 尺寸
 */
typedef NS_ENUM(NSInteger,YXADSize){
    
    YXADSize690X388,
    
    YXADSize288X150,
};

#endif /* YXLaunchConfiguration_h */
