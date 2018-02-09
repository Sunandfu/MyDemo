//
//  HomeViewController.m
//  自定义tabbar
//
//  Created by 小富 on 16/3/18.
//  Copyright © 2016年 SSF. All rights reserved.
//

#import "SSFTabBar.h"
#import "SSFTabBarButton.h"

@interface SSFTabBar ()

@property (nonatomic,weak) SSFTabBarButton *selectedButton;

@end

@implementation SSFTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
                   
    }
    return self;
}

- (void)addTabBarItem:(UITabBarItem *)item{
    //创建按钮
    SSFTabBarButton *button = [[SSFTabBarButton alloc] init];
    [self addSubview:button];
    //设置数据
    button.item = item;
    //监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    //默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
    
}
//监听按钮点击
- (void)buttonClick:(SSFTabBarButton *)button{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonW = self.frame.size.width / self.subviews.count;
    CGFloat buttonY = 0;
    for (int index=0; index<self.subviews.count; index++) {
        SSFTabBarButton *button = self.subviews[index];
        //设置按钮frame
        CGFloat buttonX = index * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //绑定tag
        button.tag = index;
    }
}

@end
