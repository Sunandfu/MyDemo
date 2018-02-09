//
//  WMLoopView.h
//  WMLoopView
//
//  Created by Mark on 15/3/30.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMLoopView;
@protocol WMLoopViewDelegate <NSObject>
@optional
- (void)loopViewDidSelectedImage:(WMLoopView *)loopView index:(int)index;
@end

@interface WMLoopView : UIView
@property (nonatomic, weak) id<WMLoopViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com