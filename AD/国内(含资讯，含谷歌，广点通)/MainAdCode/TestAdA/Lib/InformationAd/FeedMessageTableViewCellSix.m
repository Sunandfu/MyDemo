//
//  FeedMessageTableViewCellSix.m
//  TestAdA
//
//  Created by lurich on 2019/6/14.
//  Copyright © 2019 YX. All rights reserved.
//

#import "FeedMessageTableViewCellSix.h"
#import "NetTool.h"
#import "UIView+SFFrame.h"

@interface FeedMessageTableViewCellSix()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoTime;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *clickImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhidWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZhidWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userBackViewWidth;
@property (weak, nonatomic) IBOutlet UIView *userImageBackView;
@property (weak, nonatomic) IBOutlet UIView *jianbianView;

@end

@implementation FeedMessageTableViewCellSix

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundImage.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"];
    self.userImageBackView.layer.masksToBounds = self.tag1.layer.masksToBounds = self.tag2.layer.masksToBounds = self.userImage.layer.masksToBounds = YES;
    self.userImageBackView.layer.cornerRadius = self.tag1.layer.cornerRadius = self.tag2.layer.cornerRadius = self.userImage.layer.cornerRadius = self.tag1.sf_height/2.0;
    self.userImageBackView.layer.borderWidth = self.tag1.layer.borderWidth = self.tag2.layer.borderWidth = 1.0;
    self.userImageBackView.layer.borderColor = self.tag1.layer.borderColor = self.tag2.layer.borderColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:1.0f].CGColor;
    [self.videoTime setBackgroundImage:[UIImage imageNamed:@"XibAndPng.bundle/time_back"] forState:UIControlStateNormal];
    self.clickImage.image = [UIImage imageNamed:@"XibAndPng.bundle/bofang"];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, SF_ScreenW, self.jianbianView.bounds.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    [self.jianbianView.layer insertSublayer:gradient atIndex:0];
}
- (void)cellDataWithDictionary:(NSDictionary *)dict{
    NSString *type = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([dict[@"isTop"] isEqualToString:@"1"]) {
        self.zhidWidth.constant = 28;
        self.leftZhidWidth.constant = 5;
    } else {
        self.zhidWidth.constant = 0;
        self.leftZhidWidth.constant = 0;
    }
    if ([type isEqualToString:@"video"]) {//新闻
        self.adImg.hidden = YES;
    } else {// 广告
        self.adImg.hidden = NO;
    }
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    NSString *content = [NSString stringWithFormat:@"%@",dict[@"title"]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f] range:NSMakeRange(0, content.length)];
    //设置段落格式
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 2;//增加行高
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1.0;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 0;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
    [self.contentLabel setAttributedText:attrString];
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
                [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
            }
        }
    } else if ([dict[@"bigImageUrl"] isKindOfClass:[NSString class]]) {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:dict[@"bigImageUrl"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    }
    
    self.contentLabel.font = [UIFont systemFontOfSize:HFont(17) weight:UIFontWeightRegular];
    self.titleLabel.font = [UIFont systemFontOfSize:HFont(11) weight:UIFontWeightRegular];
    self.tag1.font = [UIFont systemFontOfSize:HFont(12) weight:UIFontWeightRegular];
    self.tag2.font = [UIFont systemFontOfSize:HFont(12) weight:UIFontWeightRegular];
    self.timeLabel.font = [UIFont systemFontOfSize:HFont(12) weight:UIFontWeightRegular];
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
