//
//  UIWebView+MJExtension.h
//  MJRefresh
//
//  Created by 齐志坚 on 14-9-26.
//  Copyright (c) 2014年 QiZhijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (MJExtension)

@property (assign, nonatomic) CGFloat mj_x;
@property (assign, nonatomic) CGFloat mj_y;
@property (assign, nonatomic) CGFloat mj_width;
@property (assign, nonatomic) CGFloat mj_height;
@property (assign, nonatomic) CGSize mj_size;
@property (assign, nonatomic) CGPoint mj_origin;

@end
