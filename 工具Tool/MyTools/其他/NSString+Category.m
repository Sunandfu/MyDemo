//
//  NSString+Category.m
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
/**
 *  根据文字返回当前文字的size
 *
 *  @param fontSize 字体
 *  @param maxSize  允许的最大size
 *
 *  @return 当前文字实际size
 */
- (CGSize)stringSizeWithFontSzie:(CGFloat)fontSize maxSize:(CGSize)maxSize
{
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
}
- (NSString *)stringByTrim {
//    特殊的符号集合,
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}


@end
