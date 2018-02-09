/***************************************************************************************************
 **  Copyright © 2016年 Jinn Chang. All rights reserved.
 **  Giuhub: https://github.com/jinnchang
 **
 **  FileName: JinnPopMenu.m
 **  Description: 弹出菜单，依赖 Masonry 控件，支持各种界面的适配，包括旋转，支持各种样式自定义
 **
 **  History
 **  -----------------------------------------------------------------------------------------------
 **  Author: jinnchang
 **  Date: 16/4/28
 **  Version: 1.0.0
 **  Remark: Create
 **************************************************************************************************/

#import "JinnPopMenu.h"
#import "Masonry.h"

#define TITLE_FONT_SIZE 12
#define ANIMATION_DURATION 0.4f

#pragma mark -

/***************************************************************************************************
 ** JinnPopMenuItem
 **************************************************************************************************/

@interface JinnPopMenuItem ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, strong) UIColor  *selectedTitleColor;
@property (nonatomic, strong) UIImage  *icon;
@property (nonatomic, strong) UIImage  *selectedIcon;

@end

@implementation JinnPopMenuItem

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    return [self initWithTitle:title titleColor:titleColor selectedTitle:nil selectedTitleColor:nil icon:nil selectedIcon:nil];
}

- (instancetype)initWithIcon:(UIImage *)icon
{
    return [self initWithTitle:nil titleColor:nil selectedTitle:nil selectedTitleColor:nil icon:icon selectedIcon:nil];
}

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor icon:(UIImage *)icon
{
    return [self initWithTitle:title titleColor:titleColor selectedTitle:nil selectedTitleColor:nil icon:icon selectedIcon:nil];
}

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedTitle:(NSString *)selectedTitle selectedTitleColor:(UIColor *)selectedTitleColor
{
    return [self initWithTitle:title titleColor:titleColor selectedTitle:selectedTitle selectedTitleColor:selectedTitleColor icon:nil selectedIcon:nil];
}

- (instancetype)initWithIcon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon
{
    return [self initWithTitle:nil titleColor:nil selectedTitle:nil selectedTitleColor:nil icon:icon selectedIcon:selectedIcon];
}

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selectedTitle:(NSString *)selectedTitle selectedTitleColor:(UIColor *)selectedTitleColor icon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon
{
    self = [super init];
    
    if (self)
    {
        [self setTitle:title];
        [self setTitleColor:titleColor];
        [self setSelectedTitle:selectedTitle];
        [self setSelectedTitleColor:selectedTitleColor];
        [self setIcon:icon];
        [self setSelectedIcon:selectedIcon];
        [self initGui];
    }
    
    return self;
}

- (void)initGui
{
    if (self.title == nil)
    {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = self.icon;
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(self.icon.size.width, self.icon.size.height));
        }];
    }
    else if (self.icon == nil)
    {
        self.itemLabel = [[UILabel alloc] init];
        self.itemLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        self.itemLabel.text = self.title;
        self.itemLabel.textColor = self.titleColor;
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        self.itemLabel.clipsToBounds = YES;
        [self addSubview:self.itemLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
            make.size.mas_equalTo(self);
        }];
    }
    else
    {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = self.icon;
        self.itemLabel = [[UILabel alloc] init];
        self.itemLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        self.itemLabel.text = self.title;
        self.itemLabel.textColor = self.titleColor;
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.iconView];
        [self addSubview:self.itemLabel];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(self.icon.size.width, self.icon.size.width));
        }];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
}

- (void)setItemSelected:(BOOL)selected
{
    if (selected)
    {
        [self.iconView setImage:self.selectedIcon];
        [self.itemLabel setText:self.selectedTitle];
        [self.itemLabel setTextColor:self.selectedTitleColor];
    }
    else
    {
        [self.iconView setImage:self.icon];
        [self.itemLabel setText:self.title];
        [self.itemLabel setTextColor:self.titleColor];
    }
}

@end

#pragma mark -

/***************************************************************************************************
 ** JinnPopMenu
 **************************************************************************************************/

@interface JinnPopMenu ()

@property (nonatomic, strong) NSArray *popMenus;
@property (nonatomic, assign) NSInteger itemsCount;
@property (nonatomic, assign) NSInteger itemsLinesCount;
@property (nonatomic, assign) BOOL animated;

@end

@implementation JinnPopMenu

- (instancetype)initWithPopMenus:(NSArray *)popMenus
{
    self = [super init];
    
    if (self)
    {
        [self setPopMenus:popMenus];
        [self defaultSetting];
    }
    
    return self;
}

- (void)defaultSetting
{
    self.mode = JinnPopMenuModeNormal;
    self.backgroundStyle = JinnPopMenuBackgroundStyleSolidColor;
    self.showAnimation = JinnPopMenuAnimationZoom;
    self.dismissAnimation = JinnPopMenuAnimationFade;
    self.itemSize = CGSizeMake(50, 60);
    self.itemSpaceHorizontal = 30;
    self.itemSpaceVertical = 30;
    self.offset = 0;
    self.margin = CGPointMake(0, 0);
    self.maxItemNumEachLine = 3;
    self.shouldHideWhenItemSelected = NO;
    self.shouldHideWhenBackgroundTapped = NO;
    self.backgroundView = [[UIView alloc] init];
    self.bezelView = [[UIView alloc] init];
}

#pragma mark Public

- (void)showAnimated:(BOOL)animated
{
    [self setAnimated:animated];
    [self initData];
    [self createBackgroundView];
    [self createBezelView];
    [self createItems];
    
    if (animated)
    {
        switch (self.showAnimation)
        {
            case JinnPopMenuAnimationFade:
            {
                [self showAnimatedFade];
            }
                break;
            case JinnPopMenuAnimationZoom:
            {
                [self showAnimatedZoom];
            }
                break;
            default:
                break;
        }
    }
}

- (void)dismissAnimated:(BOOL)animated
{
    if (animated)
    {
        switch (self.dismissAnimation)
        {
            case JinnPopMenuAnimationFade:
            {
                [self dismissAnimatedFade];
            }
                break;
            case JinnPopMenuAnimationZoom:
            {
                [self dismissAnimatedZoom];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        [self removeFromSuperview];
    }
}

- (void)selectItemAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    
    for (int i = 0; i < self.itemsCount; i++)
    {
        JinnPopMenuItem *popMenu = self.popMenus[i];
        
        if (i == index)
        {
            [popMenu setItemSelected:YES];
        }
        else
        {
            [popMenu setItemSelected:NO];
        }
    }
}

#pragma mark Private

- (void)initData
{
    self.itemsCount = self.popMenus.count;
    self.itemsLinesCount = self.itemsCount % self.maxItemNumEachLine == 0 ? (self.itemsCount / self.maxItemNumEachLine) : (self.itemsCount / self.maxItemNumEachLine + 1);
}

- (void)createBackgroundView
{
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped)]];
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (void)createBezelView
{
    CGFloat bezelViewWidth = 2 * self.margin.x + self.itemSize.width * self.maxItemNumEachLine + self.itemSpaceHorizontal * (self.maxItemNumEachLine - 1);
    CGFloat bezelViewHeight = 2 * self.margin.y + self.itemSize.height * self.itemsLinesCount + self.itemSpaceVertical * (self.itemsLinesCount - 1);
    
    [self.bezelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped)]];
    [self addSubview:self.bezelView];
    [self.bezelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(self.offset);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(bezelViewWidth, bezelViewHeight));
    }];
}

- (void)createItems
{
    for (int i = 0; i < self.itemsCount; i++)
    {
        CGFloat xOffset;
        CGFloat yOffset;
        
        JinnPopMenuItem *popMenu = self.popMenus[i];
        [popMenu setTag:i];
        [popMenu addTarget:self action:@selector(popMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:popMenu];
        
        if (self.itemsLinesCount == 1)
        {
            xOffset = i * (self.itemSize.width + self.itemSpaceHorizontal) + self.itemSize.width / 2 - (self.itemSize.width * self.itemsCount + self.itemSpaceHorizontal * (self.itemsCount - 1)) / 2;
            yOffset = self.offset;
        }
        else
        {
            xOffset = (i % self.maxItemNumEachLine) * (self.itemSize.width + self.itemSpaceHorizontal) + self.itemSize.width / 2 - (self.itemSize.width * self.maxItemNumEachLine + self.itemSpaceHorizontal * (self.maxItemNumEachLine - 1)) / 2;
            yOffset = (i / self.maxItemNumEachLine) * (self.itemSize.height + self.itemSpaceVertical) + self.itemSize.height / 2 - (self.itemSize.height * self.itemsLinesCount + self.itemSpaceVertical * (self.itemsLinesCount - 1)) / 2 + self.offset;
        }
        
        [popMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(yOffset);
            make.centerX.equalTo(self).offset(xOffset);
            make.size.mas_equalTo(CGSizeMake(self.itemSize.width, self.itemSize.height));
        }];
    }
}

- (void)backgroundViewTapped
{
    if ([self.delegate respondsToSelector:@selector(backgroundViewDidTapped:)])
    {
        [self.delegate backgroundViewDidTapped:self];
    }
    
    if (self.shouldHideWhenBackgroundTapped)
    {
        [self dismissAnimated:NO];
    }
}

- (void)popMenuClicked:(UIButton *)sender
{
    self.selectedIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(itemSelectedAtIndex:popMenu:)])
    {
        [self.delegate itemSelectedAtIndex:self.selectedIndex popMenu:self];
    }
    
    if (self.mode == JinnPopMenuModeSegmentedControl)
    {
        for (int i = 0; i < self.itemsCount; i++)
        {
            JinnPopMenuItem *popMenu = self.popMenus[i];
            
            if (i == self.selectedIndex)
            {
                [popMenu setItemSelected:YES];
            }
            else
            {
                [popMenu setItemSelected:NO];
            }
        }
    }
    
    if (self.shouldHideWhenItemSelected)
    {
        [self dismissAnimated:NO];
    }
}

#pragma mark Animation

- (void)showAnimatedZoom
{
    for (int i = 0; i < self.itemsCount; i++)
    {
        JinnPopMenuItem *popMenu = self.popMenus[i];
        CGAffineTransform transform = CGAffineTransformMakeScale(0.1, 0.1);
        [popMenu setTransform:transform];
        [popMenu setAlpha:0];
        transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:12 options:UIViewAnimationOptionLayoutSubviews animations:^{
            [popMenu setTransform:transform];
            [popMenu setAlpha:1];
        } completion:nil];
    }
}

- (void)dismissAnimatedZoom
{
    for (int i = 0; i < self.itemsCount; i++)
    {
        JinnPopMenuItem *popMenu = self.popMenus[i];
        CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
        [popMenu setTransform:transform];
        [popMenu setAlpha:0];
        transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [popMenu setTransform:transform];
            [popMenu setAlpha:1];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)showAnimatedFade
{
    for (int i = 0; i < self.itemsCount; i++)
    {
        JinnPopMenuItem *popMenu = self.popMenus[i];
        [popMenu setAlpha:0];
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [popMenu setAlpha:1];
        } completion:nil];
    }
}

- (void)dismissAnimatedFade
{
    for (int i = 0; i < self.itemsCount; i++)
    {
        JinnPopMenuItem *popMenu = self.popMenus[i];
        [popMenu setAlpha:1];
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [popMenu setAlpha:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end