//
//  YXFeedAdTableViewCell.h
//  LunchAd
//
//  Created by shuai on 2018/10/23.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YXFeedAdData;
@interface YXFeedAdTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *adBackView;


@property (weak, nonatomic) IBOutlet UIImageView *adIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *adContentLabel;

@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (void)initadViewWithData:(YXFeedAdData *)data;
@end
