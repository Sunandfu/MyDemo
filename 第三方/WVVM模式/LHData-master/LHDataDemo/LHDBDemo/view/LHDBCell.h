//
//  LHDBCell.h
//  LHDataDemo
//
//  Created by 3wchina01 on 16/4/7.
//  Copyright © 2016年 3wchina01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHDBCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end
