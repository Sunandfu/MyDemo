//
//  NSString+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Category)
/**
 *  根据文字返回当前文字的size
 *
 *  @param fontSize 字体
 *  @param maxSize  允许的最大size
 *
 *  @return 当前文字实际size
 */
- (CGSize)stringSizeWithFontSzie:(CGFloat)fontSize maxSize:(CGSize)maxSize;
/**
 *  去除字符串前后的空格
 */
- (NSString *)stringByTrim;

@end
