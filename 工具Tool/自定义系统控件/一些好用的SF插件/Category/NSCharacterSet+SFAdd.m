//
//  NSCharacterSet+SFAdd.m
//  SFAddKit
//
//  Created by SFAdd Team on 2018/9/17.
//

#import "NSCharacterSet+SFAdd.h"

@implementation NSCharacterSet (SFAdd)

+ (NSCharacterSet *)sf_URLUserInputQueryAllowedCharacterSet {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@"#&="];
    return set.copy;
}

@end
