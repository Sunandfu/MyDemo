//
//  SHTextView.h
//  SHTextView
//
//  Created by 宋浩文的pro on 16/4/12.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHTextView;

typedef enum
{
    ExtendUp,
    ExtendDown
}ExtendDirection;

@protocol SHTextViewDelegate <UITextViewDelegate>

// 监听输入框内的文字变化
- (void)SHTextView:(SHTextView *)SHTextView textDidChanged:(NSString *)text;

@end

@interface SHTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;

/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/** 占位文字的起始位置 */
@property (nonatomic, assign) CGPoint placeholderLocation;

/** textView是否可伸长 */
@property (nonatomic, assign) BOOL isCanExtend;

/** 伸长方向 */
@property (nonatomic, assign) ExtendDirection extendDirection;

/** 伸长限制行数 */
@property (nonatomic, assign) NSUInteger extendLimitRow;


@property (nonatomic, assign) id<SHTextViewDelegate> delegate;

@end
