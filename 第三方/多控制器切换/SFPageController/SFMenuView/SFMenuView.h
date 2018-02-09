//
//  SFMenuView.h
//  SFPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFMenuView;
@class SFMenuItem;
typedef enum {
    SFMenuViewStyleDefault,     // 默认
    SFMenuViewStyleLine,        // 带下划线 (若要选中字体大小不变，设置选中和非选中大小一样即可)
    SFMenuViewStyleFoold,       // 涌入效果 (填充)
    SFMenuViewStyleFooldHollow, // 涌入效果 (空心的)
} SFMenuViewStyle;

@protocol SFMenuViewDelegate <NSObject>
@optional
- (void)menuView:(SFMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex;
- (CGFloat)menuView:(SFMenuView *)menu widthForItemAtIndex:(NSInteger)index;
- (CGFloat)menuView:(SFMenuView *)menu itemMarginAtIndex:(NSInteger)index;
@end

@interface SFMenuView : UIView
@property (nonatomic, assign) CGFloat progressHeight;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) SFMenuViewStyle style;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, weak) id<SFMenuViewDelegate> delegate;
@property (nonatomic, copy) NSString *fontName;

- (instancetype)initWithFrame:(CGRect)frame buttonItems:(NSArray *)items backgroundColor:(UIColor *)bgColor norSize:(CGFloat)norSize selSize:(CGFloat)selSize norColor:(UIColor *)norColor selColor:(UIColor *)selColor;
- (void)slideMenuAtProgress:(CGFloat)progress;
- (void)selectItemAtIndex:(NSInteger)index;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com