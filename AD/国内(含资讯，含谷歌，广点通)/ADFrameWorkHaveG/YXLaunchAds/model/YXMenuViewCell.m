//
//  YXMenuViewCell.m
//  LunchAd
//
//  Created by lurich on 2019/3/19.
//  Copyright © 2019 YX. All rights reserved.
//

#import "YXMenuViewCell.h"

@implementation YXMenuViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

// 1. 初始化子视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 头像
        UIImageView *headImageView = [[UIImageView alloc] init];
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.clipsToBounds = YES;
        [self.contentView addSubview:headImageView];
        self.iconImageView = headImageView;
        
        // 昵称
        UILabel *nicknameLabel = [[UILabel alloc] init];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        nicknameLabel.textColor = [UIColor blackColor];
        nicknameLabel.textAlignment = NSTextAlignmentCenter;
        nicknameLabel.font = [UIFont systemFontOfSize:14.f];
        nicknameLabel.clipsToBounds = YES;
        [self.contentView addSubview:nicknameLabel];
        self.titleLabel = nicknameLabel;
    }
    
    return self;
}

// 2. 布局子视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.width-20);
    self.titleLabel.frame = CGRectMake(5, self.frame.size.width-10, self.frame.size.width-10, self.frame.size.height-self.frame.size.width);
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
