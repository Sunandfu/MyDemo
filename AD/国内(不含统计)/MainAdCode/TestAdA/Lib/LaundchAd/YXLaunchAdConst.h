//
//  YXLaunchAdConst.h
//  YXLaunchAdExample
//
//  Created by shuai on 2018/5/21.
//  Copyright © 2018年 YX. All rights reserved.

#import <UIKit/UIKit.h>

#define YXLaunchAdDeprecated(instead) __attribute__((deprecated(instead)))

#define XHWeakSelf __weak typeof(self) weakSelf = self;

#define SF_ScreenW    [UIScreen mainScreen].bounds.size.width
#define SF_ScreenH    [UIScreen mainScreen].bounds.size.height

#define SF_iPhoneXStyle ( (CGSizeEqualToSize(CGSizeMake(414, 896), [[UIScreen mainScreen] bounds].size)) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO) )
#define SF_StatusBarAndNavigationBarHeight (SF_iPhoneXStyle ? 88.f : 64.f)
#define SF_StatusBarHeight (SF_iPhoneXStyle ? 44.f : 20.f)
#define SF_TabbarHeight (SF_iPhoneXStyle ? 83.f : 49.f)
#define SF_MagrinBottom (SF_iPhoneXStyle ? 34.f : 0.f)

#define XHISURLString(string)  ([string hasPrefix:@"https://"] || [string hasPrefix:@"http://"]) ? YES:NO
#define XHStringContainsSubString(string,subString)  ([string rangeOfString:subString].location == NSNotFound) ? NO:YES

#ifdef DEBUG
#define YX_DEBUG_MODE YES
#define YXLaunchAdLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define YXLaunchAdLog(...)
#define YX_DEBUG_MODE NO
#endif

#define XHISGIFTypeWithData(data)\
({\
BOOL result = NO;\
if(!data) result = NO;\
uint8_t c;\
[data getBytes:&c length:1];\
if(c == 0x47) result = YES;\
(result);\
})

#define XHISVideoTypeWithPath(path)\
({\
BOOL result = NO;\
if([path hasSuffix:@".mp4"])  result =  YES;\
(result);\
})

#define XHDataWithFileName(name)\
({\
NSData *data = nil;\
NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];\
if([[NSFileManager defaultManager] fileExistsAtPath:path]){\
data = [NSData dataWithContentsOfFile:path];\
}\
(data);\
})

#define DISPATCH_SOURCE_CANCEL_SAFE(time) if(time)\
{\
dispatch_source_cancel(time);\
time = nil;\
}

#define REMOVE_FROM_SUPERVIEW_SAFE(view) if(view)\
{\
[view removeFromSuperview];\
view = nil;\
}

#define YXLaunchLogoURL @"http://static.yunqingugm.com/ad.png"

UIKIT_EXTERN NSString *const XHCacheImageUrlStringKey;
UIKIT_EXTERN NSString *const XHCacheVideoUrlStringKey;

UIKIT_EXTERN NSString *const YXLaunchAdWaitDataDurationArriveNotification;
UIKIT_EXTERN NSString *const YXLaunchAdDetailPageWillShowNotification;
UIKIT_EXTERN NSString *const YXLaunchAdDetailPageShowFinishNotification;
/** GIFImageCycleOnce = YES(GIF不循环)时, GIF动图播放完成通知 */
UIKIT_EXTERN NSString *const YXLaunchAdGIFImageCycleOnceFinishNotification;
/** videoCycleOnce = YES(视频不循环时) ,video播放完成通知 */
UIKIT_EXTERN NSString *const YXLaunchAdVideoCycleOnceFinishNotification;
/** 视频播放失败通知 */
UIKIT_EXTERN NSString *const YXLaunchAdVideoPlayFailedNotification;
UIKIT_EXTERN BOOL YXLaunchAdPrefersHomeIndicatorAutoHidden;

#define IMAGEHEIGHT (self.frame.size.height * 0.37)

