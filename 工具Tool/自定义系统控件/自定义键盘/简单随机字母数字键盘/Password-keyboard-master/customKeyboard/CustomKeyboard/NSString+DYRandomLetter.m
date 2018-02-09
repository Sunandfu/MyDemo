//
//  NSString+DYRandomLetter.m
//  theCustomKeyboard
//
//  Created by 大勇 on 15/4/13.
//  Copyright © 2016年 wangyong. All rights reserved.
//

#import "NSString+DYRandomLetter.h"

static NSString *letterString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

//static NSString *fu = @"][.,?)(|}{*&^%$#@￥!~:+_-=;@/`\";
@implementation NSString (DYRandomLetter)

+ (NSString *)sentletterString {

    NSString *letter = letterString;
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [letter length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [letter getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSInteger j = (arc4random_uniform(numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:numberOfCharacters];
    free(characters);

    return result;
}
+ (NSString *)DYRandomLetterLowercase:(BOOL)islowercaseString {

    NSString *letter = [self sentletterString];
    
    if (islowercaseString) { // yes 小写
       
         NSString *str = [[letter lowercaseString] substringToIndex:1];
        return str;
    }else{// no 大写
      
        NSString *str =  [letter substringToIndex:1];
        return str;
    }
  
}

+ (NSMutableArray *)DYRandomAllLetterLowercase:(BOOL)islowercaseString {

    NSMutableArray *arr = [NSMutableArray array];
    NSString *letter = nil;
  
    if (islowercaseString) { // yes 小写
        letter =  [[self sentletterString] lowercaseString];
    }else{// no 大写
        letter =  [self sentletterString];
        
    }
    for (int i = 0; i < [letter length]; i++) {
        
        NSString *str = [letter substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:str];
    }

    return arr;

}

@end
