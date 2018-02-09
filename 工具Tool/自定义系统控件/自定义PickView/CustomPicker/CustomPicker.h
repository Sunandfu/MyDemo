//
//  CustomPicker.h
//  MyPickerViewController
//
//  Created by 常新 顾 on 13-4-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomPicker : NSObject
{
    UIPickerView     *_pickerView;
    UITextField      *_textField;
    UIView           *_maskView;    //黑色的面罩
    
    __unsafe_unretained id          _delegate;
}
@property (nonatomic,retain) UIPickerView  *pickerView;
@property (nonatomic,retain) UITextField   *textField;
@property (nonatomic,retain) UIView        *maskView;
@property (nonatomic,assign) id            delegate;

+ (CustomPicker *)sharedInstance;

- (void)show;

- (void)dismiss;


@end

@protocol CustomPickerDelegate <NSObject>

- (void)finishChoose:(CustomPicker *)myPicker;
/*
 ***************代码示例*****************
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 CustomPicker *customPicker = [CustomPicker sharedInstance];
 customPicker.pickerView.backgroundColor = [UIColor whiteColor];
 customPicker.delegate = self;
 //默认选中第零行
 [customPicker.pickerView selectRow:0 inComponent:0 animated:YES];
 [customPicker show];
 }
 #pragma - mark - UIPickViw
 - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
 return 1;
 }
 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 return 5;
 }
 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
 return @"你好啊";
 }
 - (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
 return 40;
 }
 - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
 
 }
 //点击了确定按钮
 - (void)finishChoose:(CustomPicker *)myPicker{
 
 [myPicker dismiss];
 
 }
 */
@end
