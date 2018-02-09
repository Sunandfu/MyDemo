//
//  NSString+LM.m
//  FiveStar
//
//  Created by ryan on 13-2-27.
//
//

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

+ (NSString *)stringFromPrice:(float)price {
    return [NSString stringWithFormat:@"%.0f", price];
}

+ (NSString *)documentPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

//+(NSString*)createFilePathUnderDocument:(NSString*)fileName{
//	return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
//}

- (BOOL)containsString:(NSString *)string {
    if (string == nil) return NO;

    NSRange aRange = [self rangeOfString:string];
    if (aRange.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}


// the reverse of url encoding
+ (NSString *)stringByURLDecodingString:(NSString *)escapedString {
#if 0
    return [[escapedString stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#else
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
            (CFStringRef) escapedString,
            CFSTR(""),
            kCFStringEncodingUTF8));
    return result;
#endif
}

+ (NSString *)stringByURLEncodingString:(NSString *)unescapedString {
    NSString *result = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (CFStringRef) unescapedString,
            NULL, // characters to leave unescaped
            (CFStringRef) @":!*();@/&?#[]+$,='%’\"",
            kCFStringEncodingUTF8));
    return result;
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (unsigned int)strlen(cstr), result);

    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isBlank {
    return [[self trim] isEqualToString:@""];
}


- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size minimumFontSize:(CGFloat)minimumFontSize {
    CGFloat fontSize = [font pointSize];
    CGFloat height = [self boundingRectWithSize:CGSizeMake(size.width, FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    UIFont *newFont = font;
    //Reduce font size while too large, break if no height (empty string)
    while (height > size.height && height != 0 && fontSize > minimumFontSize) {
        fontSize--;
        newFont = [UIFont fontWithName:font.fontName size:fontSize];
        height = [self boundingRectWithSize:CGSizeMake(size.width, FLT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : newFont} context:nil].size.height;
    };
    // Loop through words in string and resize to fit
    for (NSString *word in [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
        CGFloat width = [word sizeWithAttributes:@{NSFontAttributeName : newFont}].width;
        while (width > size.width && width != 0 && fontSize > minimumFontSize) {
            fontSize--;
            newFont = [UIFont fontWithName:font.fontName size:fontSize];
            width = [word sizeWithAttributes:@{NSFontAttributeName : newFont}].width;
        }
    }
    return fontSize;
}
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
@end