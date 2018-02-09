//
//  MANaviAnnotationView.m
//  OfficialDemo3D
//
//  
//  Copyright (c) 2015年 . All rights reserved.
//

#import "MANaviAnnotationView.h"

#define naviButtonWidth 44
#define naviButtonHeight 74

@implementation NaviButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return self;
    }
    [self commonInit];
    return self;
}

- (void)commonInit
{
    //蓝色背景
    [self setBackgroundImage:[UIImage imageNamed:@"naviBackgroundNormal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"naviBackgroundHighlighted"] forState:UIControlStateSelected];
    
    //imageView 小车
    _carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi"]];
    [self addSubview:_carImageView];
    
    //label 文字
    _naviLabel = [[UILabel alloc] init];
    _naviLabel.text = @"导航";
    _naviLabel.font = [_naviLabel.font fontWithSize:9];
    _naviLabel.textColor = [UIColor whiteColor];
    //得到最适合当前字数的尺寸
    [_naviLabel sizeToFit];
    
    [self addSubview:_naviLabel];
}

#define kMarginRatio 0.1
- (void)layoutSubviews
{
    [super layoutSubviews];
    //图片中心点  按钮x中心点,中心点y(图片高*(0.5+0.1))
    _carImageView.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.superview.frame) - CGRectGetHeight(_carImageView.frame) * (0.5 + kMarginRatio));
    //文字中心点
    _naviLabel.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.superview.frame) + CGRectGetHeight(_naviLabel.frame) * (0.5 + kMarginRatio));
}

@end

@implementation MANaviAnnotationView

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //创建按钮  44 74
        NaviButton *naviButton = [[NaviButton alloc] initWithFrame:(CGRectMake(0, 0, naviButtonWidth, naviButtonHeight))];
        // 显示在气泡左侧的view
        self.leftCalloutAccessoryView = naviButton;
    }
    return self;
}

@end


