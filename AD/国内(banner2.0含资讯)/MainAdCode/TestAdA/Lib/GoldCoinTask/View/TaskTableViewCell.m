//
//  TaskTableViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/8/6.
//  Copyright © 2019 YX. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.jinbiIconImage.image = [UIImage imageNamed:@"XibAndPng.bundle/jinbi"];
    [self.goDoneBtn setImage:[UIImage imageNamed:@"XibAndPng.bundle/goDoneNor"] forState:UIControlStateNormal];
    [self.goDoneBtn setImage:[UIImage imageNamed:@"XibAndPng.bundle/goDoneSel"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
