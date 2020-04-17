//
//  FeedMessageTableViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import "FeedMessageTableViewCellFour.h"
#import "NetTool.h"
#import "UIView+SFFrame.h"

@interface FeedMessageTableViewCellFour()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet UIImageView *zhidImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhidWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZhidWidth;


@end

@implementation FeedMessageTableViewCellFour

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.adImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_adFlag"];
    self.zhidImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
    self.imageViewOne.image = self.imageViewTwo.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)cellDataWithDictionary:(NSDictionary *)dict{
    NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([dict[@"isTop"] isEqualToString:@"1"]) {
        self.zhidWidth.constant = 28;
        self.leftZhidWidth.constant = 5;
        if ([dict[@"topType"] isKindOfClass:[NSString class]] && [dict[@"topType"] isEqualToString:@"2"]) {
            if ([dict[@"topImage"] isKindOfClass:[NSString class]]) {
                [self.zhidImg sd_setImageWithURL:[NSURL URLWithString:dict[@"topImage"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"]];
            }
        } else {
            self.zhidImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
        }
    } else {
        self.zhidWidth.constant = 0;
        self.leftZhidWidth.constant = 0;
    }
    if ([type isEqualToString:@"news"]) {//新闻
        self.adImg.hidden = YES;
    } else {// 广告
        self.adImg.hidden = NO;
    }
    NSString *content = [NSString stringWithFormat:@"%@",dict[@"title"]];
    [self.contentLabel setAttributedText:[NetTool attributedSetWithString:content]];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.fromLabel.text = dict[@"source"];
    self.timeLabel.text = dict[@"feedTime"];
    NSArray *imageArr = dict[@"sImages"];
    for (int i=0; i<imageArr.count; i++) {
        NSString *imgStr = imageArr[i];
        if (i==0) {
            [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
//            [NetTool setImage:self.imageViewOne WithURLStr:imgStr placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
        } else if (i==1) {
            [self.imageViewTwo sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
//            [NetTool setImage:self.imageViewTwo WithURLStr:imgStr placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
        }
    }
    
    self.contentLabel.font = [SFNewsConfiguration defaultConfiguration].titleFont;
    self.fromLabel.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.timeLabel.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.imageViewOne.layer.masksToBounds = self.imageViewTwo.layer.masksToBounds = YES;
    self.imageViewOne.layer.cornerRadius = self.imageViewTwo.layer.cornerRadius = [SFNewsConfiguration defaultConfiguration].cornerRadius;
    self.contentLabel.textColor = [SFNewsConfiguration defaultConfiguration].titleColor;
    self.fromLabel.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
    self.timeLabel.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
}
// 两行  230   一行  210
@end
