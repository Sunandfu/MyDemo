//
//  UIScrollView+Category.h
//  catergory
//
//  Created by No on 16/2/23.
//  Copyright © 2016年 com.beauty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Category)
/**
 *  带动画滚动到最上部
 */
- (void)scrollToTop;

/**
 *  带动画滚动到底部
 */
- (void)scrollToBottom;

/**
 *  带动画滚动到左边
 */
- (void)scrollToLeft;

/**
 *  带动画滚动到右边
 */
- (void)scrollToRight;

/**
 *  滚动到最上部
 */
- (void)scrollToTopAnimated:(BOOL)animated;

/**
 *  滚动到最底部
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 *  滚动到最左边
 */
- (void)scrollToLeftAnimated:(BOOL)animated;

/**
 *  滚动到最有右边
 */
- (void)scrollToRightAnimated:(BOOL)animated;
@end
