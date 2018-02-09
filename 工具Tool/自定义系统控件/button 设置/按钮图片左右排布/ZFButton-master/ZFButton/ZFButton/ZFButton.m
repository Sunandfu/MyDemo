//
//  ZFButton.m
//  ZFButton
//
//  Created by renzifeng on 15/8/13.
//  Copyright (c) 2015年 任子丰. All rights reserved.
//

#import "ZFButton.h"

@implementation ZFButton
{
    UIImageView* bgImgView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.frame = frame;
        self.clipsToBounds = NO;
        
        //
        bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.backgroundColor = [UIColor clearColor];
        bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        bgImgView.clipsToBounds = NO;
        [self addSubview:bgImgView];
        
        //
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.textAlignment = 1;
        _titleLabel.font = TEXTFONT;
        [self addSubview:_titleLabel];
        
        //
        _markImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _markImgView.backgroundColor = [UIColor clearColor];
        _markImgView.contentMode = UIViewContentModeCenter;
        [self addSubview:_markImgView];
        
        //default is right
        self.markAlignment = 2;
        
    }
    return self;
}

#pragma mark - A

- (void)setTitle:(NSString *)title{
    _title = title;
    
    _titleLabel.text = title;
    

    switch (_markAlignment) {
        case 0:{
            //
            [self markAlignmentNone];
            break;
        }
        case 1:{
            [self markAlignmentLeft];
            break;
        }
        case 2:{
            [self markAlignmentRight];
            break;
        }
        default:
            
            break;
    }

}

- (void)setMarkImg:(UIImage *)markImg{
    _markImg = markImg;
    _markImgView.image = markImg;
    _markImgView.hidden = NO;
    
    switch (_markAlignment) {
        case 0:{
            //
            [self markAlignmentNone];
            break;
        }
        case 1:{
            [self markAlignmentLeft];
            break;
        }
        case 2:{
            [self markAlignmentRight];
            break;
        }
        default:
            
            break;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    bgImgView.image = backgroundImage;
}

- (void)setMarkAlignment:(ZFMarkAlignment)markAlignment{
    
    _markAlignment = markAlignment;
    switch (markAlignment) {
        case 0:{
            //
            [self markAlignmentNone];
            break;
        }
        case 1:{
            [self markAlignmentLeft];
            break;
        }
        case 2:{
            [self markAlignmentRight];
            break;
        }
        default:
            break;
    }
}

- (void)markAlignmentNone{
    CGSize size = [self getStringSizeWith:_title boundingRectWithSize:CGSizeMake(self.bounds.size.width-5, self.bounds.size.height) font:TEXTFONT];
    
    CGFloat jxW = (self.bounds.size.width-size.width-5)/2;
    
    _titleLabel.frame = CGRectMake(jxW, 0, size.width, self.bounds.size.height);
    _markImgView.frame = CGRectZero;
    _markImgView.hidden = YES;
}

- (void)markAlignmentLeft{
    CGSize size = [self getStringSizeWith:_title boundingRectWithSize:CGSizeMake(self.bounds.size.width-25, self.bounds.size.height) font:TEXTFONT];
    
    CGFloat jxW = (self.bounds.size.width-size.width-25)/2;
    
    _markImgView.frame = CGRectMake(jxW, self.bounds.size.height/2-10, 20, 20);
    _titleLabel.frame = CGRectMake(jxW+20, 0, size.width, self.bounds.size.height);

}

- (void)markAlignmentRight{
    
    CGSize size = [self getStringSizeWith:_title boundingRectWithSize:CGSizeMake(self.bounds.size.width-25, self.bounds.size.height) font:TEXTFONT];
    
    CGFloat jxW = (self.bounds.size.width-size.width-25)/2;
    
    _titleLabel.frame = CGRectMake(jxW, 0, size.width, self.bounds.size.height);
    _markImgView.frame = CGRectMake(_titleLabel.frame.origin.x+_titleLabel.frame.size.width, _titleLabel.frame.size.height/2-10, 20, 20);
}

#pragma mark - B

- (void)settitleColor:(UIColor*)color{
    _titleLabel.textColor = color;
}

#pragma mark - else

//计算字符串size
- (CGSize)getStringSizeWith:(NSString*)_mystr boundingRectWithSize:(CGSize)_boundSize font:(UIFont*)font{
    
    if ([_mystr isEqual: [NSNull null]] || _mystr == nil || [_mystr isEqualToString: @""] || [_mystr isEqualToString: @"<null>"])
    {
        return CGSizeMake(_boundSize.width, 20);
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [_mystr  boundingRectWithSize:_boundSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    
    //    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    //
    //    CGSize size1 = [_mystr boundingRectWithSize:_boundSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

@end
