//
//  UIView+Capture.m
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/9.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import "UIView+Capture.h"

@implementation UIView (Capture)

- (UIView *)captureView {
    if ([self isKindOfClass:[UIImageView class]]) {
        return [[UIImageView alloc] initWithImage:[(UIImageView*)self image]];
    }
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        return [self snapshotViewAfterScreenUpdates:NO];
    }
    return [[UIImageView alloc] initWithImage:[self capture]];
}

- (UIImage *)capture {
    return [self captureWithLimitHeight:-1];
}

- (UIImage *)captureLayer {
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [[UIScreen mainScreen] scale]);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)captureWithLimitHeight:(CGFloat)limitHeight {
    
    CGRect bounds = limitHeight > 0 ? CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, limitHeight):self.bounds;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [[UIScreen mainScreen] scale]);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
