//
//  UIImage+Helper.h
//  ptcommon
//
//  Created by 李超 on 16/6/8.
//  Copyright © 2016年 PTGX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
- (UIImage*)imageAtRect:(CGRect)rect;

- (UIImage*)fixOrientation;
@end
