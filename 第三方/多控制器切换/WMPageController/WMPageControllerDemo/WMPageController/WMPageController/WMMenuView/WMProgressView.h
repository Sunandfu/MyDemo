//
//  WMProgressView.h
//  WMPageController
//
//  Created by Mark on 15/6/20.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMProgressView : UIView
@property (nonatomic, strong) NSArray *itemFrames;
@property (nonatomic, assign) CGColorRef color;
@property (nonatomic, assign) CGFloat progress;

- (void)setProgressWithOutAnimate:(CGFloat)progress;
- (void)moveToPostion:(NSInteger)pos;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com