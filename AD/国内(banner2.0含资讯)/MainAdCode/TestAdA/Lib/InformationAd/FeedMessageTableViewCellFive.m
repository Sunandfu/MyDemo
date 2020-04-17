//
//  FeedMessageTableViewCellFive.m
//  TestAdA
//
//  Created by lurich on 2019/6/10.
//  Copyright © 2019 YX. All rights reserved.
//

#import "FeedMessageTableViewCellFive.h"
#import "NetTool.h"
#import "UIView+SFFrame.h"
#import "YXFeedAdData.h"

@interface FeedMessageTableViewCellFive()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoTime;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;
@property (weak, nonatomic) IBOutlet UIImageView *backBigImg;
@property (weak, nonatomic) IBOutlet UIImageView *clickImg;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhidWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZhidWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userBackViewWidth;
@property (weak, nonatomic) IBOutlet UIView *userImageBackView;

@end

@implementation FeedMessageTableViewCellFive

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backBigImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"];
    self.userImageBackView.layer.masksToBounds = self.tag1.layer.masksToBounds = self.tag2.layer.masksToBounds = self.userImage.layer.masksToBounds = YES;
    self.userImageBackView.layer.cornerRadius = self.tag1.layer.cornerRadius = self.tag2.layer.cornerRadius = self.userImage.layer.cornerRadius = self.tag1.sf_height/2.0;
    self.userImageBackView.layer.borderWidth = self.tag1.layer.borderWidth = self.tag2.layer.borderWidth = 1.0;
    self.userImageBackView.layer.borderColor = self.tag1.layer.borderColor = self.tag2.layer.borderColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:1.0f].CGColor;
    [self.videoTime setBackgroundImage:[UIImage imageNamed:@"XibAndPng.bundle/time_back"] forState:UIControlStateNormal];
    self.clickImg.image = [UIImage imageNamed:@"XibAndPng.bundle/bofang"];
}
- (void)cellDataWithDictionary:(NSDictionary *)dict{
    if ([dict[@"isTop"] isEqualToString:@"1"]) {
        self.zhidWidth.constant = 28;
        self.leftZhidWidth.constant = 5;
        self.adImg.hidden = NO;
        if ([dict[@"topType"] isKindOfClass:[NSString class]] && [dict[@"topType"] isEqualToString:@"2"]) {
            if ([dict[@"topImage"] isKindOfClass:[NSString class]]) {
                [self.adImg sd_setImageWithURL:[NSURL URLWithString:dict[@"topImage"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"]];
            }
        } else {
            self.adImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
        }
    } else {
        self.zhidWidth.constant = 0;
        self.leftZhidWidth.constant = 0;
        self.adImg.hidden = YES;
    }
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    NSString *content = [NSString stringWithFormat:@"%@",dict[@"title"]];
    [self.contentLabel setAttributedText:[NetTool attributedSetWithString:content]];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.text = dict[@"source"];
    self.timeLabel.text = dict[@"feedTime"];
    NSString *videoDuration = dict[@"duration"];
    [self.videoTime setTitle:[NSString stringWithFormat:@"%02ld:%02ld",videoDuration.integerValue/60,videoDuration.integerValue%60] forState:UIControlStateNormal];
    NSString *tags = dict[@"tags"];
    NSArray *tagArray = [tags componentsSeparatedByString:@","];
    for (int i=0; i<tagArray.count; i++) {
        if (i==0) {
            self.tag1.hidden = NO;
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@.",tagArray[i]]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:1.0f] range:NSMakeRange(0,string.length-1)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(string.length-1,1)];
            self.tag1.attributedText = string;
        }
        if (i==1) {
            self.tag2.hidden = NO;
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@.",tagArray[i]]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:1.0f] range:NSMakeRange(0,string.length-1)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(string.length-1,1)];
            self.tag2.attributedText = string;
        }
    }
    if ([dict[@"sourceAvatar"] isKindOfClass:[NSString class]]) {
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:dict[@"sourceAvatar"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    }
    if ([dict[@"bigImageUrl"] isKindOfClass:[NSArray class]]) {
        NSArray *imageArr = dict[@"bigImageUrl"];
        for (int i=0; i<imageArr.count; i++) {
            NSString *imgStr = imageArr[i];
            if (i==0) {
                [self.backBigImg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
            }
        }
    } else if ([dict[@"bigImageUrl"] isKindOfClass:[NSString class]]) {
        [self.backBigImg sd_setImageWithURL:[NSURL URLWithString:dict[@"bigImageUrl"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    }
    
    self.contentLabel.font = [SFNewsConfiguration defaultConfiguration].titleFont;
    self.titleLabel.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.tag1.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.tag2.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.timeLabel.font = [SFNewsConfiguration defaultConfiguration].fromFont;
    self.backBigImg.layer.masksToBounds = YES;
    self.backBigImg.layer.cornerRadius = [SFNewsConfiguration defaultConfiguration].cornerRadius;
    self.contentLabel.textColor = [SFNewsConfiguration defaultConfiguration].titleColor;
    self.titleLabel.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
    self.tag1.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
    self.tag2.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
    self.timeLabel.textColor = [SFNewsConfiguration defaultConfiguration].fromColor;
    
    self.userBackViewWidth.constant = [self cellWidthWithLabel:self.titleLabel]+30;
}
- (CGFloat)cellWidthWithLabel:(UILabel *)label
{
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, 20)];
    return size.width;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
