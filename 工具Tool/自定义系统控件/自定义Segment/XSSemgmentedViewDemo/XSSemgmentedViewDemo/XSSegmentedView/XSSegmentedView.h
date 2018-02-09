//
//  XSSegmentedView.h
//
//
//  Created by Xaofly Sho on 2016.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#pragma mark - 说明
/*
 使用说明：
 初始化：
 可以在代码中通过alloc-init的方法初始化；
 例如：
 //初始化
 self.segmentedView = [[XSSegmentedView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
 //设置标题
 [self.segmentedView setTitles:@[@"消息",@"电话",@"视频",@"空间",@"圈子"]];
 或者：
 //初始化并设置标题
 self.segmentedView = [[XSSegmentedView alloc]initWithFrame:CGRectMake(0, 0, 200, 44) titles:@[@"消息",@"电话",@"视频",@"空间",@"游戏"]];
 
 或者在Xib（Storyboard）中拖拽View，设置继承自 XSSegmentedView 类。
 在Xib（Storyboard）中可设置TintColor，改变主体颜色。
 
 设置代理：
 代码与Xib（Storyboard）均使用
 self.segmentedView.delegate = self;
 设置代理
 
 代理方法：
 提供
 - (void)xsSegmentedView:(XSSegmentedView *)XSSegmentedView selectTitleInteger:(NSInteger)integer;
 - (BOOL)xsSegmentedView:(XSSegmentedView *)XSSegmentedView didSelectTitleInteger:(NSInteger)integer;
 代理方法，
 具体功能见代码注释
 */

#pragma mark -

#import <UIKit/UIKit.h>

@protocol XSSegmentedViewDelegate;

@interface XSSegmentedView : UIView

#pragma mark - 属性
//标题数组
@property (nonatomic, copy) NSArray *titles;
//未选中文字、边框、滑块颜色
@property (nonatomic, strong) UIColor *textColor;
//背景、选中文字颜色，当设置为透明时，选中文字为白色
@property (nonatomic, strong) UIColor *viewColor;
//选中的标题
@property (nonatomic) NSInteger selectNumber;

#pragma mark - 方法
/*
 初始化方法
 设置标题
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

/*
 设置标题
 */
- (void)setTitles:(NSArray *)titles;

/*
 设置选中的标题
 超出范围，则为最后一个标题
 
 或者使用隐藏的
 - (void)setSelectNumber:(NSInteger)selectNumber
 方法，默认无动画效果。
 */
- (void)setSelectNumber:(NSInteger)selectNumber animate:(BOOL)animate;

#pragma mark - 代理

@property (nonatomic, weak) id <XSSegmentedViewDelegate> delegate;

@end

@protocol XSSegmentedViewDelegate <NSObject>

@optional

/*
 当滑动XSSegmentedView滑块时，或者XSSegmentedView被点击时，会调用此方法。
 */
- (void)xsSegmentedView:(XSSegmentedView *)XSSegmentedView selectTitleInteger:(NSInteger)integer;

/*
 是否允许被选中
 返回YES可以被选中
 返回NO不可以被选中
 */
- (BOOL)xsSegmentedView:(XSSegmentedView *)XSSegmentedView didSelectTitleInteger:(NSInteger)integer;

@end