//
//  NSString+LM.h
//  FiveStar
//
//  Created by ryan on 13-2-27.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)stringFromPrice:(float)price;

+ (NSString *)documentPath;

+ (NSString *)stringByURLDecodingString:(NSString *)escapedString;

+ (NSString *)stringByURLEncodingString:(NSString *)unescapedString;

- (BOOL)containsString:(NSString *)string;

- (NSString *)MD5String;

- (NSString *)trim;

- (BOOL)isBlank;

- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size minimumFontSize:(CGFloat)minimumFontSize;
-(BOOL)isChinese;

@end
