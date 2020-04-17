//
//  NetTool.h
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+addFunction.h"
#import "NSObject+addFunction.h"
#import "UIImageView+WebCache.h"
#import "SFNewsConfiguration.h"
#import "NSObject+SF_MJParse.h"
#import "SFConstant.h"
#import "YXGTMBase64.h"

#define WEAK(weakSelf)   __weak typeof(self) weakSelf = self
typedef void(^downloadFinish)(UIImage *image,NSString *imageUrl);
typedef void(^downloadFailure)(NSError *error);

@interface NetTool : NSObject

typedef enum {
    notReach=0,
    WWAN=1,
    net2G=2,
    net3G=3,
    net4G=4,
    net5G=5,
    wifi=100,
    Ethernet=101,
    unknown=999,
}netType;
//获取idfa
+ (NSString *)getIDFA;
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
/** APP名字 */
+ (NSString *)getAppName;
/** 获取UUID */
+ (NSString *)getDeviceUUID;
/** 系统版本 */
+ (NSString *)getOS;
/** 时间戳 */
+ (NSString *)getTimeLocal;
/** url编码 */
+ (NSString *)URLEncodedString:(NSString*)str;
/** 获取小码联城城市代码 */
+ (NSString *)getCityCode;
/** 获取IP地址 */
+ (NSString *)getDeviceIPAdress;
/** 获取网络类型 */
+ (netType) getNetTyepe;
/** 获取本机运营商 */
+ (NSInteger)getYunYingShang;
/** 计算两个时间之间的小时差   格式：yy-MM-dd HH:mm:ss */
+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop;
/** 获取当前时间字符串  格式：yy-MM-dd HH:mm:ss */
+ (NSString *)getNowDateStr;
/** 根据传入时间判断各个显示格式  eg:几分钟,几小时,几天...  格式：yy-MM-dd HH:mm:ss*/
+ (NSString *)compareCurrentTime:(NSString *)dateStr;
+ (UIImage *)getLauchImage;
/** 将当前View截取为Image */
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame;
/** 展示图片 */
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
/**
 * 获取 SDK 版本
 */
+ (NSString *)sdkVersion;
+ (void)uncaughtExceptionHandler:(NSException *)exception;

@end
