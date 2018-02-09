//
//  THVideoCell.m
//  THPlayer
//
//  Created by inveno on 16/3/23.
//  Copyright © 2016年 inveno. All rights reserved.
//

#import "THVideoCell.h"
#import "UIViewExt.h"
#import "Color+Hex.h"
#import "UIImageView+WebCache.h"

#define cellHeight 160
//获取设备的物理宽高
#define cellWidth [[UIScreen mainScreen] bounds].size.width

@implementation THVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight - 20)];
    [self.contentView addSubview:self.backView];
    
    _imgView = [[UIImageView alloc] initWithFrame:self.backView.bounds];
    _imgView.backgroundColor = [UIColor hexStringToColor:@"#dbdbdb"];
    _imgView.layer.masksToBounds = YES;
    _imgView.contentMode = UIViewContentModeCenter;
    _imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
     [_imgView layer].shadowPath =[UIBezierPath bezierPathWithRect:_imgView.bounds].CGPath;
    
    [self.backView addSubview:_imgView];

    
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"video_play_btn_bg@2x" ofType:@"png"]];
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake((cellWidth-img.size.width)/2, (cellHeight-img.size.height)/2, img.size.width, img.size.height);
    [_playBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.backView addSubview:_playBtn];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, cellWidth - 30, 33)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.backView addSubview:_titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_model == nil) return;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:nil];
    
     self.titleLabel.text = _model.title;
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com