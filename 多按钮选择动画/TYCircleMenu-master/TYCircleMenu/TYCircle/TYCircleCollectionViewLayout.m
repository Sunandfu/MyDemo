//
//  TYCircleCollectionViewLayout.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "TYCircleCollectionViewLayout.h"
#import "TYCircleMacros.h"

@implementation TYCircleCollectionViewLayout

@synthesize visibleNum = _visibleNum;
-(id)initWithRadius:(CGFloat)radius itemOffset:(CGFloat)itemOffset {
    
    if ((self = [super init]))
    {
        _circleRadius = radius;
        _visibleNum   = TYDefaultVisibleNum;
        _itemHeight   = [UIScreen mainScreen].bounds.size.height/_visibleNum;
        _itemOffset   = itemOffset+TYCircleCellSize.height/2;
    }
    return self;
}


#pragma mark - collectionViewLayout method

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _offset = -self.collectionView.contentOffset.y / self.itemHeight;
    
}

- (CGSize)collectionViewContentSize
{
    
    return CGSizeMake(self.collectionView.bounds.size.width,
                      (self.cellCount-_visibleNum) * self.itemHeight + self.collectionView.bounds.size.height);
}

//给出所有可见元素的UICollectionViewLayoutAttributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    NSInteger firstIndex = floorf(CGRectGetMinY(rect) / self.itemHeight);
    NSInteger lastIndex = floorf(CGRectGetMaxY(rect) / self.itemHeight);

    NSInteger visibleFirstIndex = fmax(0, firstIndex-1);
    NSInteger visibleLastIndex = fmin( self.cellCount-1 ,lastIndex+2);

    for( NSInteger i = visibleFirstIndex; i <= visibleLastIndex; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attributes addObject:theAttributes];
    }
    
    
    return [attributes copy];
}




- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = TYCircleCellSize;
    
    //修正位置
    CGFloat newIndex = indexPath.item + self.offset;
    CGAffineTransform translation;
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-M_PI/2+90/(self.visibleNum-1)*newIndex*M_PI/180);
    
    attributes.center = CGPointMake(self.itemOffset  , self.collectionView.bounds.size.height-self.itemOffset + self.collectionView.contentOffset.y);
    translation =CGAffineTransformMakeTranslation(self.circleRadius-self.itemOffset-TYCircleCellSize.width/2 , 0);
    attributes.transform = CGAffineTransformConcat(translation, rotation);
    
    return attributes;
}

#pragma mark - setter

- (void)setVisibleNum:(unsigned int)visibleNum {
    _visibleNum = visibleNum;
    _itemHeight = [UIScreen mainScreen].bounds.size.height/_visibleNum;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com