//
//  SFCircleProgreeView.h
//  scrollerViewDemo
//
//  Created by 史岁富 on 2018/9/7.
//  Copyright © 2018年 xiaofu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCircleProgreeView : UIView

@property (nonatomic,assign) CGFloat borderWidth;//圆环粗细
@property (nonatomic,assign) CFTimeInterval animationDuration;//动画时间
@property (nonatomic,strong) UIColor  *defaultBorderColor;//圆环颜色
@property (nonatomic,strong) UIImage  *backgroundImage;//圆环图片
@property (nonatomic,strong) UIColor  *defaultBackColor;//圆环背景颜色
@property (nonatomic,assign) BOOL isHaveBackProgress;//是否有背景圆环
@property (nonatomic,assign) BOOL isHaveShadow;//是否有阴影

- (void)DrowCirleWithProgress:(CGFloat)theProgress Animation:(BOOL)isAnimation;

@end
