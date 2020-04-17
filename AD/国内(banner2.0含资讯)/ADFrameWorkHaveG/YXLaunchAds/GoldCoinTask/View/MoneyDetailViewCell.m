//
//  MoneyDetailViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import "MoneyDetailViewCell.h"

@implementation MoneyDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.jinbiIconImage.image = [UIImage imageNamed:@"XibAndPng.bundle/jinbi"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
