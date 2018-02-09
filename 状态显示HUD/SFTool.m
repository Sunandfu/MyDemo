//
//  SFTool.m
//  45678
//
//  Created by 小富 on 16/3/31.
//  Copyright © 2016年 yunxiang. All rights reserved.
//

#import "SFTool.h"
#import <sys/sysctl.h>

@implementation SFTool

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
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
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
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S";
    
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
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G ";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G ";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G ";
    
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3 ";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3 ";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3 ";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4 WiFi  ";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4 WiFi+Cellular ";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air2 ";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air2 ";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro WiFi ";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro WiFi+Cellular";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
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
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
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

@end
