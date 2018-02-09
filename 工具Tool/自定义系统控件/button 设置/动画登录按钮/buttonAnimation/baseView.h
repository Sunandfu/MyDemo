//
//  baseView.h
//  zongjie
//
//  Created by 黄鑫 on 16/4/14.
//  Copyright © 2016年 hx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseView : UIView

/** 等待圆圈线宽 */
@property (nonatomic) CGFloat lineWidth;

/** 是否隐藏按钮没点击时的样子 */
@property (nonatomic) BOOL hidesWhenStopped;

/** 动画的定时器 */
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

/** 判断当前动画属性 */
@property (nonatomic, readonly) BOOL isAnimating;

/** 启动和停止动画的方法 */
- (void)setAnimating:(BOOL)animate;

/** 开始动画 */
- (void)startAnimating;

/** 停止动画 */
- (void)stopAnimating;

@end
