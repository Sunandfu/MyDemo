//
//  Factory.m
//  StopWatchDemo
//
//  Created by Hailong.wang on 15/7/28.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "Factory.h"
#import <sys/sysctl.h>
@implementation Factory
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
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    
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
    return label.height;
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







