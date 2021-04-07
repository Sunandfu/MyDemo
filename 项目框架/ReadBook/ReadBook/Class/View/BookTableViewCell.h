//
//  BookTableViewCell.h
//  ReadBook
//
//  Created by lurich on 2020/5/19.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AceCuteView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookType;
@property (weak, nonatomic) IBOutlet AceCuteView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeWidth;

@end

NS_ASSUME_NONNULL_END
