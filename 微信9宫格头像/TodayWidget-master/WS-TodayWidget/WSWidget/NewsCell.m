//
//  NewsCell.m
//  todayWidget123
//
//  Created by iMac on 17/5/17.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation NewsCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _creatSubViews];
    }
    
    return  self;
}


- (void)_creatSubViews {
    
    //图片
    UIImageView *cellImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    cellImg.contentMode = UIViewContentModeScaleAspectFill;//图片保持比例自适应（可能会截掉图片）
    cellImg.layer.masksToBounds = YES;
    cellImg.tag = 11;
    [self addSubview:cellImg];
    
    //主标题
    UILabel *cellTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    cellTitle.textColor = [UIColor whiteColor];
    cellTitle.numberOfLines = 2;
    cellTitle.font = [UIFont systemFontOfSize:16];
    cellTitle.tag = 22;
    [self addSubview:cellTitle];
    
    //时间
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    sourceLabel.textColor = [UIColor lightGrayColor];
    sourceLabel.font = [UIFont systemFontOfSize:13];
    sourceLabel.tag = 33;
    [self addSubview:sourceLabel];
    
    
    
}


-(void)setModel:(NewsModel *)model {
    _model = model;
    
    UIImageView *cellImg = (UIImageView *)[self viewWithTag:11];
    UILabel *cellTitle = (UILabel *)[self viewWithTag:22];
    UILabel *sourceLabel = (UILabel *)[self viewWithTag:33];
    
    //cellImg的frame
    if (_model.imageUrl.length == 0) { //如果图片网址是null，则不显示图片
        
        [cellImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.width.equalTo(@0);
            make.top.equalTo(self.mas_top).offset(7.5);
            make.height.equalTo(@70);
        }];
    }else{
        [cellImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@90);
            make.top.equalTo(self.mas_top).offset(7.5);
            make.height.equalTo(@70);
        }];
        [cellImg sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl]];//加载图片
    }
 
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellImg.mas_right).offset(10);
        make.top.equalTo(cellImg.mas_bottom).offset(-20);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    
    cellTitle.text = _model.cellTitle;
//    //计算文字的高度
//    CGFloat cellTitleHeight = [cellTitle.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - CGRectGetWidth(cellImg.frame) -10-10-5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
//    if (cellTitleHeight > 40) {
//        
//        cellTitleHeight = 40;
//    }
    
    [cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellImg.mas_right).offset(10);
        make.top.equalTo(cellImg.mas_top);
        make.right.equalTo(self.mas_right).offset(-5);
//        make.height.equalTo(@(cellTitleHeight));
    }];
    
    sourceLabel.text = _model.time;
    
    
    
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}




@end
