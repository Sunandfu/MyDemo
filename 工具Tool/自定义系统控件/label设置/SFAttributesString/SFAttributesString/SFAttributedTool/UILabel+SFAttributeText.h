//
//  UILabel+SFAttributeText.h
//  GameBox
//
//  Created by lurich on 2021/6/22.
//

#import <UIKit/UIKit.h>

@protocol SFAttributeTapActionDelegate <NSObject>
@optional
/**
 *  SFAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)sf_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end

@interface SFAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end





@interface UILabel (SFAttributeText)

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

@property (nonatomic, strong) UIColor *tapColor;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)sf_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)sf_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <SFAttributeTapActionDelegate> )delegate;

- (CGSize)sf_getAttributedStringSizeWithWidth:(CGFloat)width Height:(CGFloat)height;

@end

