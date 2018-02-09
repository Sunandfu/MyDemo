//
//  CYNavigationConfig.h
//  JKSDoctor
//
//  Created by 张 春雨 on 2017/5/4.
//  Copyright © 2017年 张春雨. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIPanGestureRecognizer *(^backBlock)(void);

@interface CYNavigationConfig : NSObject
/** bar的高度 */
@property(assign , nonatomic) CGFloat height;
/** bar的背景颜色 */
@property(strong , nonatomic) UIColor *backgroundColor;
/** 是否存在bar底部分割线 */
@property(assign , nonatomic) BOOL haveBorder;
/** bar底部分割线的高度 */
@property(assign , nonatomic) CGFloat borderHeight;
/** bar的底部分割线颜色 */
@property(strong , nonatomic) UIColor *bordergColor;
/** bar上的字体颜色 */
@property(strong , nonatomic) UIColor *fontColor;
/** 默认返回图标 */
@property (nonatomic,strong) UIImage *defaultBackImage;
/** 左按钮图标颜色(缺省的话将和字体颜色一致) */
@property (nonatomic,strong) UIColor *leftBtnImageColor;
/** 右按钮图标颜色(缺省的话将和字体颜色一致) */
@property (nonatomic,strong) UIColor *rightBtnImageColor;
/** 标题字体 */
@property(strong , nonatomic) UIFont *titleFont;
/** 其他字体 */
@property(strong , nonatomic) UIFont *outherFont;
/** 返回拖动手势(默认为左侧侧滑) */
@property (nonatomic,strong) backBlock backGesture;
/** 过渡动画类型 */
@property (nonatomic,assign) Class transitionAnimationClass;

/**
 *  外观配置的单例对象
 */
+ (instancetype)shared;
@end
