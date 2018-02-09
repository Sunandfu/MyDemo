//
//  NSString+additional.m
//  daShu
//
//  Created by 史岁富 on 15/11/3.
//  Copyright © 2015年 史岁富. All rights reserved.
//

#import "NSString+additional.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (additional)
+ (BOOL)isMeetStandard:(NSString *)passwordString{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passwordString];
}
- (NSString *)md5{
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (unsigned int)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
- (NSAttributedString *)selfFont:(int)sfont
                      selfColor:(UIColor *)selfColor
                      LightText:(NSString *)text
                      LightFont:(int)lfont
                     LightColor:(UIColor *)lightColor
{
    NSString *temp = self;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:temp];
    if ([text isKindOfClass:[NSNull class]] || text == nil) {
        return attributeStr;
    }
    NSRange range = [self rangeOfString:text];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sfont] range:NSMakeRange(0,self.length)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName value:selfColor range:NSMakeRange(0,self.length)];
    
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:lfont] range:NSMakeRange(range.location,range.length)];
    
    [attributeStr addAttribute:NSForegroundColorAttributeName value:lightColor range:NSMakeRange(range.location,range.length)];
    
    
    
    
    
    return attributeStr;
}
- (NSString*)trim1
{
    
    return [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (NSString *)getDateTime:(NSString *)TimeInterval{
    NSDate *  senddate = [NSDate dateWithTimeIntervalSince1970:[TimeInterval doubleValue]/1000];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
+ (NSString *)getDate1:(NSString *)TimeInterval{
    NSDate *  senddate = [NSDate dateWithTimeIntervalSince1970:[TimeInterval doubleValue]/1000];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
// 得到当前时间
+ (NSString *)stringWithGetCurrentTime{
    
    NSDate * senddate=[NSDate date];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];

    return locationString;
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
        
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
- (BOOL)isContainsSubStr:(NSString *)subStr{
    NSRange rang = [self rangeOfString:subStr];
    if (rang.location == NSNotFound) {
        return NO;
    }else{
        return YES;
    }
}
+ (CGFloat)heightForText:(NSString *)text withWidth:(CGFloat)width WithFont:(CGFloat)font

{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size.height;
    
}
+ (CGFloat)widthForText:(NSString *)text withWheight:(CGFloat)height WithFont:(CGFloat)font

{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size.width;
    
}
@end
