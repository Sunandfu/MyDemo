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

#define WEAK(weakSelf)   __weak typeof(self) weakSelf = self
typedef void(^downloadFinish)(UIImage *image,NSString *imageUrl);
typedef void(^downloadFailure)(NSError *error);

@interface NetTool : NSObject
//获取idfa
+(NSString *)getIDFA ;
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
//+(NSString *) getrequestInfo:(NSString *)key;
+(NSString *) getrequestInfo:(NSString *)key
                       width:(NSString*)width
                      height:(NSString*)height
                       macID:(NSString*)macID
                         uid:(NSString*)uid
                     adCount:(NSInteger)adCount;
+ (BOOL) connectedToNetwork;
//网络类型
//+ (NSDictionary *)getIPAddresses;
//+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSString*)getDPI;
+ (NSString *)getMac;
+ (NSString *)gettelModel;
+(NSString *)getPackageName;
+ (NSString *)getOpenUDID;
+ (NSString *)getOS;
+ (NSString *)getTimeLocal;
+ (NSString *)getCityCode;
+ (NSString *)deviceWANIPAdress;
+ (netType) getNetTyepe;
+ (NSInteger)getYunYingShang;
+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop;
+ (NSString *)getNowDateStr_2;
+ (NSString *)compareCurrentTime:(NSString *)dateStr;
+ (UIImage *)getLauchImage;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame;
+ (NSString *)URLEncodedString:(NSString*)str;
+ (UIViewController *)getCurrentViewController;
+ (void)setImage:(UIImageView*)imageView WithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;

+ (BOOL)isInScreenView:(UIView *)inView ;
+ (BOOL)isInScreenCell:(UITableViewCell*)cell;

+ (void)clearNetImageChace;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSMutableAttributedString *)attributedSetWithString:(NSString *)string;
+ (NSMutableDictionary *)parseURLParametersWithURLStr:(NSString *)urlStr;
+ (NSString *)urlStrWithDict:(NSDictionary *)arrayDic UrlStr:(NSString *)urlStr;
/**
 * 获取 SDK 版本
 */
+ (NSString *)sdkVersion;

@end
