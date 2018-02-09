//
//  NavigationBar.m
//  智能大棚
//
//  Created by 张春雨 on 16/8/15.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CustomNavigationBar.h"
#define SELF_H   self.bounds.size.height
#define SELF_W   self.bounds.size.width
#define SCREEN_W [[UIScreen mainScreen]bounds].size.width

@implementation CustomNavigationButton
+ (instancetype)initWithType:(NSInteger)type{
    CustomNavigationButton *btn = [[CustomNavigationButton alloc]init];
    btn.tag = type;
    btn.titleLabel.textAlignment = type == 0 ? NSTextAlignmentLeft : NSTextAlignmentRight;
    btn.titleLabel.font = [CYNavigationConfig shared].outherFont;
    
    [btn setTitleColor:[CYNavigationConfig shared].fontColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    UIColor *color = type ==0 ?[CYNavigationConfig shared].leftBtnImageColor : [CYNavigationConfig shared].rightBtnImageColor;
    btn.tintColor = color ? color : [CYNavigationConfig shared].fontColor;
    return btn;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    UIImage *img = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [super setImage:img forState:state];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = ({
        CGFloat imgViewWidth = self.imageView.image ? 20.f : 0.f;
        CGFloat x = self.tag ? self.bounds.size.width-imgViewWidth : 0;
        CGFloat y = self.bounds.size.height/2 - imgViewWidth/2;
        CGRectMake(x, y, imgViewWidth,imgViewWidth);
    });
    self.titleLabel.frame = ({
        CGFloat imgViewWidth = self.imageView.bounds.size.width;
        CGFloat width=self.bounds.size.width - imgViewWidth;
        CGFloat x = self.tag ? 0 : imgViewWidth;
        CGRectMake(x, 0, width, self.bounds.size.height);
    });
}
@end

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //Set backgroundColor color
        self.backgroundColor = [CYNavigationConfig shared].backgroundColor;
        if ([CYNavigationConfig shared].haveBorder) {
            self.border.fillColor = [CYNavigationConfig shared].bordergColor.CGColor;
        }
        //Observer Device Orientation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)OrientationDidChange{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [CYNavigationConfig shared].height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 15.0;
    _title.frame = CGRectMake((SCREEN_W - SCREEN_W/1.5)/2, (SELF_H-20)/2+10, SCREEN_W/1.5, 20);
    _leftBtn.frame = CGRectMake(y, (SELF_H-20)/2, 100, 40);
    _rightBtn.frame = CGRectMake(SCREEN_W-100-y, (SELF_H-20)/2, 100, 40);
    CGFloat height = [CYNavigationConfig shared].borderHeight;
    _border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0,SELF_H-height,SELF_W,height)].CGPath;
}

/**
 *  getter
 */
- (UILabel *)title{
    if (!_title) {
        UILabel *lab = [[UILabel alloc]init];
        lab.font = [CYNavigationConfig shared].titleFont;
        lab.textColor = [CYNavigationConfig shared].fontColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        _title = lab;
    }
    return _title;
}

- (CustomNavigationButton *)leftBtn{
    if (!_leftBtn) {
        CustomNavigationButton *btn = [CustomNavigationButton initWithType:0];
        [btn setImage: [CYNavigationConfig shared].defaultBackImage forState:UIControlStateNormal];
        [self addSubview:btn];
        _leftBtn = btn;
    }
    return _leftBtn;
}

- (CustomNavigationButton *)rightBtn{
    if (!_rightBtn) {
        CustomNavigationButton *btn = [CustomNavigationButton initWithType:1];
        [self addSubview:btn];
        _rightBtn = btn;
    }
    return _rightBtn;
}

- (CAShapeLayer *)border{
    if (!_border) {
        CAShapeLayer *border = [CAShapeLayer layer];
        [self.layer addSublayer:border];
        _border = border;
    }
    return _border;
}
- (void)customNavigationLabelColor:(UIColor *)color{
    [CYNavigationConfig shared].leftBtnImageColor = color;
    [self.rightBtn  setTitleColor:color forState:UIControlStateNormal];
    self.title.textColor = color;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
@end

