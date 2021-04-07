//
//  SFMovieCollectionViewCell.m
//  ReadBook
//
//  Created by lurich on 2020/10/13.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFMovieCollectionViewCell.h"

@implementation SFMovieCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.layer.cornerRadius = 5;
    self.iconImgView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.iconImgView.layer.borderWidth = 1.0;
    self.bookType.layer.masksToBounds = YES;
    self.bookType.layer.cornerRadius = 5;
}

@end
