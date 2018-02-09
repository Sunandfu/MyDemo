//
//  ListTableViewCell.h
//  HRVApp201601
//
//  Created by 小富 on 16/4/12.
//  Copyright © 2016年 betterlife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *osVersion;
@property (weak, nonatomic) IBOutlet UILabel *ecgPath;
@property (weak, nonatomic) IBOutlet UILabel *checktime;

@end
