//
//  FMHorizontalMenuView.m
//  YFMHorizontalMenu
//
//  Created by FM on 2018/11/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FMHorizontalMenuView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "FMHorizontalMenuCollectionLayout.h"

#define kHorizontalMenuViewInitialPageControlDotSize CGSizeMake(6, 6)

@interface FMHorizontalMenuViewCell:UICollectionViewCell

@property (nonatomic,strong) UILabel *menuTile;

@property (nonatomic,strong) UIImageView *menuIcon;

@end

@implementation FMHorizontalMenuViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuTile = [UILabel new];
        self.menuTile.textAlignment = 1;
        self.menuTile.font = [UIFont boldSystemFontOfSize:13];
        self.menuTile.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
        [self.contentView addSubview:self.menuTile];
        
        self.menuIcon = [UIImageView new];
        [self.contentView addSubview:self.menuIcon];
        
        [self.menuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.centerX.mas_equalTo(self.contentView);
        }];
        
        [self.menuTile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.menuIcon.mas_bottom).offset(10);
            make.height.mas_equalTo(17);
        }];
        
    }
    return self;
}

@end

static NSString *FMHorizontalMenuViewCellID = @"FMHorizontalMenuViewCell";
@interface FMHorizontalMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,FMHorizontalMenuViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (strong,nonatomic) UIControl         *pageControl;

@property (strong,nonatomic) FMHorizontalMenuCollectionLayout         *layout;

@end

@implementation FMHorizontalMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageControlDotSize = kHorizontalMenuViewInitialPageControlDotSize;
        _pageControlAliment = FMHorizontalMenuViewPageControlAlimentCenter;
        _pageControlBottomOffset = 0;
        _pageControlRightOffset = 0;
        _controlSpacing = 10;
        _pageControlStyle = FMHorizontalMenuViewPageControlStyleAnimated;
        _currentPageDotColor = [UIColor whiteColor];
        _pageDotColor = [UIColor lightGrayColor];
        _hidesForSinglePage = YES;
    }
    return self;
}

-(void)setUpPageControl
{
    if (_pageControl) {
        [_pageControl removeFromSuperview];//重新加载数据时调整
    }
    if (([self.layout currentPageCount] == 1) && self.hidesForSinglePage) {//一页并且单页隐藏pageControl
        return;
    }
    switch (self.pageControlStyle) {
        case FMHorizontalMenuViewPageControlStyleAnimated:
        {
            EllipsePageControl *pageControl = [[EllipsePageControl alloc]init];
            pageControl.numberOfPages = [self.layout currentPageCount];
            pageControl.currentPage = 0;
            pageControl.controlSize = self.pageControlDotSize.width;
            pageControl.controlSpacing = self.controlSpacing;
            pageControl.currentColor = self.currentPageDotColor;
            pageControl.otherColor = self.pageDotColor;
            pageControl.delegate = self;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case FMHorizontalMenuViewPageControlStyleClassic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc]init];
            pageControl.numberOfPages = [self.layout currentPageCount];
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.pageDotColor;
            pageControl.userInteractionEnabled = NO;
            pageControl.currentPage = 0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        default:
            break;
    }
    
    
    //重设pageControlDot图片
    if (self.currentPageDotImage) {
        self.currentPageDotImage = self.currentPageDotImage;
    }
    if (self.pageDotImage) {
        self.pageDotImage = self.pageDotImage;
    }
    
    NSInteger count = self.numOfPage;
    CGFloat pageWidth = (count - 1)*self.pageControlDotSize.width + self.pageControlDotSize.width * 2 + (count - 1) *self.controlSpacing;
    CGSize size = CGSizeMake(pageWidth, self.pageControlDotSize.height);
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    CGFloat y = self.frame.size.height - size.height;
    if (self.pageControlAliment == FMHorizontalMenuViewPageControlAlimentRight) {
        x = self.frame.size.width - size.width - 15;
        y = 0;
    }
    if ([self.pageControl isKindOfClass:[EllipsePageControl class]]) {
        EllipsePageControl *pageControl = (EllipsePageControl *)_pageControl;
        [pageControl sizeToFit];
    }
    CGRect pageControlFrame = CGRectMake(x, y, size.width, size.height);
    pageControlFrame.origin.y -= self.pageControlBottomOffset;
    pageControlFrame.origin.x -= self.pageControlRightOffset;
    self.pageControl.frame = pageControlFrame;
    [self addSubview:_pageControl];
}

-(UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        self.layout = [FMHorizontalMenuCollectionLayout new];
        
        //设置行数
        if (self.delegate && [self.delegate respondsToSelector:@selector(numOfRowsPerPageInHorizontalMenuView:)]) {
            self.layout.rowCount = [self.delegate numOfRowsPerPageInHorizontalMenuView:self];
        }else{
            self.layout.rowCount = 2;
        }
        // 设置列数
        if(self.delegate && [self.delegate respondsToSelector:@selector(numOfColumnsPerPageInHorizontalMenuView:)]) {
            self.layout.columCount = [self.delegate numOfColumnsPerPageInHorizontalMenuView:self];
        } else {
            self.layout.columCount = 4;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        //        _collectionView.scrollEnabled
        [_collectionView registerClass:[FMHorizontalMenuViewCell class] forCellWithReuseIdentifier:FMHorizontalMenuViewCellID];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return _collectionView;
}

/**
 刷新
 */
-(void)reloadData{
    //    self.pageControl.numberOfPages = [self.layout pageCount];
    //    self.pageControl.currentPage = 0;
    //设置行数
    if (self.delegate && [self.delegate respondsToSelector:@selector(numOfRowsPerPageInHorizontalMenuView:)]) {
        self.layout.rowCount = [self.delegate numOfRowsPerPageInHorizontalMenuView:self];
    }else{
        self.layout.rowCount = 2;
    }
    [self.collectionView reloadData];
    
    [self setUpPageControl];
    
}


#pragma mark - properties

- (void)setDelegate:(id<FMHorizontalMenuViewDelegate>)delegate
{
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(customCollectionViewCellClassForHorizontalMenuView:)] && [self.delegate customCollectionViewCellClassForHorizontalMenuView:self]) {
        [self.collectionView registerClass:[self.delegate customCollectionViewCellClassForHorizontalMenuView:self] forCellWithReuseIdentifier:FMHorizontalMenuViewCellID];
    }else if ([self.delegate respondsToSelector:@selector(customCollectionViewCellNibForHorizontalMenuView:)] && [self.delegate customCollectionViewCellNibForHorizontalMenuView:self]) {
        [self.collectionView registerNib:[self.delegate customCollectionViewCellNibForHorizontalMenuView:self] forCellWithReuseIdentifier:FMHorizontalMenuViewCellID];
    }
}
#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.pageControl isKindOfClass:[EllipsePageControl class]]) {
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / self.frame.size.width;
    if ([self.pageControl isKindOfClass:[EllipsePageControl class]]) {
        EllipsePageControl *pageControl = (EllipsePageControl *)_pageControl;
        pageControl.currentPage = currentPage;
    }
    if ([self.delegate respondsToSelector:@selector(horizontalMenuView:WillEndDraggingWithVelocity:targetContentOffset:)]) {
        [self.delegate horizontalMenuView:self WillEndDraggingWithVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
#pragma mark - UICollectionViewDataSource -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInHorizontalMenuView:)]) {
        count = [self.dataSource numberOfItemsInHorizontalMenuView:self];
    }
    return count;
}

- (FMHorizontalMenuViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMHorizontalMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMHorizontalMenuViewCellID forIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:horizontalMenuView:)] &&
        [self.delegate respondsToSelector:@selector(customCollectionViewCellClassForHorizontalMenuView:)] && [self.delegate customCollectionViewCellClassForHorizontalMenuView:self]) {
        [self.delegate setupCustomCell:cell forIndex:indexPath.item horizontalMenuView:self];
        return cell;
    }else if ([self.delegate respondsToSelector:@selector(setupCustomCell:forIndex:horizontalMenuView:)] &&
              [self.delegate respondsToSelector:@selector(customCollectionViewCellNibForHorizontalMenuView:)] && [self.delegate customCollectionViewCellNibForHorizontalMenuView:self]) {
        [self.delegate setupCustomCell:cell forIndex:indexPath.item horizontalMenuView:self];
        return cell;
    }
    NSString *title = @"";
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(horizontalMenuView:titleForItemAtIndex:)]) {
        title = [self.dataSource horizontalMenuView:self titleForItemAtIndex:indexPath.row];
    }
    cell.menuTile.text = title;
    
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(horizontalMenuView:iconURLForItemAtIndex:)]) {
        NSURL *url = [self.dataSource horizontalMenuView:self iconURLForItemAtIndex:indexPath.row];
        if(self.defaultImage) {
            [cell.menuIcon sd_setImageWithURL:url placeholderImage:self.defaultImage];
        } else {
            [cell.menuIcon sd_setImageWithURL:url];
        }
    }else if (self.dataSource && [self.dataSource respondsToSelector:@selector(horizontalMenuView:localIconStringForItemAtIndex:)]){
        NSString *imageName = [self.dataSource horizontalMenuView:self localIconStringForItemAtIndex:indexPath.row];
        cell.menuIcon.image = [UIImage imageNamed:imageName];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(iconSizeForHorizontalMenuView:)]) {
        CGSize imageSize = [self.delegate iconSizeForHorizontalMenuView:self];
        [cell.menuIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(imageSize);
        }];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.delegate && [self.delegate respondsToSelector:@selector(horizontalMenuView:didSelectItemAtIndex:)]) {
        [self.delegate horizontalMenuView:self didSelectItemAtIndex:indexPath.row];
    }
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    [self setUpPageControl];
}
- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    if ([self.pageControl isKindOfClass:[EllipsePageControl class]]) {
        EllipsePageControl *pageControl = (EllipsePageControl *)_pageControl;
        pageControl.currentColor = currentPageDotColor;
    } else {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
    
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }else{
        EllipsePageControl *pageControl = (EllipsePageControl *)_pageControl;
        pageControl.otherColor = pageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    
    if (self.pageControlStyle != FMHorizontalMenuViewPageControlStyleAnimated) {
        self.pageControlStyle = FMHorizontalMenuViewPageControlStyleAnimated;
    }
    
    [self setCustomPageControlDotImage:currentPageDotImage isCurrentPageDot:YES];
}

- (void)setPageDotImage:(UIImage *)pageDotImage
{
    _pageDotImage = pageDotImage;
    
    if (self.pageControlStyle != FMHorizontalMenuViewPageControlStyleAnimated) {
        self.pageControlStyle = FMHorizontalMenuViewPageControlStyleAnimated;
    }
    
    [self setCustomPageControlDotImage:pageDotImage isCurrentPageDot:NO];
}

- (void)setCustomPageControlDotImage:(UIImage *)image isCurrentPageDot:(BOOL)isCurrentPageDot
{
    if (!image || !self.pageControl) return;
    
    if ([self.pageControl isKindOfClass:[EllipsePageControl class]]) {
        EllipsePageControl *pageControl = (EllipsePageControl *)_pageControl;
        pageControl.currentBkImg = image;
    }
}

-(NSInteger)numOfPage
{
    return [self.layout currentPageCount];
}

#pragma  mark EllipsePageControlDelegate。监听用户点击 (如果需要点击切换,如果将EllipsePageControl 中的userInteractionEnabled切换成YES或者注掉)
-(void)ellipsePageControlClick:(EllipsePageControl *)pageControl index:(NSInteger)clickIndex{
    CGPoint position = CGPointMake(self.frame.size.width * clickIndex, 0);
    [self.collectionView setContentOffset:position animated:YES];
}

@end
