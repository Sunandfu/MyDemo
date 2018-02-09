//
//  MyHorizonCell.m
//  test
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import "MyHorizonCell.h"

@implementation MyHorizonCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.myLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.width - 10, 15)];
    self.yourLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.myLabel.bottom + 5, self.width - 10, 15)];
    
    self.myLabel.font = self.yourLabel.font = [UIFont systemFontOfSize:12];
    self.myLabel.textAlignment = self.yourLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.myLabel];
    [self addSubview:self.yourLabel];
}

- (void)layoutSubviews{
    self.yourLabel.left = self.myLabel.left = 5;
    self.yourLabel.width = self.myLabel.width = self.width - 10;
}

@end
