//
//  CopyiPhoneFadeView.m
//  渐变的文字
//
//  Created by 周少文 on 15/10/27.
//  Copyright © 2015年 ZheJiangWangHang. All rights reserved.
//

#import "CopyiPhoneFadeView.h"

@interface CopyiPhoneFadeView ()

@property (nonatomic,strong) UILabel *backLabel;
@property (nonatomic,strong) UILabel *frontLabel;


@end

@implementation CopyiPhoneFadeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createLabel];
        [self createMask];
    }
    return self;
}

- (void)createLabel
{
    _backLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_backLabel];
    _frontLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_frontLabel];
}

- (void)createMask
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor redColor].CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.25),@(0.5),@(0.75)];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    _frontLabel.layer.mask = layer;
    
    layer.position = CGPointMake(-self.bounds.size.width/4.0, self.bounds.size.height/2.0);
    
}

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(self.bounds.size.width+self.bounds.size.width/2.0);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = LONG_MAX;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_frontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    _backLabel.textColor = backColor;
    
}

- (void)setForeColor:(UIColor *)foreColor
{
    _foreColor = foreColor;
    _frontLabel.textColor = foreColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _backLabel.font = font;
    _frontLabel.font = font;
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    _alignment = alignment;
    _backLabel.textAlignment = alignment;
    _frontLabel.textAlignment = alignment;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _backLabel.text = text;
    _frontLabel.text = text;
}


@end
