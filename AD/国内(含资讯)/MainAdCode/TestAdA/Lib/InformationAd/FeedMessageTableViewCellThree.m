//
//  FeedMessageTableViewCell.m
//  TestAdA
//
//  Created by lurich on 2019/4/28.
//  Copyright © 2019 YX. All rights reserved.
//

#import "FeedMessageTableViewCellThree.h"
#import "NetTool.h"
#import "UIView+SFFrame.h"
#import "YXFeedAdData.h"

@interface FeedMessageTableViewCellThree()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet UIImageView *zhidImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhidWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftZhidWidth;

@end

@implementation FeedMessageTableViewCellThree

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.adImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_adFlag"];
    self.zhidImg.image = [UIImage imageNamed:@"XibAndPng.bundle/sf_zhid"];
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
    if (dict[@"bigImageUrl"] && [dict[@"bigImageUrl"] isKindOfClass:[NSArray class]]) {
        NSArray *imageArr = dict[@"bigImageUrl"];
        for (int i=0; i<imageArr.count; i++) {
            NSString *imgStr = imageArr[i];
            if (i==0) {
                [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
            }
        }
    } else if (dict[@"bigImageUrl"] && [dict[@"bigImageUrl"] isKindOfClass:[NSString class]]) {
        [self.imageViewOne sd_setImageWithURL:[NSURL URLWithString:dict[@"bigImageUrl"]] placeholderImage:[UIImage imageNamed:@"XibAndPng.bundle/sf_placeImg"]];
    }
    
    self.contentLabel.font = [UIFont systemFontOfSize:HFont(18) weight:UIFontWeightRegular];
    self.fromLabel.font = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightRegular];
    self.timeLabel.font = [UIFont systemFontOfSize:HFont(13) weight:UIFontWeightRegular];
}

// 一行 277　　两行  297
@end
