/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnPopMenu.h
 **  Description: 弹出菜单，依赖 Masonry 控件，支持各种界面的适配，包括旋转，支持各种样式自定义
 **
 **  History
 **  -----------------------------------------------------------------------------------------------
 **  Author: jinnchang
 **  Date: 16/4/28
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  菜单样式
 */
typedef NS_ENUM(NSInteger, JinnPopMenuMode)
{
    /**
     *  普通菜单
     */
    JinnPopMenuModeNormal,
    
    /**
     *  选项卡菜单
     */
    JinnPopMenuModeSegmentedControl
};

/**
 *  背景风格
 */
typedef NS_ENUM(NSInteger, JinnPopMenuBackgroundStyle)
{
    JinnPopMenuBackgroundStyleSolidColor
};

/**
 *  动画
 */
typedef NS_ENUM(NSInteger, JinnPopMenuAnimation)
{
    JinnPopMenuAnimationFade,
    JinnPopMenuAnimationZoom
};

#pragma mark - 

/***************************************************************************************************
 ** JinnPopMenuItem
 **************************************************************************************************/

@interface JinnPopMenuItem : UIButton

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
- (instancetype)initWithIcon:(UIImage *)icon;
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor icon:(UIImage *)icon;
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedTitle:(NSString *)selectedTitle selectedTitleColor:(UIColor *)selectedTitleColor;
- (instancetype)initWithIcon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedTitle:(NSString *)selectedTitle selectedTitleColor:(UIColor *)selectedTitleColor icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *itemLabel;

- (void)setItemSelected:(BOOL)selected;

@end

#pragma mark -

/***************************************************************************************************
 ** JinnPopMenuDelegate
 **************************************************************************************************/

@class JinnPopMenu;

@protocol JinnPopMenuDelegate <NSObject>

- (void)itemSelectedAtIndex:(NSInteger)index popMenu:(JinnPopMenu *)popMenu;

@optional

- (void)backgroundViewDidTapped:(JinnPopMenu *)popMenu;

@end

#pragma mark -

/***************************************************************************************************
 ** JinnPopMenu
 **************************************************************************************************/

@interface JinnPopMenu : UIView

@property (nonatomic, weak) id<JinnPopMenuDelegate> delegate;

/**
 *  控件样式，默认JinnPopMenuModeMenu
 */
@property (nonatomic, assign) JinnPopMenuMode mode;

/**
 *  背景样式，默认JinnPopMenuBackgroundStyleSolidColor
 */
@property (nonatomic, assign) JinnPopMenuBackgroundStyle backgroundStyle;

/**
 *  显示动画类型，默认:JinnPopMenuAnimationZoom
 */
@property (nonatomic, assign) JinnPopMenuAnimation showAnimation;

/**
 *  隐藏动画类型，默认:JinnPopMenuAnimationFade
 */
@property (nonatomic, assign) JinnPopMenuAnimation dismissAnimation;

/**
 *  菜单大小，默认:(50,60)
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 *  菜单横向间距，默认:30
 */
@property (nonatomic, assign) CGFloat itemSpaceHorizontal;

/**
 *  菜单纵向间距，默认:30
 */
@property (nonatomic, assign) CGFloat itemSpaceVertical;

/**
 *  边框视图bezelView与背景视图backgroundView的纵向偏移，默认:0
 */
@property (nonatomic, assign) CGFloat offset;

/**
 *  边框视图bezelView与菜单的边距，默认:(0,0)
 */
@property (nonatomic, assign) CGPoint margin;

/**
 *  每行最多菜单数，默认:3
 */
@property (nonatomic, assign) NSInteger maxItemNumEachLine;

/**
 *  点击背景区域是否自动隐藏视图，默认:NO
 */
@property (nonatomic, assign) BOOL shouldHideWhenBackgroundTapped;

/**
 *  菜单选择时是否自动隐藏视图，默认:NO
 */
@property (nonatomic, assign) BOOL shouldHideWhenItemSelected;

/**
 *  边框视图
 */
@property (nonatomic, strong) UIView *bezelView;

/**
 *  背景视图
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 *  当前选中的菜单序号
 */
@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithPopMenus:(NSArray *)popMenus;

/**
 *  弹出视图
 */
- (void)showAnimated:(BOOL)animated;

/**
 *  隐藏视图
 */
- (void)dismissAnimated:(BOOL)animated;

/**
 *  选中相应序号的菜单
 */
- (void)selectItemAtIndex:(NSInteger)index;

@end