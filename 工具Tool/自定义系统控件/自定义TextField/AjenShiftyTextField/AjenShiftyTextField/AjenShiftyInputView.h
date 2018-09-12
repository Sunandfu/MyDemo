//
//  AjenShiftyInputView.h
//  AjenShiftyTextField
//
//  Created by Ajen on 2018/8/13.
//  Copyright © 2018年 Ajen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AjenShiftyInputView : UIView<UITextFieldDelegate>

///icon的imageView,外部可编辑,当前有一系列默认属性设置
@property(nonatomic,strong)UIImageView * iconImageView;

///icon的image,外部赋值
@property(nonatomic,strong)UIImage * iconImage;

///占位文本
@property(nonatomic,copy)NSString * placeholder;

///光标颜色
@property(nonatomic,strong)UIColor * cursorColor;

///边缘颜色
@property(nonatomic,strong)UIColor * borderLineColor;

///是否显示清除按钮
@property(nonatomic,assign)BOOL isShowClearButton;

///输入框,外部可编辑,当前有一系列默认属性设置
@property(nonatomic,strong)UITextField * textField;

///是否显示字数视图,默认YES
@property(nonatomic,assign)BOOL isShowWordCount;

///输入的文字最大数
@property(nonatomic,assign)NSInteger maxWordNumber;




///点击了视图开始编辑回调
@property (nullable, nonatomic, copy) void (^beginEditBlock)(AjenShiftyInputView * inputView,NSString * text);

///结束了编辑回调
@property (nullable, nonatomic, copy) void (^endEditBlock)(AjenShiftyInputView * inputView,NSString * text);

///文字正在编辑回调
@property (nullable, nonatomic, copy) void (^changeBlock)(AjenShiftyInputView * inputView,NSString * text);

///点击了"完成/done"键回调
@property (nullable, nonatomic, copy) void (^finishDoneBlock)(AjenShiftyInputView * inputView,NSString * text);

@end
