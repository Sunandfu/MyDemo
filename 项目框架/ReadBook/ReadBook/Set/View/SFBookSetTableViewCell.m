//
//  SFBookSetTableViewCell.m
//  ReadBook
//
//  Created by lurich on 2020/5/26.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBookSetTableViewCell.h"

@implementation SFBookSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchValueChange:(UISwitch *)sender {
    if (self.switchValueChanged) {
        self.switchValueChanged(sender.isOn);
    }
}
- (IBAction)sliderValueChange:(UISlider *)sender {
    if (self.sliderValueChanged) {
        self.sliderValueChanged(sender.value);
    }
}

@end
