//
//  MyHelper.h
//  UIControlDemo
//
//  Created by Hailong.wang on 15/8/3.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//
/*  设置JSONKit.m 混编 -fno-objc-arc */
#ifndef UIControlDemo_MyHelper_h
#define UIControlDemo_MyHelper_h

#import "Factory.h"
#import "GlobalUtil.h"
#import "MyTextField.h"
#import "NSString+additional.h"
#import "UILabel+LXAdd.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIColor+zjdd.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"
#import "UIView+convenience.h"
#import "SAMTextView.h"
#import "SJAvatarBrowser.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "NSString+Extension.h"
#import "UIImage+Categories.h"
#import "BlueToothViewTipView.h"
#import "JSONKit.h"
#import "GiFHUD.h"

#define SCREEN_WIDTH                    CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT                   CGRectGetHeight([[UIScreen mainScreen] bounds])
#define SCREEN_SCALE                    SCREEN_WIDTH/320.f
#define kScaleNum(x)                    x*SCREEN_SCALE
//拿到屏幕的宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//拿到屏幕的高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//安全释放宏
#define Release_Safe(_control) [_control release], _control = nil;
//传入RGBA四个参数，得到颜色
//美工和设计通过PS给出的色值是0~255
//苹果的RGB参数给出的是0~1
//那我们就让美工给出的 参数/255 得到一个0-1之间的数
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//传入RGB三个参数，得到颜色
#define RGB(r,g,b) RGBA(r,g,b,1.f)
//各个页面的导航栏颜色
#define RedColor [UIColor colorWithRed:0.96 green:0.20 blue:0.40 alpha:1.0f]
//取得随机颜色
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)

#endif





