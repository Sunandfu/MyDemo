//
//  SFBookSetTableViewCell.h
//  ReadBook
//
//  Created by lurich on 2020/5/26.
//  Copyright © 2020 lurich. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBookSetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (nonatomic, copy  ) void(^switchValueChanged)(BOOL off);

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (nonatomic, copy  ) void(^sliderValueChanged)(CGFloat value);
@property (weak, nonatomic) IBOutlet UILabel *typeDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;



@end

NS_ASSUME_NONNULL_END
