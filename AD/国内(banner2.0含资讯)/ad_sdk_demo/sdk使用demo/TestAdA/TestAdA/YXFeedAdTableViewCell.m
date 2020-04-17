//
//  YXFeedAdTableViewCell.m
//  LunchAd
//
//  Created by shuai on 2018/10/23.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXFeedAdTableViewCell.h"
@implementation YXFeedAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}  
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:self.costomView];
}

@end
