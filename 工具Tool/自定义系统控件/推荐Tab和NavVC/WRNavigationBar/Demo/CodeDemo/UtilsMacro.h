//
//  UtilsMacro.h
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//判断数据是否为空
static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


typedef NS_ENUM(NSInteger, SFTransitionStyle) {
    SFTransitionStyle_default, //无效果
    SFTransitionStyle_PageCurl, //模拟翻页
    SFTransitionStyle_Scroll, //左右翻页
};


/* ---------------------------------------- 颜色 --------------------------------------------- */

//红色，调试
#define kredColor [UIColor orangeColor]

//随机颜色
#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

//清除颜色
#define  kclearColor [UIColor clearColor]


/* ---------------------------------------- 尺寸  --------------------------------------------- */

//获取真实屏幕宽高度
#define SF_ScreenW    [UIScreen mainScreen].bounds.size.width
#define SF_ScreenH    [UIScreen mainScreen].bounds.size.height

#define SF_iPhoneXStyle ( ((CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)) || (CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size))) ? YES : NO )
#define SF_StatusBarAndNavigationBarHeight (SF_iPhoneXStyle ? 88.f : 64.f)
#define SF_StatusBarHeight (SF_iPhoneXStyle ? 44.f : 20.f)
#define SF_TabbarHeight (SF_iPhoneXStyle ? 83.f : 49.f)
#define SF_MagrinBottom (SF_iPhoneXStyle ? 34.f : 0.f)

//不同屏幕尺寸适配（375,667是因为效果图为iPhone6plus如果不是则根据实际情况修改）
#define WidthRatio  (self.view.bounds.size.width / 375.0)
#define HeightRatio (self.view.bounds.size.height / 667.0)
#define AdaWidth(x)  ceilf((x) * WidthRatio)
#define AdaHeight(x) ceilf((x) * HeightRatio)

//字体适配(目前统一使用系统默认字体)
#define fontSize(R) [UIFont systemFontOfSize:R]

#define fontBoldSize(R) [UIFont boldSystemFontOfSize:R]

//平方细体
#define kFont_xi(R) [UIFont fontWithName:@"PingFangSC-Light" size:R]  ? [UIFont fontWithName:@"PingFangSC-Light" size:R] : [UIFont systemFontOfSize:R]

//中黑体
#define kFont_Zhong(R) [UIFont fontWithName:@"PingFangSC-Medium" size:R]  ? [UIFont fontWithName:@"PingFangSC-Medium" size:R] : [UIFont systemFontOfSize:R]

#define klineHeight (1.0f / [UIScreen mainScreen].scale)

// 获取状态栏的高度
#define STATUS_BAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height)

// 获取导航栏的高度
#define NavigationBar_HEIGHT 44.0f

//上面导航栏最大值（状态栏+导航栏）
#define kMaxNavHeight (NavigationBar_HEIGHT + STATUS_BAR_HEIGHT)

//tabbar高
#define TabBar_HEIGHT (STATUS_BAR_HEIGHT > 20.f ? 83.f : 49.f)


/* ---------------------------------------- 机型 iOS版本判断 --------------------------------------------- */

/** 操作系统版本号 */
#define xx_iOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define screen_Max_length (MAX(self.view.bounds.size.width, self.view.bounds.size.height))
#define screen_Min_length (MIN(self.view.bounds.size.width, self.view.bounds.size.height))

#define xx_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define xx_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define xx_retina ([[UIScreen mainScreen] scale] >= 2.0)

/** 是否iPhone4或以下版本 */
#define xx_iPhone4_Less (xx_iPhone && screen_Max_length < 568.0)

/** 是否iPhone5或5s */
#define xx_iPhone5 (xx_iPhone && screen_Max_length == 568.0)

/** 是否iPhone6 或iPhone7 或iPhone8 */
#define xx_iPhone6 (xx_iPhone && screen_Max_length == 667.0)

/** 是否iPhone6Plus 或 iPhone7Plus 或 iPhone8Plus */
#define xx_iPhone6p (xx_iPhone && screen_Max_length == 736.0)

/** 判断是否为 iPhoneXS  Max，iPhoneXS，iPhoneXR，iPhoneX */
#define xx_iPhoneX (STATUS_BAR_HEIGHT > 20.0 && !xx_iPad ? YES : NO)
//#define xx_iPhoneX ((int)((SF_ScreenH/SF_ScreenW)*100) == 216)?YES:NO

/**
 *    @brief    调试输出
 */

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//释放
#define kDealloc(objc) objc = nil;

#endif /* UtilsMacro_h */
