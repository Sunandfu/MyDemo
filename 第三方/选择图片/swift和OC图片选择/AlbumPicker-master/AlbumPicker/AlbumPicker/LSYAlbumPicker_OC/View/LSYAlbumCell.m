//
//  LSYAlbumCell.m
//  AlbumPicker
//
//  Created by okwei on 15/7/24.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAlbumCell.h"
@interface LSYAlbumCell ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *statusView;
@property (nonatomic,strong) LSYAlbumCellBottomView *bottomView;
@end
@implementation LSYAlbumCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.imageView addSubview:self.statusView];
        [self.imageView addSubview:self.bottomView];
    }
    return self;
}
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
-(UIImageView *)statusView
{
    if (!_statusView) {
        _statusView = [[UIImageView alloc] init];
        [_statusView setImage:[UIImage imageNamed:@"AlbumPicker.bundle/CardPack_Add_UnSelected@2x"]];
    }
    return _statusView;
}
-(LSYAlbumCellBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[LSYAlbumCellBottomView alloc] init];
        [_bottomView setBackgroundColor:[UIColor colorWithRed:19/255.0 green:19/255.0 blue:19/255.0 alpha:0.75]];
    }
    return _bottomView;
}
-(void)setModel:(LSYAlbumModel *)model
{
    _model = model;
    if ([model.assetType isEqual:ALAssetTypeVideo]) {
        [self.bottomView setHidden:NO];
        self.bottomView.interval = [[model.asset valueForProperty:ALAssetPropertyDuration] doubleValue];
    }
    else
    {
        [self.bottomView setHidden:YES];
    }
    _imageView.image = [UIImage imageWithCGImage:model.asset.thumbnail];
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _model.isSelect = selected;
    if (selected) {
        [self.statusView setImage:[UIImage imageNamed:@"AlbumPicker.bundle/FriendsSendsPicturesSelectYIcon@2x"]];
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.statusView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.statusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.statusView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
    else
    {
        [self.statusView setImage:[UIImage imageNamed:@"AlbumPicker.bundle/CardPack_Add_UnSelected@2x"]];
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, ViewSize(self).width, ViewSize(self).height);
    self.statusView.frame = CGRectMake(ViewSize(self).width-30, 0, 30, 30);
    self.bottomView.frame = CGRectMake(0, ViewSize(self).height-20, ViewSize(self).width, 20);
}
@end
/**
 Video Tag
 */
@interface LSYAlbumCellBottomView ()
@property (nonatomic,strong) UIImageView *videoImage;
@property (nonatomic,strong) UILabel *videoTime;
@end
@implementation LSYAlbumCellBottomView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initBottomView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBottomView];
    }
    return self;
}
-(void)initBottomView
{
    [self addSubview:self.videoImage];
    [self addSubview:self.videoTime];
}
-(UILabel *)videoTime
{
    if (!_videoTime) {
        _videoTime = [[UILabel alloc] init];
        [_videoTime setFont:[UIFont systemFontOfSize:14.0]];
        [_videoTime setTextColor:[UIColor whiteColor]];
        [_videoTime setTextAlignment:NSTextAlignmentRight];
    }
    return _videoTime;
}
-(UIImageView *)videoImage
{
    if (!_videoImage) {
        _videoImage = [[UIImageView alloc] init];
    }
    return _videoImage;
}
-(void)setInterval:(double)interval
{
    int hour;
    int minute;
    int second;
    hour = interval/3600;
    minute = (interval - 3600*hour)/60;
    second = ((int)interval - 3600*hour)%60;
    if (hour>0) {
        self.videoTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    }
    else {
        self.videoTime.text = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.videoImage setFrame:CGRectMake(0,0,20, ViewSize(self).height)];
    [self.videoTime setFrame:CGRectMake(ViewOrigin(self.videoImage).x+ViewSize(self.videoImage).width, 0,ViewSize(self).width-ViewSize(self.videoImage).width-5, ViewSize(self).height)];
}
@end