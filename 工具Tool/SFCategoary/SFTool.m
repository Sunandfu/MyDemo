//
//  SFTool.m
//  45678
//
//  Created by 小富 on 16/3/31.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "SFTool.h"
#import <sys/sysctl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AVFoundation/AVFoundation.h>

@implementation SFTool
UIWebView *phoneCallWebView;
+(void)call:(NSString*)phoneNo
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNo]];
    
    //[[UIApplication rsk_sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNo]]];
    
    if (phoneURL) {
        if (!phoneCallWebView) {
            phoneCallWebView =[[UIWebView alloc] initWithFrame:CGRectZero];
        }
        //    = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }
}

/*
 打开一个网址
 @param  inUrl http://www.iteye.com/blogs/tag/iOS
 */
+ (void)openUrl:(NSString *)inUrl{
#ifndef TARGET_IS_EXTENSION
    if ([inUrl hasPrefix:@"http://"]) {
        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", inUrl]];
        [[UIApplication sharedApplication] openURL:cleanURL];
    }else{
        NSString *textURL = [NSString stringWithFormat:@"http://%@",inUrl];
        NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
        [[UIApplication sharedApplication] openURL:cleanURL];
    }
#endif
}


/**
 程序中播放一段简短的音乐
 @param  fName  @"MusicName"
 @param  ext  @"wav"@"mp3"。。
 */
+(void)playSound:(NSString *)fName type:(NSString *)ext
{
    
    NSString *path  = [[NSBundle mainBundle] pathForResource: fName ofType :ext];
    SystemSoundID audioEffect;
    if ([[NSFileManager defaultManager] fileExistsAtPath : path])
    {
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        // [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        AudioServicesPlaySystemSound(audioEffect);
    }else
    {
        NSLog(@"error, file not found: %@", path);
    }
}
//判断是否大于某个版本号
+ (BOOL)DeviceorLaterIsSystemVersion:(double)number;
{
    return ( [[UIDevice currentDevice].systemVersion doubleValue] > number);
}
+ (BOOL)DeviceIsIpone6orLater
{
    CGSize size =  [[UIScreen mainScreen] currentMode].size ;
    CGFloat width = size.width;
    return ( width <= 375);
    
    
}
+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSUInteger)buttons done:(void (^)())act{
    
    //创建一个新窗口，用于显示警告框
    UIApplication * application = [UIApplication sharedApplication];
    UIWindow * oldWindow = application.keyWindow;
    UIWindow *window = [[UIWindow alloc] initWithFrame:oldWindow.bounds];
    window.backgroundColor = [UIColor clearColor];//窗口的背景颜色
    
    //实例化一个控制器，用于弹出警告框
    UIViewController * controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor clearColor];
    window.rootViewController = controller;
    
    
    //实例化警告框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //确定按钮
    UIAlertAction * okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(act){
            act();
        }
        
        [oldWindow makeKeyAndVisible];
    }];
    [alertController addAction:okButton];
    
    //如果是两个按钮，则增加一个取消按钮
    if (buttons==2) {
        UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelButton];
    }
    
    //显示新增窗口
    [window makeKeyAndVisible];
    
    //弹出警告框
    [controller presentViewController:alertController animated:YES completion:nil];
    
}

+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSUInteger)buttons inController:(UIViewController*)controller done:(void (^)())act{
    
    
    //实例化警告框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //确定按钮
    UIAlertAction * okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(act){
            act();
        }
        
    }];
    [alertController addAction:okButton];
    
    //如果是两个按钮，则增加一个取消按钮
    if (buttons==2) {
        UIAlertAction * cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelButton];
    }
    
    //弹出警告框
    [controller presentViewController:alertController animated:YES completion:nil];
}


+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSArray<NSString *>*)buttons done:(void (^)())agree cancel:(void (^)())disagree{
    //创建一个新窗口，用于显示警告框
    UIApplication * application = [UIApplication sharedApplication];
    UIWindow * oldWindow = application.keyWindow;
    UIWindow *window = [[UIWindow alloc] initWithFrame:oldWindow.bounds];
    window.backgroundColor = [UIColor clearColor];//窗口的背景颜色
    
    //实例化一个控制器，用于弹出警告框
    UIViewController * controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor clearColor];
    window.rootViewController = controller;
    
    //实例化警告框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (buttons.count<2) {
        buttons = @[@"取消",@"确定"];
    }
    //第一个按钮
    UIAlertAction * btn1 = [UIAlertAction actionWithTitle:buttons[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(agree){
            agree();
            [oldWindow makeKeyAndVisible];
        }
    }];
    [alertController addAction:btn1];
    
    //第一个按钮
    UIAlertAction * btn2 = [UIAlertAction actionWithTitle:buttons[1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(disagree){
            disagree();
            [oldWindow makeKeyAndVisible];
        }
    }];
    [alertController addAction:btn2];
    
    //显示新增窗口
    [window makeKeyAndVisible];
    
    //弹出警告框
    [controller presentViewController:alertController animated:YES completion:nil];
    
}

+ (CATransition *)transitWithProperties:(NSDictionary *)propertites
{
    __autoreleasing CATransition *transition = [CATransition animation];
    NSString *type = propertites[@"type"];
    transition.type = type ? type:@"fade";
    
    NSString *subType = propertites[@"subType"];
    transition.subtype = subType ? subType : kCATransitionFromRight ;
    NSString *duration = propertites[@"duration"];
    transition.duration = duration ? [duration floatValue]:1.0;
    
    NSString *timimgFountion = propertites[@"timimgFountion"];
    CAMediaTimingFunction *tf = nil;
    if(timimgFountion)
    {
        tf = [CAMediaTimingFunction functionWithName:timimgFountion];
    }
    transition.timingFunction = tf ? tf :UIViewAnimationCurveEaseInOut;
    
    NSString *fillMode = propertites[@"fileMode"];
    transition.fillMode = fillMode ? fillMode : @"removed";
    
    return transition ;
}


+ (CGFloat)dynamicHeightWithString:(NSString *)string width:(CGFloat)width attribute:(NSDictionary *)attrs
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil];
    return rect.size.height;
}

+ (void)layerCornerRadius:(CALayer *)dest radius:(float)radius width:(float)width color:(UIColor *)color
{
    dest.cornerRadius = radius;
    dest.borderWidth = width;
    dest.borderColor = color.CGColor;
    dest.masksToBounds = YES;
}
#pragma mark------正则表达式常用验证-----------------
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))|(177)\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name rule:(NSString*)rule
{
    NSString *userNameRegex;
    
    //默认规则用户名由大小写26个英文字母和数组组成，长度6-20位
    if (!rule) {
        userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    }
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord  rule:(NSString*)rule
{
    NSString *passWordRegex;
    if (!rule) {//默认验证规则由大小写26个英文字母和数组组成，长度6-20位
        passWordRegex= @"^[a-zA-Z0-9]{6,20}+$";
    }
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    __autoreleasing NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
//设置多于的分割线  该方法在创建完tableView完之后再调用
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:view];
}
//获取当前的设备
+ (NSString *)getCurrentDeviceModel{
    
    static NSString *retVal = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 请查阅 https://www.theiphonewiki.com/wiki/Models 更新设备号
        
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *devStr = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        // iPhone
        if      ([self devStr:devStr equalTo:@[@"iPhone1,1"]])
            retVal = @"iPhone";
        else if ([self devStr:devStr equalTo:@[@"iPhone1,2"]])
            retVal = @"iPhone 3G";
        else if ([self devStr:devStr equalTo:@[@"iPhone2,1"]])
            retVal = @"iPhone 3GS";
        else if ([self devStr:devStr equalTo:@[@"iPhone3,1", @"iPhone3,2", @"iPhone3,3"]])
            retVal = @"iPhone 4";
        else if ([self devStr:devStr equalTo:@[@"iPhone4,1"]])
            retVal = @"iPhone 4S";
        else if ([self devStr:devStr equalTo:@[@"iPhone5,1", @"iPhone5,2"]])
            retVal = @"iPhone 5";
        else if ([self devStr:devStr equalTo:@[@"iPhone5,3", @"iPhone5,4"]])
            retVal = @"iPhone 5c";
        else if ([self devStr:devStr equalTo:@[@"iPhone6,1", @"iPhone6,2"]])
            retVal = @"iPhone 5s";
        else if ([self devStr:devStr equalTo:@[@"iPhone7,2"]])
            retVal = @"iPhone 6";
        else if ([self devStr:devStr equalTo:@[@"iPhone7,1"]])
            retVal = @"iPhone 6 Plus";
        else if ([self devStr:devStr equalTo:@[@"iPhone8,1"]])
            retVal = @"iPhone 6s";
        else if ([self devStr:devStr equalTo:@[@"iPhone8,2"]])
            retVal = @"iPhone 6s Plus";
        else if ([self devStr:devStr equalTo:@[@"iPhone8,4"]])
            retVal = @"iPhone SE";
        else if ([self devStr:devStr equalTo:@[@"iPhone9,1", @"iPhone9,3"]])
            retVal = @"iPhone 7";
        else if ([self devStr:devStr equalTo:@[@"iPhone9,2", @"iPhone9,4"]])
            retVal = @"iPhone 7 Plus";
        else if ([self devStr:devStr equalTo:@[@"iPhone10,1", @"iPhone10,4"]])
            retVal = @"iPhone 8";
        else if ([self devStr:devStr equalTo:@[@"iPhone10,2", @"iPhone10,5"]])
            retVal = @"iPhone 8 Plus";
        else if ([self devStr:devStr equalTo:@[@"iPhone10,3", @"iPhone10,6"]])
            retVal = @"iPhone X";
        else if ([self devStr:devStr equalTo:@[@"iPhone11,8"]])
            retVal = @"iPhone XR";
        else if ([self devStr:devStr equalTo:@[@"iPhone11,2"]])
            retVal = @"iPhone XS";
        else if ([self devStr:devStr equalTo:@[@"iPhone11,6"]])
            retVal = @"iPhone XS Max";
        
        // iPod
        else if ([self devStr:devStr equalTo:@[@"iPod1,1"]])
            retVal = @"iPod touch";
        else if ([self devStr:devStr equalTo:@[@"iPod2,1"]])
            retVal = @"iPod touch (2nd generation)";
        else if ([self devStr:devStr equalTo:@[@"iPod3,1"]])
            retVal = @"iPod touch (3rd generation)";
        else if ([self devStr:devStr equalTo:@[@"iPod4,1"]])
            retVal = @"iPod touch (4th generation)";
        else if ([self devStr:devStr equalTo:@[@"iPod5,1"]])
            retVal = @"iPod touch (5th generation)";
        else if ([self devStr:devStr equalTo:@[@"iPod7,1"]])
            retVal = @"iPod touch (6th generation)";
        
        // iPad
        else if ([self devStr:devStr equalTo:@[@"iPad1,1"]])
            retVal = @"iPad";
        else if ([self devStr:devStr equalTo:@[@"iPad2,1", @"iPad2,2", @"iPad2,3", @"iPad2,4"]])
            retVal = @"iPad 2";
        else if ([self devStr:devStr equalTo:@[@"iPad3,1", @"iPad3,2", @"iPad3,3"]])
            retVal = @"iPad (3rd generation)";
        else if ([self devStr:devStr equalTo:@[@"iPad3,4", @"iPad3,5", @"iPad3,6"]])
            retVal = @"iPad (4th generation)";
        else if ([self devStr:devStr equalTo:@[@"iPad4,1", @"iPad4,2", @"iPad4,3"]])
            retVal = @"iPad Air";
        else if ([self devStr:devStr equalTo:@[@"iPad5,3", @"iPad5,4"]])
            retVal = @"iPad Air 2";
        else if ([self devStr:devStr equalTo:@[@"iPad6,7", @"iPad6,8"]])
            retVal = @"iPad Pro (12.9-inch)";
        else if ([self devStr:devStr equalTo:@[@"iPad6,3", @"iPad6,4"]])
            retVal = @"iPad Pro (9.7-inch)";
        else if ([self devStr:devStr equalTo:@[@"iPad6,11", @"iPad6,12"]])
            retVal = @"iPad (5th generation)";
        else if ([self devStr:devStr equalTo:@[@"iPad7,1", @"iPad7,2"]])
            retVal = @"iPad Pro (12.9-inch, 2nd generation)";
        else if ([self devStr:devStr equalTo:@[@"iPad7,3", @"iPad7,4"]])
            retVal = @"iPad Pro (10.5-inch)";
        else if ([self devStr:devStr equalTo:@[@"iPad7,5", @"iPad7,6"]])
            retVal = @"iPad (6th generation)";
        else if ([self devStr:devStr equalTo:@[@"iPad8,1", @"iPad8,2", @"iPad8,3", @"iPad8,4"]])
            retVal = @"iPad Pro (11-inch)";
        else if ([self devStr:devStr equalTo:@[@"iPad8,5", @"iPad8,6", @"iPad8,7", @"iPad8,8"]])
            retVal = @"iPad Pro (12.9-inch) (3rd generation)";
        else if ([self devStr:devStr equalTo:@[@"iPad7,5", @"iPad7,6"]])
            retVal = @"iPad (6th generation)";
        
        // iPad mini
        else if ([self devStr:devStr equalTo:@[@"iPad2,5", @"iPad2,6", @"iPad2,7"]])
            retVal = @"iPad mini";
        else if ([self devStr:devStr equalTo:@[@"iPad4,4", @"iPad4,5", @"iPad4,6"]])
            retVal = @"iPad mini 2";
        else if ([self devStr:devStr equalTo:@[@"iPad4,7", @"iPad4,8", @"iPad4,9"]])
            retVal = @"iPad mini 3";
        else if ([self devStr:devStr equalTo:@[@"iPad5,1", @"iPad5,2"]])
            retVal = @"iPad mini 4";
        
        // HomePod
        else if ([self devStr:devStr equalTo:@[@"AudioAccessory1,1", @"AudioAccessory1,2"]])
            retVal = @"HomePod";
        
        // AirPods
        else if ([self devStr:devStr equalTo:@[@"AirPods1,1"]])
            retVal = @"AirPods";
        
        // Apple Watch
        else if ([self devStr:devStr equalTo:@[@"Watch1,1", @"Watch1,2"]])
            retVal = @"Apple Watch (1st generation)";
        else if ([self devStr:devStr equalTo:@[@"Watch2,6", @"Watch2,7"]])
            retVal = @"Apple Watch Series 1";
        else if ([self devStr:devStr equalTo:@[@"Watch2,3", @"Watch2,4"]])
            retVal = @"Apple Watch Series 2";
        else if ([self devStr:devStr equalTo:@[@"Watch3,1", @"Watch3,2", @"Watch3,3", @"Watch3,4"]])
            retVal = @"Apple Watch Series 3";
        
        // Apple TV
        else if ([self devStr:devStr equalTo:@[@"AppleTV2,1"]])
            retVal = @"Apple TV (2nd generation)";
        else if ([self devStr:devStr equalTo:@[@"AppleTV3,1", @"AppleTV3,2"]])
            retVal = @"Apple TV (3rd generation)";
        else if ([self devStr:devStr equalTo:@[@"AppleTV5,3"]])
            retVal = @"Apple TV (4th generation)";
        else if ([self devStr:devStr equalTo:@[@"AppleTV6,2"]])
            retVal = @"Apple TV 4K";
        
        // Simulator
        else if ([self devStr:devStr equalTo:@[@"i386", @"x86_64"]])
            retVal = @"Simulator";
        
        // New device.
        else retVal = devStr;
    });
    
    return retVal;
}
+ (BOOL)devStr:(NSString *)devStr equalTo:(NSArray <NSString *> *)array {
    
    __block BOOL equal = NO;
    
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([devStr isEqualToString:obj]) {
            
            equal = YES;
            *stop = YES;
        }
    }];
    
    return equal;
}
//获取运营商
+ (NSString *)getcarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}
+ (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = nil;
    int netType = 0;    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    state = @"无网络";//无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"WIFI";
                    break;
                default:
                    state = @"网络搜索中";
                    break;
            }
        }
    }    //根据状态选择
    return state;
}
//通过字符串的长度来设置label的高度
+(CGFloat)setLabelHeightWithString:(NSString *)str label:(UILabel *)label{
    
    NSDictionary *attributes = @{NSFontAttributeName:label.font};
    CGSize size = [str boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
    CGFloat x=label.frame.origin.x;
    CGFloat y=label.frame.origin.y;
    CGFloat width=label.frame.size.width;
    
    [label setFrame:CGRectMake(x, y, width, size.height)];
    label.text=str;
    return label.bounds.size.height;
}
/*手机号码验证 MODIFIED BY HELENSONG(正则表达式)*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))|(177)\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
+(BOOL)isMobileNumber:(NSString *)mobileNum

{
    
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,186,183
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189,177
     
     */
    
    NSString * MOBILE = @"^1(3[0-9]5[0-35-9]8[025-9]8[0-9]77)\\d{8}$";
    
    /**
     
     10         * 中国移动：China Mobile
     
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     12         */
    
    NSString * CM = @"^1(34[0-8](3[5-9]5[017-9]8[278])\\d)\\d{7}$";
    
    /**
     
     15         * 中国联通：China Unicom
     
     16         * 130,131,132,152,155,156,185,186
     
     17         */
    
    NSString * CU = @"^1(3[0-2]5[256]8[56])\\d{8}$";
    /**
     
     20         * 中国电信：China Telecom
     
     21         * 133,1349,153,180,189,177
     
     22         */
    NSString * CT = @"^1(349(33538[09]77)\\d)\\d{7}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)||
        
        ([regextestcm evaluateWithObject:mobileNum] == YES)||
        
        ([regextestcu evaluateWithObject:mobileNum] == YES)||
        
        ([regextestct evaluateWithObject:mobileNum] == YES))
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
    
}
//判断密码6-16位
+(BOOL)validatePassword:(NSString *)password{
    
    NSString *Regex = @"^[a-zA-Z0-9]{5,16}$";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    return [emailTest evaluateWithObject:password];
}

//获取当前的北京时间
+(NSString *)getBeijingNowTime{
    //获取当前的UTC时间  并将其转换为北京时间
    NSDate *UTCNow=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *BeiJingTime=[dateFormatter stringFromDate:UTCNow];
    return BeiJingTime;
}
//转化为当前的时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
+ (NSDate *)dateWithString:(NSString *)dateString{//字符串时间转日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSDate *dateTime = [formatter dateFromString:dateString];
    return dateTime;
}
+ (NSString *)stringWithDate:(NSDate *)date{//日期转字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
#pragma mark 正则匹配手机号

+ (BOOL)validateMobileNumber:(NSString *)string
{
    static NSString *tempStr = @"^((\\+86)?|\\(\\+86\\))0?1[34578]\\d{9}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)validatePostCodeNumber:(NSString *)string
{
    static NSString *tempStr = @"^[1-9]\\d{5}$";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:tempStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)isEmpty:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (str == nil || [str length] == 0) {
        return YES;
    } else {
        return NO;
    }
}
+ (void)callAndBack:(NSString *)phoneNum {
    //    NSString *phoneNum = @"10086";// 电话号码
    
    //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    //NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phoneNum];
    
    //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
}


//是否是纯数字
+ (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"(/^[0-9]*$/)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
    
}
//姓名验证
+ (BOOL)checkUserName:(NSString *)userName{
    //不能含有数字标点
    NSString *regex=@"^[A-Za-z /\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:userName]) {
        return NO;
    }
    
    // 不能字母+汉字
    NSString *regex1 = @"^(([A-Za-z]+)[\u4e00-\u9fa5]+)$";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    if ([predicate1 evaluateWithObject:userName]) {
        return NO;
    }
    return YES;
    
}
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)getRandomColor
{
    return [UIColor colorWithRed:(float)(1+arc4random()%99)/100 green:(float)(1+arc4random()%99)/100 blue:(float)(1+arc4random()%99)/100 alpha:1];
}
+(UIImage*) generateQRCode:(NSString*)text size:(CGFloat)size{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [text dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return [SFTool createNonInterpolatedUIImageFormCIImage:qrFilter.outputImage withSize:size];
}


//将CGImage转换成UIImage
+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+(UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

//- (BOOL)isHeadphone {
//    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
//    for (AVAudioSessionPortDescription* desc in [route outputs]) {
//        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
//            return YES;
//    }
//    return NO;
//}

+ (UIButton *)createButtonWithTitle:(NSString *)title
                              frame:(CGRect)frame
                             target:(id)target
                           selector:(SEL)selector
                              color:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    //    button.layer.cornerRadius = 15.f;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //    button.backgroundColor = [UIColor colorWithRed:0.3 green:0.8f blue:1.f alpha:1.f];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target Selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame {
    return [self createLabelWithTitle:title frame:frame fontSize:14.f];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color {
    return [self createLabelWithTitle:title frame:frame textColor:color fontSize:14.f];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame fontSize:(CGFloat)size {
    return [self createLabelWithTitle:title frame:frame textColor:[UIColor blackColor] fontSize:size];
}

+ (UILabel *)createLabelWithTitle:(NSString *)title frame:(CGRect)frame textColor:(UIColor *)color fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}

+ (UIView *)createViewWithBackgroundColor:(UIColor *)color frame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UITextField *)createViewWithText:(NSString *)text frame:(CGRect)frame placeholder:(NSString *)placeholder textColor:(UIColor *)color borderStyle:(UITextBorderStyle)borderStyle {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.borderStyle = borderStyle;
    textField.text = text;
    textField.textColor = color;
    return textField;
}
//把图片按照新大小进行裁剪，生成一个新图片
+ (UIImage*) imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *) sourceImage
{
    //    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    //UIGraphicsBeginImageContext(targetSize); // this will crop
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 2.0);  //防止剪切后的图片 不变模糊
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

//把图片做等比缩放，生成一个新图片
+ (UIImage *) imageByScalingProportionallyToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage {
    
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
    UIImage *newImage = nil;
    //    CGSize imageSize = sourceImage.size;
    //    CGFloat width = imageSize.width;
    //    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    //    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  汉语转拼音
 */
+ (NSString *)getPinYinFromString:(NSString *)string{
    CFMutableStringRef aCstring = CFStringCreateMutableCopy(NULL, 0, (__bridge_retained CFStringRef)string);
    
    /**
     *  创建可变CFString
     *
     *  @param NULL 使用默认创建器
     *  @param 0    长度不限制
     *  @param "张三" cf字串
     *
     *  @return 可变字符串
     */
    
    /**
     1. string: 要转换的字符串(可变的)
     2. range: 要转换的范围 NULL全转换
     3. transform: 指定要怎样的转换
     4. reverse: 是否可逆的转换
     */
    CFStringTransform(aCstring, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform(aCstring, NULL, kCFStringTransformStripDiacritics, NO);
    
    
    NSLog(@"%@",aCstring);
    
    return [NSString stringWithFormat:@"%@",aCstring];
}
+ (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
//颜色转字符串
+ (NSString *) hexFromUIColor: (UIColor*) color
{
    if (CGColorGetNumberOfComponents(color.CGColor) < 4)
    {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB)
    {
        return [NSString stringWithFormat:@"FFFFFF"];
    }
    
    int r =(int)((CGColorGetComponents(color.CGColor))[0]*255.0);
    int g =(int)((CGColorGetComponents(color.CGColor))[1]*255.0);
    int b =(int)((CGColorGetComponents(color.CGColor))[2]*255.0);
    
    
    return [NSString stringWithFormat:@"%@%@%@",[self tenToHexNum:r],[self tenToHexNum:g],[self tenToHexNum:b]];
}
@end
