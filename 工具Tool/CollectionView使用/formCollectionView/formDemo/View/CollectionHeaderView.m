//
//  CollectionHeaderView.m
//  formDemo
//
//  Created by qinyulun on 16/4/15.
//  Copyright © 2016年 leTian. All rights reserved.
//

#import "CollectionHeaderView.h"
#import "CellGroupModel.h"

@interface CollectionHeaderView ()
{
    UIImageView *_imageView;
    UILabel     *_title;
    UIView      *_cutView;
}

@end

@implementation CollectionHeaderView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initWihtCutView];
        
        [self initWithImgView];
        
        [self initWithTitle];
    }
    return self;
}

- (void)initWihtCutView
{
    _cutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_BOUNDS, space)];
    _cutView.backgroundColor = [UIColor grayColor];
    [self addSubview:_cutView];
}

- (void)initWithImgView
{
    CGFloat imgWidth = space*3;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imgWidth, imgWidth)];
    _imageView.backgroundColor = [UIColor redColor];
    [self addSubview:_imageView];
}

- (void)initWithTitle
{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_imageView)+space/2, _imageView.center.y-10, SCREEN_WIDTH_BOUNDS/2, 20)];
    _title.font = [UIFont systemFontOfSize:20];
    [self addSubview:_title];
}

- (void)headerViewDataWithModel:(CellGroupModel*)model indexPath:(NSIndexPath*)indexPath
{
    [self settingFrame:indexPath];
    [self settingData:model];
}

- (void)settingFrame:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        _cutView.frame = CGRectMake(0, 0, 0, 0);
    }else{
        _cutView.frame = CGRectMake(0, 0, SCREEN_WIDTH_BOUNDS, space);
    }
    
    _imageView.frame = CGRectMake(X(_imageView), MaxY(_cutView)+space, CGRectGetWidth(_imageView.frame), CGRectGetHeight(_imageView.frame));
    
    _title.frame = CGRectMake(X(_title), _imageView.center.y-10, CGRectGetWidth(_title.frame), CGRectGetHeight(_title.frame));
}

- (void)settingData:(CellGroupModel*)model
{
    _imageView.image = [UIImage imageNamed:model.headerImg];
    _title.text      = model.headerTitle;
}

@end
