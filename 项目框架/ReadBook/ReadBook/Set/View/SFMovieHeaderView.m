//
//  SFMovieHeaderView.m
//  ReadBook
//
//  Created by lurich on 2020/10/14.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMovieHeaderView.h"

@implementation SFMovieHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconViewImg.layer.masksToBounds = YES;
    self.iconViewImg.layer.cornerRadius = 5;
    self.iconViewImg.layer.borderColor = [UIColor blackColor].CGColor;
    self.iconViewImg.layer.borderWidth = 1.0;
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.cornerRadius = 5;
    self.scoreLabel.layer.masksToBounds = YES;
    self.scoreLabel.layer.cornerRadius = 5;
}

@end
