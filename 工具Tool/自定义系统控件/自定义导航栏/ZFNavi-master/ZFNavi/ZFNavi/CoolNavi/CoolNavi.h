//
//  CoolNavi.h
//  CoolNaviDemo
//
//  Created by 任子丰 on 15/1/19.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"

@interface CoolNavi : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *backImageView;
// image action
@property (nonatomic, copy) void(^imgActionBlock)();

- (id)initWithFrame:(CGRect)frame backGroudImage:(NSString *)backImageName headerImageURL:(NSString *)headerImageURL title:(NSString *)title subTitle:(NSString *)subTitle;

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;

@end
