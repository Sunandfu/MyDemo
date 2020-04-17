//
//  TaskActicityViewCell.h
//  TestAdA
//
//  Created by lurich on 2019/8/6.
//  Copyright © 2019 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskActicityViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *showCenterBackView;
@property (weak, nonatomic) IBOutlet UIImageView *activityBackImg;
@property (weak, nonatomic) IBOutlet UITableView *activityTable;

@end

NS_ASSUME_NONNULL_END
