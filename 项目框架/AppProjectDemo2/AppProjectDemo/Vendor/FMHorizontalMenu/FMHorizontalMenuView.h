//
//  FMHorizontalMenuView.h
//  YFMHorizontalMenu
//
//  Created by FM on 2018/11/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EllipsePageControl.h"


typedef enum {
    FMHorizontalMenuViewPageControlAlimentRight,    //右上角靠右
    FMHorizontalMenuViewPageControlAlimentCenter,   //下面居中
} FMHorizontalMenuViewPageControlAliment;

typedef enum {
    FMHorizontalMenuViewPageControlStyleClassic,    //系统自带经典样式
    FMHorizontalMenuViewPageControlStyleAnimated,   //动画效果
    FMHorizontalMenuViewPageControlStyleNone,       //不显示pageControl
}FMHorizontalMenuViewPageControlStyle;


@class FMHorizontalMenuView;

@protocol FMHorizontalMenuViewDataSource <NSObject>
@optional

/**
 数据的num

 @param horizontalMenuView 控件本身
 @return 返回数量
 */
- (NSInteger)numberOfItemsInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView;
/**
每个菜单的title

 @param horizontalMenuView 控件本身
 @param index 当前下标
 @return 返回标题
 */
- (NSString *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView titleForItemAtIndex:(NSInteger )index;

/**
 每个菜单的图片地址路径

 @param horizontalMenuView 当前控件
 @param index 当前下标
 @return 返回图片的URL路径
 */
- (NSURL *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView iconURLForItemAtIndex:(NSInteger)index;

- (NSString *)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView localIconStringForItemAtIndex:(NSInteger)index;

@end


@protocol FMHorizontalMenuViewDelegate <NSObject>
@optional

/**
 设置每页的行数,默认 2
 
 @param horizontalMenuView 当前控件
 @return 行数
 */
- (NSInteger)numOfRowsPerPageInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView;

/**
 设置每页的列数 默认 4
 
 @param horizontalMenuView 当前控件
 @return 列数
 */
- (NSInteger)numOfColumnsPerPageInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView;
/**
 菜单中图片的尺寸

 @param horizontalMenuView 当前控件
 @return 图片的尺寸
 */
- (CGSize)iconSizeForHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView;

/**
 返回当前页数的pageControl的颜色

 @param horizontalMenuView 当前控件
 @return 颜色
 */
- (UIColor *)colorForCurrentPageControlInHorizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView;
/**
 当选项被点击回调
 
 @param horizontalMenuView 当前控件
 @param index 点击下标
 */
- (void)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView didSelectItemAtIndex:(NSInteger)index;

- (void)horizontalMenuView:(FMHorizontalMenuView *)horizontalMenuView WillEndDraggingWithVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

// 不需要自定义轮播cell的请忽略以下两个的代理方法

// ========== 轮播自定义cell ==========

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForHorizontalMenuView:(FMHorizontalMenuView *)view;
/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib。 */
- (UINib *)customCollectionViewCellNibForHorizontalMenuView:(FMHorizontalMenuView *)view;

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index horizontalMenuView:(FMHorizontalMenuView *)view;
@end

@interface FMHorizontalMenuView : UIView

@property (nonatomic,weak) id<FMHorizontalMenuViewDataSource> dataSource;

@property (nonatomic,weak) id<FMHorizontalMenuViewDelegate>   delegate;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic,assign) FMHorizontalMenuViewPageControlStyle pageControlStyle;
/** 分页控件位置 */
@property (nonatomic,assign) FMHorizontalMenuViewPageControlAliment pageControlAliment;

@property (strong, nonatomic)   UIImage                         *defaultImage;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic,assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;

/** 圆点之间的距离 默认 10*/
@property (nonatomic, assign) CGFloat controlSpacing;
/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;
/**
 刷新
 */
- (void)reloadData;
/**
 几页
 */
-(NSInteger)numOfPage;


















@end
