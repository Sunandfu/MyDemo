//
//  CouponDetailViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import "CouponDetailViewCell.h"

@implementation CouponDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.LeftBackImageView.image = [UIImage imageNamed:@"XibAndPng.bundle/yhjLeft"];
    self.RightBackImageView.image = [UIImage imageNamed:@"XibAndPng.bundle/yhjRight"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
