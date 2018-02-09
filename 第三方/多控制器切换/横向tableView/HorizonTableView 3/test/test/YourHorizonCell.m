//
//  YourHorizonCell.m
//  test
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import "YourHorizonCell.h"

@implementation YourHorizonCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.cycleView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, self.width / 2, self.width / 2)];
    self.myLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.cycleView.bottom + 5, self.width - 10, 15)];
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    self.myLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.cycleView];
    [self addSubview:self.myLabel];
}

- (void)layoutSubviews{
    self.cycleView.top = 5;
    self.cycleView.left = 5;
    self.cycleView.width = self.width / 2;
    self.cycleView.height = self.width / 2;
    self.cycleView.layer.cornerRadius = self.cycleView.width / 2;
    self.cycleView.layer.masksToBounds = YES;
    self.myLabel.top = self.cycleView.bottom + 5;
    self.myLabel.left = 5;
    self.myLabel.width = self.width - 10;
}
@end
