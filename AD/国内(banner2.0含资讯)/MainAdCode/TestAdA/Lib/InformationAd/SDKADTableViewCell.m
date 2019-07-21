//
//  SDKADTableViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/6/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import "SDKADTableViewCell.h"
#import "NetTool.h"
#import "UIView+SFFrame.h"
#import "YXFeedAdData.h"

@interface SDKADTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *SDKcontentLabel;
@property (weak, nonatomic) IBOutlet UILabel *SDKfromLabel;
@property (weak, nonatomic) IBOutlet UILabel *SDKtimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SDKadImg;
@property (weak, nonatomic) IBOutlet UIImageView *SDKbigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *SDKzhidingImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SDKzhidingWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SDKleftZhidWidth;

@end

@implementation SDKADTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.SDKadImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_adFlag"];
    self.SDKzhidingImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
}
- (void)cellDataWithFeedAdModel:(YXFeedAdData *)model{
    self.SDKzhidingWidth.constant = 0;
    self.SDKleftZhidWidth.constant = 0;
    self.SDKadImg.hidden = YES;
    if (model==nil) {
        //        self.contentLabel.text = @"";
        //        self.fromLabel.text = @"";
        //        self.timeLabel.text = @"";
        //        self.imageViewOne.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"];
    } else {
        NSString *content = [NSString stringWithFormat:@"%@",model.adTitle];
        [self.SDKcontentLabel setAttributedText:[NetTool attributedSetWithString:content]];
        self.SDKfromLabel.text = model.buttonText?model.buttonText:@"查看详情";
        self.SDKtimeLabel.text = @"广告";
        [self.SDKbigImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    }
    //    [NetTool setImage:self.bigImageView WithURLStr:model.imageUrl placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    
    self.SDKcontentLabel.font = [UIFont systemFontOfSize:HFont(18) weight:UIFontWeightRegular];
    self.SDKfromLabel.font = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightRegular];
    self.SDKtimeLabel.font = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightRegular];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
