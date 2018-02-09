//
//  CollectionViewCell.m
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CellModel.h"

@interface CollectionViewCell ()
{
    UILabel *_des;
}

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initWithDesLabel];
    }
    return self;
}

- (void)initWithDesLabel
{
    CGFloat width = (SCREEN_WIDTH_BOUNDS - space*2)/4;
    _des = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    _des.font = [UIFont systemFontOfSize:16];
    _des.textAlignment = NSTextAlignmentCenter;
    _des.layer.borderColor = [UIColor grayColor].CGColor;
    _des.layer.borderWidth = 1;
    [self addSubview:_des];
}

- (void)cellDataWithModle:(NSString*)des
{
    _des.text = des;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{

    CGFloat width = layoutAttributes.frame.size.width;
    CGFloat height = layoutAttributes.frame.size.height;
    _des.frame = CGRectMake(0, 0, width, height);
}


@end
