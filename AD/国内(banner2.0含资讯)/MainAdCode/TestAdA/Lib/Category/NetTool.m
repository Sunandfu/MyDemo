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
#import <SystemConfiguration/SystemConfiguration.h>
#include "netdb.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+SFAES.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "GDTSDKConfig.h"

@implementation NetTool

+ (NSString *)getTimeLocal{//毫秒级
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    return timeLocal;
}
+ (NSString *)sdkVersion{//广点通版本号
    NSLog(@"当前SDK版本号：%@-%@",[GDTSDKConfig sdkVersion],SDKVersionKey);
    return [GDTSDKConfig sdkVersion];
}
+(NSString *)getDeviceIPAdress{
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
        NSString *ipAddress = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cip"]];
        return ipAddress;
        
    }
    return @"";
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
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    //--------------------ipad-------------------------
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
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
    netType nettype = notReach;
    YXReachability *ablity = [YXReachability YXReachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus currentStatus = ablity.currentYXReachabilityStatus; 
    
    if (currentStatus == NotReachable) {
          // 没有网络的更多操作
 // 实现类似接到电话效果   self.window.frame = CGRectMake(0, 40, __width, __height-40);
        nettype = notReach;
    } else if (currentStatus == ReachableViaWiFi) {
        nettype = wifi;
//         NSLog(@"Wifi");
      } else if (currentStatus == kReachableViaWWAN) {
          CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
          if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
//              NSLog(@"2G");
              nettype = net2G;
          } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] || [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
//              NSLog(@"3G");
              nettype = net3G;
          } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
//              NSLog(@"4G");
              nettype = net4G;
          } else {
              nettype = WWAN;
          }
      } else {
          nettype = unknown;
      }
    return nettype;
}

//获取idfa
+(NSString *)getIDFA{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
        return @"";
    }else{
        NSUUID *UUID = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        NSString *adId = [NSString stringWithFormat:@"%@",UUID.UUIDString];
        return adId ;
    }
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
    return uuid;
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
    NSString *unencodedString = str;
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)unencodedString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}
//cityCode
+ (NSString *)getCityCode
{
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:KeyADSDKCityCode];
    return cityCode?cityCode:@"";
}
//系统版本
+ (NSString *)getOS
{
    NSString *os  = [[UIDevice currentDevice] systemVersion];
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
+(NSString *)getPackageName
{
    NSString *packageName = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] bundleIdentifier]];
    return packageName;
}
+ (NSString *)getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name?app_Name:@"";
}
//判断是否连接网络
+ (BOOL) connectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteYXReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteYXReachability, &flags);
    CFRelease(defaultRouteYXReachability);
    if (!didRetrieveFlags){
        printf("Error. Could not recover network YXReachability flags\n");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    // BOOL isEDGE = flags & kSCNetworkYXReachabilityFlagsIsWWAN;
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (NSInteger)getYunYingShang{
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
    if ([mobile isEqualToString:@"中国电信"]) {
        return 2;
    }else if ([mobile isEqualToString:@"中国移动"]) {
        return 1;
    }else if ([mobile isEqualToString:@"中国联通"]) {
        return 3;
    }else if ([mobile isEqualToString:@"无运营商"]) {
        return 0;
    }else{
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
+ (NSString *)getNowDateStr
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
+ (void)setImage:(UIImageView*)imageView WithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder {
    imageView.image = placeholder;
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
            NSLog(@"error:%@",error);
        }];
    }
}
+ (NSString *)cachePathWithMD5:(NSString *)md5{
    NSString *paths = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Image"];
    [self imgFileDataLocationSettingWithPath:paths];
    NSString *pathStr=[NSString stringWithFormat:@"%@/%@",paths,md5];
    //    NSLog(@"沙盒路径：%@",pathStr);
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
    const char *original_str = [urlStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    return hash;
}
+ (void)downloadImageWithUrl:(NSString *)urlStr Finish:(downloadFinish)finish Failure:(downloadFailure)failure{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //            NSLog(@"data:%@ response :%@",data,response);
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
    [[SDImageCache sharedImageCache] clearMemory];
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
/**
 获取url的所有参数
 
 @param urlStr 需要提取参数的url
 @return NSDictionary
 */
+ (NSMutableDictionary *)parseURLParametersWithURLStr:(NSString *)urlStr {
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
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *errorMessage = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSLog(@"errorMessage = %@", errorMessage);
    /*
     @try {
     [self requestADSource];
     } @catch (NSException *exception) {
     [NetTool uncaughtExceptionHandler:exception];
     } @finally {
     NSLog(@"开屏广告出现错误了");
     }
     */
}

@end
