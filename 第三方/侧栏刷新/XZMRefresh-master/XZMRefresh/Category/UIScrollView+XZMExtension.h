//
//  UIScrollView+UIScrollView_XZMExtension.h
//  XZMRefreshExample
//
//  Created by 谢忠敏 on 15/12/21.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XZMExtension)
@property (assign, nonatomic) CGFloat xzm_contentInsetTop;
@property (assign, nonatomic) CGFloat xzm_contentInsetBottom;
@property (assign, nonatomic) CGFloat xzm_contentInsetLeft;
@property (assign, nonatomic) CGFloat xzm_contentInsetRight;

@property (assign, nonatomic) CGFloat xzm_contentOffsetX;
@property (assign, nonatomic) CGFloat xzm_contentOffsetY;

@property (assign, nonatomic) CGFloat xzm_contentSizeWidth;
@property (assign, nonatomic) CGFloat xzm_contentSizeHeight;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com