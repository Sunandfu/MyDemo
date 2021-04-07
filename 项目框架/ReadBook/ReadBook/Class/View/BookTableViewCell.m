//
//  BookTableViewCell.m
//  ReadBook
//
//  Created by lurich on 2020/5/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "BookTableViewCell.h"

@implementation BookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bookType.layer.masksToBounds = YES;
    self.bookType.layer.cornerRadius = 3;
    self.bookType.layer.borderWidth = 1.0;
    self.bookType.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
