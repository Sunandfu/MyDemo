//
//  NetTool.h
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import <StoreKit/StoreKit.h>
#import <WebKit/WebKit.h>

#import "SFConstant.h"
#import "SFAdConst.h"
#import "SFImgUtil.h"
#import "SFCustomWebViewController.h"
#import "SFPermenantThread.h"
#import "SFModel.h"
#import "SFQuickSort.h"
#import "SFTimer.h"
#import "SFS2SModel.h"

#import "UIButton+SFAdd.h"
#import "UIImage+SFAdd.h"
#import "UIView+SFAdd.h"
#import "NSDate+SFAdd.h"
#import "NSObject+SFAdd.h"
#import "NSString+SFAdd.h"
#import "NSArray+SFAdd.h"
#import "NSCharacterSet+SFAdd.h"

typedef void(^downloadFinish)(UIImage *image,NSString *imageUrl);
typedef void(^downloadFailure)(NSError *error);

@interface SFNetTool : NSObject

typedef enum {
    notReach=0,
    wifi=1,
    net2G=2,
    net3G=3,
    net4G=4,
    net5G=5,
    othernet=10,
    unknown=999,
}netType;
+ (instancetype)defaultManager;
/** 获取idfa */
+ (NSString *)getIDFA;
/** 获取idfv */
+ (NSString *)getIDFV;
/** 获取UUID */
+ (NSString *)getDeviceUUID;
/** 判断是否联网 */
+ (BOOL)connectedToNetwork;
/** 获取屏幕像素密度 */
+ (NSString *)getPPI;
/** 获取mac地址 */
+ (NSString *)getMac;
/** 设备型号 */
+ (NSString *)gettelModel;
/** 设备英寸 */
+ (NSInteger)getPhysicalDevice;
/** 应用包名 Bundle ID */
+ (NSString *)getPackageName;
/** 应用主语言 */
+ (NSString *)getLanguage;
/** APP名字 */
+ (NSString *)getAppName;
/** APP版本号 */
+ (NSString *)getAppVersion;
/** APP Build 版本 */
+ (NSString *)getAppBuild;
/** iOS 系统更新标识 */
+ (NSString *)getUpdate;
/** iOS 系统启动标识 */
+ (NSString *)getBoot;
/** 获取唯一标识，随机数 */
+ (NSString *)getUniqueID;
/** 获取并保存唯一标识，随机数 */
+ (NSString *)setUniqueID;
/** User_Agent */
+ (NSString *)getUserAgent;
/** 系统版本 */
+ (NSString *)getOS;
/** 时间戳 */
+ (NSString *)getTimeLocal;
/** url编码 */
+ (NSString *)URLEncodedString:(NSString*)str;
/** 获取IP地址 */
+ (NSString *)getDeviceIPAdress;
/** 获取IPv6地址 */
+ (NSString *)getIPV6Adress;
/** 获取网络类型 */
+ (netType) getNetTyepe;
/** 获取本机运营商 */
+ (NSInteger)getYunYingShang;
/** 获取IMSI */
+ (NSString *)getIMSI;

#pragma mark -
/** 计算两个时间之间的小时差   格式：yy-MM-dd HH:mm:ss */
+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop;
/** 获取当前时间字符串  格式：yy-MM-dd HH:mm:ss */
+ (NSString *)getNowDateTimeStr;
/** 获取当前时间字符串  格式：yy-MM-dd */
+ (NSString *)getNowDateStr;
/** 获取当前时间字符串  格式：HH:mm:ss */
+ (NSString *)getNowTimeStr;
/** 根据传入时间判断各个显示格式  eg:几分钟,几小时,几天...  格式：yy-MM-dd HH:mm:ss*/
+ (NSString *)compareCurrentTime:(NSString *)dateStr;
/** 根据传入时间获得时间显示  格式：HH:mm:ss */
+(NSString *)getHMSTimeWithTimeInterval:(NSInteger)endTimeInterval;
/** 根据传入时间获得时间显示  格式：mm:ss */
+(NSString *)getMSTimeWithTimeInterval:(NSInteger)endTimeInterval;
#pragma mark - date
+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;
+ (NSInteger)getDifferenceByDate1:(NSString *)date1 Date2:(NSString *)date2;//计算两个日期之间有多少天
+ (NSString *)nextDayWithDate:(NSDate *)date Number:(NSInteger)number;
+ (NSString *)nextDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number;
+ (NSString *)nextYearMonthDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number;
/**
0->两日期相等   ( 1 *** aDate<bDate )   ( -1 *** aDate>bDate )
 */
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;
/** 获取APP启动图 */
+ (UIImage *)getLauchImage;
/** 将当前View截取为Image */
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame;
/** 展示图片 */
+ (void)setButtonImage:(UIButton*)button WithURLStr:(NSString *)urlStr;
+ (void)setImage:(UIImageView*)imageView WithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;
/** 清楚图片缓存 */
+ (void)clearNetImageChace;
/** 判断Cell是否显示在屏幕上 */
+ (BOOL)isInScreenView:(UIView *)inView ;
+ (BOOL)isInScreenCell:(UITableViewCell*)cell;
/** 将 jsonString 转化为 字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/** 富文本转化 */
+ (NSMutableAttributedString *)attributedSetWithString:(NSString *)string;
/** 获取url的所有参数 */
+ (NSMutableDictionary *)parseURLParametersWithURLStr:(NSString *)urlStr;
/** 为url添加参数 */
+ (NSString *)urlStrWithDict:(NSDictionary *)arrayDic UrlStr:(NSString *)urlStr;
/** 错误日志 */
+ (void)uncaughtExceptionHandler:(NSException *)exception;

/** MD5加密 */
+ (NSString *)MD5WithUrl:(NSString *)urlStr;
+ (NSString *)cachePathWithMD5:(NSString *)md5;

/** 16进制字符串转color */
+ (UIColor *)colorWithDarkModelColor:(NSString *)color;
+ (UIColor *)colorWithDarkModelColor:(NSString *)color andOpacity:(CGFloat)opacity;
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexColor:(NSString *)color andOpacity:(CGFloat)opacity;
/** 返回提供的颜色的image */
+ (UIImage *)imageWithColor:(UIColor *)color;
/** 返回所提供的颜色与尺寸的图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/** 雷达波纹扩散动画 */
+(void)showCircleAnimationLayerWithView:(UIView *)view Color:(UIColor *)circleColor andScale:(CGFloat)scale;
/** 在 string 中通过正则表达式 regexStr 查找符合()中的内容,以数组返回 */
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
/** 根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小 */
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
/** 根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小 */
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;
/** 字体下载并展示  */
+ (void)asynchronouslySetFontName:(NSString *)fontName WithLabel:(UILabel *)showLabel Font:(CGFloat)fontSize;
/** 提取字符串中的数字 */
+ (NSString *)getNumberFromDataStr:(NSString *)str;
/** 为view添加抖动动画 */
+ (void)addImageRotationWithView:(UIView *)view;
+ (void)addImageRotationWithView:(UIView *)view Count:(float)count;
/** 为view添加放大缩小动画 */
+ (void)addImageScaleWithView:(UIView *)view;
+ (void)addImageScaleWithView:(UIView *)view repeatCount:(float)count;
/** 为view添加延时放大动画 */
+ (void)addImageScaleShowAnimationWithView:(UIView *)view Time:(NSInteger)time;
/** 添加简单的弹框缓冲效果 */
+ (void)animationWithAlertViewWithView:(UIView*)allView;
/** 为view添加阴影 */
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor shadowRadius:(CGFloat)radius;
/** 给view设置渐变颜色 */
+ (void)addGradientLayerWithUIColors:(NSArray*)colors View:(UIView*)view;
/** 获取当前window */
+ (UIWindow *)getKeyWindow;
/** 获取当前的控制器 */
+ (UIViewController *)getCurrentViewController;
/** 获取最顶部的控制器 */
+ (UIViewController *)topViewController;
/** 判断是否是全面屏 */
+ (BOOL)isIPhoneXAbove;
/** 判断是否可以获取到idfa */
+ (BOOL)isCanGetIdfa;
/** 销毁控制器到兑换商城首页 */
+ (void)dismissCurrentVC;

@property (nonatomic, strong) SFPermenantThread *thred;

//自投渲染的模板
@property (nonatomic, strong) NSMutableArray *s2sAdArray;
@property (nonatomic, strong) NSDictionary *s2sTapAdDict;
/** 自投广告点击与上报 */
- (void)ViewClickWithModel:(SFS2SModelAds *)adModel Width:(NSString *)widthStr Height:(NSString *)heightStr X:(NSString *)x Y:(NSString *)y Controller:(UIViewController *)controller;

/** 为label添加删除线 */
+ (void)labelAddDelegateLineWithView:(UILabel *)label ShowStr:(NSString *)textStr;
/** 清除缓存和cookie */
+ (void)cleanCacheAndCookie;
/** price 保留 position 位 转字符串*/
+ (NSString *)notRounding:(float)price afterPoint:(int)position;
/** 将指定颜色变浅 */
+ (UIColor *)shallowerWithColor:(UIColor *)color;

@end
