//
//  HomeViewController.m
//  自定义tabbar
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 SSF. All rights reserved.
//

#define ImageRatio 0.6
#import "SSFTabBarButton.h"

@implementation SSFTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        //文字居中  设置文字颜色
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:RedColor forState:UIControlStateSelected];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted{
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * ImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleY = contentRect.size.height * ImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}
- (void)setItem:(UITabBarItem *)item{
    
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
}
@end
