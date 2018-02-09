//
//  MSPadHorizonView.h
//  mushuIpad
//
//  Created by charles on 15/6/19.
//  Copyright (c) 2015年 PBA. All rights reserved.
//

#import "MSPadHorizonCell.h"

// 协议
@class MSPadHorizonView;
@protocol MSPadHorizonViewDelegate <UIScrollViewDelegate>
@required
- (NSUInteger)MSPadHorizonView:(MSPadHorizonView*)horizonView numberOfColsInSection:(NSUInteger)section;
- (MSPadHorizonCell*)MSPadHorizonView:(MSPadHorizonView*)horizonView cellForColAtIndexPath:(MPIndexPath*)indexPath;
- (CGFloat)MSPadHorizonView:(MSPadHorizonView*)horizonView widthForIndexPath:(MPIndexPath*)indexPath;
@optional
- (NSUInteger)numberOfSectionsInHorizonView:(MSPadHorizonView*)horizonView;
- (CGFloat)MSPadHorizonView:(MSPadHorizonView *)horizonView widthForHeaderInSection:(NSUInteger)section;
- (CGFloat)MSPadHorizonView:(MSPadHorizonView *)horizonView widthForFooterInSection:(NSUInteger)section;
- (UIView*)MSPadHorizonView:(MSPadHorizonView*)horizonView viewForHeaderInSection:(NSUInteger)section;
- (UIView*)MSPadHorizonView:(MSPadHorizonView*)horizonView viewForFooterInSection:(NSUInteger)section;

- (void)MSPadHorizonView:(MSPadHorizonView*)horizonView didSelectCell:(MSPadHorizonCell*)cell atIndexPath:(MPIndexPath*)indexPath;
@end

// 左右拉显示的视图 必须实现这些协议 来分别提供刷新时刻的动画
@protocol MSPadHorizonRefreshViewDelegate <NSObject>
@required
// 放开刷新...
- (void)readyForRefresh:(MSPadHorizonView*)horizonView;
// 正在加载中...
- (void)hasRefresh:(MSPadHorizonView*)horizonView;
// 结束刷新回响
- (void)endRefresh:(MSPadHorizonView*)horizonView;
@end

// 刷新的方向
typedef NS_ENUM (NSUInteger, MSPadHorizonRefreshDirection){
    MSPadHorizonRefreshDirectTop,
    MSPadHorizonRefreshDirectBottom
};
@protocol MSPadHorizonViewPullRefreshDelegate <NSObject>
// 开始左右拉刷新了
- (void)MSPadHorizonView:(MSPadHorizonView*)horizonView didRefresh:(MSPadHorizonRefreshDirection)direction;
@end

typedef NS_ENUM(NSUInteger, MSPadHorizonViewStyle) {
    MSPadHorizonViewStylePlain, MSPadHorizonViewStyleGrouped
};

typedef NS_ENUM(NSInteger, MSPadHorizonViewScrollPosition) {
    MSPadHorizonViewScrollPositionLeft,
    MSPadHorizonViewScrollPositionMiddle,
    MSPadHorizonViewScrollPositionRight
};

@interface MSPadHorizonView : UIScrollView
@property (nonatomic, readonly) MSPadHorizonViewStyle style;
@property (nonatomic, weak) id<MSPadHorizonViewDelegate> horizonDelegate; // 这个最重要
@property (nonatomic, assign) NSUInteger numberOfSections;
@property (nonatomic, assign) CGFloat colWidth;
@property (nonatomic, assign) CGFloat cellSpacing; // cell的间隔，默认是1.0

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

- (instancetype)initWithFrame:(CGRect)frame style:(MSPadHorizonViewStyle)style;
/**
 * 重载(并结束刷新)，如果需要先结束刷新再reload，那么只调用这个即可，如果先finishRefresh再调用效果会有点问题
 */
- (void)reloadData;
/**
 * 如果identifier为空那么会取默认值
 */
- (id)horizonReusableCellWithIdentifier:(NSString*)identifier;

- (MSPadHorizonCell*)cellForColAtIndexPath:(MPIndexPath*)indexPath;

- (NSArray*)visibleCells;

- (NSArray*)indexPathsForVisibleCols;

- (void)scrollToColAtIndexPath:(MPIndexPath *)indexPath atScrollPosition:(MSPadHorizonViewScrollPosition)scrollPosition animated:(BOOL)animated;

@property (nonatomic, weak) id<MSPadHorizonViewPullRefreshDelegate> pullRefreshDelegate; // 开启内置左右拉刷新
@property (nonatomic, assign) CGFloat refreshHeaderOffset; // 多少偏移量来didRefresh
@property (nonatomic, assign) CGFloat refreshFooterOffset;
@property (nonatomic, strong) UIView<MSPadHorizonRefreshViewDelegate> *refreshHeader;
@property (nonatomic, strong) UIView<MSPadHorizonRefreshViewDelegate> *refreshFooter;

- (void)finishRefresh;
@end
