//
//  MyHorizonRefreshView.m
//  test
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import "MyHorizonRefreshView.h"
#import "UIView+Utils.h"

@interface MyHorizonRefreshView()
@property (nonatomic, strong) UIActivityIndicatorView *myIndic;
@property (nonatomic, strong) UILabel *myLabel;
@end

@implementation MyHorizonRefreshView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.myIndic = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.myIndic.centerX = self.width / 2;
        self.myIndic.centerY = self.height / 2 - self.myIndic.height;
        self.myIndic.color = [UIColor colorWithRed:1 green:0.3 blue:0.4 alpha:1];
        [self addSubview:self.myIndic];
        
        self.myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.myIndic.bottom + 5, self.width, 15)];
        self.myLabel.textColor = [UIColor colorWithRed:1 green:0.3 blue:0.4 alpha:1];
        self.myLabel.font = [UIFont systemFontOfSize:12];
        self.myLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.myLabel];
    }
    return self;
}
// 拉动左右边到底的时候显示的
- (void)readyForRefresh:(MSPadHorizonView *)horizonView{
    if (self.isLeft) {
        self.myLabel.text = @"放开刷新列表";
    }else {
        self.myLabel.text = @"放开加载更多";
    }
}
// 到达
- (void)hasRefresh:(MSPadHorizonView *)horizonView{
    self.myLabel.text = self.isLeft ? @"正在加载中..." : @"刷新列表中...";
    [self.myIndic startAnimating];
}

- (void)endRefresh:(MSPadHorizonView *)horizonView{
    self.myLabel.text = self.isLeft ? @"正在预览" : @"欢迎使用";
    if (self.myIndic.isAnimating) {
        [self.myIndic stopAnimating];
    }
}
@end
