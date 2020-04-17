//
//  TaskActicityViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/8/6.
//  Copyright © 2019 YX. All rights reserved.
//

#import "TaskActicityViewCell.h"

@implementation TaskActicityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.activityBackImg.layer.masksToBounds = YES;
//    self.activityBackImg.layer.cornerRadius = 5;
    self.activityBackImg.image = [UIImage imageNamed:@"XibAndPng.bundle/tableViewBackImg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
