//
//  WSTextField.h
//  封装输入框demo
//
//  Created by iMac on 16/8/25.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTextField : UIView
//文本框
@property (nonatomic,strong) UITextField *textField;

//注释信息
@property (nonatomic,copy) NSString *ly_placeholder;

//光标颜色
@property (nonatomic,strong) UIColor *cursorColor;

//注释普通状态下颜色
@property (nonatomic,strong) UIColor *placeholderNormalStateColor;

//编辑状态下颜色
@property (nonatomic,strong) UIColor *placeholderSelectStateColor;


@end
