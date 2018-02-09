//
//  RSPageControl.h
//  
//
//  Created by hehai on 2016/5/28.
//  Copyright (c) 2016年 hehai. All rights reserved.
//  GitHub:https://github.com/riversea2015
//

/**
 *  自定义PageContrl控件，主要功能：
 *  1.实现了setCurrentPage事件
 *  2.dot点击事件
 *  注：如果要使用dot的点击事件，需使用 RSPageControlDelegate
 */

#import <UIKit/UIKit.h>

@protocol RSPageControlDelegate <NSObject>

/**
 *  点击具体的 dot 时，调用此方法
 *
 *  @param index 点的下标
 */
 @optional
- (void)rs_pageControlDidStopAtIndex:(NSInteger)index;

@end

@interface RSPageControl : UIView

/**
 *  代理对象
 */
@property (nonatomic , weak) id<RSPageControlDelegate> delegate;
/**
 *  总页数
 */
@property (nonatomic , assign)NSInteger pageNumbers;
/**
 *  当前页码
 */
@property (nonatomic , assign)NSInteger currentPage;

/**
 *  创建方法
 *
 *  @param frame   frame
 *  @param nImage  正常状态的dot图片
 *  @param hImage  选中状态的dot图片
 *  @param pageNum 总页数:可在此传0，后续单独设置，如:self.pageNumbers = xxx
 *  @param length  单个dot图片长度
 *  @param height  单个dot图片高度
 *  @param gap     dot图片间距
 *
 *  @return RSPageControl对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                  normalImage:(UIImage *)nImage
             highlightedImage:(UIImage *)hImage
                   dotsNumber:(NSInteger)pageNum
                    dotLength:(CGFloat)length
                    dotHeight:(CGFloat)height
                       dotGap:(CGFloat)gap;

@end
