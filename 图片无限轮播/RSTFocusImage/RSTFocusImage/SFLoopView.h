//
//  LoopView.h
//  LoopView
//
//  Created by Lurich on 15/3/30.
//  Copyright (c) 2015年 ssf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFLoopView;
@protocol SFLoopViewDelegate <NSObject>
@optional
- (void)loopViewDidSelectedImage:(SFLoopView *)loopView index:(int)index;
@end

@interface SFLoopView : UIView
@property (nonatomic, weak) id<SFLoopViewDelegate> delegate;
@property (nonatomic, assign) BOOL autoPlay;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval;
@end
/*
 *****************示例代码**********************
 1.遵守代理SFLoopViewDelegate
 2.添加以下代码
 NSArray *images = @[@"zoro.jpg",@"three.jpg",@"onepiece.jpg"];
 SFLoopView *loopView = [[SFLoopView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/1.8) images:images autoPlay:YES delay:10.0];
 loopView.delegate = self;
 [self.view addSubview:loopView];
 3.实现代理方法
 - (void)loopViewDidSelectedImage:(SFLoopView *)loopView index:(int)index{
 NSLog(@"点击了：%d",index);
 }
 */