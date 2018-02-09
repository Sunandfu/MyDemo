//
//  NSString+DYRandomLetter.h
//  theCustomKeyboard
//
//  Created by 大勇 on 15/4/13.
//  Copyright © 2016年 wangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DYRandomLetter)

/**
 *  返回单个随机大小字母 如果yes是小写 反之大写
 *
 *  @param islowercaseString  如果yes是小写 反之大写
 *
 *  @return 返回大小写字母字符串
 */
+ (NSString *)DYRandomLetterLowercase:(BOOL)islowercaseString;


/**
 *  返回26字母全部随机   大小字母 如果yes是小写 反之大写
 *
 *  @param islowercaseString  如果yes是小写 反之大写
 *
 *  @return 返回大小写字母字数组
 */
+ (NSMutableArray *)DYRandomAllLetterLowercase:(BOOL)islowercaseString;

@end
