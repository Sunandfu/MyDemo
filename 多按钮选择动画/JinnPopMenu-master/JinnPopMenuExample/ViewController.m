//
//  ViewController.m
//  JinnPopMenuExample
//
//  Created by jinnchang on 16/4/28.
//  Copyright © 2016年 Jinn Chang. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "JinnPopMenu.h"

#define COLOR_ITEM [UIColor whiteColor]
#define COLOR_ITEM_SELECTED [UIColor yellowColor]
#define COLOR_BACKGROUND [UIColor colorWithWhite:0.1 alpha:1.000]

#define BASE_TAG 10000

@interface ViewController () <JinnPopMenuDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];
    [self initGui];
}

- (void)setup
{
    self.titles = @[@"删除", @"下载", @"编辑", @"信息", @"搜索", @"分享"];
    self.images = @[@"delete", @"download", @"edit", @"message", @"search", @"share"];
}

- (void)initGui
{
    UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [normalButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [normalButton setTitle:@"图标文本菜单" forState:UIControlStateNormal];
    [normalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [normalButton addTarget:self action:@selector(normalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalButton];
    [normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [labelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [labelButton setTitle:@"文本菜单" forState:UIControlStateNormal];
    [labelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [labelButton addTarget:self action:@selector(labelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:labelButton];
    [labelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [iconButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [iconButton setTitle:@"图标菜单" forState:UIControlStateNormal];
    [iconButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [iconButton addTarget:self action:@selector(iconButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconButton];
    [iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *segmentedContolButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [segmentedContolButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [segmentedContolButton setTitle:@"图文选项菜单" forState:UIControlStateNormal];
    [segmentedContolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [segmentedContolButton addTarget:self action:@selector(segmentedContolButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:segmentedContolButton];
    [segmentedContolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(50);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Private

/**
 *  修改图片颜色
 *
 *  @param color
 *  @param image
 *
 *  @return
 */
- (UIImage *)imageVithColor:(UIColor *)color image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Action

- (void)normalButtonClicked
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.titles.count; i++)
    {
        JinnPopMenuItem *popMenuItem = [[JinnPopMenuItem alloc] initWithTitle:self.titles[i]
                                                                   titleColor:COLOR_ITEM
                                                                         icon:[self imageVithColor:COLOR_ITEM image:[UIImage imageNamed:self.images[i]]]];
        [items addObject:popMenuItem];
    }
    
    JinnPopMenu *popMenu = [[JinnPopMenu alloc] initWithPopMenus:[items copy]];
    [popMenu setShouldHideWhenBackgroundTapped:YES];
    [popMenu.backgroundView setBackgroundColor:COLOR_BACKGROUND];
    [popMenu setDelegate:self];
    [self.view addSubview:popMenu];
    [popMenu showAnimated:YES];
    [popMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)labelButtonClicked
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.titles.count; i++)
    {
        JinnPopMenuItem *popMenuItem = [[JinnPopMenuItem alloc] initWithTitle:self.titles[i] titleColor:COLOR_BACKGROUND];
        [popMenuItem.itemLabel.layer setCornerRadius:40];
        [popMenuItem.itemLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
        [items addObject:popMenuItem];
    }
    
    JinnPopMenu *popMenu = [[JinnPopMenu alloc] initWithPopMenus:[items copy]];
    [popMenu setShouldHideWhenBackgroundTapped:YES];
    [popMenu.backgroundView setBackgroundColor:COLOR_BACKGROUND];
    [popMenu setItemSize:CGSizeMake(80, 80)];
    [popMenu setDelegate:self];
    [self.view addSubview:popMenu];
    [popMenu showAnimated:YES];
    [popMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)iconButtonClicked
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.titles.count; i++)
    {
        JinnPopMenuItem *popMenuItem = [[JinnPopMenuItem alloc] initWithIcon:[self imageVithColor:COLOR_BACKGROUND image:[UIImage imageNamed:self.images[i]]]];
        [items addObject:popMenuItem];
    }
    
    JinnPopMenu *popMenu = [[JinnPopMenu alloc] initWithPopMenus:[items copy]];
    [popMenu setMargin:CGPointMake(20, 20)];
    [popMenu setShouldHideWhenBackgroundTapped:YES];
    [popMenu.backgroundView setBackgroundColor:COLOR_BACKGROUND];
    [popMenu.bezelView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [popMenu.bezelView.layer setCornerRadius:30];
    [popMenu setDelegate:self];
    [self.view addSubview:popMenu];
    [popMenu showAnimated:YES];
    [popMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)segmentedContolButtonClicked
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.titles.count; i++)
    {
        JinnPopMenuItem *popMenuItem = [[JinnPopMenuItem alloc] initWithTitle:self.titles[i]
                                                                   titleColor:COLOR_ITEM
                                                                selectedTitle:self.titles[i]
                                                           selectedTitleColor:COLOR_ITEM_SELECTED
                                                                         icon:[self imageVithColor:COLOR_ITEM image:[UIImage imageNamed:self.images[i]]]
                                                                 selectedIcon:[self imageVithColor:COLOR_ITEM_SELECTED image:[UIImage imageNamed:self.images[i]]]];
        [items addObject:popMenuItem];
    }
    
    JinnPopMenu *popMenu = [[JinnPopMenu alloc] initWithPopMenus:[items copy]];
    [popMenu setMode:JinnPopMenuModeSegmentedControl];
    [popMenu setShouldHideWhenBackgroundTapped:YES];
    [popMenu.backgroundView setBackgroundColor:COLOR_BACKGROUND];
    [popMenu setDelegate:self];
    [popMenu setTag:BASE_TAG];
    [self.view addSubview:popMenu];
    [popMenu showAnimated:YES];
    [popMenu selectItemAtIndex:2];
    [popMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - JinnPopViewDelegate

- (void)itemSelectedAtIndex:(NSInteger)index popMenu:(JinnPopMenu *)popMenu
{
    NSLog(@"%d", (int)index);
    
    if (popMenu.tag != BASE_TAG)
    {
        [popMenu dismissAnimated:NO];
    }
}

@end