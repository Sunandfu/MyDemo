//
//  UIButton+SFAdd.h
//  TransferPlatform
//
//  Created by lurich on 2021/9/16.
//

// 用button的titleEdgeInsets和 imageEdgeInsets属性来实现button文字图片上下或者左右排列的
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SFBtnPosition) {
    SFBtnPositionImageLeft = 0,              //图片在左，文字在右，默认
    SFBtnPositionImageRight = 1,             //图片在右，文字在左
    SFBtnPositionImageTop = 2,               //图片在上，文字在下
    SFBtnPositionImageBottom = 3,            //图片在下，文字在上
};

@interface UIButton (SFAdd)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)sf_ImagePosition:(SFBtnPosition)postion spacing:(CGFloat)spacing;

/**
 *  倒计时按钮
 *  从高到低
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
 */
- (void)sf_startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color titleColor:(UIColor *)titleColor countTitleColor:(UIColor *)ctColor;
//计时  0 - timeLine 从低到高
- (void)sf_beginWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color titleColor:(UIColor *)titleColor countTitleColor:(UIColor *)ctColor;

//为按钮添加放大缩小的动画
- (void)sf_imgaeScale:(UIView *)view;

// 设置可点击范围到按钮边缘的距离
-(void)sf_setEnLargeEdge:(CGFloat)distance;

// 设置可点击范围到按钮上、右、下、左的距离
-(void)sf_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
