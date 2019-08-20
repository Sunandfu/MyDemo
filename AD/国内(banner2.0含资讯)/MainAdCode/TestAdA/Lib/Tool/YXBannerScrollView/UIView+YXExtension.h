//
//  UIView+YXExtension.h
//  YXRefreshView
//
//  Created by dudongge on 2018/12/26.
//  Copyright © 2018 dudongge. All rights reserved.
//


#import <UIKit/UIKit.h>

#define YXColorCreater(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]


@interface UIView (YXExtension)

@property (nonatomic, assign) CGFloat YX_height;
@property (nonatomic, assign) CGFloat YX_width;

@property (nonatomic, assign) CGFloat YX_y;
@property (nonatomic, assign) CGFloat YX_x;

@end
