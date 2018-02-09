//
//  Color+Hex.h
//  
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *) colorWithHex:(uint) hex;

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com