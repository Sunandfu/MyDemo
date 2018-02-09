//
//  ZFButton.h
//  ZFButton
//
//  Created by renzifeng on 15/8/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTFONT [UIFont systemFontOfSize:15.0f]

typedef enum : NSUInteger {
    ZFMarkAlignmentNone = 0,
    ZFMarkAlignmentLeft,
    ZFMarkAlignmentRight,
} ZFMarkAlignment;

@interface ZFButton : UIView

@property (nonatomic,strong) UILabel* titleLabel;
@property (nonatomic,strong) UIImageView* markImgView;

@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) UIImage* markImg;
@property (nonatomic,strong) UIImage* backgroundImage;
@property (nonatomic,assign) ZFMarkAlignment markAlignment; // 默认 ZFMarkAlignmentRight

- (void)settitleColor:(UIColor*)color;

@end
