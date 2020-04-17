//
//  WXMiniAppViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/8/8.
//  Copyright © 2019 YX. All rights reserved.
//

#import "WXMiniAppViewCell.h"

@implementation WXMiniAppViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
    [self.priceBtn setImage:[UIImage imageNamed:@"XibAndPng.bundle/goDoneNor"] forState:UIControlStateNormal];
    [self.priceBtn setImage:[UIImage imageNamed:@"XibAndPng.bundle/goDoneSel"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
