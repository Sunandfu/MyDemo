//
//  NetTool.h
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NetTool : NSObject
//获取idfa
+(NSString *)getIDFA ;
typedef enum {
    notReach=0,
    wifi=1,
    WWAN=2,
    net2G=3,
    net3G=4,
    net4G=5
}netType;
//+(NSString *) getrequestInfo:(NSString *)key;
+(NSString *) getrequestInfo:(NSString *)key width:(NSString*)width height:(NSString*)height macID:(NSString*)macID uid:(NSString*)uid;
+ (BOOL) connectedToNetwork;
//网络类型
//+ (NSDictionary *)getIPAddresses;
//+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)getMac;
+ (NSString *)gettelModel;
+(NSString *)getPackageName;
+ (NSString *)getOpenUDID;
+ (NSString *)getOS;
+(NSString *)deviceWANIPAdress;
+(netType) getNetTyepe;
+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop;
+ (NSString *)getNowDateStr_2;
+ (UIImage *)getLauchImage;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView;
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame;
+ (NSString *)URLEncodedString:(NSString*)str;
+ (UIViewController *)getCurrentViewController;
+ (void)setImage:(UIImageView*)imageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
