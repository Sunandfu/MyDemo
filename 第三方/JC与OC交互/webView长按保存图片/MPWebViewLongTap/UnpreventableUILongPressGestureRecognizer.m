//
//  UnpreventableUILongPressGestureRecognizer.m
//  MPWebViewLongTap
//
//  Created by Plum on 16/4/26.
//  Copyright © 2016年 ManPao. All rights reserved.
//

#import "UnpreventableUILongPressGestureRecognizer.h"

@implementation UnpreventableUILongPressGestureRecognizer
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
         return NO;
}
@end
