//
//  MyCell.h
//  视频2
//
//  Created by lanou3g on 15/6/8.
//  Copyright (c) 2015年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCell : UITableViewCell
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)UILabel *Labeltitle;
@property(nonatomic,strong)UIImageView *btnimage;
@property(nonatomic,strong)UILabel *playcountLabel;
@property(nonatomic,strong)UIImageView *playcountImage;
@property(nonatomic,strong)UILabel *playtimeLabel;
@property(nonatomic,strong)UIImageView *playtimeImage;
@end
