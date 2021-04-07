//
//  SFConstant.h
//  AppProjectDemo
//
//  Created by 史岁富 on 2018/5/28.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSUserDefaultsKey

#define kFontSize [[NSUserDefaults standardUserDefaults] floatForKey:@"textViewFontSize"]
#define RANDOM_COLOR [UIColor colorWithHexString:@"ffa244"]

//是否开启亮度随系统标识
extern NSString * const KeyBrightSwitch;
//是否开启开屏验证
extern NSString * const KeySplashAuthID;
//开屏验证的间隔时长
extern NSString * const KeySplashAuthTime;
//是否开启高斯模糊
extern NSString * const KeyBlurEffect;
//是否开启屏幕常亮
extern NSString * const KeyTimerDisabled;
//翻页样式
extern NSString * const KeyPageStyle;
//点击区域
extern NSString * const KeyClickArea;
//阅读界面点击发出通知
extern NSString * const KeyReadDetailViewClick;
//是否开启字典功能
extern NSString * const KeyReadBookStudy;
//缓存书籍功能
extern NSString * const KeyCacheBooks;
//朗读语速
extern NSString * const KeyBookRate;
//朗读语调
extern NSString * const KeyBookPitch;
//文本行高
extern NSString * const KeyBookLineHeight;
//文本段高
extern NSString * const KeyBookParagraphHeight;
//字体样式
extern NSString * const KeyFontName;
//黑暗模式
extern NSString * const KeyDarkMode;
//语音样式
extern NSString * const KeyVoiceName;
//选中的APPlogo
extern NSString * const KeyAppLogoName;
//退出小说详情页 弹框
extern NSString * const KeyExitAlert;
//排行榜本地缓存
extern NSString * const KeyRunLocaCache;
//翻页点击互换
extern NSString * const KeyTapClickExchange;
//书籍更新提醒
extern NSString * const KeyBookUpdateReminder;
//书籍自动阅读速率
extern NSString * const KeyBookAutoReadSpeed;
//结束书籍自动阅读
extern NSString * const KeyBookEndAutoRead;
//阅读界面是否隐藏状态栏
extern NSString * const KeyBookHiddleStatus;
//阅读界面是否隐藏章节标题
extern NSString * const KeyBookHiddleTitle;
//书架小说按照阅读时间排序
extern NSString * const KeyBookReadTimeSolt;
//书架首页书籍按照九宫格样式排序
extern NSString * const KeyBookJiugongStyle;
//用户的UserAgent
extern NSString * const KeyUserAgent;
//书籍目录倒序
extern NSString * const KeyMenuReverse;
//书籍页面手势返回
extern NSString * const KeySwipeBack;
//当前选中的分组
extern NSString * const KeySelectGroup;
//当前是否选中黑夜模式
extern NSString * const KeySelectNight;
//当前暗黑模式是否跟随系统
extern NSString * const KeyNightFollowingSystem;
