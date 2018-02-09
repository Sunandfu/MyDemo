//
//  PPScroll.h
//  PPScroll
//  项目地址：https://github.com/Fanish/PPScroll-OC
//  Created by Charlie C on 15/8/29.
//  Copyright (c) 2015年 Charlie C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PPScroll;

@protocol PPScrollDelegate <NSObject>

@optional
//代理
- (void)scroll:(PPScroll *)scroll selectedIndexDic:(NSMutableDictionary *)selectedIndexDic;//所有已选择的index
- (void)scroll:(PPScroll *)scroll index:(NSInteger)index;//目标行的index
@end

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface PPScroll : UIView <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readwrite, strong) id delegate;
@property (nonatomic) BOOL shouldUpdate;
//UI属性
@property (nonatomic, readwrite, strong) UIColor *textColor_n;//未选择字体颜色
@property (nonatomic, readwrite, strong) UIColor *textColor_h;//已选择字体颜色
@property (nonatomic, readwrite, strong) UIFont *font;//字体
@property (nonatomic, readwrite, strong) UIColor *separatorLineColor;//分割线颜色
@property (nonatomic, readwrite, strong) UIColor *bgColor;//背景颜色
@property (nonatomic, readwrite, strong) UIColor *bannerColor;//选择条颜色
//行数和列数
@property (nonatomic) float lineNum;
@property (nonatomic) float columnNum;
//方法
- (void)refreshTableWithArr:(NSMutableArray *)arr;
@end

