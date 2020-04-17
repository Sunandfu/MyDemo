//
//  UILabel+SFAdd.h
//  SFLabelDemo
//
//  Created by 刘鑫 on 16/4/13.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SFAdd)
/**
 *  字间距
 */
@property (nonatomic,assign)CGFloat characterSpace;

/**
 *  行间距
 */
@property (nonatomic,assign)CGFloat lineSpace;

/**
 *  是否首行缩进两个字
 */
@property (nonatomic, assign) CGFloat firstLineHeadIndent;

/**
 *  关键字
 */
@property (nonatomic,copy)NSString *keywords;
@property (nonatomic,strong)UIFont *keywordsFont;
@property (nonatomic,strong)UIColor *keywordsColor;

/**
 *  下划线
 */
@property (nonatomic,copy)NSString *underlineStr;
@property (nonatomic,strong)UIColor *underlineColor;

/**
 *  计算label宽高，必须调用
 *
 *  @param maxWidth 最大宽度
 *
 *  @return label的rect
 */
- (CGSize)getLableRectWithMaxWidth:(CGFloat)maxWidth;
@end
