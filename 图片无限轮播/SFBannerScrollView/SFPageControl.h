//
//  TAPageControl.h
//  AdDemo
//
//  Created by lurich on 2021/6/11.
//

#import <UIKit/UIKit.h>

@protocol SFPageControlDelegate;


@interface YXAbstractDotView : UIView

/**
 *  A method call let view know which state appearance it should take. Active meaning it's current page. Inactive not the current page.
 *
 *  @param active BOOL to tell if view is active or not
 */
- (void)changeActivityState:(BOOL)active;

@end

@interface YXAnimatedDotView : YXAbstractDotView

@property (nonatomic, strong) UIColor *dotColor;

@end

@interface YXDotView : YXAbstractDotView

@end

@interface SFPageControl : UIControl

/**
 *  The Class of your custom UIView, make sure to respect the TAAbstractDotView class.
 */
@property (nonatomic) Class dotViewClass;

/**
 *  UIImage to represent a dot.
 */
@property (nonatomic) UIImage *dotImage;

/**
 *  UIImage to represent current page dot.
 */
@property (nonatomic) UIImage *currentDotImage;

/**
 *  Dot size for dot views. Default is 8 by 8.
 */
@property (nonatomic) CGSize dotSize;

@property (nonatomic, strong) UIColor *dotColor;

/**
 *  Spacing between two dot views. Default is 8.
 */
@property (nonatomic) NSInteger spacingBetweenDots;

/**
 * Delegate for TAPageControl
 */
@property(nonatomic,assign) id<SFPageControlDelegate> delegate;

/**
 *  Number of pages for control. Default is 0.
 */
@property (nonatomic) NSInteger numberOfPages;

/**
 *  Current page on which control is active. Default is 0.
 */
@property (nonatomic) NSInteger currentPage;

/**
 *  Hide the control if there is only one page. Default is NO.
 */
@property (nonatomic) BOOL hidesForSinglePage;

/**
 *  Let the control know if should grow bigger by keeping center, or just get longer (right side expanding). By default YES.
 */
@property (nonatomic) BOOL shouldResizeFromCenter;

/**
 *  Return the minimum size required to display control properly for the given page count.
 *
 *  @param pageCount Number of dots that will require display
 *
 *  @return The CGSize being the minimum size required.
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end

@protocol SFPageControlDelegate <NSObject>

@optional

- (void)ddgPageControl:(SFPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end
