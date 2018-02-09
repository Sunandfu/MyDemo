//
//  Color+Hex.m
//

#import "Color+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *) colorWithHex:(uint) hex
{
	int red, green, blue, alpha;
	
	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);
	alpha = ((hex & 0xFF000000) >> 24);
	
	return [UIColor colorWithRed:red/255.0f 
						   green:green/255.0f 
							blue:blue/255.0f 
						   alpha:alpha/255.f];
}

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    if (stringToConvert == nil) {
        return [UIColor redColor];
    }
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com