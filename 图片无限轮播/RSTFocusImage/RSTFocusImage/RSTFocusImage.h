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


@end
