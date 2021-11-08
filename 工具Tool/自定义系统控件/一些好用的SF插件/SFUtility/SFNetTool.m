//
//  NetTool.m
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import "SFNetTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreText/CoreText.h>
#import <AdSupport/ASIdentifierManager.h>
#import "SFNetwork.h"
#import "SFReachability.h"
#import "NSString+SFAES.h"

#include "netdb.h"
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface SFNetTool()<SFSafariViewControllerDelegate,SKStoreProductViewControllerDelegate>

@property (nonatomic, retain) CTTelephonyNetworkInfo *info;

@end

@implementation SFNetTool

+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    static SFNetTool *sftool = nil;
    dispatch_once(&onceToken, ^{
        sftool = [[SFNetTool alloc]init];
    });
    return sftool;
}
- (CTTelephonyNetworkInfo *)info{
    if (!_info) {
        _info = [[CTTelephonyNetworkInfo alloc] init];
    }
    return _info;
}
- (SFPermenantThread *)thred{
    if (!_thred) {
        _thred = [[SFPermenantThread alloc] init];
    }
    return _thred;
}
+ (NSString *)getTimeLocal{//毫秒级
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    return timeLocal;
}
+ (NSString *)getDeviceIPAdress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    NSString *CT_NUM = @"(\\d+\\.\\d+\\.\\d+\\.\\d+)";
    //判断返回字符串是否为所需数据
    if (ip.length>0) {
        NSArray *strArr = [self matchString:ip toRegexString:CT_NUM];
        return strArr.count>0?[strArr firstObject]:@"0.0.0.0";
    } else {
        return @"0.0.0.0";
    }
}
+ (NSString *)getIPV6Adress{
//    IPToolManager *ipTool = [IPToolManager sharedManager];
//    SFLog(@"%@",[ipTool currentIpAddress]);
    return @"";
}
+(NSString *)iphonePlatform{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    /*-----**************************** iPhone ****************************-----*/
    
    if ([platform isEqualToString:@"iPhone1,1"])   return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])   return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])   return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])   return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"])   return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"])   return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"])   return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"])   return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])   return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])   return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])   return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])   return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])   return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])   return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])  return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,8"])  return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone11,2"])  return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])  return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])  return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])  return @"iPhone SE 2nd";
    if ([platform isEqualToString:@"iPhone13,1"])  return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"])  return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])  return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])  return @"iPhone 12 Pro Max";
    
    /*-----**************************** iPad ****************************-----*/
    
    if ([platform isEqualToString:@"iPad1,1"])    return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])    return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])    return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])    return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])    return @"iPad 4";
    if ([platform isEqualToString:@"iPad6,11"])   return @"iPad 5";
    if ([platform isEqualToString:@"iPad6,12"])   return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,5"])    return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,6"])    return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,11"])   return @"iPad 7";
    if ([platform isEqualToString:@"iPad7,12"])   return @"iPad 7";
    if ([platform isEqualToString:@"iPad11,6"])   return @"iPad 8";
    if ([platform isEqualToString:@"iPad11,7"])   return @"iPad 8";
    
    /*-----**************************** iPad Air ****************************-----*/
    
    if ([platform isEqualToString:@"iPad4,1"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])    return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])    return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])    return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad11,3"])   return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"])   return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad13,1"])   return @"iPad Air 4";
    if ([platform isEqualToString:@"iPad13,2"])   return @"iPad Air 4";
    
    /*-----**************************** iPad Pro ****************************-----*/
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro 2 (12.9-inch)";
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro 2 (12.9-inch)";
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad8,1"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,2"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,3"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,4"])   return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,5"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,6"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,7"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,8"])   return @"iPad Pro 3 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,8"])   return @"iPad Pro 2 (11-inch)";
    if ([platform isEqualToString:@"iPad8,10"])  return @"iPad Pro 2 (11-inch)";
    if ([platform isEqualToString:@"iPad8,11"])  return @"iPad Pro 4 (12.9-inch)";
    if ([platform isEqualToString:@"iPad8,12"])  return @"iPad Pro 4 (12.9-inch)";
    
    /*-----**************************** iPad Mini ****************************-----*/
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad11,1"])  return @"iPad Mini 5";
    if ([platform isEqualToString:@"iPad11,2"])  return @"iPad Mini 5";
    
    /*-----**************************** iPod Touch ****************************-----*/
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6";
    if ([platform isEqualToString:@"iPod9,1"])   return @"iPod Touch 7";
    
    /*-----**************************** Apple Watch ****************************-----*/
    
    if ([platform isEqualToString:@"Watch1,1"])   return @"Apple Watch 1";
    if ([platform isEqualToString:@"Watch1,2"])   return @"Apple Watch 1";
    if ([platform isEqualToString:@"Watch2,6"])   return @"Apple Watch Series 1";
    if ([platform isEqualToString:@"Watch2,7"])   return @"Apple Watch Series 1";
    if ([platform isEqualToString:@"Watch2,3"])   return @"Apple Watch Series 2";
    if ([platform isEqualToString:@"Watch2,4"])   return @"Apple Watch Series 2";
    if ([platform isEqualToString:@"Watch3,1"])   return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,2"])   return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,3"])   return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch3,4"])   return @"Apple Watch Series 3";
    if ([platform isEqualToString:@"Watch4,1"])   return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch4,2"])   return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch4,3"])   return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch4,4"])   return @"Apple Watch Series 4";
    if ([platform isEqualToString:@"Watch5,1"])   return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,2"])   return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,3"])   return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,4"])   return @"Apple Watch Series 5";
    if ([platform isEqualToString:@"Watch5,9"])   return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch5,10"])  return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch5,11"])  return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch5,12"])  return @"Apple Watch SE";
    if ([platform isEqualToString:@"Watch6,1"])   return @"Apple Watch Series 6";
    if ([platform isEqualToString:@"Watch6,2"])   return @"Apple Watch Series 6";
    if ([platform isEqualToString:@"Watch6,3"])   return @"Apple Watch Series 6";
    if ([platform isEqualToString:@"Watch6,4"])   return @"Apple Watch Series 6";
    
    /*-----******************************** 模拟器 ********************************-----*/
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

//获取网络类型
+(netType)getNetTyepe
{
    netType nettype = notReach;
    SFReachability *ablity = [SFReachability reachabilityWithHostName:@"www.baidu.com"];
    SFNetworkStatus currentStatus = [ablity currentReachabilityStatus];
    switch (currentStatus) {
        case SFNetworkStatusNotReachable:
            nettype = notReach;
            SFLog(@"网络不可用");
            break;
        case SFNetworkStatusUnknown:
            nettype = unknown;
            SFLog(@"未知网络");
            break;
        case SFNetworkStatusWWAN2G:
            nettype = net3G;
            SFLog(@"2G网络");
            break;
        case SFNetworkStatusWWAN3G:
            nettype = net3G;
            SFLog(@"3G网络");
            break;
        case SFNetworkStatusWWAN4G:
            nettype = net4G;
            SFLog(@"4G网络");
            break;
        case SFNetworkStatusWWAN5G:
            nettype = net5G;
            SFLog(@"5G网络");
            break;
        case SFNetworkStatusWiFi:
            nettype = wifi;
            SFLog(@"WiFi");
            break;
            
        default:
            break;
    }
    return nettype;
}

//获取idfa
+(NSString *)getIDFA{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa?idfa:@"";
}
//获取idfa
+(NSString *)getIDFV{
    NSUUID *UUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *idfv = [NSString stringWithFormat:@"%@",UUID.UUIDString];
    return idfv;
}
//获取IMSI
+ (NSString *)getIMSI{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *imsi = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return imsi?imsi:@"";
}
// User_Agent
+ (NSString *)getUserAgent{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userAgent = [userDefault objectForKey:KeyUserAgent];
    return userAgent?userAgent:@"Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148";
}
//OpenUDID zzz uid
+ (NSString *)getDeviceUUID
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [userDefault objectForKey:@"ApplicationUniqueIdentifier"];
    if (uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        if (uuid == nil) {uuid = @"";}
        [userDefault setObject:uuid forKey:@"ApplicationUniqueIdentifier"];
        [userDefault synchronize];
    }
    return uuid?uuid:@"";
}


//获取mac地址
//Mac地址
+ (NSString *)getMac{
    int                   mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        free(buf);
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
    
}
+ (NSString *)URLEncodedString:(NSString*)str{
    NSString *encodedString = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}
//系统版本
+ (NSString *)getOS
{
    NSString *os = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@",os];
}
//设备型号
+ (NSString *)gettelModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    return [NSString stringWithFormat:@"%@",platform];
}
+ (NSString*)getPPI
{
    if (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size)) {//4S 5
        return @"163";
    }else if (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)){//5S  SE
        return @"326";
    }else if (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size)){//6 7 8
        return @"326";
    }else if (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)){//6+ 7+ 8+
        return @"401";
    }else if (CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)){//XS
        return @"458";
    }else if (CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size)){
        if ([[self iphonePlatform] isEqualToString:@"iPhone XS Max"]) {//6.5  XS Max
            return @"458";
        } else {//6.1 iPhone XR
            return @"401";
        }
    }else{
        return @"163";
    }
}
//获取设备英寸
+ (NSInteger)getPhysicalDevice{
    if (CGSizeEqualToSize(CGSizeMake(414, 896), [UIScreen mainScreen].bounds.size)){
        if ([[self iphonePlatform] isEqualToString:@"iPhone XS Max"]) {//6.5
            return 6.5;
        } else {//6.1 iPhone XR
            return 6.1;
        }
    } else if (CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)){
        return 5.8;
    } else if (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)){
        return 5.5;
    } else if (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size)){
        return 4.7;
    } else if (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)){
        return 4;
    } else {
        return 3.5;
    }
}
//应用包名
+ (NSString *)getPackageName
{
    NSString *packageName = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] bundleIdentifier]];
    return packageName;
}
+ (NSString *)getLanguage{
    NSArray *allLanguages = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    if ([allLanguages firstObject] && [[allLanguages firstObject] isKindOfClass:[NSString class]]) {
        NSString *preferredLang = [allLanguages firstObject];
        return preferredLang?preferredLang:@"zh-Hans-CN";
    }
    return @"zh-Hans-CN";
}
+ (NSString *)getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name?app_Name:@"";
}
+ (NSString *)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version?app_Version:@"";
}
+ (NSString *)getAppBuild{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build?app_build:@"";
}
+ (NSString *)getUpdate
{
    NSString *timeString = nil;
    struct stat sb;
    NSString *enCodePath = @"L3Zhci9tb2JpbGU=";
    NSData *data=[[NSData alloc]initWithBase64EncodedString:enCodePath options:0];
    NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    const char* dePath = [dataString cStringUsingEncoding:NSUTF8StringEncoding];
    if (stat(dePath, &sb) != -1) {
        timeString = [NSString stringWithFormat:@"%d.%d", (int)sb.st_ctimespec.tv_sec, (int)sb.st_ctimespec.tv_nsec];
    }
    else {
        timeString = @"0.0";
    }
    return timeString?:@"";
}

+ (NSString *)getBoot
{
    NSString *timeString = nil;
    
    int mib[2];
    size_t size;
    struct timeval  boottime;

    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1)
    {
        timeString = [NSString stringWithFormat:@"%d.%d", (int) boottime.tv_sec, (int) boottime.tv_usec];
    }
    return timeString?:@"";
}
+ (NSString *)getUniqueID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KeyUniqueID];
}
+ (NSString *)setUniqueID{
    NSString *uniqueID = [NSString stringWithFormat:@"%@%u",[self getTimeLocal],arc4random()];
    [[NSUserDefaults standardUserDefaults] setObject:uniqueID forKey:KeyUniqueID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return uniqueID;
}
//判断是否连接网络
+ (BOOL) connectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags){
        printf("Error. Could not recover network Reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // BOOL isEDGE = flags & kSCNetworkReachabilityFlagsIsWWAN;
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (NSInteger)getYunYingShang{
    //获取本机运营商名称
    CTCarrier *carrier = [[SFNetTool defaultManager].info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
//        SFLog(@"没有SIM卡");
        mobile = @"无运营商";
    }else{
        mobile = [carrier carrierName];
    }
    
    if ([mobile isEqualToString:@"中国移动"]) {
        return 1;
    }
    else if ([mobile isEqualToString:@"中国联通"]) {
        return 2;
    }
    else if ([mobile isEqualToString:@"中国电信"]) {
        return 3;
    }
    else if ([mobile isEqualToString:@"无运营商"]) {
        return 0;
    }
    else{
        return 99;
    }
}

+ (NSInteger)getSpendTimeWithStartDate:(NSString *)start stopDate:(NSString *)stop
{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yy-MM-dd HH:mm:ss";
    NSDate * startDate = [dateFormatter dateFromString:start];
    NSDate * stopDate = [dateFormatter dateFromString:stop];
    NSTimeInterval interval = [stopDate timeIntervalSinceDate:startDate];
    return (NSInteger)interval/3600;
}
+ (NSString *)getNowDateTimeStr
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getNowDateStr
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"yyyy-MM-dd";
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getNowTimeStr
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"HH:mm:ss";
    return [recordDateFormatter stringFromDate:[NSDate date]];
}
+(NSString *)getHMSTimeWithTimeInterval:(NSInteger)endTimeInterval{
    NSTimeInterval timeInterval = endTimeInterval;
    int hours = (int)((timeInterval)/3600);
    int minutes = (int)(timeInterval-hours*3600)/60;
    int seconds = timeInterval-hours*3600-minutes*60;
    
    NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //小时
    hoursStr = [NSString stringWithFormat:@"%02d",hours];
    //分钟
    minutesStr = [NSString stringWithFormat:@"%02d",minutes];
    //秒
    secondsStr = [NSString stringWithFormat:@"%02d", seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"00:00:00";
    }
    return [NSString stringWithFormat:@"%@:%@:%@",hoursStr , minutesStr,secondsStr];
}
+(NSString *)getMSTimeWithTimeInterval:(NSInteger)endTimeInterval{
    NSTimeInterval timeInterval = endTimeInterval;
    int minutes = (int)(timeInterval)/60;
    int seconds = timeInterval-minutes*60;
    
    NSString *minutesStr;NSString *secondsStr;
    //分钟
    minutesStr = [NSString stringWithFormat:@"%02d",minutes];
    //秒
    secondsStr = [NSString stringWithFormat:@"%02d", seconds];
    if (minutes<=0&&seconds<=0) {
        return @"00:00";
    }
    return [NSString stringWithFormat:@"%@:%@",minutesStr,secondsStr];
}
+ (void)dismissCurrentVC{
    for (UIViewController *infoVC in [SFNetTool getCurrentViewController].navigationController.viewControllers) {
        if ([infoVC isKindOfClass:NSClassFromString(@"SFThirdStoreHomeViewController")]) {
            [[SFNetTool getCurrentViewController].navigationController popToViewController:infoVC animated:YES];
            return;
        }
    }
    [[SFNetTool getCurrentViewController].navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - date

+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSInteger)getDifferenceByDate1:(NSString *)date1 Date2:(NSString *)date2{
    if (date1==nil || date2==nil) {
        return 0;
    }
    //获得当前时间
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *oldDate = [dateFormatter dateFromString:date1];
    NSDate *newDate = [dateFormatter dateFromString:date2];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oldDate  toDate:newDate  options:0];
    return [comps day];
}

+ (NSString *)nextDayWithDate:(NSDate *)date Number:(NSInteger)number{
    NSDate *newDate = [date dateByAddingTimeInterval:number * (24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return [dateString substringWithRange:NSMakeRange(8, 2)];
}

+ (NSString *)nextDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [dateFormatter dateFromString:nowDateStr];
    NSDate *newDate = [date dateByAddingTimeInterval:number * (24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"dd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return dateString;
}
+ (NSString *)nextYearMonthDayWithDateStr:(NSString *)nowDateStr Number:(NSInteger)number{
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate * date = [dateFormatter dateFromString:nowDateStr];
    NSDate *newDate = [date dateByAddingTimeInterval:number * (24 * 60 * 60)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    return dateString;
}
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    if (aDate==nil||bDate==nil) {
        return 0;
    }
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
    }
    return aa;
}

+ (UIImage *)getLauchImage
{
    return [self imageFromLaunchImage] ?[self imageFromLaunchImage]: [self imageFromLaunchScreen];
}
+ (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage *)imageFromLaunchImage{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL)  return imageL;
    //    XHLaunchAdLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

+(UIImage *)imageFromLaunchScreen{
    NSString *UILaunchStoryboardName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchStoryboardName"];
    if(UILaunchStoryboardName == nil){
        //        XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
        return nil;
    }
    UIViewController *LaunchScreenSb = [[UIStoryboard storyboardWithName:UILaunchStoryboardName bundle:nil] instantiateInitialViewController];
    if(LaunchScreenSb){
        UIView * view = LaunchScreenSb.view;
        view.frame = [UIScreen mainScreen].bounds;
        UIImage *image = [self imageFromView:view];
        return image;
    }
    //    XHLaunchAdLog(@"从 LaunchScreen 中获取启动图失败!");
    return nil;
}

+(UIImage*)imageFromView:(UIView*)view{
    CGSize size = view.bounds.size;
    //参数1:表示区域大小 参数2:如果需要显示半透明效果,需要传NO,否则传YES 参数3:屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)launchImageWithType:(NSString *)type{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict){
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]){
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"]){
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize)){
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage * image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)snapshotScreenInView:(UIView *)contentView
{
    UIImage * image = nil;
    CGRect rect = contentView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    //自iOS7开始，UIView类提供了一个方法-drawViewHierarchyInRect:afterScreenUpdates:它允许你截取一个UIView或者其子类中的内容，并且以位图的形式（bitmap）保存到UIImage中
    [contentView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)snapshotScreenInView:(UIView *)contentView WithFrame:(CGRect)frame
{
    CGFloat scaleFlote = [UIScreen mainScreen].scale;
    CGRect newFrame = CGRectMake(scaleFlote*frame.origin.x, scaleFlote*frame.origin.y, scaleFlote*frame.size.width, scaleFlote*frame.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self snapshotScreenInView:contentView].CGImage, newFrame);
    UIGraphicsBeginImageContextWithOptions(newFrame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}

+ (void)setButtonImage:(UIButton*)button WithURLStr:(NSString *)urlStr{
    if (!urlStr) {
        return;
    }
    NSString *md5 = [self MD5WithUrl:urlStr];
    NSString *cachePath = [self cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        UIImage *image = [UIImage imageWithData:data];
        [button setImage:image forState:UIControlStateNormal];
    }else{
        [self downloadImageWithUrl:urlStr Finish:^(UIImage *image, NSString *imageUrl) {
            if (image) {
                if (![imageUrl isEqualToString:urlStr]) {
                    return ;
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData *data = UIImagePNGRepresentation(image);
                    [data writeToFile:cachePath atomically:YES];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setImage:image forState:UIControlStateNormal];
                });
            }
        } Failure:^(NSError *error) {
            SFLog(@"error:%@",error);
        }];
    }
}
+ (void)setImage:(UIImageView*)imageView WithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder {
    if (placeholder) {
        imageView.image = placeholder;
    }
    if (!urlStr) {
        return;
    }
    NSString *md5 = [self MD5WithUrl:urlStr];
    NSString *cachePath = [self cachePathWithMD5:md5];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    if (isExist) {
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        UIImage *image = [UIImage imageWithData:data];
        imageView.image = image;
    }else{
        [self downloadImageWithUrl:urlStr Finish:^(UIImage *image, NSString *imageUrl) {
            if (image) {
                if (![imageUrl isEqualToString:urlStr]) {
                    return ;
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData *data = UIImagePNGRepresentation(image);
                    [data writeToFile:cachePath atomically:YES];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            }
        } Failure:^(NSError *error) {
            SFLog(@"error:%@",error);
        }];
    }
}
+ (NSString *)compareCurrentTime:(NSString *)dateStr
{
    NSDateFormatter * dateformatter = [NSDateFormatter new];
    dateformatter.dateFormat = [@"yyyy-MM-dd HH:mm:ss" substringToIndex:dateStr.length];
    NSDate *compareDate = [dateformatter dateFromString:dateStr];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%d秒前",(int)timeInterval];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <3){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else{
        result = [NSString stringWithFormat:@"%@",dateStr];
    }
    return  result;
}
+ (NSString *)MD5WithUrl:(NSString *)urlStr{
    if (urlStr) {
        const char *original_str = [urlStr UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
        NSMutableString *hash = [NSMutableString string];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [hash appendFormat:@"%02X",result[i]];
        }
        return hash;
    } else {
        return @"";
    }
}
+ (NSString *)cachePathWithMD5:(NSString *)md5{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    [self imgFileDataLocationSettingWithPath:paths];
    NSString *pathStr=[NSString stringWithFormat:@"%@/%@",paths,md5];
    //    SFLog(@"沙盒路径：%@",pathStr);
    return pathStr;
}
//处理缓存路径
+(void)imgFileDataLocationSettingWithPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
+ (void)downloadImageWithUrl:(NSString *)urlStr Finish:(downloadFinish)finish Failure:(downloadFailure)failure{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //            SFLog(@"data:%@ response :%@",data,response);
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                finish(image,urlStr);
            }
            if (error) {
                failure(error);
            }
        }] resume];
        
    });
}
//清理沙盒中的图片缓存
+ (void)clearNetImageChace
{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:paths]){
        [fileManager removeItemAtPath:paths error:nil];
    }
    [fileManager createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
//    [[SDImageCache sharedImageCache] clearMemory];
}
// 判断View是否显示在屏幕上
+ (BOOL)isInScreenView:(UIView*)view
{
    if (view == nil) {
        return FALSE;
    }
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 转换view对应window的Rect
    CGRect rect = [view convertRect:view.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    // 若view 隐藏
    if (view.hidden) {
        return FALSE;
    }
    // 若没有superview
    if (view.superview == nil) {
        return FALSE;
    }
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return FALSE;
    }
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    return TRUE;
}
// 判断Cell是否显示在屏幕上
+ (BOOL)isInScreenCell:(UITableViewCell*)cell
{
    if (cell == nil) { 
        return NO;
    }
    UITableView * tableView = (UITableView*)cell.superview;
    CGFloat cellY = cell.frame.origin.y;
    CGFloat cellH = cell.frame.size.height;
    CGFloat tableHeight = tableView.frame.size.height;
    CGFloat newY = tableView.contentOffset.y;
    newY = newY + tableHeight;
    if (newY > cellY + cellH) {
        return YES;
    }else{
        return NO;
    }
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

+ (NSMutableAttributedString *)attributedSetWithString:(NSString *)string{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    //    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:NSMakeRange(0, string.length)];
    //字体名称有以下：
//    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceHanSansSC-Regular" size:17] range:NSMakeRange(0, string.length)];
    //2000-23
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:52.0f/255.0f green:52.0f/255.0f blue:52.0f/255.0f alpha:1.0f] range:NSMakeRange(0, string.length)];
    //设置段落格式
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 2;//增加行高
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1.0;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 0;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
    
    //字符间距 2pt
//    [attrString addAttribute:NSKernAttributeName value:@1 range:NSMakeRange(0, string.length)];
    return attrString;
}
//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    return rect.size.width;
}
+ (void)asynchronouslySetFontName:(NSString *)fontName WithLabel:(UILabel *)showLabel Font:(CGFloat)fontSize{
    UIFont* aFont = [UIFont fontWithName:fontName size:12.];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // Go ahead and display the sample text.
        showLabel.font = [UIFont fontWithName:fontName size:fontSize];
        return;
    }
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    // Start processing the font descriptor..
    // This function returns immediately, but can potentially take long time to process.
    // The progress is notified via the callback block of CTFontDescriptorProgressHandler type.
    // See CTFontDescriptor.h for the list of progress states and keys for progressParameter dictionary.
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //SFLog( @"state %d - %@", state, progressParameter);
#if DEBUG
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        SFLog(@"下载字体进度 %f",progressValue);
#endif
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                SFLog(@"开始下载字体");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                showLabel.font = [UIFont fontWithName:fontName size:fontSize];
                // Log the font URL in the console
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
//                SFLog(@"%@", (__bridge NSURL*)(fontURL));
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    SFLog(@"%@ downloaded", fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                SFLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                SFLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                SFLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            // An error has occurred.
            // Get the error message
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error) {
                SFLog(@"error = %@", error);
            }
        }
        return (bool)YES;
    });
}
/**
 获取url的所有参数
 
 @param urlStr 需要提取参数的url
 @return NSDictionary
 */
+ (NSMutableDictionary *)parseURLParametersWithURLStr:(NSString *)urlStr {
    if (!urlStr) {
        return nil;
    }
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.location == NSNotFound) return nil;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *parametersString = [urlStr substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (key == nil || value == nil) {
                continue;
            }
            id existValue = [parameters valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [parameters setValue:items forKey:key];
                } else {
                    [parameters setValue:@[existValue, value] forKey:key];
                }
            } else {
                [parameters setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return nil;
        }
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        if (key == nil || value == nil) {
            return nil;
        }
        [parameters setValue:value forKey:key];
    }
    
    return parameters;
}
+ (NSString *)urlStrWithDict:(NSDictionary *)arrayDic UrlStr:(NSString *)urlStr{
    NSMutableString *URL = [NSMutableString stringWithString:urlStr];
    //获取字典的所有keys
    NSArray * keys = [arrayDic allKeys];
    //拼接字符串
    for (int j = 0; j < keys.count; j ++) {
        NSString *string;
        if (j == 0) {
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[j], arrayDic[keys[j]]];
        } else {
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[j], arrayDic[keys[j]]];
        }
        //拼接字符串
        [URL appendString:string];
    }
    return [NSString stringWithString:URL];
}
// 获取异常崩溃信息
+ (void)uncaughtExceptionHandler:(NSException *)exception{
#if DEBUG
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *errorMessage = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    SFLog(@"errorMessage = %@", errorMessage);
#endif
    /*
     @try {
     [self requestADSource];
     } @catch (NSException *exception) {
     [SFNetTool uncaughtExceptionHandler:exception];
     } @finally {
     }
     */
}

+(void)showCircleAnimationLayerWithView:(UIView *)view Color:(UIColor *)circleColor andScale:(CGFloat)scale
{
    if (!view.superview && circleColor) {
        return;
    }
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds), view.bounds.size.width, view.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:view.layer.cornerRadius];
    
    CGPoint shapePosition = [view.superview convertPoint:view.center fromView:view.superview];
    
    //内圈
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = circleColor.CGColor;//
    circleShape.lineWidth = 0.6;
    
    [view.superview.layer addSublayer:circleShape];
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    scaleAnimation.duration = 1;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape addAnimation:scaleAnimation forKey:nil];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    alphaAnimation.duration = 0.9;
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:alphaAnimation forKey:nil];
    
    
    //内圈
    CAShapeLayer *circleShape2 = [CAShapeLayer layer];
    circleShape2.path = path.CGPath;
    circleShape2.position = shapePosition;
    circleShape2.fillColor = circleColor.CGColor;//
    circleShape2.opacity = 0;
    circleShape2.strokeColor = [UIColor clearColor].CGColor;
    circleShape2.lineWidth = 0;
    
    [view.superview.layer insertSublayer:circleShape2 atIndex:0];
    
    CABasicAnimation *scaleAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    scaleAnimation2.duration = 1;
    scaleAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circleShape2 addAnimation:scaleAnimation2 forKey:nil];
    
    CABasicAnimation *alphaAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation2.fromValue = @0.8;
    alphaAnimation2.toValue = @0;
    alphaAnimation2.duration = 0.8;
    alphaAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape2 addAnimation:alphaAnimation2 forKey:nil];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [circleShape removeFromSuperlayer];
        [circleShape2 removeFromSuperlayer];
    });

}

+ (UIColor *)colorWithDarkModelColor:(NSString *)color{
    return [self colorWithDarkModelColor:color andOpacity:1.0f];
}
+ (UIColor *)colorWithDarkModelColor:(NSString *)color andOpacity:(CGFloat)opacity {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //判断前缀
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    //从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R G B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle==UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:((float) (255.0-r) / 255.0f) green:((float) (255.0-g) / 255.0f) blue:((float) (255.0-b) / 255.0f) alpha:opacity];
            } else {
                return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:opacity];
            }
        }];
    } else {
        // Fallback on earlier versions
        return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:opacity];
    };
}
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexColor:color andOpacity:1.0f];
}
+ (UIColor *)colorWithHexColor:(NSString *)color andOpacity:(CGFloat)opacity {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    //判断前缀
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    //从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R G B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:opacity];
}
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr{
    if (string.length>0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionAnchorsMatchLines error:nil];
        NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        //match: 所有匹配到的字符,根据() 包含级
        NSMutableArray *array = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:1]];
            [array addObject:component];
        }
        return array;
    } else {
        return @[@""];
    }
}
+ (NSString *)getNumberFromDataStr:(NSString *)str{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

+ (void)addImageRotationWithView:(UIView *)view{
    [self addImageRotationWithView:view Count:MAXFLOAT];
}
+ (void)addImageRotationWithView:(UIView *)view Count:(float)count{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.rotation";
    anima.values = @[@(((-5) * M_PI / 180.0)),@(((5) * M_PI / 180.0)),@(((-5) * M_PI / 180.0))];
    anima.repeatCount = count;
    [view.layer addAnimation:anima forKey:@"doudong"];
}
+ (void)addImageScaleWithView:(UIView *)view{
    [self addImageScaleWithView:view repeatCount:MAXFLOAT];
}
+ (void)addImageScaleWithView:(UIView *)view repeatCount:(float)count{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.values = @[@(1.0),@(1.2),@(1.0),@(0.8),@(1.0)];
    anima.repeatCount = count;
    anima.duration = 1;
    [view.layer addAnimation:anima forKey:@"daxiao"];
}

+ (void)addImageScaleShowAnimationWithView:(UIView *)view Time:(NSInteger)time{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.values = @[@(0.0),@(1.0)];
    anima.repeatCount = 1;
    anima.duration = time;
    [view.layer addAnimation:anima forKey:@"daxiao"];
}
/**
 添加简单的弹框缓冲效果
 @param allView 动画View
 */
+ (void)animationWithAlertViewWithView:(UIView*)allView{
//    CAKeyframeAnimation * animation;
//    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.2;
//    animation.removedOnCompletion = YES;
//    animation.fillMode = kCAFillModeForwards;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [allView.layer addAnimation:animation forKey:nil];
    
    allView.alpha = 0.0f;
    allView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.35f animations:^{
        allView.alpha = 1.f;
        allView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    
//    allView.transform = CGAffineTransformScale(allView.transform,1.2,1.2);
//    [UIView animateWithDuration:0.3 animations:^{
//        allView.transform = CGAffineTransformIdentity;
//    }];
}
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor shadowRadius:(CGFloat)radius{
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = radius;
}
+ (void)addGradientLayerWithUIColors:(NSArray*)colors View:(UIView*)view {
    NSMutableArray *colorArray = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorArray addObject:(id)color.CGColor];
    }
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.colors = colorArray;
    for (CAGradientLayer *oldGLayer in view.layer.sublayers) {
        [oldGLayer removeFromSuperlayer];
    }
    [view.layer addSublayer:gradient];
}
+ (UIViewController *)getCurrentViewController
{
    UIViewController * vc = [SFNetTool getKeyWindow].rootViewController;
    
    if([vc isKindOfClass:[UITabBarController class]])
    {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if([vc isKindOfClass:[UINavigationController class]])
    {
        vc = [(UINavigationController *)vc visibleViewController];
    }
    return vc;
}
+ (UIWindow *)getKeyWindow{
    UIWindow* window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self topViewControllerWithVC:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self topViewControllerWithVC:resultVC.presentedViewController];
    }
    return resultVC;
}
+ (UIViewController *)topViewControllerWithVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerWithVC:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewControllerWithVC:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
+ (BOOL)isIPhoneXAbove{
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)isCanGetIdfa{
    NSString *idfa = [self getIDFA];
    return [idfa isEqualToString:@"00000000-0000-0000-0000-000000000000"];
}
- (void)ViewClickWithModel:(SFS2SModelAds *)adModel Width:(NSString *)widthStr Height:(NSString *)heightStr X:(NSString *)xStr Y:(NSString *)yStr Controller:(UIViewController *)controller{
    if (adModel==nil) {
        return;
    }
    
    // 1.跳转链接
    NSString *urlStr = adModel.landing_page;
    urlStr = [self replaceUrlWithUrl:urlStr Width:widthStr Height:heightStr X:xStr Y:yStr Controller:controller];
    //点击类型，1=下载app; 2=打开网页;3=唤起app;
    switch (adModel.ac_type) {
        case 1:
        {
            NSString *reStr = @"id(\\d+)";
            NSArray *strArr = [SFNetTool matchString:adModel.landing_page toRegexString:reStr];
            if (controller && strArr.count>0) {
                SKStoreProductViewController *skstore = [[SKStoreProductViewController alloc] init];
                skstore.delegate=self;
                [controller presentViewController:skstore animated:YES completion:^{
                    //最后加载应用数据（一定要记住这个数据要在视图出现以后去加载）
                    [skstore loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:[strArr firstObject]} completionBlock:^(BOOL result, NSError * _Nullable error) {
                        if (error) {
                            SFLog(@"%@",error);
                        }
                    }];
                }];
                
            } else {
                NSURL *url = [NSURL URLWithString:adModel.deeplink_url.sf_stringByEncodingUserInputQuery];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (success) {
                            SFLog(@"跳转成功");
                        } else {
                            SFCustomWebViewController *safariVC = [[SFCustomWebViewController alloc] initWithURL:[NSURL URLWithString:urlStr.sf_stringByEncodingUserInputQuery]];
                            safariVC.delegate = self;
                            [controller presentViewController:safariVC animated:YES completion:nil];
                        }
                    }];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
            break;
        case 2:
        {
            NSURL *url = [NSURL URLWithString:urlStr.sf_stringByEncodingUserInputQuery];
            SFCustomWebViewController *safariVC = [[SFCustomWebViewController alloc] initWithURL:url];
            safariVC.delegate = self;
            [controller presentViewController:safariVC animated:YES completion:nil];
        }
            break;
        case 3:
        {
            NSURL *url = [NSURL URLWithString:adModel.deeplink_url.sf_stringByEncodingUserInputQuery];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        SFLog(@"跳转成功");
                        
                        [SFNetwork groupNotifyToSerVer:adModel.dpsuccess_notice_urls];
                    } else {
                        SFCustomWebViewController *safariVC = [[SFCustomWebViewController alloc] initWithURL:[NSURL URLWithString:urlStr.sf_stringByEncodingUserInputQuery]];
                        safariVC.delegate = self;
                        [controller presentViewController:safariVC animated:YES completion:nil];
                    }
                }];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
            
        default:
            break;
    }
    // 2.上报服务器
    if (![[SFNetTool gettelModel] isEqualToString:@"iPhone Simulator"]) {
        // 上报服务器
        NSArray *viewS = adModel.click_notice_urls;
        if(viewS && ![viewS isKindOfClass:[NSNull class]] && viewS.count){
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (NSString *notiStr in viewS) {
                [tmpArr addObject:[self replaceUrlWithUrl:notiStr Width:widthStr Height:heightStr X:xStr Y:yStr Controller:controller]];
            }
            [SFNetwork groupNotifyToSerVer:tmpArr];
        }
    }
}
- (NSString *)replaceUrlWithUrl:(NSString *)notice_url Width:(NSString *)widthStr Height:(NSString *)heightStr X:(NSString *)x Y:(NSString *)y Controller:(UIViewController *)controller{
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__REQ_WIDTH__" withString:widthStr];
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__REQ_HEIGHT__" withString:heightStr];
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__WIDTH__" withString:widthStr];
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__HEIGHT__" withString:heightStr];
    
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__DOWN_X__" withString:x];
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__DOWN_Y__" withString:y];
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__UP_X__" withString:x];
    notice_url = [notice_url stringByReplacingOccurrencesOfString:@"__UP_Y__" withString:y];
    return notice_url;
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller API_AVAILABLE(ios(9.0)){
    [[NSNotificationCenter defaultCenter] postNotificationName:KeySFSafariDoneClick object:nil];
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //点击完成或是下载更新完成的回调，dismiss掉VC
    [viewController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KeySFSafariDoneClick object:nil];
}
+ (void)labelAddDelegateLineWithView:(UILabel *)label ShowStr:(NSString *)textStr{
    // 中线 NSStrikethroughStyleAttributeName
    // 下划线 NSUnderlineStyleAttributeName
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    // 赋值
    label.attributedText = attribtStr;
}
/**清除缓存和cookie*/
+ (void)cleanCacheAndCookie{
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        NSLog(@"缓存清理成功");
    }];
}
+ (NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
+ (UIColor *)shallowerWithColor:(UIColor *)color{
    CGFloat R,G,B;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    R = components[0];
    G = components[1];
    B = components[2];
    UIColor *newColor = [UIColor colorWithRed:R+0.1 green:G+0.1 blue:B+0.1 alpha:1.0];
    return newColor;
}

@end
