//
//  RSTFocusImage.h
//  RSTFocusImage
//
//  Created by rong on 16/4/28.
//  Copyright © 2016年 rong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSTFocusImageDelegate <NSObject>

- (void)tapFocusWithIndex:(NSInteger)index;

@end

typedef void(^downloadFinish)(UIImage *image,NSInteger index);
typedef void(^downloadFailure)(NSError *error);

@interface RSTFocusImage : UIView

@property (assign, nonatomic) NSInteger interval;  //范围建议：大于或等于1s
@property (assign, nonatomic) BOOL showPageControl;
@property (weak, nonatomic) id <RSTFocusImageDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images Placeholder:(UIImage *)placeholder;
/*
 NSArray *images = @[
 @"http://img1.3lian.com/img013/v4/96/d/50.jpg",
 @"http://img15.3lian.com/2015/f2/15/d/142.jpg",
 @"http://img2.3lian.com/2014/f4/143/d/103.jpg",];
 RSTFocusImage *focus = [[RSTFocusImage alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200.0) Images:images Placeholder:[UIImage imageNamed:@"123"]];
 [self.view addSubview:focus];
 */

@end
