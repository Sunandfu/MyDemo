//
//  NSObjectSafe.h
//  UsefulCategory
//  GitHub地址: https://github.com/LuochuanAD/UsefulCategory
//  Created by care on 2018/4/3.
//  Copyright © 2018年 luochuan. All rights reserved.
//


/**
 * Warn: NSObjectSafe must used in MRC, otherwise it will cause 
 * strange release error: [UIKeyboardLayoutStar release]: message sent to deallocated instance
 */

#import <UIKit/UIKit.h>

//! Project version number for NSObjectSafe.
FOUNDATION_EXPORT double NSObjectSafeVersionNumber;

//! Project version string for NSObjectSafe.
FOUNDATION_EXPORT const unsigned char NSObjectSafeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <NSObjectSafe/PublicHeader.h>

@interface NSObject(Swizzle)

+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector;
- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector;
@end

