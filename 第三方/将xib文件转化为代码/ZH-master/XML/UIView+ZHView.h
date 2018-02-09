//
//  UIView+ZHView.h
//  ZHView
//
//  Created by mac on 16/2/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHView)
//一开始我以为这样是不行的,因为UIView中里面自带这些属性,但是这些属性可以生成getter方法和setter方法,调用这些方法就可以实现自己想实现的方法

//但是,千万不能有本身自带的属性,否则会造成死循环
//比如说UIView本身有frame属性,就不能再添加frame了

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic)CGFloat centerX;
@property (assign, nonatomic)CGFloat centerY;
@property (assign, nonatomic,readonly)CGFloat minX;
@property (assign, nonatomic,readonly)CGFloat minY;
@property (assign, nonatomic,readonly)CGFloat maxX;
@property (assign, nonatomic,readonly)CGFloat maxY;

@property (nonatomic,copy,readonly)NSString *nameDescription;

//给控件设置成圆角
- (void)cornerRadius;
- (void)cornerRadiusWithFloat:(CGFloat)vaule;
- (void)cornerRadiusWithBorderColor:(UIColor *)color borderWidth:(CGFloat)width;
- (void)cornerRadiusWithFloat:(CGFloat)vaule borderColor:(UIColor *)color borderWidth:(CGFloat)width;

/**判断两个控件是否重叠*/
- (BOOL)interSectionWithOtherView:(UIView *)otherView;
/**返回两个控件的交集的Frame*/
- (CGRect)getCGRectInterSectionWithOtherView:(UIView *)otherView;

/**为view添加点击手势*/
- (UITapGestureRecognizer *)addUITapGestureRecognizerWithTarget:(id)target withAction:(SEL)action;

//为view添加捏合手势
- (UIPinchGestureRecognizer *)addUIPinchGestureRecognizerWithTarget:(id)target withAction:(SEL)action;

//为view添加旋转手势
- (UIRotationGestureRecognizer *)addUIRotationGestureRecognizerWithTarget:(id)target withAction:(SEL)action;

//为view添加拖动手势
- (UISwipeGestureRecognizer *)addUISwipeGestureRecognizerWithTarget:(id)target withAction:(SEL)action withDirection:(UISwipeGestureRecognizerDirection)direction;

//为view添加旋转手势
- (UIPanGestureRecognizer *)addUIPanGestureRecognizerWithTarget:(id)target withAction:(SEL)action withMinimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches withMaximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches;

//为view添加长按手势
- (UILongPressGestureRecognizer *)addUILongPressGestureRecognizerWithTarget:(id)target withAction:(SEL)action withMinimumPressDuration:(double)minimumPressDuration;

/**为View添加抛光效果*/
- (void)addPolishingWithBackColor:(UIColor *)color;

/**将本身的View添加到父视图中,并且以父视图为参考线添加约束*/
- (void)addConstraintsToSuperView:(UIView *)superView withLeft:(CGFloat)left withRight:(CGFloat)right withTop:(CGFloat)top withBottom:(CGFloat)bottom;

//为View添加左右晃动的效果,类似于密码输入错误后的效果
- (void)addShakerWithDuration:(NSTimeInterval)duration;

/**获取ViewController*/
-(UIViewController *)getViewController;
@end