//
//  UIView+ZHView.m
//  ZHView
//
//  Created by mac on 16/2/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIView+ZHView.h"

@implementation UIView (ZHView)

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center=self.center;
    center.x=centerX;
    self.center=center;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center=self.center;
    center.y=centerY;
    self.center=center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (NSString *)nameDescription{
    
    if ([self isMemberOfClass:[UIImageView class]]) {
        return @"UIView";
    }else if([self isMemberOfClass:[UILabel class]]){
        return @"UILabel";
    }else if([self isMemberOfClass:[UIButton class]]){
        return @"UIButton";
    }else if([self isMemberOfClass:[UICollectionView class]]){
        return @"UICollectionView";
    }else if([self isMemberOfClass:[UIView class]]){
        return @"UIView";
    }else if([self isMemberOfClass:[UISegmentedControl class]]){
        return @"UISegmentedControl";
    }else if([self isMemberOfClass:[UITextField class]]){
        return @"UITextField";
    }else if([self isMemberOfClass:[UITextView class]]){
        return @"UITextView";
    }else if([self isMemberOfClass:[UISlider class]]){
        return @"UISlider";
    }else if([self isMemberOfClass:[UISwitch class]]){
        return @"UISwitch";
    }else if([self isMemberOfClass:[UIActivityIndicatorView class]]){
        return @"UIActivityIndicatorView";
    }else if([self isMemberOfClass:[UIProgressView class]]){
        return @"UIProgressView";
    }else if([self isMemberOfClass:[UIPageControl class]]){
        return @"UIPageControl";
    }else if([self isMemberOfClass:[UIStepper class]]){
        return @"UIStepper";
    }else if([self isMemberOfClass:[UITableView class]]){
        return @"UITableView";
    }else if([self isMemberOfClass:[UITableViewCell class]]){
        return @"UITableViewCell";
    }else if([self isMemberOfClass:[UICollectionView class]]){
        return @"UICollectionView";
    }else if([self isMemberOfClass:[UICollectionViewCell class]]){
        return @"UICollectionViewCell";
    }else if([self isMemberOfClass:[UIScrollView class]]){
        return @"UIScrollView";
    }else if([self isMemberOfClass:[UIDatePicker class]]){
        return @"UIDatePicker";
    }else if([self isMemberOfClass:[UIAlertView class]]){
        return @"UIAlertView";
    }else if([self isMemberOfClass:[UIWebView class]]){
        return @"UIWebView";
    }else{
        return @"Unkown View";
    }
    
}

- (void)cornerRadius{
    [self cornerRadiusWithFloat:0 borderColor:nil borderWidth:0];
}
- (void)cornerRadiusWithFloat:(CGFloat)vaule{
    [self cornerRadiusWithFloat:vaule borderColor:nil borderWidth:0];
}
- (void)cornerRadiusWithBorderColor:(UIColor *)color borderWidth:(CGFloat)width{
    [self cornerRadiusWithFloat:0 borderColor:color borderWidth:width];
}
- (void)cornerRadiusWithFloat:(CGFloat)vaule borderColor:(UIColor *)color borderWidth:(CGFloat)width{
    if (vaule==0) {
        if(self.frame.size.height==0||self.frame.size.width==0){
            NSString *errorString=[self.nameDescription stringByReplacingOccurrencesOfString:@"UI" withString:@""];
            NSLog(@"调试:存在%@控件宽度或高度为 0 ,无法切成圆形",errorString);
        }else if(self.frame.size.height==self.frame.size.width){
            self.layer.cornerRadius=self.frame.size.height/2.0;
        }else{
            NSString *errorString=[self.nameDescription stringByReplacingOccurrencesOfString:@"UI" withString:@""];
            NSLog(@"调试:存在%@控件不是正方形,无法切成圆形",errorString);
        }
    }else{
        self.layer.cornerRadius=vaule;
    }
    
    if (color!=nil) {
        self.layer.borderColor=[color CGColor];
    }
    
    if(width!=0){
        self.layer.borderWidth=width;
    }
    
    self.layer.masksToBounds=YES;
}


//判断两个控件是否重叠
- (BOOL)interSectionWithOtherView:(UIView *)otherView{
    return CGRectIntersectsRect(self.frame, otherView.frame);
}
//返回两个控件的交集的Frame
- (CGRect)getCGRectInterSectionWithOtherView:(UIView *)otherView{
    return CGRectIntersection(self.frame, otherView.frame);
}

//为view添加点击手势
- (UITapGestureRecognizer *)addUITapGestureRecognizerWithTarget:(id)target withAction:(SEL)action{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled=YES;
    return tap;
}

//为view添加捏合手势
- (UIPinchGestureRecognizer *)addUIPinchGestureRecognizerWithTarget:(id)target withAction:(SEL)action{
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:pinch];
    self.userInteractionEnabled=YES;
    return pinch;
}

//为view添加旋转手势
- (UIRotationGestureRecognizer *)addUIRotationGestureRecognizerWithTarget:(id)target withAction:(SEL)action{
    UIRotationGestureRecognizer *rotation=[[UIRotationGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:rotation];
    self.userInteractionEnabled=YES;
    return rotation;
}

//为view添加拖动手势
- (UISwipeGestureRecognizer *)addUISwipeGestureRecognizerWithTarget:(id)target withAction:(SEL)action withDirection:(UISwipeGestureRecognizerDirection)direction{
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:target action:action];
    swipe.direction=direction;
    [self addGestureRecognizer:swipe];
    self.userInteractionEnabled=YES;
    return swipe;
}

//为view添加旋转手势
- (UIPanGestureRecognizer *)addUIPanGestureRecognizerWithTarget:(id)target withAction:(SEL)action withMinimumNumberOfTouches:(NSUInteger)minimumNumberOfTouches withMaximumNumberOfTouches:(NSUInteger)maximumNumberOfTouches{
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:target action:action];
    pan.minimumNumberOfTouches=minimumNumberOfTouches;
    pan.maximumNumberOfTouches=maximumNumberOfTouches;
    [self addGestureRecognizer:pan];
    self.userInteractionEnabled=YES;
    return pan;
}

//为view添加长按手势
- (UILongPressGestureRecognizer *)addUILongPressGestureRecognizerWithTarget:(id)target withAction:(SEL)action withMinimumPressDuration:(double)minimumPressDuration{
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:target action:action];
    longPress.minimumPressDuration=minimumPressDuration;
    [self addGestureRecognizer:longPress];
    self.userInteractionEnabled=YES;
    return longPress;
}

//为view添加长按手势示例代码
/*

//[self.imageView addUILongPressGestureRecognizerWithTarget:self withAction:@selector(longPress:) withMinimumPressDuration:0.5];
////长按后触发该方法
//-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
//        //        NSLog(@"长按事件开始");
//
//    }
//    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
//        //        NSLog(@"长按事件结束");
//    }
//}
*/

//为View添加抛光效果
- (void)addPolishingWithBackColor:(UIColor *)color{
    CALayer *layer = self.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    //底层绘制函数
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    //设置绘制的区域
    shineLayer.frame = self.layer.bounds;
    //设置过度色(这里绘制了五层)
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    //设置绘制色的均分位置
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    //添加绘制
    [self.layer addSublayer:shineLayer];
    [self setBackgroundColor:color];
    
    //判断自身控件是否是按钮,如果是得话,添加点击和弹起事件
    if([self isMemberOfClass:[UIButton class]]){
        
        //之所以不用手势,是因为手势只能添加一个,不能重复添加,否则相同的手势会被替换
        //而添加事件则不同,可以添加多个事件到事件链中
        
        [(UIButton *)self addTarget:self action:@selector(startPressedButton) forControlEvents:UIControlEventTouchDown];
        [(UIButton *)self addTarget:self action:@selector(endPressedButton) forControlEvents:UIControlEventTouchUpInside];
    }
}
//点击按下时发生的变化(背景颜色 与上面的那个抛光效果函数是匹配的,一般用于button按钮)
- (void)startPressedButton{
    UIColor *newColor;
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0, white = 0.0;
    if([self.backgroundColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        //获取背景颜色中的色调参数
        [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        [self.backgroundColor getWhite:&white alpha:&alpha];
        
        if(!(red + green + blue) && white){
            //白度减少0.2
            newColor = [UIColor colorWithWhite:white - 0.2 alpha:alpha];
        } else if(!(red + green + blue) && !white) {
            //白度增加0.2
            newColor = [UIColor colorWithWhite:white + 0.2 alpha:alpha];
        } else{
            //否则都减少0.2
            newColor = [UIColor colorWithRed:red - 0.2 green:green - 0.2 blue:blue - 0.2 alpha:alpha];
        }
    }
    self.backgroundColor = newColor;
}
- (void)endPressedButton{
    UIColor *newColor;
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0, white = 0.0;
    if([self.backgroundColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        //获取背景颜色中的色调参数
        [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        [self.backgroundColor getWhite:&white alpha:&alpha];
        
        if(!(red + green + blue) && white){
            //白度减加0.2
            newColor = [UIColor colorWithWhite:white + 0.2 alpha:alpha];
        } else if(!(red + green + blue) && !white) {
            //白度增少0.2
            newColor = [UIColor colorWithWhite:white - 0.2 alpha:alpha];
        } else{
            //否则都减加0.2
            newColor = [UIColor colorWithRed:red + 0.2 green:green + 0.2 blue:blue + 0.2 alpha:alpha];
        }
    }
    self.backgroundColor = newColor;
}

- (void)addConstraintsToSuperView:(UIView *)superView withLeft:(CGFloat)left withRight:(CGFloat)right withTop:(CGFloat)top withBottom:(CGFloat)bottom{
    self.translatesAutoresizingMaskIntoConstraints=NO;
    [superView addSubview:self];
    
    //右边约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:right*-1];
    
    //底部约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottom*-1];
    
    //顶部约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:top];
    
    //左边约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:left];
    
    
    //关联视图也需要添加以上约束
    [superView addConstraints:@[rightConstraint,bottomConstraint,leftConstraint,topConstraint]];
}


//为View添加左右晃动的效果,类似于密码输入错误后的效果
- (void)addShakerWithDuration:(NSTimeInterval)duration{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = self.transform.tx;
    
    animation.delegate = self;
    animation.duration = duration;
    animation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

-(UIViewController *)getViewController{
    for (UIView *view = self.superview; view; view = view.superview) {
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}
@end
