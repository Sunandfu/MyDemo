//
//  UIImage+Categories.h
//  FiveStar
//
//  Created by Leon on 13-4-18.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Categories)

- (UIImage *)scaleToSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)compressWithRate:(CGFloat)rate;

@end
