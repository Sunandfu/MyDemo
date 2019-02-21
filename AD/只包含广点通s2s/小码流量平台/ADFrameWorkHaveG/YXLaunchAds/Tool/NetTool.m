//
//  NetTool.m
//  xzmoblibs
//
//  Created by caiq on 2018/3/7.
//  Copyright © 2018年 M. All rights reserved.
//

#import "NetTool.h"
#import "YXReachability.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import "GuOpenUDID.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include "netdb.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "YXAdSDKManager.h"

@implementation NetTool
netType nettype = notReach;
NSString *_gulatitude;
NSString *_gulongitude;
+(NSString *) getrequestInfo:(NSString *)key
                       width:(NSString *)width
                      height:(NSString *)height
                       macID:(NSString *)macID
                         uid:(NSString*)uid
                     adCount:(NSInteger)adCount
{
    CGFloat c_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat c_h = [UIScreen mainScreen].bounds.size.height;
    // 1.2网络状态
    NSString *orientationStr;
    __block UIInterfaceOrientation  orientation ;
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
    });
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        orientationStr = @"2";
        //横屏
    }else{
        orientationStr = @"1";
        //竖屏
    }
    //
    [self getNetTyepe];
    int netNumber = nettype;//网络标示
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *cityCode = [YXAdSDKManager defaultManager].cityCode;
    
    [dic setValue:cityCode forKey:@""];
    
    [dic setValue:@"3.0" forKey:@"version"] ;
    [dic setValue:@"2" forKey:@"c_type"] ;
    
    NSString * adCountStr = [NSString stringWithFormat:@"%ld",adCount];
    [dic setValue:adCountStr forKey:@"adCount"];
    
    [dic setValue:key forKey:@"mid"];
    
    [dic setValue:uid forKey:@"uid"];
    
    [dic setValue:@"0" forKey:@"support_https"] ;
    [dic setValue:@"0" forKey:@"support_full_screen_interstitial"] ;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *adStr = [userDefault objectForKey:@"AD_ID"];
    if (adStr) {
        [dic setValue:adStr forKey: @"last_ad_ids"];
    }
    
    [dic setValue:@"IOS" forKey:@"os"];
    [dic setValue:[self getMac] forKey:@"mac"];
    [dic setValue:[self getOS] forKey:@"osv"];
    [dic setValue:[NSString stringWithFormat:@"%d",netNumber] forKey:@"networktype"];
    
    [dic setValue:macID forKey:@"remoteip"];
    
    //    NSLog(@"MAc地址------------%@", macID);
    [dic setValue:@"apple" forKey: @"make"];
    [dic setValue:@"apple" forKey:@"brand"];
    [dic setValue:[self gettelModel] forKey:@"model"];
    [dic setValue:@"1" forKey:@"devicetype"];
    
    [dic setValue:[self getIDFA] forKey:@"idfa"];
    
    [dic setValue:[self getDPI] forKey:@"dpi"];
    
    
    [dic setValue:[NSString stringWithFormat:@"%.f",c_w] forKey:@"width"];
    [dic setValue:[NSString stringWithFormat:@"%.f",c_h] forKey:@"height"];
    [dic setValue:[self getPackageName] forKey:@"appid"];
    [dic setValue:app_Name forKey:@"appname"];
    
    //    [dic setValue:@"1" forKey:@"geo_type"];
    //    [dic setValue:[self getlatitude] forKey:@"geo_latitude"];
    //    [dic setValue:[self getlongitude] forKey:@"geo_longitude"];
    [dic setValue:orientationStr forKey:@"orientation"];
    
    [dic setValue:@{ @"width": width,@"height": height } forKey:@"image"];
    
    [dic setValue:@"4" forKey:@"postion"];
    
    [dic setValue:@"" forKey:@"imei"];
    
    [dic setValue:@"" forKey:@"imsi"];
    
    [dic setValue:@"" forKey:@"androidid"];
    
    NSString *yun = [self getYunYingShang];
    
    if ([yun isEqualToString:@"中国电信"]) {
        [dic setValue:@"2" forKey:@"operator"];
    }else if ([yun isEqualToString:@"中国移动"]) {
        [dic setValue:@"1" forKey:@"operator"];
    }else if ([yun isEqualToString:@"中国联通"]) {
        [dic setValue:@"3" forKey:@"operator"];
    }else if ([yun isEqualToString:@"无运营商"]) {
        [dic setValue:@"0" forKey:@"operator"];
    }else{
        [dic setValue:@"4" forKey:@"operator"];
    }
    
    //    NSJSONSerialization 组json字符串
    NSData * postDatas = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:postDatas encoding:NSUTF8StringEncoding];
    NSString *innitStr = str ;
    return innitStr;
}


+(NSString *)deviceWANIPAdress{
    
    //    NSLog(@"开始请求MAc地址------------%@", [NSThread currentThread]);
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *ipAddress = [dict objectForKey:@"cip"];
        return ipAddress;
        
    }
    return nil;
}


+(NSString *)iphonePlatform{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

//获取网络类型
+(netType) getNetTyepe
{
    YXReachability *ablity = [YXReachability YXReachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus currentStatus = ablity.currentYXReachabilityStatus;
    
    if (currentStatus == NotReachable) {
        // 没有网络的更多操作
        // 实现类似接到电话效果   self.window.frame = CGRectMake(0, 40, __width, __height-40);
        nettype = notReach;
    } else if (currentStatus == ReachableViaWiFi) {
        nettype = wifi;
        //         NSLog(@"Wifi");
    } else {
        nettype = WWAN;
        //          NSLog(@"3G/4G/5G");
    }
    
    [self setNetType:nettype];
    return nettype;
}


+(void)setNetType:(netType)type
{
    nettype = type;
}

//获取idfa
+(NSString *)getIDFA
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
        return @"";
        
    }else{
        NSString *adId =[[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString];
        return adId ;
    }
}

//OpenUDID zzz uid
+ (NSString *)getOpenUDID
{
    NSString *openUDIDStr = [NSUUID UUID].UUIDString;
    //    NSString *openUDIDStr = [GuOpenUDID value];
    
    return openUDIDStr;
}


//获取mac地址
//Mac地址
+ (NSString *)getMac
{
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
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        free(buf);
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
    
}

//系统版本
+ (NSString *)getOS
{
    NSString *os  = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@",os];
}
//设备型号
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}
//网络类型
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
    
    //    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    //    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    //    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    //
    //    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    //    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    //    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    //    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    //
    //    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    //    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    //
    //    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    //    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    //
    //    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    //    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    //
    //    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    //    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    //
    //    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    //    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    //    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    //    if ([platform isEqualToString:@"iPhone9,1"]||[platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    //    if ([platform isEqualToString:@"iPhone9,2"]||[platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    //    if ([platform isEqualToString:@"iPhone10,1"]||[platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    //    if ([platform isEqualToString:@"iPhone10,2"]||[platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    //    if ([platform isEqualToString:@"iPhone10,3"]||[platform isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    //
    //    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    //    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    //    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    //    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    //
    //    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    //    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    //    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    //    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    //    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    //    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    //    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    //    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    //    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    //    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    //    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    //    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    //    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    //    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    //    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    //    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    //    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    //    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    //    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    //    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    //    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    //    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    //    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    //    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    //    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    //    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    //    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    //    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    //    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    //    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    //    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    //    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    //    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    //    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5 inch (WiFi)";
    //    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5 inch (Cellular)";
    //
    //    if ([platform isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    //    if ([platform isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    //    if ([platform isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    //    if ([platform isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    //
    //    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    //    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
+ (NSString*)getDPI
{
    if (CGSizeEqualToSize(CGSizeMake(320, 480), [UIScreen mainScreen].bounds.size)) {
        return @"163";
    }else if (CGSizeEqualToSize(CGSizeMake(320, 568), [UIScreen mainScreen].bounds.size)){
        return @"326";
    }else if (CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size)){
        return @"326";
    }else if (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)){
        return @"401";
    }else if (CGSizeEqualToSize(CGSizeMake(375, 812), [UIScreen mainScreen].bounds.size)){
        return @"458";
    }else{
        return @"163";
    }
}

+(NSString*)getlatitude{
    if (!_gulatitude) {
        return @"";
    }
    return _gulatitude;
}
+(NSString*)getlongitude{
    if (!_gulongitude) {
        return @"";
    }
    return _gulongitude;
}

+(void)setlatitude :(NSString*)info{
    
    _gulatitude = info;
    
}

+(void)setlongitude :(NSString*)info{
    
    _gulongitude = info;
    
}


//应用包名
+(NSString *)getPackageName
{
    NSString *packageName = [[NSBundle mainBundle] bundleIdentifier];
    return packageName;
}


+ (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteYXReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteYXReachability, &flags);
    CFRelease(defaultRouteYXReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network YXReachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // BOOL isEDGE = flags & kSCNetworkYXReachabilityFlagsIsWWAN;
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (NSString*)getYunYingShang
{
    //获取本机运营商名称
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        //        NSLog(@"没有SIM卡");
        mobile = @"无运营商";
        
    }else{
        mobile = [carrier carrierName];
        
    }
    return mobile;
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
+ (NSString *)getNowDateStr_2
{
    NSDateFormatter * recordDateFormatter = [NSDateFormatter new];
    recordDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [recordDateFormatter stringFromDate:[NSDate date]];
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
/** * URLEncode */
+ (NSString *)URLEncodedString:(NSString*)str {
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    NSString *unencodedString = str;
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     kCFAllocatorDefault, (CFStringRef)unencodedString,                                              NULL,                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
    
}
+ (UIViewController *)getCurrentViewController
{
    UIViewController * vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    
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
+ (void)setImage:(UIImageView*)imageView WithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    NSURLSession *shareSessin = [NSURLSession sharedSession];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [shareSessin dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    }];
    [dataTask resume];
}
// 判断View是否显示在屏幕上
+ (BOOL)isInScreenView:(UIView*)view
{
    if (self == nil) {
        
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
@end
