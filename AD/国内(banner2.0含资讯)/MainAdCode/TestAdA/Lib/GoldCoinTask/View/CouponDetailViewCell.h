//
//  CouponDetailViewCell.h
//  TestAdA
//
//  Created by lurich on 2019/8/12.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LeftBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RightBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiezhiLabel;

@end

NS_ASSUME_NONNULL_END
