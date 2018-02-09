//
//  MyCell.m
//  视频2
//
//  Created by lanou3g on 15/6/8.
//  Copyright (c) 2015年 my. All rights reserved.
//

#import "MediaCell.h"

@implementation MediaCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self layoutCell];
    }
    return self;
    
}
-(void)layoutCell
{
    self.btn =[[UIButton alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, 210)];
    
    self.btnimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, 210)];
    [self.btn addSubview:self.btnimage];
    [self.contentView addSubview:self.btn];
    
    self.myImageView=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-30,90,40,40)];
    self.myImageView.image=[UIImage imageNamed:@"audionews_index_play@2x.png"];
    [self.btnimage addSubview:self.myImageView];
    self.Labeltitle=[[UILabel alloc]initWithFrame:CGRectMake(10,235, [UIScreen mainScreen].bounds.size.width, 20)];
    [self.Labeltitle setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:self.Labeltitle];
    self.playcountLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 255, 250, 15)];
    [self.playcountLabel setFont:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:self.playcountLabel];
    self.playcountImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 255, 15, 15)];
    self.playcountImage.image=[UIImage imageNamed:@"night_video_list_cell_count@2x"];
    [self.contentView addSubview:self.playcountImage];
    self.playtimeLabel=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-40, 255, 45, 15)];
    [self.playtimeLabel setFont:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:self.playtimeLabel];
    self.playtimeImage=[[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 255, 15, 15)];
    self.playtimeImage.image=[UIImage imageNamed:@"night_audionews_indexheader_recent@2x"];
    [self.contentView addSubview:self.playtimeImage];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
