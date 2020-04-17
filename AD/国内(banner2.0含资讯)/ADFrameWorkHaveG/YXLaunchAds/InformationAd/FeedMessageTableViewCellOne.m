//
//  FeedMessageTableViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import "FeedMessageTableViewCellOne.h"
#import "NetTool.h"
#import "UIView+SFFrame.h"

@interface FeedMessageTableViewCellOne()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *adImg1;
@property (weak, nonatomic) IBOutlet UIImageView *zhidImg1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhidWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZhidWidth1;

@end

@implementation FeedMessageTableViewCellOne

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.adImg1.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_adFlag"];
    self.zhidImg1.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellDataWithDictionary:(NSDictionary *)dict{
    NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([dict[@"isTop"] isKindOfClass:[NSString class]] && [dict[@"isTop"] isEqualToString:@"1"]) {
        self.zhidWidth1.constant = 28;
        self.leftZhidWidth1.constant = 5;
        if ([dict[@"topType"] isKindOfClass:[NSString class]] && [dict[@"topType"] isEqualToString:@"2"]) {
            if ([dict[@"topImage"] isKindOfClass:[NSString class]]) {
                [self.zhidImg1 sd_setImageWithURL:[NSURL URLWithString:dict[@"topImage"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"]];
            }
        } else {
            self.zhidImg1.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
        }
    } else {
        self.zhidWidth1.constant = 0;
        self.leftZhidWidth1.constant = 0;
    }
    if ([type isEqualToString:@"news"]) {//新闻
        self.adImg1.hidden = YES;
    } else {// 广告
        self.adImg1.hidden = NO;
    }
    NSString *content = [NSString stringWithFormat:@"%@",dict[@"title"]];
    [self.contentLabel1 setAttributedText:[NetTool attributedSetWithString:content]];
    self.contentLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
    self.fromLabel1.text = dict[@"source"];
    self.timeLabel.text = dict[@"feedTime"];
    NSArray *imageArr = dict[@"sImages"];
    NSString *imgStr = [imageArr firstObject];
    [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
//    [NetTool setImage:self.imageView1 WithURLStr:imgStr placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    self.contentLabel1.font = [SFNewsConfiguration defaultConfiguration].titleFont;
    self.fromLabel1.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.timeLabel.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.layer.cornerRadius = [SFNewsConfiguration defaultConfiguration].cornerRadius;
    self.contentLabel1.textColor = [SFNewsConfiguration defaultConfiguration].titleColor;
    self.fromLabel1.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
    self.timeLabel.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
}

@end
