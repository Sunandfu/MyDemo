//
//  TYCircleCollectionView.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "TYCircleCollectionView.h"
#import "TYCircleCell.h"
#import "TYCircleCollectionViewLayout.h"
#import "TYCircleMacros.h"

@interface TYCircleCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>

@end

static NSString *cellId = @"TYCircleCell";

@implementation TYCircleCollectionView
{
    NSInteger selectedIndex;
}
@synthesize isDismissWhenSelected = _isDismissWhenSelected;

- (instancetype)initWithFrame:(CGRect)frame itemOffset:(CGFloat)itemOffset imageArray:(NSArray *)images titleArray:(NSArray *)titles {
     _circleLayout = [[TYCircleCollectionViewLayout alloc]initWithRadius:frame.size.height-TYCircleViewMargin  itemOffset:itemOffset];
    return [self initWithFrame:frame collectionViewLayout:_circleLayout imageArray:images titleArray:titles];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout imageArray:(NSArray *)images titleArray:(NSArray *)titles {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;

        _menuImages = images;
        _menuTitles = titles;
        selectedIndex = -1;
        [self registerClass:[TYCircleCell class] forCellWithReuseIdentifier:cellId];
    }
    return self;
}

#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menuImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYCircleCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.menuImages[indexPath.item]];
    cell.titleLabel.text = self.menuTitles[indexPath.item];
    if (!_isDismissWhenSelected && indexPath.item == selectedIndex) {
         cell.bgImageView.image = [UIImage imageNamed:@"empty_btn_highlight"];
    } else {
         cell.bgImageView.image = [UIImage imageNamed:@"empty_btn"];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return TYCircleCellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (_menuDelegate && [_menuDelegate respondsToSelector:@selector(selectMenuAtIndex:)]) {
        [_menuDelegate selectMenuAtIndex:indexPath.item];
    }
    
    if (_isDismissWhenSelected && self.selecteBlock) {
        self.selecteBlock();
    } else {
        selectedIndex = indexPath.item;
        TYCircleCell *selectedCell =
        (TYCircleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        selectedCell.bgImageView.image = [UIImage imageNamed:@"empty_btn_highlight"];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isDismissWhenSelected) {
        TYCircleCell *selectedCell =
        (TYCircleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        selectedCell.bgImageView.image = [UIImage imageNamed:@"empty_btn"];
    }
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com