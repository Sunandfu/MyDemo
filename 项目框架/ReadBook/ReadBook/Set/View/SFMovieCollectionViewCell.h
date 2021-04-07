//
//  SFMovieCollectionViewCell.h
//  ReadBook
//
//  Created by lurich on 2020/10/13.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AceCuteView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFMovieCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *bookType;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;
@property (weak, nonatomic) IBOutlet AceCuteView *redView;

@end

NS_ASSUME_NONNULL_END
