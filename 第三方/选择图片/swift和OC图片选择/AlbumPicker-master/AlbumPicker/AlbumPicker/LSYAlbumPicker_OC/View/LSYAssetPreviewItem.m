//
//  LSYAssetPreviewItem.m
//  AlbumPicker
//
//  Created by okwei on 15/7/31.
//  Copyright (c) 2015年 okwei. All rights reserved.
//

#import "LSYAssetPreviewItem.h"
@interface LSYAssetPreviewItem ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *previewScrollView;
@property (nonatomic,strong) UIImageView *assetImageView;
@end
@implementation LSYAssetPreviewItem
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initAssetPreViewItem];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAssetPreViewItem];
    }
    return self;
}
-(void)initAssetPreViewItem
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBar)]];
    [self addSubview:self.previewScrollView];
    [self.previewScrollView addSubview:self.assetImageView];
}
-(void)hiddenBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenBarControl)]) {
        [self.delegate hiddenBarControl];
    }
}
-(UIScrollView *)previewScrollView
{
    if (!_previewScrollView) {
        _previewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, ScreenSize.width-20, ScreenSize.height)];
        _previewScrollView.center = CGPointMake(_previewScrollView.center.x, CGRectGetMidY(self.frame));
        [_previewScrollView setDelegate:self];
        [_previewScrollView setShowsVerticalScrollIndicator:NO];
        [_previewScrollView setShowsHorizontalScrollIndicator:NO];
        [_previewScrollView setMinimumZoomScale:1.0];
        [_previewScrollView setMaximumZoomScale:2.0];
    }
    return _previewScrollView;
}
-(UIImageView *)assetImageView
{
    if (!_assetImageView) {
        _assetImageView = [[UIImageView alloc] init];
    }
    return _assetImageView;
}
-(void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    _assetImageView.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
    CGFloat imageViewHeight = (_assetImageView.image.size.height/_assetImageView.image.size.width*_previewScrollView.frame.size.width);
    CGFloat imageViewWidth = _previewScrollView.frame.size.width;
    [_assetImageView setFrame:CGRectMake(0, 0, imageViewWidth,imageViewHeight)];
    [_assetImageView setCenter:CGPointMake(_assetImageView.center.x, CGRectGetMidY(self.previewScrollView.frame))];
}
#pragma mark -UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _assetImageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize originalSize = _previewScrollView.bounds.size;
    CGSize contentSize = _previewScrollView.contentSize;
    CGFloat offsetX = (originalSize.width>contentSize.width)?(originalSize.width-contentSize.width):0;
    CGFloat offsetY = (originalSize.height>contentSize.height)?(originalSize.height-contentSize.height):0;
    _assetImageView.center = CGPointMake(contentSize.width/2+offsetX,(originalSize.height>contentSize.height)?originalSize.height/2:contentSize.height/2+offsetY);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
