//
//  Config.h
//  XDQRCode
//
//  Created by DINGYONGGANG on 15/9/27.
//  Copyright (c) 2015年 DINGYONGGANG. All rights reserved.
//

#ifndef XDQRCode_Config_h
#define XDQRCode_Config_h

typedef NS_ENUM(NSInteger, XDScaningViewCoverMode) {
    XDScaningViewCoverModeClear,
    XDScaningViewCoverModeNormal, //默认
    XDScaningViewCoverModeBlur,
};

typedef NS_ENUM(NSInteger, XDScaningViewShapeMode) {
    XDScaningViewShapeModeSquare, //默认
    XDScaningViewShapeModeRound,
   
};

typedef NS_ENUM(NSInteger, XDScaningLineMoveMode) {
    XDScaningLineMoveModeDown, //默认
    XDScaningLineMoveModeUpAndDown,
    XDScaningLineMoveModeNone,
 
};

typedef NS_ENUM(NSInteger, XDScaningLineMode) {
    XDScaningLineModeNone, //什么都没有
    XDScaningLineModeDeafult, //默认
    XDScaningLineModeImge,  //以一个图为扫描线，微信，百度
    XDScaningLineModeGrid, //类似京东
};

typedef NS_ENUM(NSInteger, XDScaningWarningTone) {
    XDScaningWarningToneSound, //声音
    XDScaningWarningToneVibrate, //震动
    XDScaningWarningToneSoundAndVibrate, //声音和振动
};



#define Iphone4 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480))?YES:NO
#define Iphone5 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))?YES:NO
#define Iphone6 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667))?YES:NO
#define Iphone6Plus CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))?YES:NO
#define ScreenSize [UIScreen mainScreen].bounds.size
#define Color(r,g,b,a)  [UIColor colorWithRed:r/225.0 green:g/225.0 blue:b/225.9 alpha:a]

/***********************   配置区   ***************************/


/*
    此处是配置扫描秒区域适配各种屏幕的大小
    介于iPhone4和iPhone5的屏幕宽度一样，所以就归为一类
    猿类们可以根据自己项目的要求设置在不同屏幕中显示的大小
    不管怎么调整扫描区域在屏幕的位置始终是居中， 如果不想剧中则自行改代码去吧 
*/
#define Iphone45ScanningSize_width 230
#define Iphone45ScanningSize_height 230
#define Iphone6ScanningSize_width 260
#define Iphone6ScanningSize_height 260
#define Iphone6PlusScanningSize_width 290
#define Iphone6PlusScanningSize_height 290
#define TransparentArea(a,b)  CGSizeMake(a, b)



#define LineColor Color(225,0,225,.2) //扫描线的颜色，RGBA,用户可以定义任何颜色
#define LineShadowLastInterval .4 //此属性决定扫描线后面的尾巴的长短，值越大越长，当然XDScaningLineMode必须为XDScaningLineDeafult，其他无效
#define LineMoveSpeed 1 //扫描线移动的速度，值为每1/60秒移动的点数，数值越大移动速度越快
#define NavigationBarHidden YES //是否隐藏导航栏（前提是有导航栏，没有导航栏此设置无效）

#define ButtonSize CGSizeMake(40,40) //扫描界面所有触发事件的按钮的大小
#define ButtonFromBottom 80 // 屏幕下面的按钮到屏幕底部的距离


/*************************************************************/
#endif
