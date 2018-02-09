//
//  NSNumber+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Category)
/**
 * 从字符串创建一个NSNumber对象,有可能是nil
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (NSNumber *)numberWithString:(NSString *)string;
@end
