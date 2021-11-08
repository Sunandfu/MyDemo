//
//  NSDate+SFAdd.m
//  TestAdA
//
//  Created by lurich on 2021/4/12.
//  Copyright © 2021 . All rights reserved.
//

#import "NSDate+SFAdd.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSDate (SFAdded)
- (NSString *)sf_yyyy_MM_dd_HH_mm_ss {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return [dateFormatter stringFromDate:self];
}
- (NSString *)sf_yyyy_MM_dd_HH_mm {
    return [self.sf_yyyy_MM_dd_HH_mm_ss substringToIndex:16];
}
- (NSString *)sf_yyyy_MM_dd {
    return [self.sf_yyyy_MM_dd_HH_mm_ss substringToIndex:10];
}
- (NSString *)sf_HH_mm_ss {
    return [self.sf_yyyy_MM_dd_HH_mm_ss substringFromIndex:11];
}
- (NSString *)sf_yyyy {
    return [self.sf_yyyy_MM_dd substringToIndex:4];
}
- (NSString *)sf_MM {
    return [self.sf_yyyy_MM_dd substringWithRange:NSMakeRange(5, 2)];
}
- (NSString *)sf_dd {
    return [self.sf_yyyy_MM_dd substringWithRange:NSMakeRange(8, 2)];
}
- (NSString *)sf_HH {
    return [self.sf_HH_mm_ss substringWithRange:NSMakeRange(0, 2)];
}
- (NSString *)sf_mm {
    return [self.sf_HH_mm_ss substringWithRange:NSMakeRange(3, 2)];
}
- (NSString *)sf_ss {
    return [self.sf_HH_mm_ss substringWithRange:NSMakeRange(6, 2)];
}
@end
NS_ASSUME_NONNULL_END
