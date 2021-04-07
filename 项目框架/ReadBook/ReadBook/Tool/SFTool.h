//
//  NetTool.h
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^downloadFinish)(UIImage *image,NSString *imageUrl);
typedef void(^downloadFailure)(NSError *error);
@interface SFTool : NSObject

+ (instancetype)defaultManager;
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
// User_Agent
+ (NSString *)getUserAgent;
/** 获取UUID */
+ (NSString *)getDeviceUUID;
/** 系统版本 */
+ (NSString *)getOS;
/** 时间戳 */
+ (NSString *)getTimeLocal;
/** url编码 */
+ (NSString *)URLEncodedString:(NSString*)str;
/** 获取IP地址 */
+ (NSString *)getDeviceIPAdress;
/** 计算两个时间之间的小时差   格式：yy-MM-dd HH:mm:ss */
+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop;
/** 获取当前时间字符串  格式：yy-MM-dd HH:mm:ss */
+ (NSString *)getNowDateTimeStr;
/** 获取当前时间字符串  格式：yy-MM-dd */
+ (NSString *)getNowDateStr;
/** 获取当前时间字符串  格式：HH:mm:ss */
+ (NSString *)getNowTimeStr;
/** 获取当前时间字符串  传入格式符号，如：yy-MM-dd HH:mm:ss */
+ (NSString *)getNowTimeWithDataFormat:(NSString *)format;
/** 根据传入时间判断各个显示格式  eg:几分钟,几小时,几天...  格式：yy-MM-dd HH:mm:ss*/
+ (NSString *)compareCurrentTime:(NSString *)dateStr;
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
/** 获取当前启动页（启动页截取为Image） */
+ (UIImage *)getLauchImage;
/** 将当前View截取为Image */
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame;
/** 获取图片饼缓存图片 */
+ (UIImage *)getImageWithURLStr:(NSString *)urlStr;
/** 获取图片饼缓存图片路径 */
+ (NSString *)cacheImagePathWithMD5:(NSString *)md5;
/** 展示图片 */
+ (void)setImage:(UIImageView*)imageView WithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;
/** 下载图片 */
+ (void)downloadImageWithUrl:(NSString *)urlStr Finish:(downloadFinish)finish Failure:(downloadFailure)failure;
/** url 链接进行MD5缓存 */
+ (NSString *)MD5WithUrl:(NSString *)urlStr;
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

+ (void)uncaughtExceptionHandler:(NSException *)exception;
/** 颜色转换十六进制字符串 */
+ (NSString *)hexadecimalFromUIColor:(UIColor *)color;
/** 十六进制字符串转颜色 */
+ (UIColor *)colorWithHexString:(NSString *)color;
/** 十六进制字符串转颜色 加透明度 */
+ (UIColor *)colorWithHexColor:(NSString *)color andOpacity:(CGFloat)opacity;
/** 返回提供的颜色的image */
+ (UIImage *)imageWithColor:(UIColor *)color;
/** 返回所提供的颜色与尺寸的图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
/** 雷达波纹扩散动画 */
+(void)showCircleAnimationLayerWithView:(UIView *)view Color:(UIColor *)circleColor andScale:(CGFloat)scale;
/** 在 string 中通过正则表达式 regexStr 查找符合()中的内容,以数组返回 */
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
/** 提取字符串中的数字 */
+ (NSString *)getNumberFromDataStr:(NSString *)str;
/** 为view添加抖动动画 */
+ (void)addImageRotationWithView:(UIView *)view;
/** 为view添加放大缩小动画 */
+ (void)addImageScaleWithView:(UIView *)view;
/** 为view添加放大动画 */
+ (void)addImageScaleShowAnimationWithView:(UIView *)view Time:(NSInteger)time;
/** 获取当前window最顶层的控制器 */
+ (UIViewController *)topViewController;
/** 获取当前的控制器 */
+ (UIViewController *)getCurrentViewController;
/** 获取当前的导航栏 */
+ (UINavigationController *)currentNavigationController;
/** 判断是否是全面屏 */
+ (BOOL)isIPhoneXAbove;
/** 下载字体 */
+ (void)sf_asynchronouslySetFontName:(NSString *)fontName;
/** 去除字符串中的空白字符 */
+ (NSString *)sf_stringRemoveSpecialCharactersOfString:(NSString *)target;
+ (NSString *)sf_contentRemoveSpecialCharactersOfString:(NSString *)target;

@property (nonatomic, strong) UIProgressView *progressView;
+ (BOOL)isHaveProgress;
/** 根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小 */
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (UIFont *)font;
/** 根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小 */
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

+ (id)dataWithJsonPath:(NSString *)jsonPath Data:(id)jsonData;

@end
