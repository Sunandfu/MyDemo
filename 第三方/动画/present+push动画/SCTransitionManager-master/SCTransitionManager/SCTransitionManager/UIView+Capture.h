//
//  UIView+Capture.h
//  SCTransitionManager
//
//  Created by sichenwang on 16/2/9.
//  Copyright © 2016年 sichenwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Capture)

- (UIImage *)capture;
- (UIView *)captureView;
- (UIImage *)captureLayer;

@end
